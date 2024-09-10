-- A flip-flop implemented using two gated D latches
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY ff_t IS
    PORT (CLK, CLR, T : IN    STD_LOGIC;
                    Q : OUT    STD_LOGIC);
END ff_t;

ARCHITECTURE Structural OF ff_t IS
    SIGNAL D_in, s : STD_LOGIC;
BEGIN
    D_in <= CLR AND ((T AND (NOT s)) OR ((NOT T) AND s));
    D_internal : ENTITY work.ff_d(Structural) PORT MAP(
       CLK => CLK,
       D => D_in,
       Q => s
    );
	 Q <= s;
END Structural;