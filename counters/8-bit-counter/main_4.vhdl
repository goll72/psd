-- Counter + 7 segment display

library ieee;
use ieee.std_logic_1164.all;

library work;

entity main_4 is
    PORT (clk, enable, clr : in  std_logic;
          hex0             : out std_logic_vector(0 to 6));
end entity;

architecture structural of main_4 is
    signal count : std_logic_vector(3 downto 0);
begin
    h_a : entity work.hex(behavioral) port map (
        x => count,
        h => hex0
    );
    counter : entity work.counter_4(structural) port map (
        clk => clk,
        enable => enable,
        clr => clr,
        q => count
    );
end architecture;
