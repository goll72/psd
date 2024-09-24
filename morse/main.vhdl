library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity main is
    port (
        clk, enable, rst :  in std_logic;
        -- Specifies the letter to be displayed, "000" is A, "001" is B, ..., "111" is H
        alpha_code       :  in std_logic_vector(2 downto 0);
        -- Morse code output
        morse_code       : out std_logic
    );
end entity;

library work;

architecture structural of main is
    -- morse_pulses guarda a sequência de pulsos da letra escolhida
    -- morse_out é a saída do registrador de deslocamento
    signal morse_pulses, morse_out : std_logic_vector(10 downto 0);
    signal morse_len : std_logic_vector(3 downto 0);
    -- count_clk é a saída do contador que será utilizada para derivar o clock
    signal count_clk : std_logic_vector(25 downto 0);
    -- morse_clk é o clock de 0.5s derivado do contador 
    signal morse_clk : std_logic;

    signal cur_step : std_logic_vector(4 downto 0);

    signal is_displaying : std_logic;
begin
    lut : entity work.morse_lut(behavioral) port map (
        x => alpha_code,
        q => morse_pulses,
        l => morse_len
    );
    
    pulse_reg : entity work.shift_reg(behavioral) 
        generic map (
            N => 11
        )
        port map (
            clk => morse_clk,
            enable => '1',
            load => enable,
            data => morse_pulses,
            q => morse_out
        );
        
    counter_clk : entity work.counter(behavioral) 
        generic map (
            N => 25
        )
        port map (
            clk => clk,
            enable => '1',
            clr => not rst,
            q => count_clk
        );
        
    counter_code_len : entity work.counter(behavioral) 
        generic map (
            N => 4
        )
        port map (
            clk => morse_clk,
            enable => '1',
            clr => not enable,
            q => cur_step
        );
        
    morse_clk <= count_clk(25);
    morse_code <= is_displaying and morse_out(10);

    stop_displaying : process(rst, cur_step, morse_len) is
        variable cur_step_is_final : std_logic := not(or_reduce(cur_step xor morse_len));
    begin
        if rst = '1' or cur_step_is_final = '1' then
            is_displaying <= '0';
        end if;
    end process;
end architecture;
