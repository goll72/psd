library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity alu is
    port (
        op    :  in std_logic_vector(3 downto 0);
        a, b  :  in std_logic_vector(7 downto 0);
        q     : out std_logic_vector(7 downto 0)
    );
end entity;

architecture behavioral of alu is
begin
    do_arith_op : process(a, b) is
    begin
        case op is
            -- and
            when "0000" =>
                q <= a and b;
            -- or
            when "0001" =>
                q <= a or b;
            -- not
            when "0010" =>
                q <= not a;
            -- add
            when "0011" =>
                q <= std_logic_vector(signed(a) + signed(b));
            -- sub
            when "0100" =>
                q <= std_logic_vector(signed(a) - signed(b));
        end case;              
    end process;
end architecture;
