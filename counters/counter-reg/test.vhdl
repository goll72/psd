-- Counter testbench

library ieee;
use ieee.std_logic_1164.all;

library work;

entity test is
end entity;

use std.env.stop;

architecture behavioral of test is
    signal clk : std_logic := '0';
    signal enable, clr : std_logic;
    signal count : std_logic_vector(15 downto 0);

    constant CLK_PERIOD : time := 100 ps;

    attribute keep : boolean;
    attribute keep of clk, enable, clr : signal is true;
begin
    main : entity work.counter(behavioral) port map (
        clk => clk,
        enable => enable,
        clr => clr,
        q => count
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
