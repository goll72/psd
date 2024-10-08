library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity counter is
    generic (N : integer);
    port (clk, enable :  in std_logic;
          updown      :  in std_logic;
          load        :  in std_logic;
          data        :  in std_logic_vector(N - 1 downto 0);
          q           : out std_logic_vector(N - 1 downto 0));
end entity;

architecture behavioral of counter is
begin
    increment : process(clk, load) is
        variable k : unsigned(N - 1 downto 0);
    begin
        if load = '1' then
            k := unsigned(data);
        elsif rising_edge(clk) and enable = '1' then
            if updown = '1' then 
                k := k + 1;
            elsif updown = '0' then
                k := k - 1;
            end if;
        end if;

        q <= std_logic_vector(k);
    end process;
end architecture;
