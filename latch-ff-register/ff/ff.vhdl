-- A flip-flop implemented using two gated D latches
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY ff IS
	PORT (CLK,    D : IN		STD_LOGIC;
					  Q : OUT 	STD_LOGIC);
END ff;

ARCHITECTURE ff_structure OF ff IS
	SIGNAL Q_m, Q_s : STD_LOGIC;
	ATTRIBUTE KEEP : BOOLEAN;
	ATTRIBUTE KEEP OF Q_m : SIGNAL IS TRUE;
BEGIN
	D_m : ENTITY work.d(Structural) PORT MAP(
		CLK => "NOT"(CLK),
		D => D,
		Q => Q_m
	);
	D_s : ENTITY work.d(Structural) PORT MAP(
		CLK => CLK,
		D => Q_m,
		Q => Q_s
	);
	Q <= Q_s;
END ff_structure;