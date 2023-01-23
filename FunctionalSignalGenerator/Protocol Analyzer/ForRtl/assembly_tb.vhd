library ieee;
use ieee.std_logic_1164.all;

entity assembly_tb is
end;

architecture bench of assembly_tb is

  component assembly
		port (
			Clk 				: in std_logic;
			nRst 				: in std_logic;
    
			q_input 			: in std_logic_vector (15 downto 0);
			usedw_input_fi : in std_logic_vector (10 downto 0);
			usedw_input_fo : in std_logic_vector (10 downto 0);
			rdreq_output 	: out std_logic;
			data_output 	: out std_logic_vector (15 downto 0);
			wrreq_output 	: out std_logic
 
		);    
  end component;

  component assembly_tester
    port (
         Clk 				: out std_logic;
			nRst 				: out std_logic;
    
			q_input 			: out std_logic_vector (15 downto 0);
			usedw_input_fi : out std_logic_vector (10 downto 0);
			usedw_input_fo : out std_logic_vector (10 downto 0)
    );
    end component;


  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
	signal Clk 				: std_logic;
	signal nRst 				:  std_logic;
    
	signal q_input 			:  std_logic_vector (15 downto 0);
	signal usedw_input_fi :  std_logic_vector (10 downto 0);
	signal usedw_input_fo :  std_logic_vector (10 downto 0);
	signal rdreq_output 	: std_logic;
	signal data_output 	:  std_logic_vector (15 downto 0);
	signal wrreq_output 	:  std_logic;
  -- Ports


begin

  
  assembly_inst : assembly
    port map (
			Clk => Clk,
			nRst => nRst,		
    
			q_input => q_input,			
			usedw_input_fi => usedw_input_fi,
			usedw_input_fo => usedw_input_fo,
			rdreq_output => rdreq_output,	
			data_output =>	data_output,
			wrreq_output => wrreq_output	 
    );
	 assembly_tester_inst : assembly_tester
	  port map (
			Clk => Clk,
			nRst => nRst,		
    
			q_input => q_input,			
			usedw_input_fi => usedw_input_fi,
			usedw_input_fo => usedw_input_fo
    );
	 


end;
