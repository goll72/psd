library ieee;

use ieee.std_logic_1164.all;

library work;

package attrs is
    constant CPU_N_REGS : natural := 4;
    constant CPU_N_REG_BITS : natural := 2;
    
    constant CPU_N_BITS : natural := 8;
    
    type reg_file_t is array (0 to CPU_N_REGS - 1) of std_logic_vector(CPU_N_BITS - 1 downto 0);

    constant MEM_ADDR_BITS : natural := CPU_N_BITS;
    constant MEM_WORD_BITS : natural := CPU_N_BITS;

    constant MEM_MAX_ADDR : natural := 2 ** MEM_ADDR_BITS - 1;
    type mem_array_t is array(0 to MEM_MAX_ADDR) of std_logic_vector(MEM_WORD_BITS - 1 downto 0);

    type control_value_t is (
        CTL_MEM_EN,
        CTL_MEM_RD,
        CTL_MEM_WR,
        CTL_IO_IN_EN,
        CTL_IO_OUT_EN,

        CTL_DATA_TO_IR,

        CTL_ALU_TO_REG,
        CTL_DATA_TO_REG,

        CTL_INCREMENT_PC,
        CTL_PC_TO_ADDR,
        CTL_REG_B_TO_PC,

        CTL_REG_A_TO_DATA,
        CTL_REG_B_TO_ADDR,
        CTL_REG_B_TO_REG,

        -- ~~Santa Cruz Operation~~ (sign, carry, overflow flag registers)
        --
        -- NOTE: the zero flag register is always updated
        -- when an operation that uses the ALU is performed
        CTL_UPDATE_SCO
    );

    type control_t is array (control_value_t) of std_logic;
    type control_fsm_state_t is (RESET, FETCH, STORE, FETCH_IMM, STORE_IMM, EXECUTE, POLL);

    subtype IR_RANGE is natural range 3 downto 0;
    subtype DATA_IR_RANGE is natural range 7 downto 4;

    subtype RS_RANGE is natural range 3 downto 0;
    subtype DATA_RS_RANGE is natural range 3 downto 0;

    subtype RS_A_SEL_RANGE is natural range 3 downto 2;
    subtype RS_B_SEL_RANGE is natural range 1 downto 0;
end package;
