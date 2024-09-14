-- Counter testbench

library ieee;

use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;

entity test is
end entity;

use std.env.stop;

architecture behavioral of test is
	signal clk : std_logic := '0';
	signal clr : std_logic;
	signal count : std_logic_vector(15 downto 0);
	signal hex : std_logic_vector(0 to 6);

	-- 20ns = 1/(50 * 10 ** 6 Hz) 
	constant CLK_PERIOD : time := 20 ns;

	attribute keep : boolean;
	attribute keep of clk, clr, hex : signal is true;
begin
	main : entity work.main(structural) port map (
		clk => clk,
		clr => clr,
		hex0 => hex
	);

	clk <= not clk after CLK_PERIOD / 2;

	stim : process is
	begin
		clr <= '0';
		wait for CLK_PERIOD;
		clr <= '1';
		wait for 14 sec;

		stop;
	end process;
end architecture;
