library ieee;
use ieee.std_logic_1164.all;

entity DDS is
	port
	(
		-- Входные сигналы
		clk	: in std_logic;
		nRst	: in std_logic;
		
		-- Сигналы WISHBONE
		WB_Addr		: in	std_logic_vector(15 downto 0);
		WB_DataOut	: out	std_logic_vector(15 downto 0);
		WB_DataIn	: in	std_logic_vector(15 downto 0);
		WB_WE			: in	std_logic;
		WB_Sel		: in	std_logic_vector(1 downto 0);
		WB_STB		: in	std_logic;
		WB_Cyc		: in	std_logic;
		WB_Ack		: out	std_logic;
		WB_CTI		: in	std_logic_vector(2 downto 0);
		
		-- Выходные сигналы
		DataFlow_Clk	: out std_logic;
		ADC_Clk			: out std_logic
	);
end DDS;

architecture Behavioral of DDS is

	component ACC is
		port(
			clk		: in	std_logic;
			nRst		: in	std_logic;
			enable	: in 	std_logic;
			clear		: in	std_logic;
			FTW		: in	std_logic_vector(31 downto 0);
			ACC_in	: in	std_logic_vector(31 downto 0);
			
			ACC_out	: out	std_logic_vector(31 downto 0)
		);
	end component;
	
	component FGen is
		port(
			ACC_out		: in	std_logic_vector(31 downto 0);

			fADC			: out	std_logic;
			fDataFlow	: out	std_logic
		);
	end component;
	
	component WB is
		port(
			-- Управляющие
			clk	: in std_logic;
			nRst	: in std_logic;
			
			-- Wishbone сигналы
			WB_Addr		: in	std_logic_vector(15 downto 0);
			WB_DataOut	: out	std_logic_vector(15 downto 0);
			WB_DataIn	: in	std_logic_vector(15 downto 0);
			WB_WE			: in	std_logic;
			WB_Sel		: in	std_logic_vector(1 downto 0);
			WB_STB		: in	std_logic;
			WB_Cyc		: in	std_logic;
			WB_Ack		: out	std_logic;
			WB_CTI		: in	std_logic_vector(2 downto 0);
			
			-- Получаемые сигналы
			clear		: out std_logic;
			enable	: out std_logic;
			ADC_FTW	: out std_logic_vector(31 downto 0)
		);
	end component;
	
	-- Register signals from wishbone
	signal ADC_FTW	: std_logic_vector(31 downto 0);
	signal clear	: std_logic;
	signal enable	: std_logic;
	
	signal ACC_r	: std_logic_vector(31 downto 0);

begin

	WB_0:WB port map(
		-- Управляющие
		clk	=> clk,
		nRst	=> nRst,
	
		-- Сигналы WISHBONE
		WB_Addr		=> WB_Addr,
		WB_DataOut	=> WB_DataOut,
		WB_DataIn	=> WB_DataIn,
		WB_WE			=> WB_WE,
		WB_Sel		=> WB_Sel,
		WB_STB		=> WB_STB,
		WB_Cyc		=> WB_Cyc,
		WB_Ack		=> WB_Ack,
		WB_CTI		=> WB_CTI,
		
		-- Получаемые сигналы
		ADC_FTW	=> ADC_FTW,
		clear		=> clear,
		enable	=> enable
	);

	ACC_0:ACC port map(
		clk		=> clk,
		nRst		=> nRst,
		enable	=> enable,
		clear		=> clear,
		FTW		=> ADC_FTW,
		ACC_in	=> ACC_r,
		
		ACC_out	=> ACC_r
	);
	
	FGen_0:FGen port map(
		ACC_out		=> ACC_r,
			
		fADC			=> ADC_Clk,
		fDataFlow	=> DataFlow_Clk
	);

end Behavioral;










