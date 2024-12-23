library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

use work.asm.all;
use work.attrs.all;

entity alu is
    generic (
        N_BITS : natural
    );
    port (
        op       :  in std_logic_vector(IR_RANGE);
        a, b     :  in std_logic_vector(N_BITS - 1 downto 0);
        q        : out std_logic_vector(N_BITS - 1 downto 0);
        carry    : out std_logic;
        overflow : out std_logic
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
            c_out => carry,
            q => adder_out,
            overflow => overflow
        );

    do_op : process(op, a, b, adder_out) is
    begin
        -- NOTE: this is needed, otherwise adder_in/adder_c_in will become latches clocked by ir/op!!
        -- It doesn't matter, as we only use the output of the adder in the cases where we override 
        -- these signals. We could just drive the signals out of the process but I think this is more readable.
        adder_in <= (others => '0');
        adder_c_in <= '0';

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
            when OP_SUB | OP_CMP =>
                adder_in <= not b;
                adder_c_in <= '1';

                q <= adder_out;
            when others =>
                q <= (others => '0');
        end case;              
    end process;
end architecture;
