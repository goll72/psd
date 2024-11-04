library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;

library work;

use work.attrs.all;

-- Runs a demo and dumps the state of registers and memory
-- so that the output can be compared with the output 
-- from the C simulation of the same demo
entity sim is
    generic (
        DEMO_INIT_FILE : string;
        DEMO_IN : string
    );
end entity;

architecture behavioral of sim is
    constant CLK_PERIOD : time := 100 ns;

    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal int : std_logic := '0';

    signal mem_enable, mem_read, mem_write : std_logic;

    signal addr_bus, data_bus : std_logic_vector(CPU_N_BITS - 1 downto 0);
begin
    clk <= not clk after CLK_PERIOD / 2;

    cpu : entity work.cpu(structural)
        port map (
            clk => clk,
            rst => rst,
            int => int,

            mem_enable => mem_enable,
            mem_read => mem_read,
            mem_write => mem_write,

            addr_bus => addr_bus,
            data_bus => data_bus
        );

    memory : entity work.mem(rtl)
        generic map (
            ADDR_BITS => CPU_N_BITS,
            WORD_BITS => CPU_N_BITS,
            INIT_FILE => DEMO_INIT_FILE
        )
        port map (
            clk => clk,
            addr => addr_bus,
            data => data_bus,

            read => mem_enable and mem_read,
            write => mem_enable and mem_write
        );

    init : process is
        file input_file : text open read_mode is DEMO_IN;

        alias pc is << signal cpu.pc : std_logic_vector(CPU_N_BITS - 1 downto 0) >>;
    begin
        wait for 2 * CLK_PERIOD;

        rst <= '0';
    end process;
end architecture;
