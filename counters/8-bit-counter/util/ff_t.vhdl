-- A flip-flop implemented using two gated D latches

library ieee;
use ieee.std_logic_1164.all;

library work;

entity ff_t is
    port (clk, clr, t : in  std_logic;
                    q : out std_logic);
end entity;

architecture structural of ff_t is
    signal data_in, s : std_logic;
begin
    data_in <= clr and (t xor s);
    d_internal : entity work.ff_d(structural) port map (
        clk => clk,
        d => data_in,
        q => s
    );
    q <= s;
end architecture;
