library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

--use std.env.stop;

entity Quadratic_Geterodin_input_tester is
    port (
        clk	            : out std_logic;
		  nRst	         : out std_logic;
        ReceiveDataMode : out std_logic;
       
        clear		      : out	std_logic;
        AutoFreqConEn	: out std_logic;
increment_phase_i  : out std_logic_vector(31 downto 0);
increment_phase_q  : out std_logic_vector(31 downto 0);
        HFreqDWord	   : out std_logic_vector(31 downto 0);
        HIncrFreqWord	: out std_logic_vector(15 downto 0);
        TimeCount	      : out std_logic_vector(15 downto 0);
        TimeUnit	      : out std_logic_vector(1 downto 0)
    );
end entity Quadratic_Geterodin_input_tester;

architecture a_Quadratic_Geterodine_input_tester of Quadratic_Geterodin_input_tester is
    constant clk_period: time := 100000 ps;
    signal clk_r: std_logic := '1';
  

    procedure skiptime_clk(time_count: in integer) is
    begin
        count_time: for k in 0 to time_count-1 loop
            wait until falling_edge(clk_r); 
            wait for 80000000 ps; 
                        
        end loop count_time ;
    end;
begin
    clk_r <= not clk_r after clk_period / 2;
    clk <= clk_r;


    tester_process: process
    begin
        nRst <= '0';
        ReceiveDataMode <= '1';
        
       
        clear <= '1';
        AutoFreqConEn <=  '1';
		  -- 0 i 180 q
		 increment_phase_i  <= (others => '0');
		  increment_phase_q  <=  (others => '0');
		
        HFreqDWord  <= "00000001010001000001111000111100";
        HIncrFreqWord <= (others => '0');
        TimeCount <= (others => '0');
        TimeUnit <= "00";

        skiptime_clk(5);

        --Сброс
		skiptime_clk(2);
		nRst <= '1';
       -- clear <= '0';
      wait for 100 ps;
		 clear <= '0';
        skiptime_clk(3);

        -- Ввод HFreqDWord IData_In и QData_In 
       
		  wait until rising_edge(clk_r); 
		wait for 200 ps;
		
		
        AutoFreqConEn <= '1';
		  --45 45 i q
		   increment_phase_i  <= "01111001010101100011010010011110";
		  increment_phase_q  <= "01111001010101100011010010011110";
		
    

        skiptime_clk(20);
       
        -- Меняем автоматическую подстройку
        wait until rising_edge(clk_r); 
		wait for 200 ps;
		--11000101100000100110110010010000 270
		--01111111110111111110110110101100 180
		--00000010010010000001011111010000 360
		--
		   increment_phase_i  <= "01000100001111100100111001010011";
		  increment_phase_q  <= (others => '0');
		
    

        skiptime_clk(20);
       wait until rising_edge(clk_r); 
		wait for 200 ps;
		
		--135
       
		   increment_phase_i  <= "01111001010101100011010010011110";
		  increment_phase_q  <= "01111001010101100011010010011110";
		
    

        skiptime_clk(20);
         
         -- Меняем задержку
        wait until rising_edge(clk_r);
		wait for 200 ps;
        AutoFreqConEn <= '1';
       -- TimeCount <= "0000000000000000";
      --  TimeUnit <= "00";
			  
		    increment_phase_i  <= "01111111110111111110110110101100";
			   increment_phase_q  <= "11000101100000100110110010010000";
        skiptime_clk(20);
		   wait until rising_edge(clk_r); 
		wait for 200 ps;
		
		--225
       
		   increment_phase_i  <= "01111001010101100011010010011110";
		  increment_phase_q  <= "01111001010101100011010010011110";
		
    

        skiptime_clk(20);
  wait until rising_edge(clk_r);
		wait for 200 ps;
		   increment_phase_q  <= x"C5826C90";
		  increment_phase_i  <=   "01111111110111111110110110101100";
		  skiptime_clk(20);
        -- Меняем добавочную частоту
		   wait until rising_edge(clk_r); 
		wait for 200 ps;
		
		
       --7956 349E
		   increment_phase_i  <= x"7956349E";
		  increment_phase_q  <=  "01111001010101100011010010011110";
		
    

        skiptime_clk(20);
          wait until rising_edge(clk_r);
		wait for 200 ps;
        increment_phase_q  <= "00000000000000000000000000000000";
		  increment_phase_i  <=   "00000000000000000000000000000000";
		  skiptime_clk(20);
		  
		  --01111001010101100011010010011110 45
		  --01111001010101100011010010011110 135
		  --01111001010101100011010010011110 225
		  --01111001010101100011010010011110 300+
		  --
		  --  HFreqDWord  <= "00000001010001000001111000111100";
      
       wait until rising_edge(clk_r); 
            wait for 800000000 ps;
			wait for 800000000 ps; 
		wait for 800000000 ps; 
	wait for 800000000 ps; 
wait for 800000000 ps; 	
         -- wait for 200000000 ps;  
      --  stop;
    end process;
end architecture;