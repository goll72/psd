library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

library work;

use work.morse_attrs.all;

entity morse_fsm is 
    port (
        w, clk, enable, reset :  in std_logic;
        count                 :  in std_logic_vector(MORSE_MAX_LEN_BITS - 1 downto 0);
        q, next_pulse         : out std_logic
    );
end entity;

architecture behavioral of morse_fsm is
    type state_t is (A, B, C, D, E, F);
begin
    state_transition : process(w, clk, reset) is
        variable current : state_t;
    begin
        if rising_edge(clk) then
            case current is
                when A =>
                    if enable = '0' then
                        current := B;
                    end if;
                when B =>
                    if or_reduce(count) = '0' then
                        current := A;
                    elsif w = '1' then
                        current := D;
                    elsif w = '0' then
                        current := C;
                    end if;
                when C => 
                    current := B;
                when D =>
                    current := E;
                when E => 
                    current := F;
                when F =>
                    current := B;
            end case;

            if current = A or current = B then
                q <= '0';
            else
                q <= '1';
            end if;

            if current = C or current = F then
                next_pulse <= '1';
            else
                next_pulse <= '0';
            end if;
        end if;

        if reset = '0' then
            current := A;
        end if;
    end process;
end architecture;
