library ieee;

use ieee.std_logic_1164.all;

library work;

package display_attrs is
    constant N_DISPLAYS : integer := 4;
    type display_array_t is array (N_DISPLAYS - 1 downto 0, 6 downto 0) of std_logic;
end package;

library ieee;

use ieee.std_logic_1164.all;

library work;

use work.display_attrs.all;

entity main is
    port (clk, clr : in  std_logic;
          hex      : out display_array_t);
end entity;

architecture structural of main is
    constant DISPLAY_INIT : display_array_t :=
        -- ' ', 'd', 'E', '0'
        ("1111111", "1000010", "0110000", "0000001");
    signal s : display_array_t;
begin
    shift_regs : for i in 0 to 6
    generate
        reg : entity work.shift_reg(structural) 
            generic map (
                N => N_DISPLAYS
            )
            port map (
                clk => clk,
                load => not clr,
                data => DISPLAY_INIT(N_DISPLAYS - 1 downto 0, i),
                q => s(N_DISPLAYS - 1 downto 0, i)
            );
    end generate;
    hex <= s;
end architecture;
