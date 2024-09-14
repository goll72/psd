library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity main is
    port (clk, clr : in  std_logic;
          hex0     : out std_logic_vector(0 to 6));
end entity;

architecture structural of main is
    signal n : std_logic_vector(24 downto 0);
    signal k : std_logic_vector(3 downto 0);

    attribute keep : boolean;
    attribute keep of n, k : signal is true;
begin
    large : entity work.counter_large(behavioral) port map (
        clk => clk,
        enable => '1',
        clr => clr,
        q => n
    );
    small : entity work.counter_small(behavioral) port map (
        clk => clk,
        -- not (n(0) or n(1) ... or n(24))
        enable => not(or_reduce(n)),
        clr => clr,
        q => k
    );
    h : entity work.hex(behavioral) port map (
        x => k,
        h => hex0
    );
end architecture;                        
