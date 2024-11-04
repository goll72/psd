library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

use work.asm.all;

entity control is
    port (
        clk : in std_logic;
        rst : in std_logic;
        int : in std_logic;

        zero, sign : in std_logic;

        -- program counter
        pc  : inout std_logic_vector(7 downto 0);
        -- instruction register
        ir  : inout std_logic_vector(3 downto 0);
        -- register selection register
        rs  : inout std_logic_vector(3 downto 0);

        mem_enable : out std_logic;
        mem_read, mem_write : out std_logic;

        io_in_enable, io_out_enable : out std_logic;

        alu_to_reg_write, data_to_reg_write : out std_logic;

        increment_pc : out std_logic;
        pc_to_addr_write : out std_logic;
        reg_b_to_pc_write : out std_logic;

        reg_a_to_data_write : out std_logic;
        reg_b_to_addr_write : out std_logic;
        reg_b_to_reg_write : out std_logic;

        reg_data_sel : out std_logic_vector(1 downto 0);

        data_bus : in std_logic_vector(7 downto 0)
    );
end entity;

architecture behavioral of control is
    type state_t is (FETCH, DECODE, FETCH_IMM, EXECUTE, POLL);

    signal current : state_t := FETCH;
begin
    fsm : process(clk, rst) is
        variable rs_v : std_logic_vector(3 downto 0);
    begin
        if rising_edge(clk) then
            mem_enable <= '0';
            mem_read <= '0';
            mem_write <= '0';

            alu_to_reg_write <= '0';
            data_to_reg_write <= '0';

            increment_pc <= '0';
            pc_to_addr_write <= '0';
            reg_b_to_pc_write <= '0';

            reg_a_to_data_write <= '0';
            reg_b_to_addr_write <= '0';
            reg_b_to_reg_write <= '0';
            
            case current is
                when FETCH =>
                    mem_enable <= '1';
                    mem_read <= '1';

                    increment_pc <= '1';
                    pc_to_addr_write <= '1';

                    current <= DECODE;
                when DECODE =>
                    ir <= data_bus(7 downto 4);

                    rs_v := data_bus(3 downto 0);
                    rs <= rs_v;
            
                    if rs_v(0) = '1' and rs_v(1) = '1' then
                        current <= FETCH_IMM;
                    else
                        current <= EXECUTE;
                    end if;            
                when FETCH_IMM =>
                    mem_read <= '1';

                    increment_pc <= '1';
                    pc_to_addr_write <= '1';

                    current <= EXECUTE;
                when EXECUTE =>
                    -- Instructions that use the ALU, result must be stored in R
                    if ir(3) = '0' and (ir(2) /= '1' or ir(1) /= '1') then
                        alu_to_reg_write <= '1';
                        reg_data_sel <= REG_R;
                    end if;
                
                    case ir is
                        when OP_JMP =>
                            reg_b_to_pc_write <= '1';
                        when OP_JEQ =>
                            if zero = '1' then
                                reg_b_to_pc_write <= '1';
                            end if;
                        when OP_JGR =>
                            if sign = '1' then
                                reg_b_to_pc_write <= '1';
                            end if;
                        when OP_LOAD =>
                            mem_enable <= '1';
                            mem_read <= '1';

                            reg_b_to_addr_write <= '1';
                        
                            data_to_reg_write <= '1';
                            reg_data_sel <= ir(3 downto 2);
                        when OP_STORE =>
                            mem_enable <= '1';
                            mem_write <= '1';

                            reg_a_to_data_write <= '1';
                            reg_b_to_addr_write <= '1';
                        when OP_MOV =>
                            reg_b_to_reg_write <= '1';
                            reg_data_sel <= ir(3 downto 2);
                        when OP_IN =>
                            io_in_enable <= '1';

                            data_to_reg_write <= '1';
                            reg_data_sel <= ir(3 downto 2);
                        when OP_OUT =>
                            io_out_enable <= '1';
                            
                            reg_a_to_data_write <= '1';
                        when OP_WAIT =>
                            current <= POLL;
                        when OP_NOP =>
                        
                        when others =>

                    end case;
                
                    current <= FETCH;
                when POLL =>
                    if int = '1' then
                        current <= FETCH;
                    end if;
            end case;
        end if;

        if rst = '1' then
            mem_enable <= '0';
            mem_read <= '0';
            mem_write <= '0';

            alu_to_reg_write <= '0';
            data_to_reg_write <= '0';

            increment_pc <= '0';
            pc_to_addr_write <= '0';
            reg_b_to_pc_write <= '0';

            reg_a_to_data_write <= '0';
            reg_b_to_addr_write <= '0';
            reg_b_to_reg_write <= '0';
            
            current <= FETCH;
        end if;
    end process;
end architecture;
