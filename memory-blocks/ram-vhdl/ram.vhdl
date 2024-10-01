library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

entity ram is
    generic (
        ADDR_BITS : integer := 5;
        WORD_BITS : integer := 4
    );
    port (
        clk   :  in std_logic;
        write :  in std_logic;
        addr  :  in std_logic_vector(ADDR_BITS - 1 downto 0);
        data  :  in std_logic_vector(WORD_BITS - 1 downto 0);
        q     : out std_logic_vector(WORD_BITS - 1 downto 0)
    );
    
    constant MAX_ADDR : integer := 2 ** ADDR_BITS - 1;
    type mem_array_t is array(0 to MAX_ADDR) of std_logic_vector(WORD_BITS - 1 downto 0);
end entity;

architecture structural of ram is
    signal mem : mem_array_t;
begin
    read_or_write : process(clk, write, addr, data) is
        variable addr_index : integer := to_integer(unsigned(addr));
    begin
        if rising_edge(clk) then
            if write = '1' then
                mem(addr_index) <= data;
            end if;
            
            q <= mem(addr_index);
            -- end if;
        end if;
    end process;
end;
