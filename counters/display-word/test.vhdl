-- Word display testbench

library ieee;

use ieee.std_logic_1164.all;

library work;

use work.display_attrs.all;

entity test is
end entity;

use std.env.stop;

architecture behavioral of test is
    signal clk : std_logic := '0';
    signal clr : std_logic;
    signal hex : display_array_t;

    constant CLK_PERIOD : time := 100 ps;

    attribute keep : boolean;
    attribute keep of clk, clr : signal is true;
begin
    main : entity work.main(structural) port map (
        clk => clk,
        clr => clr,
        hex => hex
    );

    clk <= not clk after CLK_PERIOD / 2;

    stim : process is
    begin
        clr <= '0';
        wait for CLK_PERIOD;
        clr <= '1';
        wait for 600 * CLK_PERIOD;

        stop;
    end process;
end architecture;
