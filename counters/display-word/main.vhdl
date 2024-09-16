library ieee;

use ieee.std_logic_1164.all;

library work;

package display_attrs is
    constant N_DISPLAYS : integer := 4;
    type segmentwise_t is array (6 downto 0) of std_logic_vector(N_DISPLAYS - 1 downto 0);
    type display_array_t is array (N_DISPLAYS - 1 downto 0) of std_logic_vector(6 downto 0);
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
    constant DISPLAY_INIT : segmentwise_t :=
        -- ' ', 'd', 'E', '0'
        -- Transposed: ("1111111", "1000010", "0110000", "0000001");
        ("1100", "1010", "1010", "1000", "1000", "1100", "1001");
    signal t : segmentwise_t;
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
                data => DISPLAY_INIT(i),
                q => t(i)
            );
    end generate;
    hex_signals : for i in 0 to N_DISPLAYS - 1
    generate
        hex(i) <= (t(0)(i), t(1)(i), t(2)(i), t(3)(i), t(4)(i), t(5)(i), t(6)(i));
    end generate;
end architecture;
