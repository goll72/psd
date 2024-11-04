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
    signal pc_in : std_logic_vector(CPU_N_BITS - 1 downto 0);
    signal next_pc : std_logic_vector(CPU_N_BITS - 1 downto 0);
    
    signal ir, rs : std_logic_vector(3 downto 0);
    
    signal zero, sign, carry, overflow : std_logic;

    signal reg_file_data_sel : std_logic_vector(1 downto 0);
    signal reg_file_data_in : std_logic_vector(CPU_N_BITS - 1 downto 0);

    signal a, b : std_logic_vector(CPU_N_BITS - 1 downto 0);

    signal alu_out : std_logic_vector(CPU_N_BITS - 1 downto 0);

    signal alu_to_reg_write, data_to_reg_write : std_logic;
    
    signal increment_pc : std_logic;
    signal pc_to_addr_write : std_logic;
    signal reg_b_to_pc_write : std_logic;

    signal reg_a_to_data_write : std_logic;
    signal reg_b_to_addr_write : std_logic;
    signal reg_b_to_reg_write : std_logic;
begin
    pc_adder : entity work.adder(behavioral)
        generic map (CPU_N_BITS)
        port map (
            a => pc,
            b => (CPU_N_BITS - 1 downto 1 => '0', 0 => '1'),
            c_in => '0',
            q => next_pc
        );
        
    pc_reg : entity work.reg(behavioral)
        generic map (CPU_N_BITS)
        port map (
            clk => clk,
            rst => rst,
            write => increment_pc or reg_b_to_pc_write,
            input => pc_in,
            q => pc
        );

    regs : entity work.reg_file(rtl)
        generic map (CPU_N_BITS)
        port map (
            clk => clk,
            rst => rst,

            a_sel => rs(3 downto 2),
            b_sel => rs(1 downto 0),
            data_sel => reg_file_data_sel,
            data_in => reg_file_data_in,

            write => alu_to_reg_write or data_to_reg_write,
        
            out_a => a,
            out_b => b
        );

    control_unit : entity work.control(behavioral) port map (
        clk => clk,
        rst => rst,
        int => int,

        zero => zero,
        sign => sign,

        pc => pc,
        ir => ir,
        rs => rs,

        alu_to_reg_write => alu_to_reg_write,
        data_to_reg_write => data_to_reg_write,

        increment_pc => increment_pc,
        pc_to_addr_write => pc_to_addr_write,
        reg_b_to_pc_write => reg_b_to_pc_write,

        reg_a_to_data_write => reg_a_to_data_write,
        reg_b_to_addr_write => reg_b_to_addr_write,
        reg_b_to_reg_write => reg_b_to_reg_write,

        mem_enable => mem_enable,
        mem_read => mem_read,
        mem_write => mem_write,

        data_bus => data_bus
    );

    alu : entity work.alu(behavioral)
        generic map (CPU_N_BITS)
        port map (
            op => ir,
            a => a,
            b => b,
            q => alu_out
        );

    reg_file_data_in <= alu_out when alu_to_reg_write = '1' else 
                        data_bus when data_to_reg_write = '1' else
                        b when reg_b_to_reg_write = '1' else 
                        (others => 'Z');

    pc_in <= next_pc when increment_pc = '1' else
             b when reg_b_to_pc_write = '1' else
             (others => 'Z');

    addr_bus <= b when reg_b_to_addr_write = '1' else
                pc when pc_to_addr_write = '1' else
                (others => 'Z');

    data_bus <= a when reg_a_to_data_write = '1' else
                (others => 'Z');

    reset : process(rst) is
    begin
        if rst = '1' then
            zero <= '0';
            sign <= '0';
            carry <= '0';
            overflow <= '0';
        end if;
    end process;
end architecture;
