library ieee;

use ieee.std_logic_1164.all;

library work;

entity reg is
    generic (
        N_BITS : natural
    );
    port (
        clk   :  in std_logic;
        rst   :  in std_logic;
        write :  in std_logic;
        input :  in std_logic_vector(N_BITS - 1 downto 0);
        q     : out std_logic_vector(N_BITS - 1 downto 0)
    );
end entity;

architecture behavioral of reg is
begin
    load : process(clk) is
    begin
        if rising_edge(clk) then
            if write = '1' then
                q <= input;
            end if;
        end if;

        if rst = '1' then
            q <= (others => '0');
        end if;
    end process;
end architecture;
