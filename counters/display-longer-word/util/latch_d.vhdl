-- A gated D latch, with asynchronous PRESET and CLEAR signals

library ieee;
use ieee.std_logic_1164.all;

entity latch_d is
    port (clk, d, preset, clr : in    std_logic;
                            q : out   std_logic);
end entity;

architecture structural of latch_d is
   signal r, s, r_g, s_g, q_a, q_b : std_logic;
   attribute keep : boolean;
   attribute keep of r, s, r_g, s_g, q_a, q_b : signal is true;
begin
   s <= d;
   r <= not d;
   r_g <= r nand clk;
   s_g <= s nand clk;
   q_a <= not(r_g and q_b and preset);
   q_b <= not(s_g and q_a and clr);
   q <= q_a;
end architecture;
