library ieee;

use ieee.std_logic_1164.all;

library work;

use work.attrs.all;

entity cpu is
    port (
        clk : in std_logic;
        rst : in std_logic;
        int : in std_logic;

        addr_bus : inout std_logic_vector(CPU_N_BITS - 1 downto 0);
        data_bus : inout std_logic_vector(CPU_N_BITS - 1 downto 0);

        mem_enable : out std_logic;
        mem_read, mem_write : out std_logic;

        io_in_enable, io_out_enable : out std_logic
    );
end entity;

architecture structural of cpu is
    signal pc : std_logic_vector(CPU_N_BITS - 1 downto 0);
    signal ir, rs : std_logic_vector(3 downto 0);
    
    signal zero, sign, carry, overflow : std_logic;

    signal reg_file_data_sel : std_logic_vector(1 downto 0);
    signal reg_file_data_in : std_logic_vector(CPU_N_BITS - 1 downto 0);

    signal a, b : std_logic_vector(CPU_N_BITS - 1 downto 0);

    signal alu_out : std_logic_vector(CPU_N_BITS - 1 downto 0);

    signal alu_save_reg, data_save_reg : std_logic;
begin
    regs : entity work.reg_file(rtl) 
        generic map (CPU_N_BITS)
        port map (
            clk => clk,
            rst => rst,

            a_sel => rs(3 downto 2),
            b_sel => rs(1 downto 0),
            data_sel => reg_file_data_sel, 
            data_in => reg_file_data_in,

            write => alu_save_reg or data_save_reg,
        
            out_a => a,
            out_b => b
        );

    control_unit : entity work.control(behavioral) port map (
        clk => clk, 
        rst => rst, 

        pc => pc,
        ir => ir,
        rs => rs,

        alu_save_reg => alu_save_reg,
        data_save_reg => data_save_reg,
    
        mem_read => mem_read,
        mem_write => mem_write,
        addr_bus => addr_bus
    );

    alu : entity work.alu(behavioral)
        generic map (CPU_N_BITS)
        port map (
            op => ir,
            a => a,
            b => b,
            q => alu_out
        );

    reg_file_data_in <= alu_out when alu_save_reg = '1' else 
                        data_bus when data_save_reg = '1' else 
                        (others => 'Z');

    reset : process(rst) is
    begin
        if rst = '1' then
            pc <= (others => '0');

            zero <= '0';
            sign <= '0';
            carry <= '0';
            overflow <= '0';
        end if;
    end process;
end architecture;
