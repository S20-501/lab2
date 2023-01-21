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
        almost_full : out STD_LOGIC;
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
		full 						: in 		std_logic;
		
		rdreq_buff 				: out		std_logic;
		empty_buff 				: in 		std_logic
	);
	end component;
	
	component ring_buffer
		generic (
			RAM_WIDTH : natural;
			RAM_DEPTH : natural
		);
		port (
			clk : in std_logic;
			nRst : in std_logic;

			-- Write port
			wr_en : in std_logic;
			wr_data : in std_logic_vector(RAM_WIDTH - 1 downto 0);

			-- Read port
			rd_en : in std_logic;
			rd_valid : out std_logic;
			rd_data : out std_logic_vector(RAM_WIDTH - 1 downto 0);
	
			-- Flags
			empty : out std_logic;
			empty_next : out std_logic;
			full : out std_logic;
			full_next : out std_logic;

			-- The number of elements in the FIFO
			fill_count : out integer range RAM_DEPTH - 1 downto 0
		);
	end component;


	signal wrreq 		: std_logic 	:= '0';
	signal full_r 		: std_logic 	:= '0';
	signal DataPort_r	: std_logic_vector( 15 downto 0 ) := (others=>'0');
	signal rdreq_buff : std_logic := '0';
	signal empty_buff : std_logic := '0';
	
	signal WB_DataOut_1_r	: std_logic_vector( 15 downto 0 ) := (others=>'0');
	signal WB_DataOut_2_r	: std_logic_vector( 15 downto 0 ) := (others=>'0');
	
	constant RAM_WIDTH : natural := 16;
	constant RAM_DEPTH : natural := 1024;

  -- DUT signals
	
	signal rd_en : std_logic := '0';
	signal rd_valid : std_logic;
	
--	signal empty_buff : std_logic;
	signal empty_next : std_logic;
	signal full : std_logic;
	signal full_next : std_logic;
	signal fill_count : integer range RAM_DEPTH - 1 downto 0;
	
begin
--		full <= full_r;
    GSMRegister_inst : GSMRegister
    port map (
        clk => clk,
        nRst => nRst,
        WB_Addr => WB_Addr,
        WB_DataOut_0 => WB_DataOut_0,
		  WB_DataOut_2 => WB_DataOut_1_r,
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
		  full => full_r,
		  rdreq_buff => rdreq_buff,
		  empty_buff => empty_buff
	 );
						

    GSMRegistr_FIFO_inst : GSMRegistr_FIFO
        port map (
            clock => clk,
            data => DataPort_r,
            rdreq => rdreq,
            wrreq => wrreq,
            empty => empty,
            almost_full => full_r,
            q => q
--            usedw => usedw
        );
	 DUT : ring_buffer
		 generic map (
			RAM_WIDTH => RAM_WIDTH,
			RAM_DEPTH => RAM_DEPTH
		 )
		port map (
			clk => clk,
			nRst => nRst,
			
			wr_en => wrreq,
			wr_data => DataPort_r,
			
			rd_en => rdreq_buff,
			rd_valid => rd_valid,
			rd_data => WB_DataOut_2_r,
			
			empty => empty_buff,
			empty_next => empty_next,

			full => full,
			full_next => full_next,
			fill_count => fill_count
		);
	process(clk, rdreq_buff)
		begin
			if( nRst = '0') then
				WB_DataOut_2 <= (others =>'0');
				
			elsif (rising_edge(clk)) then
				if(WB_Cyc_2 = '1' and WB_WE = '0' and WB_STB = '1' ) then
					if(WB_Addr = x"000C") then
						WB_DataOut_2 <= WB_DataOut_2_r;
					else
						WB_DataOut_2 <= WB_DataOut_1_r;
					end if;
				end if;
			end if;
	end process;
end architecture;
