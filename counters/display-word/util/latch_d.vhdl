-- A gated D latch

library ieee;
use ieee.std_logic_1164.all;

entity latch_d is
    port (clk,   d : in    std_logic;
                 q : out   std_logic);
end entity;

architecture structural of latch_d is
   signal r, s, r_g, s_g, q_a, q_b : std_logic;
   attribute keep : boolean;
   attribute keep of r, s, r_g, s_g, q_a, q_b : signal is true;
begin
   s <= d;
   r <= not d;
   r_g <= r and clk;
   s_g <= s and clk;
   q_a <= not (r_g or q_b);
   q_b <= not (s_g or q_a);
   q <= q_a;
end architecture;
