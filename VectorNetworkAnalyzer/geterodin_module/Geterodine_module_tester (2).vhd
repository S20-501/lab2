library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

--use std.env.stop;

entity Quadratic_Geterodin_tester is
    port (
        clk	            : out std_logic;
		  nRst	         : out std_logic;
        ReceiveDataMode : out std_logic;
        ISig_In         : out std_logic_vector(9 downto 0);
        QSig_In         : out std_logic_vector(9 downto 0);
        DataStrobe      : out std_logic;
        clear		      : out	std_logic;
        AutoFreqConEn	: out std_logic;
        HFreqDWord	   : out std_logic_vector(31 downto 0);
        HIncrFreqWord	: out std_logic_vector(15 downto 0);
        TimeCount	      : out std_logic_vector(15 downto 0);
        TimeUnit	      : out std_logic_vector(1 downto 0)
    );
end entity Quadratic_Geterodin_tester;

architecture a_Quadratic_Geterodine_tester of Quadratic_Geterodin_tester is
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
        ISig_In <= (others => '0');
        QSig_In <= (others => '0');
        DataStrobe <= '1';
        clear <= '1';
        AutoFreqConEn <=  '1';
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
		wait for 200 fs;

      --  HFreqDWord  <= "00000001010001000001111000111100";
        ISig_In <= (6 => '1', others => '0');
        QSig_In<= (3 => '1', others => '0');

        skiptime_clk(5);
        -- Меняем автоматическую подстройку
        wait until rising_edge(clk_r); 
		wait for 200 fs;
        AutoFreqConEn <= '1';
        HIncrFreqWord <= ( 4 => '1', 7 => '1', 9 => '1', others => '0');

        skiptime_clk(2);
        AutoFreqConEn <= '1';
         skiptime_clk(5);
         -- Меняем задержку
        wait until rising_edge(clk_r);
		wait for 200 fs;
        AutoFreqConEn <= '1';
        TimeCount <= "0000000000000000";
        TimeUnit <= "00";

        skiptime_clk(5);

        -- Меняем добавочную частоту
        wait until rising_edge(clk_r);
		wait for 200 fs;
        HIncrFreqWord <= (4 => '1', others => '0');

      wait until rising_edge(clk_r); 
            wait for 80000000 ps; 
		  AutoFreqConEn <= '0';
        TimeCount <= "0000000000000001";
        TimeUnit <= "00";
		wait until rising_edge(clk_r); 
            wait for 80000000 ps; 
        AutoFreqConEn <= '1';
     wait until rising_edge(clk_r); 
            wait for 80000000 ps; 
         HIncrFreqWord <= "1111111111111111";
			
			wait until rising_edge(clk_r); 
            wait for 80000000 ps; 
		  AutoFreqConEn <= '0';
        TimeCount <= "0000000000000100";
        TimeUnit <= "01";
		wait until rising_edge(clk_r); 
            wait for 80000000 ps; 
        AutoFreqConEn <= '1';
     wait until rising_edge(clk_r); 
            wait for 80000000 ps; 
         HIncrFreqWord <= "0000000100000000";
		wait until rising_edge(clk_r); 
            wait for 80000000 ps; 
	 --     HFreqDWord  <= "00000000000000000001111000111100";	
      wait until rising_edge(clk_r); 
            wait for 80000000 ps; 
        
		  
		  
		  --  HFreqDWord  <= "00000001010001000001111000111100";
        ISig_In <= "0001101100";
        QSig_In<=  "0001001001";
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