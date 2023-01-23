library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Top is
--Port(
	 --
--);
end Top;


architecture connection of Top is

  signal FT2232H_FSDI : std_logic;
  signal FT2232H_FSCLK : std_logic;
  signal tester_clk : std_logic;
  signal tester_reset : std_logic;
  signal FT2232H_FSCTS : std_logic;
  signal FT2232H_FSDO : std_logic;


component test_bench
    port (
    FT2232H_FSDI : out std_logic;
    FT2232H_FSCLK : out std_logic;
    tester_clk : in std_logic;
    tester_reset : in std_logic;
    FT2232H_FSCTS : in std_logic;
    FT2232H_FSDO : in std_logic
  );
end component;

component Tester
    port (
    FT2232H_FSDI : in std_logic;
    FT2232H_FSCLK : in std_logic;
    tester_clk : out std_logic;
    tester_reset : out std_logic;
    FT2232H_FSCTS : out std_logic;
    FT2232H_FSDO : out std_logic
  );
end component;

begin

test_bench_inst : test_bench
  port map (
    FT2232H_FSDI => FT2232H_FSDI,
    FT2232H_FSCLK => FT2232H_FSCLK,
    tester_clk => tester_clk,
    tester_reset => tester_reset,
    FT2232H_FSCTS => FT2232H_FSCTS,
    FT2232H_FSDO => FT2232H_FSDO
  );


Tester_inst : Tester
  port map (
    FT2232H_FSDI => FT2232H_FSDI,
    FT2232H_FSCLK => FT2232H_FSCLK,
    tester_clk => tester_clk,
    tester_reset => tester_reset,
    FT2232H_FSCTS => FT2232H_FSCTS,
    FT2232H_FSDO => FT2232H_FSDO
  );


end connection;