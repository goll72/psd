-- A synchronous 8-bit counter + 7 segment display

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY main IS
   PORT (CLK, ENABLE, CLR :  IN  STD_LOGIC;
         HEX0, HEX1       : OUT  STD_LOGIC_VECTOR(0 TO 6));
END main;

ARCHITECTURE Structural OF main IS
	SIGNAL count : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL K_a, K_b : STD_LOGIC_VECTOR(3 DOWNTO 0);
	ATTRIBUTE KEEP : BOOLEAN;
   ATTRIBUTE KEEP OF count, K_a, K_b : SIGNAL IS TRUE;
BEGIN
	h_a : ENTITY work.hex(Procedural) PORT MAP (
		X => count(3 DOWNTO 0),
		H => HEX0
	);
	K_a <= count(3 DOWNTO 0);
	h_b : ENTITY work.hex(Procedural) PORT MAP (
		X => count(7 DOWNTO 4),
		H => HEX1
	);
	K_b <= count(7 DOWNTO 4);
	counter : ENTITY work.counter_8(Structural) PORT MAP (
		CLK => CLK,
		ENABLE => ENABLE,
		CLR => CLR,
		Q_0 => count(0),
		Q_1 => count(1),
		Q_2 => count(2),
		Q_3 => count(3),
		Q_4 => count(4),
		Q_5 => count(5),
		Q_6 => count(6),
		Q_7 => count(7)
	);
END Structural;