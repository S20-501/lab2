library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GSMRegistr_tester is
    port (
        WB_Addr : out std_logic_vector( 15 downto 0 );
        clk : out std_logic;
        WB_DataIn: out std_logic_vector( 15 downto 0 );
        nRst : out std_logic;
        WB_Sel: out std_logic_vector( 1 downto 0 );
        WB_STB : out std_logic;
        WB_WE: out std_logic;
		WB_Cyc_0		: out	std_logic;
		WB_Cyc_2		: out	std_logic;
		WB_CTI		: out	std_logic_vector(2 downto 0);
        
        rdreq : out STD_LOGIC
    );
end entity GSMRegistr_tester;

architecture rtl of GSMRegistr_tester is
	constant clk_period: time := 16666667 fs;
    signal clk_r: std_logic := '0';
	signal WB_DataIn_r : std_logic_vector( 15 downto 0) := (others => '0');
    procedure skiptime_clk(time_count: in integer) is
    begin
        count_time: for k in 0 to time_count-1 loop
            wait until rising_edge(clk_r); 
            wait for 200 ps; --need to wait for signal stability, value depends on the clk frequency. 
                        --For example, for clk period = 100 ns (10 MHz) it's ok to wait for 200 ps.
        end loop count_time ;
    end;

    
begin
	clk_r <= not clk_r after clk_period / 2;
	clk <= clk_r;
    tester_process: process 
			begin 
				WB_Addr <= (others => '0');
				WB_DataIn <= (others => '0');
				WB_WE  <= '0';
				WB_Sel <= (others => '0');
				WB_STB <= '0';
				rdreq <= '0';
				WB_Cyc_0 <= '0';
				WB_Cyc_2 <= '0';
				WB_CTI <= (others => '0');
				nRst <= '0';
				wait until rising_edge(clk_r);
				nRst <= '1';
				
				
				skiptime_clk(10);
				
				WB_Addr <= (3 => '1',2 => '1', others => '0');
				WB_Cyc_2 <= '1';
				WB_Sel <= "11";
				WB_WE <= '1';
				WB_CTI <= "001";
				counter: for k in 0 to 1024 loop
					WB_STB <= '1'; 
					WB_DataIn <= WB_DataIn_r;
					WB_DataIn_r <= std_logic_vector(unsigned(WB_DataIn_r) + 1);
					
					wait until rising_edge(clk_r);
					wait until rising_edge(clk_r);
					WB_STB <= '0';
					skiptime_clk(1);
				end loop counter ;
				WB_CTI <= "111";
				WB_STB <= '1'; 
				WB_DataIn <= WB_DataIn_r;
				WB_DataIn_r <= std_logic_vector(unsigned(WB_DataIn_r) + 1);
					
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				WB_STB <= '0';
				skiptime_clk(1);
				-- Stop writing
				WB_CTI <= "000";
--				skiptime_clk(10);
--				nRst <= '0';
--				wait until rising_edge(clk_r);
--				nRst <= '1';
				skiptime_clk(10);
				WB_Addr <= (3 => '1',2 => '1', others => '0');
				WB_Cyc_2 <= '1';
				WB_Sel <= "11";
				WB_WE <= '0';
				WB_CTI <= "001";
				read_counter: for k in 0 to 1024 loop
					WB_STB <= '1'; 
					wait until rising_edge(clk_r);
					wait until rising_edge(clk_r);
					WB_STB <= '0';
					skiptime_clk(1);
				end loop read_counter ;
				WB_CTI <= "111";
				WB_STB <= '1';
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				WB_STB <= '0';
				WB_CTI <= "000";
				skiptime_clk(100);								
		end process;	

end architecture;
