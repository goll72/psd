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

    constant MEM_MAX_ADDR : integer := 2 ** MEM_ADDR_BITS - 1;
    type mem_array_t is array(0 to MEM_MAX_ADDR) of std_logic_vector(MEM_WORD_BITS - 1 downto 0);
end package;
