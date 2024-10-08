library ieee;

use ieee.std_logic_1164.all;

library work;

entity main is
    port (w, clk, reset :  in std_logic;
          z             : out std_logic;
          fsm_state : out std_logic_vector(8 downto 0)); 
end entity;

architecture structural of main is
begin
    fsm : entity work.fsm_inv(behavioral) port map (
        w => w,
        clk => clk,
        reset => reset,
        z => z,
        state => fsm_state        
    );
end architecture;
