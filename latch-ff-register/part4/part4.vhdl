-- A flip-flop implemented using two gated D latches
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY part4 IS
	PORT (CLK,    D : IN		STD_LOGIC;
					  Q_a, Q_b, Q_c, Q_na, Q_nb, Q_nc : OUT 	STD_LOGIC);
END part4;

ARCHITECTURE part4_structure OF part4 IS
	
	
BEGIN
	D_1 : ENTITY work.d(d) PORT MAP(
		CLK => CLK,
		D => D,
		Q => Q_a 
	);
	
	
	ff_n : ENTITY work.ff(ff) PORT MAP(
		CLK => CLK,
		D => D,
		Q => Q_b
	);
	
	
	ff_p : ENTITY work.ff(ff) PORT MAP(
		CLK => "NOT"(CLK),
		D => D,
		Q => Q_c
	);
	
	
END part4_structure;