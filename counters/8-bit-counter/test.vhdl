-- Counter + display testbench

library ieee;
use ieee.std_logic_1164.all;

library work;

entity test is
end entity;

use std.env.stop;

architecture behavioral of test is
    signal clk : std_logic := '0';
    signal enable, clr : std_logic;
    signal hex0, hex1 : std_logic_vector(0 to 6);

    constant CLK_PERIOD : time := 100 ps;

    attribute keep : boolean;
    attribute keep of clk, enable, clr, hex0, hex1 : signal is true;
begin
    main : entity work.main(structural) port map (
        clk => clk,
        enable => enable,
        clr => clr,
        hex0 => hex0,
        hex1 => hex1
    );

    clk <= not clk after CLK_PERIOD / 2;

    stim : process is
    begin
        clr <= '0';
        wait for CLK_PERIOD;
        clr <= '1';
        enable <= '1';
        wait for 12 * CLK_PERIOD;
        enable <= '0';
        wait for 5 * CLK_PERIOD;
        enable <= '1';
        wait for 5 * CLK_PERIOD;

        stop;
    end process;
end architecture;
