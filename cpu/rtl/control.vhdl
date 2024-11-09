library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

use work.asm.all;
use work.attrs.all;

entity control is
    port (
        clk : in std_logic;
        rst : in std_logic;
        int : in std_logic;

        zero, sign : in std_logic;

        -- instruction register
        ir  : in std_logic_vector(IR_RANGE);
        -- register selection register
        rs  : in std_logic_vector(RS_RANGE);

        control : out control_t;

        reg_data_sel : out std_logic_vector(CPU_N_REG_BITS - 1 downto 0)
    );
end entity;

architecture behavioral of control is
    procedure setup_signals_for_fetch(signal control : out control_t) is
    begin
        control(CTL_MEM_EN) <= '1';
        control(CTL_MEM_RD) <= '1';

        control(CTL_PC_TO_ADDR) <= '1';
    end procedure;

    procedure setup_signals_for_execute(
            signal control : out control_t;
            signal reg_data_sel : out std_logic_vector(CPU_N_REG_BITS - 1 downto 0)
        ) is
    begin
        -- XXX: implementation_detail
        -- Instructions that use the ALU, result must be stored in R
        if ir(3) = '0' and (ir(2) /= '1' or ir(1) /= '1') then
            control(CTL_ALU_TO_REG) <= '1';
            reg_data_sel <= REG_R;
        end if;

        case ir is
            when OP_ADD | OP_SUB =>
                control(CTL_UPDATE_SCO) <= '1';
            -- CMP is the only exception, we don't want to store the result in R
            when OP_CMP =>
                control(CTL_UPDATE_SCO) <= '1';
                reg_data_sel <= REG_I;
            when OP_JMP =>
                control(CTL_REG_B_TO_PC) <= '1';
            when OP_JEQ =>
                if zero = '1' then
                    control(CTL_REG_B_TO_PC) <= '1';
                end if;
            when OP_JGR =>
                if sign = '1' then
                    control(CTL_REG_B_TO_PC) <= '1';
                end if;
            when OP_LOAD =>
                control(CTL_MEM_EN) <= '1';
                control(CTL_MEM_RD) <= '1';

                control(CTL_REG_B_TO_ADDR) <= '1';

                control(CTL_DATA_TO_REG) <= '1';
                reg_data_sel <= rs(RS_A_SEL_RANGE);
            when OP_STORE =>
                control(CTL_MEM_EN) <= '1';
                control(CTL_MEM_WR) <= '1';

                control(CTL_REG_A_TO_DATA) <= '1';
                control(CTL_REG_B_TO_ADDR) <= '1';
            when OP_MOV =>
                control(CTL_REG_B_TO_REG) <= '1';
                reg_data_sel <= rs(RS_A_SEL_RANGE);
            when OP_IN =>
                control(CTL_IO_IN_EN) <= '1';

                control(CTL_DATA_TO_REG) <= '1';
                reg_data_sel <= rs(RS_A_SEL_RANGE);
            when OP_OUT =>
                control(CTL_IO_OUT_EN) <= '1';

                control(CTL_REG_A_TO_DATA) <= '1';
            when OP_NOP =>

            when others =>

        end case;
    end procedure;

    signal current : control_fsm_state_t := RESET;
begin
    fsm : process(clk, rst) is
    begin
        if rising_edge(clk) then
            control <= (others => '0');
            reg_data_sel <= (others => '0');
            
            case current is
                when RESET =>
                    setup_signals_for_fetch(control);
                    current <= FETCH;
                when FETCH =>
                    control(CTL_DATA_TO_IR) <= '1';
                    control(CTL_INCREMENT_PC) <= '1';

                    current <= STORE;
                when STORE =>
                    if rs(RS_A_SEL_RANGE) = REG_I or rs(RS_B_SEL_RANGE) = REG_I then
                        setup_signals_for_fetch(control);

                        control(CTL_DATA_TO_REG) <= '1';
                        reg_data_sel <= REG_I;

                        current <= FETCH_IMM;
                    else
                        setup_signals_for_execute(control, reg_data_sel);
                        current <= EXECUTE;
                    end if;
                when FETCH_IMM =>
                    control(CTL_INCREMENT_PC) <= '1';

                    current <= STORE_IMM;
                when STORE_IMM =>
                    setup_signals_for_execute(control, reg_data_sel);
                    current <= EXECUTE;
                when EXECUTE =>
                    if ir = OP_WAIT then
                        current <= POLL;
                    else
                        setup_signals_for_fetch(control);
                        current <= FETCH;
                    end if;
                when POLL =>
                    if int = '1' then
                        setup_signals_for_fetch(control);
                        current <= FETCH;
                    end if;
            end case;
        end if;

        if rst = '1' then
            control <= (others => '0');
            reg_data_sel <= (others => '0');
            
            current <= RESET;
        end if;
    end process;
end architecture;
