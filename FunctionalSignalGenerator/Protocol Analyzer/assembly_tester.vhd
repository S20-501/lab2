library ieee;
use ieee.std_logic_1164.all;
entity assembly_tester is
    port (
         Clk 				: out std_logic;
			nRst 				: out std_logic;
    
			q_input 			: out std_logic_vector (15 downto 0);
			usedw_input_fi : out std_logic_vector (10 downto 0);
			usedw_input_fo : out std_logic_vector (10 downto 0);
    );
end entity assembly_tester;

architecture rtl of assembly_tester_tester is
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
			
		end process;	

end architecture;
