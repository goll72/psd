library ieee;

use ieee.std_logic_1164.all;

library work;

use work.morse_attrs.all;

entity main is
    port (
        clk, reset :  in std_logic;
        enable     :  in std_logic;
        alpha_code :  in std_logic_vector(2 downto 0);
        morse_code : out std_logic
    );
end entity;

architecture structural of main is
    signal morse_pulses : std_logic_vector(MORSE_MAX_LEN - 1 downto 0);
    signal morse_len : std_logic_vector(MORSE_MAX_LEN_BITS - 1 downto 0);
    signal next_pulse : std_logic;

    signal current_pulse_seq : std_logic_vector(MORSE_MAX_LEN - 1 downto 0);

    signal remaining_len : std_logic_vector(MORSE_MAX_LEN_BITS - 1 downto 0);
    
    signal morse_clk_count : std_logic_vector(COUNTER_CLK_BITS - 1 downto 0);
    signal morse_clk : std_logic;
begin
    lut : entity work.morse_lut(behavioral) port map (
        x => alpha_code,
        q => morse_pulses,
        l => morse_len
    );

    fsm : entity work.morse_fsm(behavioral) port map (
        clk => morse_clk,
        enable => enable,
        reset => reset,
        w => current_pulse_seq(MORSE_MAX_LEN - 1),
        count => remaining_len,
        q => morse_code,
        next_pulse => next_pulse
    );

    counter_morse_len : entity work.counter(behavioral)
        generic map (
            N => MORSE_MAX_LEN_BITS
        )
        port map (
            clk => morse_clk,
            updown => '0',
            load => not enable,
            enable => next_pulse,
            data => morse_len,
            q => remaining_len
        );

    counter_clk : entity work.counter(behavioral)
        generic map (
            N => COUNTER_CLK_BITS
        )
        port map (
            clk => clk,
            updown => '1',
            load => '0',
            enable => '1',
            data => (others => '0'),
            q => morse_clk_count
        );

    morse_clk <= morse_clk_count(COUNTER_CLK_BITS - 1);

    pulse_reg : entity work.shift_reg(behavioral) 
        generic map (
            N => MORSE_MAX_LEN
        )
        port map (
            clk => morse_clk,
            enable => next_pulse,
            load => not enable,
            data => morse_pulses,
            q => current_pulse_seq
        );
end architecture;
