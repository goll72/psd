library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity mem is
    generic (
        ADDR_BITS : natural;
        WORD_BITS : natural;
        -- File used to initialize the memory.
        -- For the standard VHDL implementation, a .bin file is needed.
        -- For the implementation using altsyncram, a .mif file is needed.
        INIT_FILE : string
    );
    port (
        clk   :    in std_logic;
        read  :    in std_logic;
        write :    in std_logic;
        addr  :    in std_logic_vector(ADDR_BITS - 1 downto 0);
        data  : inout std_logic_vector(WORD_BITS - 1 downto 0)
    );
    
    constant MAX_ADDR : integer := 2 ** ADDR_BITS - 1;
    type mem_array_t is array(0 to MAX_ADDR) of std_logic_vector(WORD_BITS - 1 downto 0);
end entity;

-- synthesis translate_off
architecture rtl of mem is
    signal mem : mem_array_t := (others => (others => '0'));
begin
    init_mem : process is
        type char_file_t is file of character;
        
        file f : char_file_t open read_mode is INIT_FILE;
            variable i : natural := 0;
        variable c : character;
    begin
        while not endfile(f) loop
            read(f, c);

            mem(i) <= std_logic_vector(to_unsigned(integer(character'pos(c)), WORD_BITS));
            i := i + 1;
        end loop;
    end process;
    
    read_or_write : process(clk, write, addr, data) is
        variable addr_index : integer := to_integer(unsigned(addr));
    begin
        if rising_edge(clk) then
            if write = '1' then
                mem(addr_index) <= data;
            end if;

            if read = '1' then
                data <= mem(addr_index);
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
-- begin
--     ram : entity altsyncram(syn)
--         generic map (
--             OPERATION_MODE => "SINGLE_PORT",
--             RAM_BLOCK_TYPE => "M10K",
--             WIDTHAD_A => ADDR_BITS,
--             WIDTH_A => WORD_BITS,
--             INIT_FILE => INIT_FILE
--         )
--         port map (
--             address_a => addr,
--             clock0 => clk,
--             data_a => data,
--             wren_a => write,
--             q_a => data
--         );
-- end architecture;
-- synthesis read_comments_as_hdl off
