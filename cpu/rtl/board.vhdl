library ieee;

use ieee.std_logic_1164.all;

library work;

use work.attrs.all;

entity board is
    port (
        clk : in std_logic;
        -- This board's reset signal is active low
        rst : in std_logic;
        int : in std_logic;

        input  :     in std_logic_vector(CPU_N_BITS - 1 downto 0);
        output : buffer std_logic_vector(CPU_N_BITS - 1 downto 0);

        hex_in  : out hex_display_byte_t;
        hex_out : out hex_display_byte_t
    );
end entity;

architecture rtl of board is
    signal io_in_enable, io_out_enable : std_logic;
    signal mem_enable, mem_read, mem_write : std_logic;

    signal addr_bus, data_bus : std_logic_vector(CPU_N_BITS - 1 downto 0);

    -- `int' corresponds to a push button on the board (active low).
    --
    -- The board that we're using (DE0-CV) has debounce circuitry
    -- for the push buttons, so we don't have to worry about that.
    --
    -- However, if we just sent the `int' signal to the CPU, a
    -- single button press could lead to multiple `wait'
    -- instructions being skipped.
    --
    -- To solve that, an FSM will take that signal and output 1
    -- on a change from 1 to 0, and 0 for anything else.
    type int_fsm_state_t is (ONE, ZERO, TRAILING_ZEROS);

    signal int_pulse : std_logic;
    signal int_state : int_fsm_state_t;

    signal out_valid : std_logic;
begin
    cpu : entity work.cpu(structural) port map (
        clk => clk,
        rst => not rst,
        int => int_pulse,

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
            INIT_FILE => "current.mif"
        )
        port map (
            clk => clk,
            read => mem_enable and mem_read,
            write => mem_enable and mem_write,
            addr => addr_bus,
            data => data_bus
        );

    int_fsm_transition : process(clk, int, rst) is
    begin
        if rising_edge(clk) then
            case int_state is
                when ONE =>
                    if int = '0' then
                        int_state <= ZERO;
                    end if;
                when ZERO =>
                    if int = '0' then
                        int_state <= TRAILING_ZEROS;
                    else
                        int_state <= ONE;
                    end if;
                when TRAILING_ZEROS =>
                    if int = '1' then
                        int_state <= ONE;
                    end if;
            end case;
        end if;

        if rst = '0' then
            int_state <= ONE;
        end if;
    end process;

    int_pulse <= '1' when int_state = ZERO else '0';

    perform_io : process(clk, io_in_enable, io_out_enable) is
    begin
        if rising_edge(clk) then
            data_bus <= (others => 'Z');

            if io_in_enable = '1' then
                data_bus <= input;
            end if;

            if io_out_enable = '1' then
                output <= data_bus;
            end if;
        end if;

        if rst = '0' then
            output <= (others => '0');
        end if;
    end process;

    out_valid_reg : entity work.reg(behavioral)
        generic map (1)
        port map (clk, not rst, io_out_enable, input(0) => '1', q(0) => out_valid);

    hex_in_driver_lower : entity work.hex(behavioral) port map (
        valid => rst,
        x => input(3 downto 0),
        q => hex_in(0)
    );

    hex_in_driver_upper : entity work.hex(behavioral) port map (
        valid => rst,
        x => input(7 downto 4),
        q => hex_in(1)
    );

    hex_out_driver_lower : entity work.hex(behavioral) port map (
        valid => out_valid,
        x => output(3 downto 0),
        q => hex_out(0)
    );

    hex_out_driver_upper : entity work.hex(behavioral) port map (
        valid => out_valid,
        x => output(7 downto 4),
        q => hex_out(1)
    );
end architecture;
