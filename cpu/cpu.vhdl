library ieee;

use ieee.std_logic_1164.all;

library work;

entity cpu is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        int    : in  std_logic;
        input  : in  std_logic_vector(7 downto 0);
        output : out std_logic_vector(7 downto 0)
    );
end entity;

architecture structural of cpu is
    signal pc : std_logic_vector(7 downto 0);
    signal ir, rs : std_logic_vector(3 downto 0);
    
    signal zero, sign, carry, overflow : std_logic;

    signal addr_bus : std_logic_vector(7 downto 0);
    signal data_bus : std_logic_vector(7 downto 0);

    signal reg_data_sel : std_logic_vector(1 downto 0);
    signal reg_data_in : std_logic_vector(7 downto 0);

    signal mem_read, mem_write : std_logic;

    signal a, b : std_logic_vector(7 downto 0);

    signal alu_out : std_logic_vector(7 downto 0);

    signal alu_save_reg, data_save_reg : std_logic;
begin
    regs : entity work.reg_file(rtl) port map (
        clk => clk,
        rst => rst,
        a_sel => rs(3 downto 2),
        b_sel => rs(1 downto 0),
        data_sel => reg_data_sel, 
        data_in => reg_data_in,

        write => alu_save_reg or data_save_reg,
        
        out_a => a,
        out_b => b
    );

    memory : entity work.mem(syn)
        generic map (
            ADDR_BITS => 8,
            WORD_BITS => 8
        )
        port map (
            clk => clk,
            addr => addr_bus,
            read => mem_read,
            write => mem_write 
        );

    c_unit : entity work.control(behavioral) port map (
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

    alu : entity work.alu(behavioral) port map (
        op => ir(2 downto 0),
        a => a,
        b => b,
        q => alu_out
    );

    reg_data_in <= alu_out when alu_save_reg = '1' else 
                   data_bus when data_save_reg = '1' else (others => 'Z');

    reset : process(rst) is
    begin
        pc <= (others => '0');

        zero <= '0';
        sign <= '0';
        carry <= '0';
        overflow <= '0';
    end process;
end architecture;
