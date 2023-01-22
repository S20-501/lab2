library ieee;
use ieee.std_logic_1164.all;

entity GSMRegister is
	port
	(
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
		full_fifo 						: in 		std_logic;
		
		rdreq_buff 					: out		std_logic;
		empty_buff 				: in 		std_logic
	);
end entity GSMRegister;
architecture Behavior of GSMRegister is
--	signal Amplitude_r: std_logic_vector( 15 downto 0 );
--	signal Start_Phase_r: std_logic_vector( 15 downto 0 );
	signal WB_DataOut_0_r: std_logic_vector(15 downto 0);
	signal WB_DataOut_2_r: std_logic_vector(15 downto 0);
	signal Carrier_Frequency_r: std_logic_vector( 31 downto 0 );
	signal Symbol_Frequency_r: std_logic_vector( 31 downto 0 );
	signal DataPort_r: std_logic_vector( 15 downto 0 ); -- пойдет в ФИФО
	signal Ack_r: std_logic;
	signal wrreq_r: std_logic;
	
	signal 	Sync_r						:	std_logic;
	signal	nRstDDS_r					: 	std_logic;
	signal	Signal_mode_r				: 	std_logic_vector( 1 downto 0);
	signal	Modulation_mode_r			: 	std_logic_vector( 1 downto 0);
	signal	Mode_r						: 	std_logic;
	
	signal 	rdreq_buff_r 				:	std_logic;

begin
		
		process(clk,nRst, WB_STB, WB_WE, WB_Cyc_0, WB_Cyc_2)
		begin
			if (nRst = '0') then
--				Amplitude_r <= x"0000";
--				Start_Phase_r <= x"0000";
				Carrier_Frequency_r <= x"00000000";
				Symbol_Frequency_r <= x"00000000";
				DataPort_r <= x"0000";
				wrreq_r <= '0';
				Ack_r <= '0';
				WB_DataOut_0_r <= "0000000000000000";
				WB_DataOut_2_r <= "0000000000000000";
				Sync_r <= '0';
				nRstDDS_r <= '0';
				Signal_mode_r <= "00";
				Modulation_mode_r <= "00";
				Mode_r <= '0';
				rdreq_buff_r <= '0';
			elsif (rising_edge(clk)) then
				if((WB_STB and (WB_Cyc_0 or WB_Cyc_2)) = '1') then--other operation
					if(Ack_r = '0') then
						Ack_r <= '1';
					else
						Ack_r <= '0';
					end if;
				else
					Ack_r <= '0';
				end if;
				--
				
				if (WB_Cyc_2 = '1' and WB_WE = '1' and WB_STB = '1' and WB_Addr = x"000C") then
					if(wrreq_r = '0') then
						if (full_fifo = '0') then
							wrreq_r <= '1';
						else
							wrreq_r <= '0';
						end if;
					else
						wrreq_r <= '0';
					end if;
				else
					wrreq_r <= '0';
				end if;
				
				
				if(WB_Cyc_2 = '1' and WB_WE = '0' and WB_STB = '1' and WB_Addr = x"000C") then
					if(rdreq_buff_r = '0') then
						if (empty_buff = '0') then
							rdreq_buff_r <= '1';
						else
							rdreq_buff_r <= '0';
						end if;
					else
						rdreq_buff_r <= '0';
					end if;
				else
					rdreq_buff_r <= '0';
				end if;
				
				if (WB_Cyc_0 = '1') then 
					if(WB_WE = '1' and WB_STB = '1') then 
						if(WB_Addr = x"0000") then
							if(WB_Sel(0) = '1')then
								Sync_r<= WB_DataIn(6);
								nRstDDS_r<= WB_DataIn(5);
								Signal_mode_r<= WB_DataIn(4 downto 3);
								Modulation_mode_r<= WB_DataIn(2 downto 1);
								Mode_r<= WB_DataIn(0);
							end if;
						end if;
					elsif(WB_WE = '0' and WB_STB = '1') then
						if(WB_Addr = x"0000") then
							WB_DataOut_0_r(15 downto 7) <= "000000000";
							if(WB_Sel(0) = '1')then
								WB_DataOut_0_r(6 downto 0) <= Sync_r & nRstDDS_r & Signal_mode_r & Modulation_mode_r & Mode_r;
							else
								WB_DataOut_0_r(6 downto 0) <= "0000000";
							end if;
						end if;
					end if;
					--
				elsif (WB_Cyc_2 = '1') then
					if(WB_WE = '1' and WB_STB = '1') then
						if(WB_Addr = x"0004") then
							if(WB_Sel(0) = '1')then
								Carrier_Frequency_r( 23 downto 16 ) <= WB_DataIn(7 downto 0);
							else 
								Carrier_Frequency_r( 23 downto 16 ) <= "00000000";
							end if;
							if(WB_Sel(1) = '1') then
								Carrier_Frequency_r( 31 downto 24 ) <= WB_DataIn(15 downto 8);
							else 
								Carrier_Frequency_r( 31 downto 24 ) <= "00000000";
							end if;
						elsif(WB_Addr = x"0006") then
							if(WB_Sel(0) = '1')then
								Carrier_Frequency_r( 7 downto 0 ) <= WB_DataIn(7 downto 0);
							else
								Carrier_Frequency_r( 7 downto 0 ) <= "00000000";
							end if;
							if(WB_Sel(1) = '1')then
								Carrier_Frequency_r( 15 downto 8 ) <= WB_DataIn(15 downto 8);
							else
								Carrier_Frequency_r( 15 downto 8 ) <= "00000000";
							end if;
						elsif(WB_Addr = x"0008") then
							if(WB_Sel(0) = '1')then
								Symbol_Frequency_r( 23 downto 16 ) <= WB_DataIn(7 downto 0);
							else 
								Symbol_Frequency_r( 23 downto 16 ) <= "00000000";
							end if;
							if(WB_Sel(1) = '1') then
								Symbol_Frequency_r( 31 downto 24 ) <= WB_DataIn(15 downto 8);
							else 
								Symbol_Frequency_r( 31 downto 24 ) <= "00000000";
							end if;
						elsif(WB_Addr = x"000A") then
							Symbol_Frequency_r( 15 downto 0 ) <= WB_DataIn;
							if(WB_Sel(0) = '1')then
								Symbol_Frequency_r( 7 downto 0 ) <= WB_DataIn(7 downto 0);
							else
								Symbol_Frequency_r( 7 downto 0 ) <= "00000000";
							end if;
							if(WB_Sel(1) = '1')then
								Symbol_Frequency_r( 15 downto 8 ) <= WB_DataIn(15 downto 8);
							else
								Symbol_Frequency_r( 15 downto 8 ) <= "00000000";
							end if;
						elsif(WB_Addr = x"000C") then
							if (full_fifo = '0')then
								if(WB_Sel(0) = '1')then
									DataPort_r( 7 downto 0 ) <= WB_DataIn(7 downto 0);
								else
									DataPort_r( 7 downto 0 ) <= "00000000";
								end if;
								if(WB_Sel(1) = '1')then
									DataPort_r( 15 downto 8 ) <= WB_DataIn(15 downto 8);
								else
									DataPort_r( 15 downto 8 ) <= "00000000";
								end if;
							end if;
						end if;
					elsif(WB_WE = '0' and WB_STB = '1') then
						if(WB_Addr = x"0004") then
							if(WB_Sel(0) = '1')then
								WB_DataOut_2_r(7 downto 0) <= Carrier_Frequency_r( 23 downto 16 );
							else
								WB_DataOut_2_r(7 downto 0) <= "00000000";
							end if;
							if(WB_Sel(1) = '1')then
								WB_DataOut_2_r(15 downto 8) <= Carrier_Frequency_r( 31 downto 24 );
							else
								WB_DataOut_2_r(15 downto 8) <= "00000000";
							end if;
						elsif(WB_Addr = x"0006") then
							if(WB_Sel(0) = '1')then
								WB_DataOut_2_r(7 downto 0) <= Carrier_Frequency_r( 7 downto 0 );
							else
								WB_DataOut_2_r(7 downto 0) <= "00000000";
							end if;
							if(WB_Sel(1) = '1')then
								WB_DataOut_2_r(15 downto 8) <= Carrier_Frequency_r( 15 downto 8 );
							else
								WB_DataOut_2_r(15 downto 8) <= "00000000";
							end if;
						elsif(WB_Addr = x"0008") then
							if(WB_Sel(0) = '1')then
								WB_DataOut_2_r(7 downto 0) <= Symbol_Frequency_r( 23 downto 16 );
							else
								WB_DataOut_2_r(7 downto 0) <= "00000000";
							end if;
							if(WB_Sel(1) = '1')then
								WB_DataOut_2_r(15 downto 8) <= Symbol_Frequency_r( 31 downto 24 );
							else
								WB_DataOut_2_r(15 downto 8) <= "00000000";
							end if;
						elsif(WB_Addr = x"000A") then
							if(WB_Sel(0) = '1')then
								WB_DataOut_2_r(7 downto 0) <= Symbol_Frequency_r( 7 downto 0 );
							else
								WB_DataOut_2_r(7 downto 0) <= "00000000";
							end if;
							if(WB_Sel(1) = '1')then
								WB_DataOut_2_r(15 downto 8) <= Symbol_Frequency_r( 15 downto 8 );
							else
								WB_DataOut_2_r(15 downto 8) <= "00000000";
							end if;
						end if;
					end if;
				end if;
			end if;
		end process;
 	Sync <= Sync_r;
	nRstDDS <= nRstDDS_r;
	Signal_mode <=	Signal_mode_r;
	Modulation_mode <= Modulation_mode_r;
	Mode <= Mode_r;
--	Amplitude_OUT <= Amplitude_r;
--	StartPhase_OUT <= Start_Phase_r;
	CarrierFrequency_OUT <= Carrier_Frequency_r;
	SymbolFrequency_OUT <= Symbol_Frequency_r;
	DataPort_OUT <= DataPort_r;
	wrreq <= wrreq_r;
	WB_Ack <= Ack_r;
	WB_DataOut_0 <= WB_DataOut_0_r;
	WB_DataOut_2 <= WB_DataOut_2_r;
	rdreq_buff <= rdreq_buff_r;
end architecture Behavior;
