library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity counter is
    generic (N : integer);
    port (clk, enable, clr : in  std_logic;
                         q : out std_logic_vector(N - 1 downto 0));
end entity;

architecture behavioral of counter is
    signal k : unsigned(N - 1 downto 0);
begin
    increment : process(clk, clr) is
    begin
        if clr = '0' then
            k <= (others => '0');
        elsif rising_edge(clk) and enable = '1' then
            k <= k + 1;
        end if;

        q <= std_logic_vector(k);
    end process;
end architecture;
