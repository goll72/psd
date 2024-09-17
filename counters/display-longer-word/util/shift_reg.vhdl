library ieee;

use ieee.std_logic_1164.all;

library work;

entity shift_reg is
    generic (N : integer);
    port (clk, load :  in std_logic;
          data      :  in std_logic_vector(N - 1 downto 0);
          q         : out std_logic_vector(N - 1 downto 0));
end entity;

architecture behavioral of shift_reg is
    signal s : std_logic_vector(N - 1 downto 0);
    signal k : std_logic;
begin
    load_or_shift : process(clk) is
    begin
        if rising_edge(clk) then
            k <= s(N - 1);
            s(N - 1 downto 1) <= s(N - 2 downto 0);
            s(0) <= k;
        end if;
        
        if load = '1' then
            s <= data;
        end if;
    end process;
    q <= s;
end architecture;

architecture structural of shift_reg is
    signal s : std_logic_vector(N - 1 downto 0);
begin
    ff_d_chain : for i in 0 to N - 1
    generate
        ff : entity work.ff_d(structural) port map (
            clk => clk,
            d => s((i - 1) mod N),
            preset => not (load and data(i)),
            clr => not (load and not data(i)),
            q => s(i)
        );
    end generate;
    q <= s;
end architecture;
