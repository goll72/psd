library ieee;

use ieee.std_logic_1164.all;

library work;

entity reg_file is
    generic (
        N_REGS : natural := 4;
        N_REG_BITS : natural := 2
    );
    port (
        clk : in std_logic;
        rst : in std_logic;

        data_sel : in std_logic_vector(N_REG_BITS - 1 downto 0);
        data_in : in std_logic_vector(7 downto 0);

        write : in std_logic;

        -- 4 registers: A, B, R and I
        a_sel, b_sel : in std_logic_vector(N_REG_BITS - 1 downto 0);
        out_a, out_b : out std_logic_vector(7 downto 0)
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
            generic map (8)
            port map (
                clk => clk,
                rst => rst,
                write => write and reg_write(i),
                input => data_in,
                q => reg_contents(i)
            );
    end generate;

    select_out_regs : process(clk, a_sel, b_sel) is
    begin
        if rising_edge(clk) then
            case a_sel is 
                when "00" => out_a <= reg_contents(0);
                when "01" => out_a <= reg_contents(1);
                when "10" => out_a <= reg_contents(2);
                when "11" => out_a <= reg_contents(3);
            end case;

            case b_sel is 
                when "00" => out_b <= reg_contents(0);
                when "01" => out_b <= reg_contents(1);
                when "10" => out_b <= reg_contents(2);
                when "11" => out_b <= reg_contents(3);
            end case;
        end if;
    end process;

    select_in_reg : process(clk, data_sel) is
    begin
        if rising_edge(clk) then
            case data_sel is
                when "00" => reg_write <= "0001";
                when "01" => reg_write <= "0010";
                when "10" => reg_write <= "0100";
                when "11" => reg_write <= "1000";
            end case;
        end if;
    end process;
end architecture;
