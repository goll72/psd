library ieee;

use std.textio.all;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

use work.asm.all;
use work.attrs.all;

-- Runs a demo and dumps the state of registers and memory
-- so that the output can be compared with the output 
-- from the C simulation of the same demo
entity sim is
    generic (
        DEMO_INIT_FILE : string;
        DEMO_IN : string;
        DEMO_OUT : string;
        DEMO_DUMP : string
    );
end entity;

architecture behavioral of sim is
    constant CLK_PERIOD : time := 100 ps;

    signal clk : std_logic := '0';
    signal rst : std_logic;
    signal int : std_logic;

    signal io_data : std_logic_vector(CPU_N_BITS - 1 downto 0);

    signal io_in_enable, io_out_enable : std_logic;
    signal mem_enable, mem_read, mem_write : std_logic;

    signal addr_bus, data_bus : std_logic_vector(CPU_N_BITS - 1 downto 0);
begin
    clk <= not clk after CLK_PERIOD / 2;

    cpu : entity work.cpu(structural)
        port map (
            clk => clk,
            rst => rst,
            int => int,

            io_in_enable => io_in_enable,
            io_out_enable => io_out_enable,

            mem_enable => mem_enable,
            mem_read => mem_read,
            mem_write => mem_write,

            addr_bus => addr_bus,
            data_bus => data_bus
        );

    memory : entity work.mem(rtl)
        generic map (
            INIT_FILE => DEMO_INIT_FILE
        )
        port map (
            clk => clk,
            addr => addr_bus,
            data => data_bus,

            read => mem_enable and mem_read,
            write => mem_enable and mem_write
        );

    stim : process is
        file input_file : text open read_mode is DEMO_IN;
        file output_file : text open write_mode is DEMO_OUT;
        file dump_file : text open write_mode is DEMO_DUMP;

        variable text_buf : line;
        variable io_data : std_logic_vector(CPU_N_BITS - 1 downto 0);

        variable last_pc : std_logic_vector(CPU_N_BITS - 1 downto 0);

        alias pc is << signal cpu.pc : std_logic_vector(CPU_N_BITS - 1 downto 0) >>;

        alias ir is << signal cpu.ir : std_logic_vector(3 downto 0) >>;
        alias rs is << signal cpu.rs : std_logic_vector(3 downto 0) >>;
        
        alias regs is << signal cpu.regs.reg_contents : reg_file_t >>;

        alias zero is << signal cpu.zero : std_logic >>;
        alias sign is << signal cpu.sign : std_logic >>;
        alias carry is << signal cpu.carry : std_logic >>;
        alias overflow is << signal cpu.overflow : std_logic >>;

        alias mem is << signal memory.mem : mem_array_t >>;
    begin
        int <= '0';
        rst <= '1';

        wait for 2 * CLK_PERIOD;

        rst <= '0';

        last_pc := pc; 

        while true loop
            wait until rising_edge(clk);

            -- I/O in request --- read from input file
            if io_in_enable = '1' then
                readline(input_file, text_buf);
                bread(text_buf, io_data);
                
                data_bus <= io_data;
            end if;

            -- I/O out request -- write to output file
            if io_out_enable = '1' then
                io_data := data_bus;

                bwrite(text_buf, io_data);
                writeline(output_file, text_buf);
            end if;

            -- PC changed, dump register contents
            if pc /= last_pc then
                write(text_buf, "pc " & to_string(pc) & "\t" & "ir " & to_string(ir) & "\t" & "rs " & to_string(rs) & "\t" & "zero " & to_string(zero) & "\t" & "sign " & to_string(sign) & "\t" & "carry " & to_string(carry) & "\t" & "overflow " & to_string(overflow));
                writeline(dump_file, text_buf);

                write(text_buf, "a " & to_string(regs(to_integer(unsigned(REG_A)))));
                writeline(dump_file, text_buf);

                write(text_buf, "b " & to_string(regs(to_integer(unsigned(REG_B)))));
                writeline(dump_file, text_buf);

                write(text_buf, "r " & to_string(regs(to_integer(unsigned(REG_R)))));
                writeline(dump_file, text_buf);

                write(text_buf, "i " & to_string(regs(to_integer(unsigned(REG_I)))));
                writeline(dump_file, text_buf);
            end if;

            if ir = OP_WAIT then
                for i in 0 to 15 loop
                    for j in 0 to 15 loop
                        write(text_buf, to_hex_string(mem(i * 16 + j)));

                        if j /= 15 then
                            write(text_buf, string'(" "));
                        end if;
                    end loop;

                    writeline(dump_file, text_buf);
                end loop;

                file_close(output_file);
                file_close(dump_file);

                std.env.stop;
            end if;
        end loop;
    end process;
end architecture;
