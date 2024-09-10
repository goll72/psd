-- A gated D latch
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY latch_d IS
   PORT (CLK,    D : IN    STD_LOGIC;
                 Q : OUT   STD_LOGIC);
END latch_d;

ARCHITECTURE Structural OF latch_d IS
   SIGNAL R, S, R_g, S_g, Q_a, Q_b : STD_LOGIC;
   ATTRIBUTE KEEP : BOOLEAN;
   ATTRIBUTE KEEP OF R, S, R_g, S_g, Q_a, Q_b : SIGNAL IS TRUE;
BEGIN
   S <= D;
   R <= NOT D;
   R_g <= R AND CLK;
   S_g <= S AND CLK;
   Q_a <= NOT (R_g OR Q_b);
   Q_b <= NOT (S_g OR Q_a);
   Q <= Q_a;
END Structural;