library ieee;

use ieee.std_logic_1164.all;

library work;

entity fsm_inv is 
    port (w, clk, reset :  in std_logic;
          z             : out std_logic;
          state         : out std_logic_vector(8 downto 0));
end entity;

architecture behavioral of fsm_inv is
begin
    state_transition : process(w, clk, reset) is
        variable current_state : std_logic_vector(8 downto 0);
    begin
        
        if rising_edge(clk) then
            case current_state is
                when "000000000" =>
                    if w = '0' then 
                        current_state := "000000011";
                    elsif w = '1' then
                        current_state := "000100001";
                    end if;

                when "000000011" =>
                    if w = '0' then 
                        current_state := "000000101";
                    elsif w = '1' then
                        current_state := "000100001";
                    end if;

                when "000000101" =>
                    if w = '0' then 
                        current_state := "000001001";
                    elsif w = '1' then
                        current_state := "000100001";
                    end if;

                when "000001001" =>
                    if w = '0' then 
                        current_state := "000010001";
                    elsif w = '1' then
                        current_state := "000100001";
                    end if;

                when "000010001" =>
                    if w = '0' then 
                        current_state := "000010001";
                    elsif w = '1' then
                        current_state := "000100001";
                    end if;

                when "000100001" =>
                    if w = '0' then 
                        current_state := "000000011";
                    elsif w = '1' then
                        current_state := "001000001";
                    end if;

                when "001000001" =>
                    if w = '0' then 
                        current_state := "000000011";
                    elsif w = '1' then
                        current_state := "010000001";
                    end if;

                when "010000001" =>
                    if w = '0' then 
                        current_state := "000000011";
                    elsif w = '1' then
                        current_state := "100000001";
                    end if;

                when "100000001" =>
                    if w = '0' then 
                        current_state := "000000011";
                    elsif w = '1' then
                        current_state := "100000001";
                    end if;

                when others =>
                    current_state := "000000000";
            end case;
            
            if reset = '0' then
                current_state := "000000000";
            end if;
        end if;

        state <= current_state;
        z <= current_state(8) or current_state(4);
    end process;
end architecture;
