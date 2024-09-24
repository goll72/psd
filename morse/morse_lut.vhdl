library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

use work.morse_attrs.all;

entity morse_lut is
    port (
        x :  in std_logic_vector(2 downto 0);
        q : out std_logic_vector(MORSE_MAX_LEN - 1 downto 0);
        l : out std_logic_vector(MORSE_MAX_LEN_BITS - 1 downto 0)
    );
end entity;

architecture behavioral of morse_lut is
begin
    process(x) is
    begin
        case x is
            -- A
            when "000" =>
                q <= "10111" & "000000";
                l <= x"6";
            -- B
            when "001" =>
                q <= "111010101" & "00";
                l <= x"a";
            -- C
            when "010" =>
                q <= "11101011101";
                l <= x"c";
            -- D
            when "011" =>
                q <= "1110101" & "0000";
                l <= x"8"; 
            -- E 
            when "100" =>
                q <= "1" & "0000000000";
                l <= x"2";
            -- F 
            when "101" =>
                q <= "101011101" & "00";
                l <= x"a";
            -- G
            when "110" =>
                q <= "111011101" & "00";
                l <= x"a";
            -- H
            when "111" =>
                q <= "10101010" & "000";
                l <= x"9";
            -- Não é um caso sintetizável
            when others =>
                q <= (others => '0');
                l <= (others => '0');
        end case;
    end process;
end architecture;
