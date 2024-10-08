library ieee;

use ieee.std_logic_1164.all;

library work;

entity test is
end entity;

architecture structural of test is
    signal w : std_logic;
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal z : std_logic;
    signal fsm_state : std_logic_vector(8 downto 0);

    constant CLK_PERIOD : time := 50 ps;
begin
    uut : entity work.fsm(behavioral) port map (        
        w => w,
        clk => clk,
        reset => reset,
        z => z,
        state => fsm_state
    );

    clk <= not clk after CLK_PERIOD / 2;

    stim : process is
    begin
        wait for 2 * CLK_PERIOD;
        
        reset <= '1';
        w <= '1';
        
        wait for 2 * CLK_PERIOD;

        w <= '0';

        wait for 6 * CLK_PERIOD;

        w <= '1';

        wait for 3 * CLK_PERIOD;
        
        std.env.stop;
    end process;
end architecture;
