library ieee;
use ieee.std_logic_1164.all;

entity Quadratic_Geterodin_input is
	port
	(
		-- Входные сигналы
		clk	: in std_logic;
		nRst	: in std_logic;
        ReceiveDataMode     : in std_logic;
       
       
	increment_phase_i  : in std_logic_vector(31 downto 0);
	increment_phase_q  : in std_logic_vector(31 downto 0);
		clear		: in	std_logic;
		AutoFreqConEn	: in std_logic;
		HFreqDWord	: in std_logic_vector(31 downto 0);
		HIncrFreqWord	: in std_logic_vector(15 downto 0);
		TimeCount	: in std_logic_vector(15 downto 0);
		TimeUnit	: in std_logic_vector(1 downto 0);
        

		-- Выходные сигналы
        DataValid   : out std_logic;
		IData_Out 	: out std_logic_vector(9 downto 0);
		QData_Out 	: out std_logic_vector(9 downto 0)
	);
end Quadratic_Geterodin_input;

architecture Behavioral of Quadratic_Geterodin_input is

	component dds_sine_input is
		port(
			clk		: in	std_logic;
			nRst		: in	std_logic;
			DDS_out	: out	std_logic_vector(9 downto 0);
            -- Получаемые сигналы
			clear		: in	std_logic;
			AutoFreqConEn	: in std_logic;
			start_phase  : in std_logic_vector(31 downto 0); 
			increment_phase  : in std_logic_vector(31 downto 0);  
			
			HFreqDWord	: in std_logic_vector(31 downto 0);
			HIncrFreqWord	: in std_logic_vector(15 downto 0);
			TimeCount	: in std_logic_vector(15 downto 0);
			TimeUnit	: in std_logic_vector(1 downto 0)

		);
	end component;
	
	 signal I_temp : std_logic_vector(9 downto 0);
	signal    start_phase_q: std_logic_vector(31 downto 0) :="01000100001111100100111001010011";
	 signal    start_phase_i: std_logic_vector(31 downto 0) :=(others => '0');
     signal Q_temp : std_logic_vector(9 downto 0);
	
   
	


begin

	DDS_input_0:dds_sine_input port map(
		-- Управляющие
		clk	    => clk,
		nRst	=> nRst,
        DDS_out	=> IData_Out,
	
		-- Получаемые сигналы
        clear	=> clear,
		  increment_phase => increment_phase_i,
		  start_phase => start_phase_i,
		HFreqDWord	=> HFreqDWord,
        HIncrFreqWord	=> HIncrFreqWord,
        TimeCount	=> TimeCount,
        TimeUnit	=> TimeUnit,
		AutoFreqConEn	=> AutoFreqConEn
	);
    DDS_input_1:dds_sine_input port map(
		-- Управляющие
		clk	    => clk,
		nRst	=> nRst,
        DDS_out	=> QData_Out,
	
		-- Получаемые сигналы
        clear	=> clear,
	increment_phase => increment_phase_q,
		  start_phase => start_phase_q,
		HFreqDWord	=> HFreqDWord,
        HIncrFreqWord	=> HIncrFreqWord,
        TimeCount	=> TimeCount,
        TimeUnit	=> TimeUnit,
		AutoFreqConEn	=> AutoFreqConEn
	);
end Behavioral;
