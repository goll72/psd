-- A 7-segment hexadecimal display driver circuit

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;

-- X(3) é o MSB, X(0) é o LSB
ENTITY hex IS
   PORT (X : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
         H : OUT   STD_LOGIC_VECTOR(0 TO 6));
END hex;

ARCHITECTURE Procedural OF hex IS
	ATTRIBUTE KEEP : BOOLEAN;
   ATTRIBUTE KEEP OF X : SIGNAL IS TRUE;
BEGIN
	PROCESS(X) IS
	BEGIN
		CASE X IS
			WHEN "0000" => -- 0
				H <= "0000001";
			WHEN "0001" => -- 1
				H <= "1001111";
			WHEN "0010" => -- 2
				H <= "0010010";
			WHEN "0011" => -- 3
				H <= "0000110";
			WHEN "0100" => -- 4
				H <= "1001100";
			WHEN "0101" => -- 5
				H <= "0100100";
			WHEN "0110" => -- 6
				H <= "0100000";
			WHEN "0111" => -- 7
				H <= "0001111";
			WHEN "1000" => -- 8
				H <= "0000000";
			WHEN "1001" => -- 9
				H <= "0000100";
			WHEN "1010" => -- A
				H <= "0001000";
			WHEN "1011" => -- B
				H <= "1100000";
			WHEN "1100" => -- C
				H <= "0110001";
			WHEN "1101" => -- D
				H <= "1000010";
			WHEN "1110" => -- E
				H <= "0110000";
			WHEN "1111" => -- F
				H <= "0111000";
			WHEN OTHERS => H <= "1111110";
		END CASE;
	END PROCESS;
END Procedural;