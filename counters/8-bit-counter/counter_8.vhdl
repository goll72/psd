-- A synchronous 8-bit counter implemented using 8 type T flip-flops

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY counter_8 IS
   PORT (CLK, ENABLE, CLR :  IN  STD_LOGIC;
         Q_0, Q_1, Q_2, Q_3, Q_4, Q_5, Q_6, Q_7 : OUT  STD_LOGIC);
END counter_8;

ARCHITECTURE Structural OF counter_8 IS
	SIGNAL i_0, i_1, i_2, i_3, i_4, i_5, i_6 : STD_LOGIC;
	SIGNAL s_0, s_1, s_2, s_3, s_4, s_5, s_6, s_7 : STD_LOGIC;
BEGIN
   t_0 : ENTITY work.ff_t(Structural) PORT MAP (
		CLK => CLK,
		CLR => CLR,
		T => ENABLE,
		Q => s_0
   );
	i_0 <= s_0 AND ENABLE;
	Q_0 <= s_0;
   t_1 : ENTITY work.ff_t(Structural) PORT MAP (
		CLK => CLK,
		CLR => CLR,
		T => i_0,
		Q => s_1
   );
	i_1 <= s_1 AND i_0;
	Q_1 <= s_1;
   t_2 : ENTITY work.ff_t(Structural) PORT MAP (
		CLK => CLK,
		CLR => CLR,
		T => i_1,
		Q => s_2
   );
	i_2 <= s_2 AND i_1;
	Q_2 <= s_2;
   t_3 : ENTITY work.ff_t(Structural) PORT MAP (
		CLK => CLK,
		CLR => CLR,
		T => i_2, 
		Q => s_3
   );
	i_3 <= s_3 AND i_2;
	Q_3 <= s_3;
   t_4 : ENTITY work.ff_t(Structural) PORT MAP (
		CLK => CLK,
		CLR => CLR,
		T => i_3, 
		Q => s_4
   );
	i_4 <= s_4 AND i_3;
	Q_4 <= s_4;
   t_5 : ENTITY work.ff_t(Structural) PORT MAP (
		CLK => CLK,
		CLR => CLR,
		T => i_4, 
		Q => s_5
   );
	i_5 <= s_5 AND i_4;
	Q_5 <= s_5;
   t_6 : ENTITY work.ff_t(Structural) PORT MAP (
		CLK => CLK,
		CLR => CLR,
		T => i_5, 
		Q => s_6
   );
	i_6 <= s_6 AND i_5;
	Q_6 <= s_6;
   t_7 : ENTITY work.ff_t(Structural) PORT MAP (
		CLK => CLK,
		CLR => CLR,
		T => i_6,
		Q => s_7
   );
	Q_7 <= s_7;
END Structural;