-- A 7-segment hexadecimal display driver circuit

library ieee;
use ieee.std_logic_1164.all;

library work;

-- X(3) é o MSB, X(0) é o LSB
entity hex is
   	port (x : in    std_logic_vector(3 downto 0);
          h : out   std_logic_vector(0 to 6));
end entity;

architecture behavioral of hex is
begin
    process(x) is
    begin
		case x is
            when "0000" => -- 0
                h <= "0000001";
            when "0001" => -- 1
                h <= "1001111";
            when "0010" => -- 2
                h <= "0010010";
            when "0011" => -- 3
                h <= "0000110";
            when "0100" => -- 4
                h <= "1001100";
            when "0101" => -- 5
                h <= "0100100";
            when "0110" => -- 6
                h <= "0100000";
            when "0111" => -- 7
                h <= "0001111";
            when "1000" => -- 8
                h <= "0000000";
            when "1001" => -- 9
                h <= "0000100";
            when "1010" => -- A
                h <= "0001000";
            when "1011" => -- B
                h <= "1100000";
            when "1100" => -- C
                h <= "0110001";
            when "1101" => -- D
                h <= "1000010";
            when "1110" => -- E
                h <= "0110000";
            when "1111" => -- F
                h <= "0111000";
            when others =>
                h <= "1111110";
		end case;
	end process;
end architecture;
