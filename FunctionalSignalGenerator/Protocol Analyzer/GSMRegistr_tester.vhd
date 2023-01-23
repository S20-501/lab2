library ieee;
use ieee.std_logic_1164.all;
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
				WB_Sel <= "11";
				WB_STB <= '0';
				rdreq <= '0';
				WB_Cyc_0 <= '0';
				WB_Cyc_2 <= '0';
				WB_CTI <= (others => '0');
				nRst <= '0';
				wait until rising_edge(clk_r);
				nRst <= '1';
				
				
				skiptime_clk(10);
				--for address 0x000C
				WB_DataIn <= "1111111111111111";
				WB_Cyc_2 <= '1';
				WB_Addr <= (3 => '1',2 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_2 <= '0';
				WB_WE <= '0';
				skiptime_clk(10);
				rdreq <= '1';
				wait until rising_edge(clk_r);
				wait for 200 fs;
				rdreq <= '0';
				skiptime_clk(15);
				skiptime_clk(15);
				
				
				--for address 0x0000
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Cyc_0 <= '1';
				WB_DataIn <= "0110000000011100";
				WB_Addr <= (others => '0');
				WB_Sel <= "01";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_0 <= '0';
				WB_WE <= '0';
				
				skiptime_clk(5);
				
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Cyc_0 <= '1';
				WB_DataIn <= "0000000100011100";
				WB_Addr <= (others => '0');
				WB_Sel <= "10";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_0 <= '0';
				WB_WE <= '0';
				
				skiptime_clk(5);
				
				WB_DataIn <= "1000100000101001";
				WB_Cyc_0 <= '1';
				WB_Addr <= (others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "11";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_0 <= '0';
				WB_WE <= '0';
				
				skiptime_clk(5);
				
				WB_DataIn <= "0010100100000000";
				WB_Cyc_0 <= '1';
				WB_Addr <= (others => '0');
				WB_STB <= '1';
				WB_Sel <= "11";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_0 <= '0';
				
				skiptime_clk(10);
				
				--for 0x0004
				WB_DataIn <= "0010100001011000";
				WB_Cyc_2 <= '1';
				WB_Addr <= (2 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "01";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_2 <= '0';
				WB_WE <= '0';
				
				skiptime_clk(5);
				
				WB_Cyc_2 <= '1';
				WB_Addr <= (2 => '1', others => '0');
				WB_STB <= '1';
				WB_Sel <= "11";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_2 <= '0';
				skiptime_clk(10);
				
				--for 0x0006
				WB_DataIn <= "1010101101011011";
				WB_Cyc_2 <= '1';
				WB_Addr <= (2 => '1',1 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "01";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_2 <= '0';
				WB_WE <= '0';
				
				skiptime_clk(5);
				
				WB_Cyc_2 <= '1';
				WB_Addr <= (2 => '1',1 => '1', others => '0');
				WB_STB <= '1';
				WB_Sel <= "11";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_2 <= '0';
				skiptime_clk(10);
				
				--for 0x0008
				WB_DataIn <= "0011101001001000";
				WB_Cyc_2 <= '1';
				WB_Addr <= (3 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "01";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_2 <= '0';
				WB_WE <= '0';
				
				skiptime_clk(5);
				
				WB_Cyc_2 <= '1';
				WB_Addr <= (3 => '1', others => '0');
				WB_STB <= '1';
				WB_Sel <= "11";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_2 <= '0';
				
				skiptime_clk(10);
				
				--for 0x000A
				WB_DataIn <= "0101010111011011";
				WB_Cyc_2 <= '1';
				WB_Addr <= (3 => '1',1 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "01";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_2 <= '0';
				WB_WE <= '0';
				
				skiptime_clk(5);
				
				WB_Cyc_2 <= '1';
				WB_Addr <= (3 => '1',1 => '1', others => '0');
				WB_STB <= '1';
				WB_Sel <= "11";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_2 <= '0';
				skiptime_clk(10);
				
				--for 0x000C
				WB_DataIn <= (0 => '1', others => '0');
				WB_Cyc_2 <= '1';
				WB_Addr <= (3 => '1',2 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "11";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_2 <= '0';
				WB_WE <= '0';
				
				skiptime_clk(5);
				WB_DataIn <= (1 => '1', others => '0');
				WB_Cyc_2 <= '1';
				WB_Addr <= (3 => '1',2 => '1', others => '0');
				WB_WE <= '1';
				WB_STB <= '1';
				WB_Sel <= "11";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_2 <= '0';
				WB_WE <= '0';
				
				skiptime_clk(5);
				WB_DataIn <= (1 => '1', 0 => '1', others => '0');
				WB_Cyc_2 <= '1';
				WB_Addr <= (3 => '1',2 => '1', others => '0');
				WB_STB <= '1';
				WB_Sel <= "11";
				wait until rising_edge(clk_r);
				wait until rising_edge(clk_r);
				wait for 200 fs;
				WB_STB <= '0';
				WB_Cyc_2 <= '0';
				
				skiptime_clk(15);
				
				--read FIFO
				rdreq <= '1';
				wait until rising_edge(clk_r);
				wait for 200 fs;
				rdreq <= '0';
				skiptime_clk(15);
				skiptime_clk(15);
				
				
		end process;	

end architecture;
