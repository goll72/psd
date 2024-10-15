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
                q <= "01" & "00";
                l <= "010";
            -- B
            when "001" =>
                q <= "1000";
                l <= "100";
            -- C
            when "010" =>
                q <= "1010";
                l <= "100";
            -- D
            when "011" =>
                q <= "100" & "0";
                l <= "011"; 
            -- E 
            when "100" =>
                q <= "0" & "000";
                l <= "001";
            -- F 
            when "101" =>
                q <= "0010";
                l <= "100";
            -- G
            when "110" =>
                q <= "110" & "0";
                l <= "011";
            -- H
            when "111" =>
                q <= "0000";
                l <= "100";
            -- Não é um caso sintetizável
            when others =>
                q <= (others => '0');
                l <= (others => '0');
        end case;
    end process;
end architecture;
