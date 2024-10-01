library ieee;

use ieee.std_logic_1164.all;

library work;


entity main is
	port (
		address		: in  std_logic_vector(4 downto 0);
		clock 		: in  std_logic;
		data        : in  std_logic_vector(3 downto 0);
		wren		: in  std_logic;
		q		    : out std_logic_vector(3 downto 0)
	);
end entity;

architecture structural of main is
begin
    ram : entity work.ram32x4(syn) port map (
        address => address,
        clock => clock,
        data => data,
        wren => wren,
        q => q
    );
end architecture;
