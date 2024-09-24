library ieee;

use ieee.std_logic_1164.all;

entity shift_reg is
    generic (
        N : integer
    );
    port (
        clk, enable, load :  in std_logic;
        data              :  in std_logic_vector(N - 1 downto 0);
        q                 : out std_logic_vector(N - 1 downto 0)
    );
end entity;

architecture behavioral of shift_reg is
begin
    shift_or_load : process is
    begin
        if load = '1' then
            q <= data;
        elsif rising_edge(clk) and enable = '1' then
            q(N - 2 downto 0) <= q(N - 1 downto 1);
            q(N - 1) <= q(0);            
        end if;
    end process;
end architecture;
