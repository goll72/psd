-- A synchronous 4-bit counter implemented using 8 type T flip-flops

library ieee;
use ieee.std_logic_1164.all;

library work;

entity counter_4 is
    port (clk, enable, clr : in  std_logic;
                         q : out std_logic_vector(3 downto 0));
end entity;

architecture structural of counter_4 is
    signal i : std_logic_vector(2 downto 0);
    signal s : std_logic_vector(3 downto 0);
begin
    t_0 : entity work.ff_t(structural) port map (
        clk => clk,
        preset => '1',
        clr => clr,
        t => enable and clr,
        q => s(0)
    );
    i(0) <= s(0) and enable;
    t_1 : entity work.ff_t(structural) port map (
        clk => clk,
        preset => '1',
        clr => clr,
        t => i(0),
        q => s(1)
    );
    i(1) <= s(1) and i(0);
    t_2 : entity work.ff_t(structural) port map (
        clk => clk,
        preset => '1',
        clr => clr,
        t => i(1),
        q => s(2)
    );
    i(2) <= s(2) and i(1);
    t_3 : entity work.ff_t(structural) port map (
        clk => clk,
        preset => '1',
        clr => clr,
        t => i(2),
        q => s(3)
    );
    q <= s;
end architecture;
