library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

use work.asm.all;

entity control is
    port (
        clk : in std_logic;
        rst : in std_logic;

        -- program counter
        pc  : inout std_logic_vector(7 downto 0);
        -- instruction register
        ir  : inout std_logic_vector(3 downto 0);
        -- register selection register
        rs  : inout std_logic_vector(3 downto 0);

        mem_read, mem_write : out std_logic;

        alu_save_reg, data_save_reg : out std_logic;

        addr_bus : inout std_logic_vector(7 downto 0);
        data_bus : inout std_logic_vector(7 downto 0)
    );
end entity;

architecture behavioral of control is
    type state_t is (FETCH, DECODE, FETCH_IMM, EXECUTE);

    signal current : state_t := FETCH;
begin
    fsm : process(all) is
    begin
        case current is
            when FETCH =>
                mem_read <= '1'; 
                addr_bus <= pc;

                pc <= std_logic_vector(unsigned(pc) + 1);
                
                current <= DECODE;
            when DECODE =>
                mem_read <= '0';
                
                ir <= data_bus(7 downto 4);
                rs <= data_bus(3 downto 0);

                -- aa
                wait on rs;
            
                if rs(0) = '1' and rs(1) = '1' then
                    current <= FETCH_IMM;
                else
                    current <= EXECUTE;
                end if;            
            when FETCH_IMM =>
                mem_read <= '1';
                addr_bus <= pc;

                pc <= std_logic_vector(unsigned(pc) + 1);

                current <= EXECUTE;
            when EXECUTE =>
                -- Instructions that use the ALU
                if ir(3) = '0' and (ir(2) /= '1' or ir(1) /= '1') then
                    alu_save_reg <= '1';
                end if;
                
                case ir is
                    when OP_LOAD =>
                        mem_read <= '1';
                        -- XXX: read from I register
                        -- addr_bus <= 

                        
                    when OP_NOP =>
                        mem_read <= '0';
                end case;
                
                current <= FETCH;
        end case;

        if rst = '1' then
            mem_read <= '0';
            mem_write <= '0';

            current <= FETCH;
        end if;
    end process;
end architecture;
