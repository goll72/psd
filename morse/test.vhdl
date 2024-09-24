library ieee;

use ieee.std_logic_1164.all;

entity test is
end entity;

architecture structural of test is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal enable : std_logic := '0';

    signal alpha_code : std_logic_vector(2 downto 0);
    signal morse_code : std_logic;

    constant CLK_PERIOD : time := 50 ps;
begin
    main : entity work.main(structural) port map (
        clk => clk,
        rst => rst,
        enable => enable,

        alpha_code => alpha_code,
        morse_code => morse_code
    );
    
    clk <= not clk after CLK_PERIOD / 2;
    
    stim : process is
    begin
        wait for 10 * CLK_PERIOD;

        rst <= '1';
        alpha_code <= "000";
        enable <= '0';

        wait for 2 * CLK_PERIOD;

        enable <= '1';

        wait for 80 * CLK_PERIOD;

        alpha_code <= "010";
        enable <= '0';

        wait for 2 * CLK_PERIOD;

        enable <= '1';

        wait for 120 * CLK_PERIOD;

        std.env.stop;
    end process;
end architecture;
