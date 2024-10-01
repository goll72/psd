library ieee;

use ieee.std_logic_1164.all;

library work;

package display_attrs is
    type display_t is array(3 downto 0) of std_logic_vector(0 to 6);
end package;

library ieee;

use ieee.std_logic_1164.all;

library work;

entity main is
    port (clock   :  in std_logic;
          data    :  in std_logic_vector(3 downto 0);
          address :  in std_logic_vector(4 downto 0);
          wren    :  in std_logic;
          hex     : out work.display_attrs.display_t);
end entity;

architecture structural of main is
    signal q : std_logic_vector(3 downto 0);
begin
    ram : entity work.ram32x4(syn) port map (
        clock => clock,
        data => data,
        address => address,
        wren => wren,
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
        x => address(3 downto 0),
        h => hex(2) 
    );

    display_addr_upper : entity work.hex(behavioral) port map (
        x => "000" & address(4),
        h => hex(3)
    );
end architecture;
