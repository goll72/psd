library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity morse_lut is
    port (
        x :  in std_logic_vector(2 downto 0);
        q : out std_logic_vector(10 downto 0);
        l : out std_logic_vector(3 downto 0)
    );
end entity;

architecture behavioral of morse_lut is
begin
    process is
    begin
        case? x is
            -- A
            when "000" =>
                q <= "10111" & (others => '0');
                l <= x"5";
            -- B
            when "001" =>
                q <= "111010101" & (others => '0');
                l <= x"9";
            -- C
            when "010" =>
                q <= "11101011101" & (others => '0');
                l <= x"b";
            -- D
            when "011" =>
                q <= "1110101" & (others => '0');
                l <= x"7"; 
            -- E 
            when "100" =>
                q <= "1" & (others => '0');
                l <= x"1";
            -- F 
            when "101" =>
                q <= "101011101" & (others => '0');
                l <= x"9";
            -- G
            when "110" =>
                q <= "111011101" & (others => '0');
                l <= x"9";
            -- H
            when "111" =>
                q <= "10101010" & (others => '0');
                l <= x"8";
        end case?;                
    end process;
end architecture;
