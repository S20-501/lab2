library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiply is
	port(
		    DDS_out		: in	std_logic_vector(9 downto 0);
            Data_In     : in    std_logic_vector(9 downto 0);
			Data_Out    :out	std_logic_vector(9 downto 0)
	);
end Multiply;

architecture Behavioral of Multiply is
signal Data_Out_r : std_logic_vector(19 downto 0);
begin
  mult:  process(Data_In, DDS_out) 
	begin

	Data_Out_r <= std_logic_vector(signed(Data_In) * signed(DDS_out));
    Data_Out<= Data_Out_r(19 downto 10);
	
    end process mult;
end Behavioral;