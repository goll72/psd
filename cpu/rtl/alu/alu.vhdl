library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

use work.asm.all;

entity alu is
    generic (
        N_BITS : natural
    );
    port (
        op    :  in std_logic_vector(3 downto 0);
        a, b  :  in std_logic_vector(N_BITS - 1 downto 0);
        q     : out std_logic_vector(N_BITS - 1 downto 0)
    );
end entity;

architecture behavioral of alu is
    signal adder_in : std_logic_vector(N_BITS - 1 downto 0);
    signal adder_out : std_logic_vector(N_BITS - 1 downto 0);
    signal adder_c_in : std_logic;
begin
    adder : entity work.adder
        generic map (N_BITS)
        port map (
            a => a,
            b => adder_in,
            c_in => adder_c_in,
            q => adder_out
        );

    do_op : process(a, b) is
    begin
        case op is
            when OP_AND =>
                q <= a and b;
            when OP_OR =>
                q <= a or b;
            when OP_NOT =>
                q <= not a;
            when OP_ADD =>
                adder_in <= b;
                adder_c_in <= '0';
                
                q <= adder_out;
            when OP_SUB =>
                adder_in <= not b;
                adder_c_in <= '1';

                q <= adder_out;
            when others =>
                q <= (others => '0');
        end case;              
    end process;
end architecture;
