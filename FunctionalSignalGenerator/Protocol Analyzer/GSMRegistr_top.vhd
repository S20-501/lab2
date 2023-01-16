library ieee;
use ieee.std_logic_1164.all;


entity GSMRegistr_top is
    port (
        WB_Addr: in std_logic_vector( 15 downto 0 );
        WB_Ack: out std_logic;
        Clk: in std_logic;
        WB_DataIn: in std_logic_vector( 15 downto 0 );
        WB_DataOut_0: out std_logic_vector( 15 downto 0 );
		  WB_DataOut_2: out std_logic_vector( 15 downto 0 );
        nRst: in std_logic;
        WB_Sel: in std_logic_vector( 1 downto 0 );
        WB_STB: in std_logic;
        WB_WE: in std_logic;
		  WB_Cyc_0		: in	std_logic;
		  WB_Cyc_2		: in	std_logic;
		  WB_CTI		: in	std_logic_vector(2 downto 0);
    
        
		  Sync						: out 	std_logic;
		  nRstDDS					: out 	std_logic;
		  Signal_mode				: out 	std_logic_vector( 1 downto 0);
		  Modulation_mode		: out 	std_logic_vector( 1 downto 0);
		  Mode						: out 	std_logic;
--        Amplitude_OUT: out std_logic_vector( 15 downto 0);
--       StartPhase_OUT: out std_logic_vector( 15 downto 0);
        CarrierFrequency_OUT: out std_logic_vector(31 downto 0);
        SymbolFrequency_OUT: out std_logic_vector( 31 downto 0);
        
        
		rdreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
--	full		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
--	usedw		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
    );
end entity GSMRegistr_top;

architecture rtl of GSMRegistr_top is
    component GSMRegistr_FIFO
        port (
        clock : in STD_LOGIC;
        data : in STD_LOGIC_VECTOR (15 DOWNTO 0);
        rdreq : in STD_LOGIC;
        wrreq : in STD_LOGIC;
        empty : out STD_LOGIC;
        full : out STD_LOGIC;
        q : out STD_LOGIC_VECTOR (15 DOWNTO 0)
 --       usedw : out STD_LOGIC_VECTOR (9 DOWNTO 0)
      );
    end component;
    
	component GSMRegister
		port(
		clk	: in	std_logic;
		nRst	: in	std_logic;
		
		--Wishbone
		WB_Addr		: in	std_logic_vector( 15 downto 0 );
		WB_DataOut_0	: out	std_logic_vector( 15 downto 0 );
		WB_DataOut_2	: out	std_logic_vector( 15 downto 0 );
		WB_DataIn	: in	std_logic_vector( 15 downto 0 );
		WB_WE			: in 	std_logic;
		WB_Sel		: in 	std_logic_vector( 1 downto 0 );
		WB_STB		: in 	std_logic;
		WB_Cyc_0		: in	std_logic;
		WB_Cyc_2		: in	std_logic;
		WB_Ack		: out std_logic;
		WB_CTI		: in	std_logic_vector(2 downto 0);

		Sync						: out 	std_logic;
		nRstDDS					: out 	std_logic;
		Signal_mode				: out 	std_logic_vector( 1 downto 0);
		Modulation_mode		: out 	std_logic_vector( 1 downto 0);
		Mode						: out 	std_logic;
--		Amplitude_OUT			: out 	std_logic_vector( 15 downto 0);
--		StartPhase_OUT			: out 	std_logic_vector( 15 downto 0);
		CarrierFrequency_OUT	: out 	std_logic_vector(31 downto 0);
		SymbolFrequency_OUT	: out 	std_logic_vector( 31 downto 0);
		DataPort_OUT			: out 	std_logic_vector( 15 downto 0);--идет в FIFO
		wrreq						: out 	std_logic;
		full : in std_logic
	);
	end component;
    signal wrreq : std_logic 	:= '0';
	 signal full_r : std_logic := '0';
    signal DataPort_r: std_logic_vector( 15 downto 0 ) := (others=>'0');
begin
--		full <= full_r;
    GSMRegister_inst : GSMRegister
    port map (
        clk => clk,
        nRst => nRst,
        WB_Addr => WB_Addr,
        WB_DataOut_0 => WB_DataOut_0,
		  WB_DataOut_2 => WB_DataOut_2,
        WB_DataIn => WB_DataIn,
        WB_WE => WB_WE,
        WB_Sel => WB_Sel,
        WB_STB => WB_STB,
        WB_Cyc_0 => WB_Cyc_0,
		  WB_Cyc_2 => WB_Cyc_2,
        WB_Ack => WB_Ack,
        WB_CTI => WB_CTI,
        Sync => Sync,
		  nRstDDS => nRstDDS,
		  Signal_mode =>	Signal_mode,
		  Modulation_mode => Modulation_mode,
		  Mode => Mode,
 --       Amplitude_OUT => Amplitude_OUT,
 --       StartPhase_OUT => StartPhase_OUT,
        CarrierFrequency_OUT => CarrierFrequency_OUT,
        SymbolFrequency_OUT => SymbolFrequency_OUT,
        DataPort_OUT => DataPort_r,
        wrreq => wrreq,
		  full => full_r
    );
						

    GSMRegistr_FIFO_inst : GSMRegistr_FIFO
        port map (
            clock => clk,
            data => DataPort_r,
            rdreq => rdreq,
            wrreq => wrreq,
            empty => empty,
            full => full_r,
            q => q
--            usedw => usedw
        );
end architecture;
