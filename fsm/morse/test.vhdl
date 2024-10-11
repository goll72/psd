library ieee;

use ieee.std_logic_1164.all;

entity test is
end entity;

architecture structural of test is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal enable : std_logic := '1';

    signal alpha_code : std_logic_vector(2 downto 0);
    signal morse_code : std_logic;

    constant CLK_PERIOD : time := 50 ps;
begin
    uut : entity work.main(structural) port map (
        clk => clk,
        reset => reset,
        enable => enable,
        alpha_code => alpha_code,
        morse_code => morse_code
    );

    clk <= not clk after CLK_PERIOD / 2;

    stim : process is
    begin
        wait for 2 * CLK_PERIOD;

        reset <= '1';
        enable <= '0';
        alpha_code <= "001";

        wait for 30 * CLK_PERIOD;

        std.env.stop;
    end process;
end architecture;
