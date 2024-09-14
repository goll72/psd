-- A synchronous 8-bit counter implemented using 8 type T flip-flops

library ieee;
use ieee.std_logic_1164.all;

library work;

entity counter_8 is
   port (clk, enable, clr : in  std_logic;
                         q : out std_logic_vector(7 downto 0));
end entity;

architecture structural of counter_8 is
    signal i : std_logic_vector(6 downto 0);
    SIGNAL s : std_logic_vector(7 downto 0);
BEGIN
    t_0 : entity work.ff_t(structural) port map (
        clk => clk,
        clr => clr,
        t => enable,
        q => s(0)
    );
    i(0) <= s(0) AND ENABLE;
    t_1 : entity work.ff_t(structural) port map (
        clk => clk,
        clr => clr,
        t => i(0),
        q => s(1)
    );
    i(1) <= s(1) and i(0);
    t_2 : entity work.ff_t(structural) port map (
        clk => clk,
        clr => clr,
        t => i(1),
        q => s(2)
    );
    i(2) <= s(2) and i(1);
    t_3 : entity work.ff_t(structural) port map (
        clk => clk,
        clr => clr,
        t => i(2),
        q => s(3)
    );
    i(3) <= s(3) and i(2);
    t_4 : entity work.ff_t(structural) port map (
        clk => clk,
        clr => clr,
        t => i(3),
        q => s(4)
    );
    i(4) <= s(4) and i(3);
    t_5 : entity work.ff_t(structural) port map (
        clk => clk,
        clr => clr,
        t => i(4),
        q => s(5)
    );
    i(5) <= s(5) and i(4);
    t_6 : entity work.ff_t(structural) port map (
        clk => clk,
        clr => clr,
        t => i(5),
        q => s(6)
    );
    i(6) <= s(6) and i(5);
    t_7 : entity work.ff_t(structural) port map (
        clk => clk,
        clr => clr,
        t => i(6),
        q => s(7)
    );
    q <= s;
end architecture;
