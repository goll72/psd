library ieee;
use ieee.std_logic_1164.all;

entity main is
    port (clk, enable, clr       : in  std_logic;
          hex0, hex1, hex2, hex3 : out std_logic_vector(0 to 6));
end entity;

architecture structural of main is
    signal count : std_logic_vector(15 downto 0);

    attribute keep : boolean;
    attribute keep of count : signal is true;
begin
    counter : entity work.counter(behavioral) port map (
        clk => clk,
        enable => enable,
        clr => clr,
        q => count
    );
    h_a : entity work.hex(behavioral) port map (
        x => count(3 downto 0),
        h => hex0
    );
    h_b : entity work.hex(behavioral) port map (
        x => count(7 downto 4),
        h => hex1
    );
    h_c : entity work.hex(behavioral) port map (
        x => count(11 downto 8),
        h => hex2
    );
    h_d : entity work.hex(behavioral) port map (
        x => count(15 downto 12),
        h => hex3
    );
end architecture;                        
