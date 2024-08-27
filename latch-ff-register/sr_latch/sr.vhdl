-- A gated SR latch desribed the hard way
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY sr IS
	PORT (CLK, R, S : IN		STD_LOGIC;
					  Q : OUT 	STD_LOGIC);
END sr;

ARCHITECTURE sr_structure OF sr IS
	SIGNAL R_g, S_g, Q_a, Q_b : STD_LOGIC ;
	ATTRIBUTE KEEP : BOOLEAN;
	ATTRIBUTE KEEP OF R_g, S_g, Q_a, Q_b : SIGNAL IS TRUE;
BEGIN
	R_g <= R AND CLK;
	S_g <= S AND CLK;
	Q_a <= NOT (R_g OR Q_b);
	Q_b <= NOT (S_g OR Q_a);
	Q <= Q_a;
END sr_structure;