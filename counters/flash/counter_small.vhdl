-- Counts up to 10

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity counter_small is
    port (clk, enable, clr : in  std_logic;
                         q : out std_logic_vector(3 downto 0));
end entity;

architecture behavioral of counter_small is
    signal k : unsigned(3 downto 0);
begin
    increment : process(clk) is
    begin
        if clr = '0' then 
            k <= (others => '0');
        elsif rising_edge(clk) and enable = '1' then
            k <= (k + 1) mod 10;
        end if;

        q <= std_logic_vector(k);
    end process;
end architecture;
