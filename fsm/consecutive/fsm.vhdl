library ieee;

use ieee.std_logic_1164.all;

library work;

entity fsm is 
    port (w, clk, reset :  in std_logic;
          z             : out std_logic;
          state         : out std_logic_vector(8 downto 0));
end entity;

architecture behavioral of fsm is
begin
    state_transition : process(w, clk, reset) is
        variable current_state : std_logic_vector(8 downto 0);
    begin
        if rising_edge(clk) then
            case current_state is
                when "000000001" =>
                    if w = '0' then 
                        current_state := "000000010";
                    elsif w = '1' then
                        current_state := "000100000";
                    end if;

                when "000000010" =>
                    if w = '0' then 
                        current_state := "000000100";
                    elsif w = '1' then
                        current_state := "000100000";
                    end if;

                when "000000100" =>
                    if w = '0' then 
                        current_state := "000001000";
                    elsif w = '1' then
                        current_state := "000100000";
                    end if;

                when "000001000" =>
                    if w = '0' then 
                        current_state := "000010000";
                    elsif w = '1' then
                        current_state := "000100000";
                    end if;

                when "000010000" =>
                    if w = '0' then 
                        current_state := "000010000";
                    elsif w = '1' then
                        current_state := "000100000";
                    end if;

                when "000100000" =>
                    if w = '0' then 
                        current_state := "000000010";
                    elsif w = '1' then
                        current_state := "001000000";
                    end if;

                when "001000000" =>
                    if w = '0' then 
                        current_state := "000000010";
                    elsif w = '1' then
                        current_state := "010000000";
                    end if;

                when "010000000" =>
                    if w = '0' then 
                        current_state := "000000010";
                    elsif w = '1' then
                        current_state := "100000000";
                    end if;

                when "100000000" =>
                    if w = '0' then 
                        current_state := "000000010";
                    elsif w = '1' then
                        current_state := "100000000";
                    end if;

                when others =>
                    current_state := "000000001";
            end case;
            
            if reset = '0' then
                current_state := (0 => '1', others => '0');
            end if;
        end if;

        state <= current_state;
        z <= current_state(8) or current_state(4);
    end process;
end architecture;
