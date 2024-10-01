library ieee;

use ieee.std_logic_1164.all;

library work;

package display_attrs is
    type display_t is array(5 downto 0) of std_logic_vector(0 to 6);
end package;

library ieee;

use ieee.std_logic_1164.all;

library work;

entity main is
	port (
		wraddress : in  std_logic_vector(4 downto 0);
		clk 	  : in  std_logic;
        -- rst ativa com '0' (push button)
        rst       : in  std_logic;
		data      : in  std_logic_vector(3 downto 0);
		wren      : in  std_logic;
		hex       : out work.display_attrs.display_t
	);
end entity;

architecture structural of main is
    signal count_clk : std_logic_vector(25 downto 0);
    signal rdaddress : std_logic_vector(4 downto 0);
    signal q : std_logic_vector(3 downto 0);
begin
    ram : entity work.ram32x4(syn) port map (
        rdaddress => rdaddress,
        wraddress => wraddress,
        clock => clk,
        data => data,
        wren => wren,
        q => q
    );

    counter_clk : entity work.counter(behavioral) 
        generic map (
            N => 26
        )
        port map (
            clk => clk,
            clr => rst,
            enable => '1',
            q => count_clk
        );

    counter_rdaddress : entity work.counter(behavioral)
        generic map (
            N => 5
        )
        port map (
            clk => count_clk(count_clk'high),
            clr => rst,
            enable => '1',
            q => rdaddress
        );
        

    display_q : entity work.hex(behavioral) port map (
        x => q,
        h => hex(0)
    );
    
    display_wrdata : entity work.hex(behavioral) port map (
        x => data,
        h => hex(1)
    );
    
    display_rdaddr_lower : entity work.hex(behavioral) port map (
        x => rdaddress(3 downto 0),
        h => hex(2) 
    );

    display_rdaddress_upper : entity work.hex(behavioral) port map (
        x => "000" & rdaddress(4),
        h => hex(3)
    );

    display_wraddr_lower : entity work.hex(behavioral) port map (
        x => wraddress(3 downto 0),
        h => hex(4) 
    );

    display_wraddress_upper : entity work.hex(behavioral) port map (
        x => "000" & wraddress(4),
        h => hex(5)
    );
end architecture;
