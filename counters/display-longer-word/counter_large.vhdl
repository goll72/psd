-- Counts up to 2^26 - 1

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity counter_large is
    port (clk, enable, clr : in  std_logic;
                         q : out std_logic_vector(25 downto 0));
end entity;

architecture behavioral of counter_large is
    signal k : unsigned(25 downto 0);
begin
    increment : process(clk) is
    begin
        if clr = '0' then 
            k <= (others => '0');
        elsif rising_edge(clk) and enable = '1' then
            k <= k + 1;
        end if;

        q <= std_logic_vector(k);
    end process;
end architecture;
