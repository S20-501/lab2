library ieee;
use ieee.std_logic_1164.all;

entity Quadratic_Geterodin is
	port
	(
		-- Входные сигналы
		clk	: in std_logic;
		nRst	: in std_logic;
        ReceiveDataMode     : in std_logic;
        ISig_In : in std_logic_vector(9 downto 0);
        QSig_In : in std_logic_vector(9 downto 0);
        DataStrobe   : in std_logic;
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
end Quadratic_Geterodin;

architecture Behavioral of Quadratic_Geterodin is

	component dds_sine is
		port(
			clk		: in	std_logic;
			nRst		: in	std_logic;
			DDS_out	: out	std_logic_vector(9 downto 0);
            -- Получаемые сигналы
			clear		: in	std_logic;
			AutoFreqConEn	: in std_logic;
			start_phase  : in std_logic_vector(31 downto 0);  
			HFreqDWord	: in std_logic_vector(31 downto 0);
			HIncrFreqWord	: in std_logic_vector(15 downto 0);
			TimeCount	: in std_logic_vector(15 downto 0);
			TimeUnit	: in std_logic_vector(1 downto 0)

		);
	end component;
	 signal  DDS_out_i_r : std_logic_vector(9 downto 0);
	 	 signal  DDS_out_q_r : std_logic_vector(9 downto 0);
	 signal I_temp : std_logic_vector(9 downto 0);
	signal    start_phase_q: std_logic_vector(31 downto 0) :="01000100001111100100111001010011";
	 signal    start_phase_i: std_logic_vector(31 downto 0) :=(others => '0');
     signal Q_temp : std_logic_vector(9 downto 0);
	
    component Multiply is
		port(
			
			DDS_out		: in	std_logic_vector(9 downto 0);
            Data_In     : in    std_logic_vector(9 downto 0);
			Data_Out    :out	std_logic_vector(9 downto 0)
		);
	end component;
	
	
	component separator is

      port(
		clk   : in std_logic;
        nRst: in std_logic;
        ReceiveDataMode: in std_logic;
		DataStrobe: in std_logic;
        ISig_In: in std_logic_vector(9 downto 0);
		QSig_In: in std_logic_vector(9 downto 0);
		  
		  

        IData_Out: out std_logic_vector(9 downto 0);
        QData_Out: out std_logic_vector(9 downto 0);

        DataValid: out std_logic
		
		
		
		
		  );
		  end component;

begin

	DDS_0:dds_sine port map(
		-- Управляющие
		clk	    => clk,
		nRst	=> nRst,
        DDS_out	=> DDS_out_i_r,
	
		-- Получаемые сигналы
        clear	=> clear,
		  start_phase => start_phase_i,
		HFreqDWord	=> HFreqDWord,
        HIncrFreqWord	=> HIncrFreqWord,
        TimeCount	=> TimeCount,
        TimeUnit	=> TimeUnit,
		AutoFreqConEn	=> AutoFreqConEn
	);
    DDS_1:dds_sine port map(
		-- Управляющие
		clk	    => clk,
		nRst	=> nRst,
        DDS_out	=> DDS_out_q_r,
	
		-- Получаемые сигналы
        clear	=> clear,
		  start_phase => start_phase_q,
		HFreqDWord	=> HFreqDWord,
        HIncrFreqWord	=> HIncrFreqWord,
        TimeCount	=> TimeCount,
        TimeUnit	=> TimeUnit,
		AutoFreqConEn	=> AutoFreqConEn
	);
	separate: separator port map(
		clk => clk,
		nRst => nRst,
		ReceiveDataMode => ReceiveDataMode,
		DataStrobe => DataStrobe,
		ISig_In => ISig_In,
		QSig_In => QSig_In,
		IData_Out => I_temp,
		QData_Out => Q_temp,
		DataValid => DataValid
);
	Multiply_0:Multiply port map(
		DDS_out		=> DDS_out_i_r,
		Data_In			=> I_temp,
		Data_Out	=> IData_Out
	);
    Multiply_1:Multiply port map(
		DDS_out		=> DDS_out_q_r,
		Data_In			=> Q_temp,
		Data_Out	=> QData_Out
	);

end Behavioral;
