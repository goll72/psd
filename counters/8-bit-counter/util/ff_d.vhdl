-- A type D flip-flop implemented using two gated D latches 
-- With asynchronous PRESET and CLEAR signals

library ieee;
use ieee.std_logic_1164.all;

library work;

entity ff_d is
   port (clk, d, preset, clr : in  std_logic;
                           q : out std_logic);
end entity;

architecture structural of ff_d is
   signal q_m, q_s : std_logic;
begin
   d_m : entity work.latch_d(structural) port map (
      clk => not clk,
      d => d,
      preset => clr,
      clr => preset,
      q => q_m
   );
   d_s : entity work.latch_d(structural) port map (
      clk => clk,
      d => q_m,
      preset => preset,
      clr => clr,
      q => q_s
   );
   q <= q_s;
end architecture;
