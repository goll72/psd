library ieee;

use ieee.std_logic_1164.all;

library work;

entity adder is
    generic (
        N_BITS : natural
    );
    port (
        a, b     :  in std_logic_vector(N_BITS - 1 downto 0);
        c_in     :  in std_logic;
        q        : out std_logic_vector(N_BITS - 1 downto 0);
        c_out    : out std_logic;
        overflow : out std_logic
    );
end entity;

architecture behavioral of adder is
    signal t : std_logic_vector(N_BITS - 1 downto 0);
    -- c(i) is the carry-in at the ith step
    signal c : std_logic_vector(N_BITS downto 0);
begin
    c(0) <= c_in;
    
    carry_adder : for i in 0 to N_BITS - 1 generate
    begin
        t(i) <= a(i) xor b(i);
        
        q(i) <= t(i) xor c(i);
        c(i + 1) <= a(i) and b(i) or t(i) and c(i);
    end generate;

    c_out <= c(c'high);
    overflow <= c(c'high) xor c(c'high - 1);
end architecture;
