library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity Quadratic_Geterodin_input_tb is
end entity Quadratic_Geterodin_input_tb;

architecture a_Quadratic_Geterodin_input_tb of Quadratic_Geterodin_input_tb is
      signal  clk	:  std_logic;
      signal  nRst	: std_logic;
      signal  ReceiveDataMode:  std_logic;
		 
      signal  clear		: 	std_logic;
	  	signal  AutoFreqConEn	:  std_logic;
signal  increment_phase_i  :  std_logic_vector(31 downto 0);
signal  increment_phase_q  :  std_logic_vector(31 downto 0);
      signal  HFreqDWord	:  std_logic_vector(31 downto 0);
      signal  HIncrFreqWord	:  std_logic_vector(15 downto 0);
      signal  TimeCount	:  std_logic_vector(15 downto 0);
      signal  TimeUnit	:  std_logic_vector(1 downto 0);
      signal  IData_Out:  std_logic_vector(9 downto 0);
      signal  QData_Out:  std_logic_vector(9 downto 0);
      signal  DataValid:  std_logic;
  
  
  
    component Quadratic_Geterodin_input 
	 port(
    -- Входные сигналы
		clk	: in std_logic;
		nRst	: in std_logic;
    ReceiveDataMode     : in std_logic;
  
    clear		: in	std_logic;
    AutoFreqConEn	: in std_logic;
increment_phase_i  : in std_logic_vector(31 downto 0);
increment_phase_q  : in std_logic_vector(31 downto 0);
    HFreqDWord	: in std_logic_vector(31 downto 0);
    HIncrFreqWord	: in std_logic_vector(15 downto 0);
    TimeCount	: in std_logic_vector(15 downto 0);
    TimeUnit	: in std_logic_vector(1 downto 0);


		-- Выходные сигналы
    DataValid   : out std_logic;
		IData_Out 	: out std_logic_vector(9 downto 0);
		QData_Out 	: out std_logic_vector(9 downto 0)
		  );
		  end component;
        

    component Quadratic_Geterodin_input_tester
        port (
		clk	: out std_logic;
		nRst	: out std_logic;
    ReceiveDataMode     : out std_logic;
   
    clear		: out	std_logic;
    AutoFreqConEn	: out std_logic;
increment_phase_i  : out std_logic_vector(31 downto 0);
increment_phase_q  : out std_logic_vector(31 downto 0);
    HFreqDWord	: out std_logic_vector(31 downto 0);
    HIncrFreqWord	: out std_logic_vector(15 downto 0);
    TimeCount	: out std_logic_vector(15 downto 0);
    TimeUnit	: out std_logic_vector(1 downto 0)
      );
    end component;
   
	 
	 
	 
begin
	Quadratic_Geterodin_input_inst: Quadratic_Geterodin_input
	port map(
	
		clk => clk,
		nRst => nRst,
		ReceiveDataMode => ReceiveDataMode,
		
   
		clear => clear,
    AutoFreqConEn => AutoFreqConEn,
 increment_phase_i  => increment_phase_i,
 increment_phase_q  => increment_phase_q,
    HFreqDWord => HFreqDWord,
    HIncrFreqWord => HIncrFreqWord,
    TimeCount => TimeCount,
    TimeUnit => TimeUnit,
    DataValid => DataValid,
		IData_Out => IData_Out,
		QData_Out => QData_Out
		
   
  );

    Quadratic_Geterodin_tester_input_i : entity work.Quadratic_Geterodin_input_tester
    port map (
        clk => clk,
		    nRst => nRst,
		    ReceiveDataMode => ReceiveDataMode,
		   
       
		    clear => clear,
        AutoFreqConEn => AutoFreqConEn,
 increment_phase_i  => increment_phase_i,
 increment_phase_q  => increment_phase_q,
       HFreqDWord => HFreqDWord,
       HIncrFreqWord => HIncrFreqWord,
        TimeCount => TimeCount,
        TimeUnit => TimeUnit
       
    );
end architecture;