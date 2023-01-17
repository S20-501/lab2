library ieee;
use ieee.std_logic_1164.all;

entity ma_tester is 
	port (
		i_clk			: out	std_logic;
		i_nRst		: out std_logic;
		IData_In		: out	std_logic_vector(10-1 downto 0);
		QData_In		: out	std_logic_vector(10-1 downto 0);
		MANumber		: out	std_logic_vector(5-1 downto 0)
	);
end entity ma_tester;

architecture a_ma_tester of ma_tester is 
	constant clk_period: time := 16 ns;
	signal i_clk_r: std_logic := '1';

	procedure skiptime_clk(time_count: in integer) is
	begin
		count_time: for k in 0 to time_count-1 loop
			wait until falling_edge(i_clk_r); 
			wait for 200 fs;
		end loop count_time ;
	end;
	
	begin 
		i_clk_r <= not i_clk_r after clk_period / 2;
		i_clk <= i_clk_r;
		
		tester_process: process 
			begin
				IData_In	<= (others => '0');
				QData_In	<= (others => '0');
				MANumber	<= b"11111"; -- 31
				
				skiptime_clk(2);
				
				-- Сброс
				i_nRst <= '0';
				skiptime_clk(1);
				i_nRst <= '1';
				
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(10);
				--IData_In <= b"0000001010"; -- 10
				--QData_In <= b"0000000000"; -- 0
				--skiptime_clk(10);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(10);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(10);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(10);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(10);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(10);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(10);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(10);
				
				
				skiptime_clk(50);
				
				
				
				
				MANumber	<= b"00000"; -- 0
				
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				
				skiptime_clk(20);
				
				MANumber	<= b"00011"; -- 3
				
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				
				
				skiptime_clk(20);
				
				MANumber	<= b"00111"; -- 7
				
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				
				
				skiptime_clk(20);
				
				MANumber	<= b"00100"; -- 4
				
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				IData_In <= b"0000000000"; -- 0
				QData_In <= b"0000000000"; -- 0
				skiptime_clk(1);
				
				
				skiptime_clk(20);
				
				MANumber	<= b"00100"; -- 4
				
				IData_In <= b"0000000011"; -- 3
				QData_In <= b"0000000011"; -- 3
				skiptime_clk(1);
				IData_In <= b"0000000100"; -- 4
				QData_In <= b"0000000100"; -- 4
				skiptime_clk(1);
				IData_In <= b"0000001010"; -- 10
				QData_In <= b"0000001010"; -- 10
				skiptime_clk(1);
				IData_In <= b"0000001110"; -- 14
				QData_In <= b"0000001110"; -- 14
				skiptime_clk(1);
				IData_In <= b"0000001111"; -- 15
				QData_In <= b"0000001111"; -- 15
				skiptime_clk(1);
				IData_In <= b"0000010000"; -- 16
				QData_In <= b"0000010000"; -- 16
				skiptime_clk(1);
				IData_In <= b"0000010010"; -- 18
				QData_In <= b"0000010010"; -- 18
				skiptime_clk(1);
				IData_In <= b"0000010110"; -- 22
				QData_In <= b"0000010110"; -- 22
				skiptime_clk(1);
				IData_In <= b"0000010111"; -- 23
				QData_In <= b"0000010111"; -- 23
				
				skiptime_clk(1);
				
		end process;	

end architecture;
