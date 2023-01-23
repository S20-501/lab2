library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;

entity dds_sine_input is
port(
  clk          : in  std_logic;
  nRst         : in  std_logic;
  clear        : in  std_logic;
  start_phase  : in std_logic_vector(31 downto 0);  
  increment_phase  : in std_logic_vector(31 downto 0);  
  HFreqDWord     : in  std_logic_vector(31 downto 0);
  HIncrFreqWord  : In  std_logic_vector(15 downto 0);  
  DDS_out        : out std_logic_vector(9 downto 0);
  AutoFreqConEn  : in  std_logic;
  TimeCount	: in std_logic_vector(15 downto 0);
  TimeUnit	: in std_logic_vector(1 downto 0)
  
  );
end dds_sine_input;

architecture rtl of dds_sine_input is

constant C_LUT_DEPTH    : integer := 2**9;  -- 8Kword
constant C_LUT_BIT      : integer := 10;     -- 10 bit LUT
type t_lut_sin is array(0 to C_LUT_DEPTH-1) of std_logic_vector(C_LUT_BIT-1 downto 0);

-- quantize a real value as signed 
function quantization_sgn(nbit : integer; max_abs : real; dval : real) return std_logic_vector is
variable temp    : std_logic_vector(nbit-1 downto 0):=(others=>'0');
constant scale   : real :=(2.0**(real(nbit-1)))/max_abs;
constant minq    : integer := -(2**(nbit-1));
constant maxq    : integer := +(2**(nbit-1))-1;
variable itemp   : integer := 0;
begin
  if(nbit>0) then
    if (dval>=0.0) then 
      itemp := +(integer(+dval*scale+0.49));
    else 
      itemp := -(integer(-dval*scale+0.49));
    end if;
    if(itemp<minq) then itemp := minq; end if;
    if(itemp>maxq) then itemp := maxq; end if;
  end if;
  temp := std_logic_vector(to_signed(itemp,nbit));
  return temp;
end quantization_sgn;

-- generate the sine values for a LUT of depth "LUT_DEPTH" and quantization of "LUT_BIT"
function init_lut_sin return t_lut_sin is
variable ret           : t_lut_sin:=(others=>(others=>'0'));  -- LUT generated
variable v_tstep       : real:=0.0;
variable v_qsine_sgn   : std_logic_vector(C_LUT_BIT-1 downto 0):=(others=>'0');
constant step          : real := 1.00/real(C_LUT_DEPTH);
begin
  for count in 0 to C_LUT_DEPTH-1 loop
    v_qsine_sgn := quantization_sgn(C_LUT_BIT, 1.0,sin(MATH_2_PI*v_tstep));
    ret(count)  := v_qsine_sgn;
    v_tstep := v_tstep + step;
     end loop;
     return ret;
end function init_lut_sin;

-- initialize LUT with sine samples
constant C_LUT_SIN                 : t_lut_sin := init_lut_sin;
signal r_sync_reset                : std_logic;
signal r_start_phase               : unsigned(31 downto 0);
signal r_increment_phase               : unsigned(31 downto 0);
signal r_increment_phase_t               : unsigned(31 downto 0);
signal r_fcw                       : unsigned(31 downto 0);
signal r_acc                       : unsigned(31 downto 0);
signal lut_addr                    : std_logic_vector(8 downto 0);
signal lut_value                   : std_logic_vector(9 downto 0);
signal HFreqDWord_t                : std_logic_vector(31 downto 0);
signal HIncrFreqWord_i             : std_logic_vector(15 downto 0);
shared variable delay        : integer ;
shared variable time_coef    : integer ;
shared variable counter      : integer := 0;
shared variable autofreq_i   : integer := 0;
shared variable HFreqDWord_i : integer := 0;
signal indicator : std_logic := '0' ;

begin


Delay_counting : process(clk)
begin
  if(TimeUnit = "00") then
     time_coef := 100;
  elsif (TimeUnit = "01") then
     time_coef := 1000;
  elsif (TimeUnit = "10") then
     time_coef := 10000;  
  else
     time_coef := 0;
  end if;
  delay := time_coef*to_integer(unsigned(TimeCount));
end process Delay_counting;


AutoFreq_counting : process(clk)
begin
  
  if(rising_edge(clk)) then
     if(HIncrFreqWord_i /= HIncrFreqWord) then
	     counter:=0;
		  HIncrFreqWord_i <= HIncrFreqWord;
		  autofreq_i := 0;
		end if;  
		if(AutoFreqConEn = '0') then
	     counter:=0;
		end if;  
     if(counter = delay) then
	     autofreq_i := 1;
		  counter := 0;
	  elsif (AutoFreqConEn = '1') then counter := counter+1;
	       
     end if;	  
  end if;
end process AutoFreq_counting; 
  
  
  
-- тут функция добавления частоты
AutoFreq : process(clk)
begin
  if(AutoFreqConEn = '1' and autofreq_i=1) then
	 HFreqDWord_t <= (b"0000000000000000" & HIncrFreqWord) + HFreqDWord;
  else 
    HFreqDWord_t <= HFreqDWord; 
	end if;
end process AutoFreq;	

--indicatoric : process(clk)
--begin
--if(r_increment_phase_t /= unsigned(increment_phase)) then
--      indicator <='1';
--	end if;
--end process indicatoric;

p_acc : process(clk,nRst)
begin
  if(nRst='0') then
    r_sync_reset      <= '1';
    r_start_phase     <= unsigned(start_phase);
    r_increment_phase <= unsigned(increment_phase);
    r_fcw             <= (others=>'0');
    r_acc             <= r_start_phase;
  elsif(rising_edge(clk)) then
    if(r_increment_phase_t /= unsigned(increment_phase)) then
      indicator <='1';
	 end if;
	 
	 r_sync_reset      <= clear   ;
    r_start_phase     <= unsigned(start_phase);
	 r_increment_phase <= unsigned(increment_phase);
	 r_increment_phase_t <= r_increment_phase;
    r_fcw             <= unsigned(HFreqDWord_t);
	  
    if( r_sync_reset='1') then
      r_acc             <= r_start_phase;
    elsif (indicator='1') then
      r_acc             <= r_acc + r_fcw + r_increment_phase;
		indicator <=   '0';
		else r_acc <= r_acc + r_fcw;
    end if;
  end if;
end process p_acc;

p_rom : process(clk)
begin
  if(rising_edge(clk)) then
    lut_addr   <= std_logic_vector(r_acc(31 downto 23));
    lut_value  <= C_LUT_SIN(to_integer(unsigned(lut_addr)));
  end if;
end process p_rom;

p_sine : process(clk,nRst)
begin
  if(nRst='0') then
    DDS_out     <= (others=>'0');
  elsif(rising_edge(clk)) then
    DDS_out     <= lut_value;
  end if;
end process p_sine;

end rtl;