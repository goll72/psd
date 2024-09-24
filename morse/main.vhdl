library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

library work;

use work.morse_attrs.all;

entity main is
    port (
        -- enable e rst estão ligados a push buttons que geram nível lógico 1 quando NÃO pressionados
        -- e 0 quando pressionados, portanto, o enable e o rst ambos ativam com 0.
        clk, enable, rst :  in std_logic;
        -- Specifies the letter to be displayed, "000" is A, "001" is B, ..., "111" is H
        alpha_code       :  in std_logic_vector(2 downto 0);
        -- Morse code output
        morse_code       : out std_logic;
        a, b             : out std_logic_vector(3 downto 0)
    );
end entity;

architecture structural of main is
    -- morse_pulses guarda a sequência de pulsos da letra escolhida
    -- morse_out é a saída do registrador de deslocamento
    signal morse_pulses, morse_out : std_logic_vector(MORSE_MAX_LEN - 1 downto 0);
    signal morse_len : std_logic_vector(3 downto 0);
    -- count_clk é a saída do contador que será utilizada para derivar o clock
    signal count_clk : std_logic_vector(COUNTER_CLK_BITS - 1 downto 0);
    -- morse_clk é o clock de 0.5s derivado do contador 
    signal morse_clk : std_logic;

    signal cur_step : std_logic_vector(3 downto 0);

    signal is_displaying : std_logic;
begin
    lut : entity work.morse_lut(behavioral) port map (
        x => alpha_code,
        q => morse_pulses,
        l => morse_len
    );
    
    pulse_reg : entity work.shift_reg(structural) 
        generic map (
            N => MORSE_MAX_LEN
        )
        port map (
            clk => morse_clk,
            enable => is_displaying,
            load => not enable,
            data => morse_pulses,
            q => morse_out
        );
        
    counter_clk : entity work.counter(behavioral) 
        generic map (
            N => COUNTER_CLK_BITS
        )
        port map (
            clk => clk,
            enable => '1',
            clr => rst,
            q => count_clk
        );
        
    counter_code_len : entity work.counter(behavioral) 
        generic map (
            N => MORSE_MAX_LEN_BITS
        )
        port map (
            clk => morse_clk,
            enable => is_displaying,
            clr => enable and rst,
            q => cur_step
        );
        
    morse_clk <= count_clk(COUNTER_CLK_BITS - 1);
    morse_code <= is_displaying and morse_out(MORSE_MAX_LEN - 1);
   
    control_display : process(rst, cur_step, morse_len) is
        variable cur_step_is_final : std_logic := not(or_reduce(cur_step xor morse_len));
    begin
        if rst = '0' or cur_step_is_final = '1' then
            is_displaying <= '0';
        elsif enable = '0' then
            is_displaying <= '1';
        end if;
    end process;
end architecture;
