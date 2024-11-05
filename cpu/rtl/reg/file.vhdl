library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

use work.attrs.all;

entity reg_file is
    port (
        clk : in std_logic;
        rst : in std_logic;

        data_sel : in std_logic_vector(CPU_N_REG_BITS - 1 downto 0);
        data_in : in std_logic_vector(CPU_N_BITS - 1 downto 0);

        write : in std_logic;

        -- 4 registers: A, B, R and I
        a_sel, b_sel : in std_logic_vector(CPU_N_REG_BITS - 1 downto 0);
        out_a, out_b : out std_logic_vector(CPU_N_BITS - 1 downto 0)
    );

end entity;

architecture rtl of reg_file is
    signal reg_contents : reg_file_t; 
    signal reg_write : std_logic_vector(0 to CPU_N_REGS - 1);
begin
    reg_set : for i in 0 to CPU_N_REGS - 1 
    generate
        reg : entity work.reg(behavioral)
            generic map (CPU_N_BITS)
            port map (
                clk => clk,
                rst => rst,
                write => write and reg_write(i),
                input => data_in,
                q => reg_contents(i)
            );
    end generate;

    select_out_regs : process(clk, a_sel, b_sel) is
        variable a_index : integer;
        variable b_index : integer;
    begin
        a_index := to_integer(unsigned(a_sel));
        b_index := to_integer(unsigned(b_sel));
        
        if rising_edge(clk) then
            out_a <= reg_contents(a_index);
            out_b <= reg_contents(b_index);
        end if;
    end process;

    reg_write <= std_logic_vector(to_unsigned(1, reg_write'length) sll to_integer(unsigned(data_sel)));
end architecture;
