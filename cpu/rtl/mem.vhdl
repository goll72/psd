library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

use work.attrs.all;

entity mem is
    generic (
        -- File used to initialize the memory.
        -- For the standard VHDL implementation, a .bin file is needed.
        -- For the implementation using altsyncram, a .mif file is needed.
        INIT_FILE : string
    );
    port (
        clk   :    in std_logic;
        read  :    in std_logic;
        write :    in std_logic;
        addr  :    in std_logic_vector(MEM_ADDR_BITS - 1 downto 0);
        data  : inout std_logic_vector(MEM_WORD_BITS - 1 downto 0)
    );
end entity;

-- synthesis translate_off
architecture rtl of mem is
    impure function init_mem(init_file : string) return mem_array_t is
        type char_file_t is file of character;

        file f : char_file_t open read_mode is init_file;
        variable i : natural;
        variable c : character;

        variable value : unsigned(MEM_WORD_BITS - 1 downto 0);

        variable mem : mem_array_t := (others => (others => '0'));
    begin
        while not endfile(f) loop
            read(f, c);

            value := to_unsigned(integer(character'pos(c)), value'length);
            
            mem(i) := std_logic_vector(value);
            i := i + 1;
        end loop;

        return mem;
    end function;
    
    signal mem : mem_array_t := init_mem(INIT_FILE);
begin
    read_or_write : process(clk, read, write, addr, data) is
        variable addr_index : integer;
    begin
        -- NOTE: we need to set `addr_index' inside the `if' guards, otherwise simulation
        -- tools would complain about a metavalue ('Z') being converted to '0'. We can't
        -- use the RHS directly as expressions may not be allowed in array slices.
        if rising_edge(clk) then    
            if write = '1' then
                addr_index := to_integer(unsigned(addr));
                mem(addr_index) <= data;
            end if;
            
            if read = '1' then
                addr_index := to_integer(unsigned(addr));
                data <= mem(addr_index);
            else
                data <= (others => 'Z');
            end if;
        end if;
    end process;
end architecture;
-- synthesis translate_on

-- synthesis read_comments_as_hdl on
-- library altera_mf;
--
-- use altera_mf.altera_mf_components.all;
--
-- architecture rtl of mem is
--     signal tmp : std_logic_vector(MEM_WORD_BITS - 1 downto 0);
-- begin
--     ram : altsyncram
--         generic map (
--             OPERATION_MODE => "SINGLE_PORT",
--             RAM_BLOCK_TYPE => "M10K",
--             WIDTHAD_A => MEM_ADDR_BITS,
--             WIDTH_A => MEM_WORD_BITS,
--             INIT_FILE => INIT_FILE
--         )
--         port map (
--             address_a => addr,
--             clock0 => clk,
--             data_a => tmp,
--             wren_a => write,
--             q_a => tmp
--         );
--
--     read_or_write : process(read, write, data) is
--     begin
--         if write = '1' then
--             tmp <= data;
--         else
--             tmp <= (others => 'Z');
--         end if;
--
--         if read = '1' then
--             data <= tmp;
--         else
--             data <= (others => 'Z');
--         end if;
--     end process;
-- end architecture;
-- synthesis read_comments_as_hdl off
