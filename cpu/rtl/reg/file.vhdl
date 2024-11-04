library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity reg_file is
    generic (
            N_BITS : natural;
            N_REGS : natural := 4;
        N_REG_BITS : natural := 2
    );
    port (
        clk : in std_logic;
        rst : in std_logic;

        data_sel : in std_logic_vector(N_REG_BITS - 1 downto 0);
        data_in : in std_logic_vector(N_BITS - 1 downto 0);

        write : in std_logic;

        -- 4 registers: A, B, R and I
        a_sel, b_sel : in std_logic_vector(N_REG_BITS - 1 downto 0);
        out_a, out_b : out std_logic_vector(N_BITS - 1 downto 0)
    );

    type reg_file_t is array (0 to N_REGS - 1) of std_logic_vector(7 downto 0);
end entity;

architecture rtl of reg_file is
    signal reg_contents : reg_file_t; 
    signal reg_write : std_logic_vector(0 to N_REGS - 1);
begin
    reg_set : for i in 0 to N_REGS - 1 
    generate
        reg : entity work.reg(behavioral)
            generic map (N_BITS)
            port map (
                clk => clk,
                rst => rst,
                write => write and reg_write(i),
                input => data_in,
                q => reg_contents(i)
            );
    end generate;

    select_out_regs : process(clk, a_sel, b_sel) is
        variable a_index : integer := to_integer(unsigned(a_sel));
        variable b_index : integer := to_integer(unsigned(b_sel));
    begin
        if rising_edge(clk) then
            out_a <= reg_contents(a_index);
            out_b <= reg_contents(b_index);
        end if;
    end process;

    reg_write <= std_logic_vector(to_unsigned(1, reg_write'length)) sll to_integer(unsigned(data_sel));
end architecture;
