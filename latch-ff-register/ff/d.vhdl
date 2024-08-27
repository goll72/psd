-- A gated D latch desribed the hard way
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY d IS
	PORT (CLK,    D : IN		STD_LOGIC;
					  Q : OUT 	STD_LOGIC);
END d;

ARCHITECTURE Structural OF d IS
	SIGNAL R, S, R_g, S_g, Q_a, Q_b : STD_LOGIC ;
	ATTRIBUTE KEEP : BOOLEAN;
	ATTRIBUTE KEEP OF R, S, R_g, S_g, Q_a, Q_b : SIGNAL IS TRUE;
BEGIN
	S <= D;
	R <= NOT D;
	R_g <= NOT (R AND CLK);
	S_g <= NOT (S AND CLK);
	Q_a <= NOT (S_g AND Q_b);
	Q_b <= NOT (R_g AND Q_a);
	Q <= Q_a;
END Structural;