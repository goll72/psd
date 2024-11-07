library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

    signal ir : std_logic_vector(IR_RANGE);
    signal rs : std_logic_vector(RS_RANGE);
    
    signal zero, sign, carry, overflow : std_logic;

    signal reg_file_data_sel : std_logic_vector(CPU_N_REG_BITS - 1 downto 0);
    signal reg_file_data_in : std_logic_vector(CPU_N_BITS - 1 downto 0);

    signal a, b : std_logic_vector(CPU_N_BITS - 1 downto 0);

    signal alu_out : std_logic_vector(CPU_N_BITS - 1 downto 0);

    signal control : control_t;
begin
    pc_adder : entity work.adder(behavioral)
        generic map (CPU_N_BITS)
        port map (
            a => pc,
            b => std_logic_vector(to_unsigned(1, CPU_N_BITS)),
            c_in => '0',
            q => next_pc
        );
        
    pc_reg : entity work.reg(behavioral)
        generic map (CPU_N_BITS)
        port map (
            clk => clk,
            rst => rst,
            write => control(CTL_INCREMENT_PC) or control(CTL_REG_B_TO_PC),
            input => pc_in,
            q => pc
        );

    ir_reg : entity work.reg(behavioral)
        generic map (ir'length)
        port map (
            clk => clk,
            rst => rst,
            write => control(CTL_DATA_TO_IR),
            input => data_bus(DATA_IR_RANGE),
            q => ir
        );

    rs_reg : entity work.reg(behavioral)
        generic map (rs'length)
        port map (
            clk => clk,
            rst => rst,
            write => control(CTL_DATA_TO_IR),
            input => data_bus(DATA_RS_RANGE),
            q => rs
        );

    regs : entity work.reg_file(rtl)
        port map (
            clk => not clk,
            rst => rst,

            a_sel => rs(RS_A_SEL_RANGE),
            b_sel => rs(RS_B_SEL_RANGE),
            data_sel => reg_file_data_sel,
            data_in => reg_file_data_in,

            write => control(CTL_ALU_TO_REG) or control(CTL_DATA_TO_REG),
        
            out_a => a,
            out_b => b
        );

    control_unit : entity work.control(behavioral) port map (
        clk => not clk,
        rst => rst,
        int => int,

        zero => zero,
        sign => sign,

        ir => ir,
        rs => rs,

        control => control,

        reg_data_sel => reg_file_data_sel
    );

    alu : entity work.alu(behavioral)
        generic map (CPU_N_BITS)
        port map (
            op => ir,
            a => a,
            b => b,
            q => alu_out,

            carry => carry,
            overflow => overflow
        );

    reg_file_data_in <= alu_out when control(CTL_ALU_TO_REG) = '1' else 
                        data_bus when control(CTL_DATA_TO_REG) = '1' else
                        b when control(CTL_REG_B_TO_REG) = '1' else 
                        (others => 'Z');

    pc_in <= next_pc when control(CTL_INCREMENT_PC) = '1' else
             b when control(CTL_REG_B_TO_PC) = '1' else
             (others => 'Z');

    addr_bus <= b when control(CTL_REG_B_TO_ADDR) = '1' else
                pc when control(CTL_PC_TO_ADDR) = '1' else
                (others => 'Z');

    data_bus <= a when control(CTL_REG_A_TO_DATA) = '1' else
                (others => 'Z');

    mem_enable <= control(CTL_MEM_EN);
    mem_read <= control(CTL_MEM_RD);
    mem_write <= control(CTL_MEM_WR);

    io_in_enable <= control(CTL_IO_IN_EN);
    io_out_enable <= control(CTL_IO_OUT_EN);

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
