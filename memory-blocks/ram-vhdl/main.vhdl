library ieee;

use ieee.std_logic_1164.all;

library work;

package attrs is
    constant ADDR_BITS : integer := 5;
    constant WORD_BITS : integer := 4;
    type display_t is array(3 downto 0) of std_logic_vector(0 to 6);
end package;

library ieee;

use ieee.std_logic_1164.all;

library work;

use work.attrs.all;

entity main is
    port (
        clk, write :  in std_logic;
        addr       :  in std_logic_vector(ADDR_BITS - 1 downto 0);
        data       :  in std_logic_vector(WORD_BITS - 1 downto 0);
        hex        : out display_t
    );
end entity;

architecture structural of main is
    signal q : std_logic_vector(WORD_BITS - 1 downto 0);
begin
    ram : entity work.ram
        generic map (
            ADDR_BITS => ADDR_BITS,
            WORD_BITS => WORD_BITS
        )
        port map (
            clk => clk,
            write => write,
            addr => addr,
            data => data,
            q => q
        );

    display_q : entity work.hex(behavioral) port map (
        x => q,
        h => hex(0)
    );

    display_data_in : entity work.hex(behavioral) port map (
        x => data,
        h => hex(1)
    );
    
    display_addr_lower : entity work.hex(behavioral) port map (
        x => addr(3 downto 0),
        h => hex(2) 
    );

    display_addr_upper : entity work.hex(behavioral) port map (
        x => "000" & addr(4),
        h => hex(3)
    );
end architecture;
