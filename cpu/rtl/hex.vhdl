library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity hex is
   	port (
        valid : in std_logic;

        x :  in std_logic_vector(3 downto 0);
        q : out std_logic_vector(0 to 6)
    );
end entity;

architecture behavioral of hex is
begin
    process(valid, x) is
    begin
        if valid = '1' then
    		case to_integer(unsigned(x)) is
                when 16#0# =>
                    q <= "0000001";
                when 16#1# =>
                    q <= "1001111";
                when 16#2# =>
                    q <= "0010010";
                when 16#3# =>
                    q <= "0000110";
                when 16#4# =>
                    q <= "1001100";
                when 16#5# =>
                    q <= "0100100";
                when 16#6# =>
                    q <= "0100000";
                when 16#7# =>
                    q <= "0001111";
                when 16#8# =>
                    q <= "0000000";
                when 16#9# =>
                    q <= "0000100";
                when 16#A# =>
                    q <= "0001000";
                when 16#B# =>
                    q <= "1100000";
                when 16#C# =>
                    q <= "0110001";
                when 16#D# =>
                    q <= "1000010";
                when 16#E# =>
                    q <= "0110000";
                when 16#F# =>
                    q <= "0111000";
    		end case;
        else
            q <= "1111110";
        end if;
	end process;
end architecture;
