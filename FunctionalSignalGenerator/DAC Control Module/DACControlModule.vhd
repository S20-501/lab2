library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DACControlModule is
	port (
			Clk: in std_logic;
			nRst: in std_logic;
			DAC_I_sig: in std_logic_vector(9 downto 0); --sinphase component of moduled harmonic signal
			DAC_Q_sig: in std_logic_vector(9 downto 0); --quadrature component of moduled harmonic signal
			
			Rst_For_DAC: in std_logic; --reset only for DAC
			Power_Down: in std_logic; --Turn off DAC.If DAC_Rst=1 during 4 clocks of DAC_Clk, DAC circuit turns off
			
			
			DAC_Clk: out std_logic := '0';
			DAC_Rst: out std_logic;	
			DAC_Write: out std_logic := '1';
			DAC_Select: out std_logic := '1';
			DAC_Data: out std_logic_vector(9 downto 0) := "0000000000"
		  );
end DACControlModule;


architecture Behavioral of DACControlModule is
	signal DAC_Rst_buf_r: std_logic := '0';
	signal DAC_Rst_count: std_logic_vector(3 downto 0) := (others=>'0');
	signal Clk_count: std_logic_vector(3 downto 0) := (others=>'0');
	signal Select_Enable_r: std_logic := '1';
	signal Power_Down_r: std_logic := '0';
	
	
begin
	--настраиваем регистр сброса, регистр выключения и регистр доступа к данным
	process(Clk,nRst,Rst_For_DAC,Power_Down)
	begin
		if (rising_edge(Clk)) then
			DAC_Rst_buf_r <= (not nRst or Rst_For_DAC);
			Power_Down_r <= Power_Down;
			Select_Enable_r <= ((nRst and not Rst_For_DAC) and (not Power_Down) and not DAC_Rst_count(3));
		end if;
	end process;
	
	--счетчик тактов, сбрасываем его при условии включенного регистра сброса или регистра выключения
	process(Clk,Power_Down_r)
	begin
		if rising_edge(Clk) then
			if (DAC_Rst_buf_r='1' or Power_Down_r='1') then
				Clk_count <= "0000";
			else
				Clk_count <= Clk_count + 1;
			end if;
		end if;
	end process;

	-- счетчик тактов при включенном ресете
	process(Clk,nRst)
	begin
		if (nRst = '0') then
			DAC_Rst_Count <= "0000";
		elsif (rising_edge(Clk)) then
			if (DAC_Rst_buf_r='1') then
				DAC_Rst_count <= DAC_Rst_count + 1;
			elsif (DAC_Rst_buf_r='0' and DAC_Rst_count < "1000") then
				DAC_Rst_Count <= "0000";
			end if;
		end if;
	end process;
	
	DAC_signals_assignment : process(DAC_Rst_buf_r,Clk,Power_Down_r,Clk_count)
	begin
		if (Power_Down_r='1') then
			DAC_Rst <= '0';
		else
			DAC_Rst <= DAC_Rst_buf_r;
		end if;

		if falling_edge(Clk) then
			if Select_Enable_r='1' then
				DAC_Write <= not Clk_count(0);
			else
				DAC_Write <= '0';
			end if;
		end if ;

		if (Select_Enable_r='0') then
			DAC_Clk <= '0';
			DAC_Select <= '0';
			DAC_Data <= "0000000000";
		elsif (Select_Enable_r='1') then
			DAC_Clk <= Clk_count(0);
			DAC_Select <= not Clk_count(1);
			if (Clk_count(1)='0') then
				DAC_Data <= DAC_I_sig;
			elsif (Clk_count(1)='1') then
				DAC_Data <= DAC_Q_sig;
			end if;
		end if;
	end process;
	
end Behavioral;