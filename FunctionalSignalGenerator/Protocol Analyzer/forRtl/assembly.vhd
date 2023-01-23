library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;

entity assembly is
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
end;

architecture assembly2 of assembly is
--ptotocol exchange module
	signal WB_DataIn_0 : std_logic_vector( 15 downto 0 ); 
   signal WB_DataIn_1 : std_logic_vector( 15 downto 0 );
   signal WB_DataIn_2 : std_logic_vector( 15 downto 0 );
   signal WB_DataIn_3 : std_logic_vector( 15 downto 0 );
   signal WB_Ack 		: std_logic;
	
	signal WB_Addr : std_logic_vector (15 downto 0);
   signal WB_DataOut : std_logic_vector (15 downto 0);
   signal WB_WE : std_logic;
   signal WB_Sel : std_logic_vector (1 downto 0);
   signal WB_STB : std_logic;
   signal WB_Cyc_0 : std_logic;
	signal WB_Cyc_1 : std_logic;
   signal WB_Cyc_2 : std_logic;
   signal WB_Cyc_3 : std_logic;
   signal WB_CTI : std_logic_vector (2 downto 0);
--protocol analizer
	signal rdreq : std_logic;
	signal Sync						:	std_logic;
	signal nRstDDS					: 	std_logic;
	signal Signal_mode				: 	std_logic_vector( 1 downto 0);
	signal Modulation_mode		: 	std_logic_vector( 1 downto 0);
	signal Mode						: 	std_logic;		
	signal CarrierFrequency	: std_logic_vector(31 downto 0);
	signal SymbolFrequency	: std_logic_vector( 31 downto 0);
	signal DataPort			: std_logic_vector( 15 downto 0);
	signal wrreq : std_logic;
	signal empty : std_logic ;
	signal q	: std_logic_vector (15 DOWNTO 0);
--modulator	
	signal Amplitude : std_logic_vector(15 downto 0);
   signal StartPhase : std_logic_vector(15 downto 0);
	signal DDS_en_r : std_logic;
   
begin
  Protocol_exchange_module_inst : entity work.Protocol_exchange_module
  port map (
	--direct in
	Clk => Clk,
	nRst => nRst,
	q_input => q_input,
	usedw_input_fi => usedw_input_fi,
	usedw_input_fo => usedw_input_fo,
	--indirect in
	WB_DataIn_0 => WB_DataIn_0,
   WB_DataIn_1 => WB_DataIn_1,
   WB_DataIn_2 => WB_DataIn_2,
   WB_DataIn_3 => WB_DataIn_3,
   WB_Ack => WB_Ack,
	--direct out
	rdreq_output => rdreq_output,
	data_output => data_output,
	wrreq_output => wrreq_output,
	--inderect out
    --WISHBONE
    WB_Addr => WB_Addr,
    WB_DataOut => WB_DataOut,
    WB_WE => WB_WE,
    WB_Sel => WB_Sel,
    WB_STB => WB_STB,
    WB_Cyc_0 => WB_Cyc_0,
    WB_Cyc_1 => WB_Cyc_1,
    WB_Cyc_2 => WB_Cyc_2,
    WB_Cyc_3 => WB_Cyc_3,
    WB_CTI => WB_CTI
  );
 GSMRegistr_top_inst : entity work.GSMRegistr_top
  port map (
  --direct in
	 Clk => Clk,
	 nRst => nRst,
  --from modulator
    rdreq => rdreq,
  --indirect in
	 WB_Addr => WB_Addr,
    WB_DataIn => WB_DataOut,
    WB_Sel => WB_Sel,
    WB_STB => WB_STB,
    WB_WE => WB_WE,
    WB_Cyc_0 => WB_Cyc_0,
	 WB_Cyc_2 => WB_Cyc_2,
    WB_CTI => WB_CTI,
  --back to master
	 WB_DataOut_0 => WB_DataIn_0,
	 WB_DataOut_2 => WB_DataIn_2,
	 WB_Ack => WB_Ack,
    Sync => Sync,
	 nRstDDS => nRstDDS,
	 Signal_mode =>	Signal_mode,
	 Modulation_mode => Modulation_mode,
	 Mode => Mode,
  --out to modulator
    CarrierFrequency_OUT => CarrierFrequency,
    SymbolFrequency_OUT => SymbolFrequency,
    empty => empty,
    q => DataPort
  );
  modulator_inst : entity work.modulator
    port map (
      clk => Clk,
      nRst => nRst,
      ModulationMode => Modulation_mode,
      Mode => Mode,
		
      Amplitude => Amplitude,
      StartPhase => StartPhase,
		
      SymbolFrequency => SymbolFrequency,
      DataPort => DataPort,
      rdreq => rdreq,
		empty => empty,
      DDS_en => DDS_en_r
    );
  

end;
