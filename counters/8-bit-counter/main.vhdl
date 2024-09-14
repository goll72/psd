-- Counter + 7 segment display

library ieee;
use ieee.std_logic_1164.all;

library work;

entity main is
    port (clk, enable, clr : in  std_logic;
          hex0, hex1       : out std_logic_vector(0 to 6));
end entity;

architecture structural of main is
    signal count : std_logic_vector(7 downto 0);
begin
    h_a : entity work.hex(behavioral) port map (
        x => count(3 downto 0),
        h => hex0
    );
    h_b : entity work.hex(behavioral) port map (
        x => count(7 downto 4),
        h => hex1
    );
    counter : entity work.counter_8(structural) port map (
        clk => clk,
        enable => enable,
        clr => clr,
        q => count
    );
end architecture;
