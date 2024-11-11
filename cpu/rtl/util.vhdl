use std.textio.all;

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;

use work.asm.all;
use work.attrs.all;

package util is
    function to_lower(str: string) return string;

    procedure dump_regs(file f : text; variable l : inout line; regs : reg_file_t;
                        ic : integer;
                        pc : std_logic_vector(CPU_N_BITS - 1 downto 0);
                        ir : std_logic_vector(IR_RANGE);
                        rs : std_logic_vector(RS_RANGE);
                        zero, sign, carry, overflow : std_logic);
end package;

package body util is
    function to_lower(str : string) return string is
        variable result : string(str'range);
    begin
        for i in str'range loop
            if str(i) >= 'A' and str(i) <= 'Z' then
                result(i) := character'val(character'pos(str(i)) + 32);
            else
                result(i) := str(i);
            end if;
        end loop;

        return result;
    end function;

    procedure dump_regs(file f : text; variable l : inout line; regs : reg_file_t;
                        ic : integer;
                        pc : std_logic_vector(CPU_N_BITS - 1 downto 0);
                        ir : std_logic_vector(IR_RANGE);
                        rs : std_logic_vector(RS_RANGE);
                        zero, sign, carry, overflow : std_logic) is
    begin
        write(l, "pc " & to_string(pc) & HT & "ir " & to_string(ir) & HT & "rs " & to_string(rs) & HT & "zero " & to_string(zero) & HT & "sign " & to_string(sign) & HT & "carry " & to_string(carry) & HT & "overflow " & to_string(overflow) & HT & "ic " & to_lower(to_hstring(to_unsigned(ic, 32))));
        writeline(f, l);

        write(l, "a  " & to_string(regs(to_integer(unsigned(REG_A)))));
        writeline(f, l);

        write(l, "b  " & to_string(regs(to_integer(unsigned(REG_B)))));
        writeline(f, l);

        write(l, "r  " & to_string(regs(to_integer(unsigned(REG_R)))));
        writeline(f, l);

        write(f, "i  " & to_string(regs(to_integer(unsigned(REG_I)))));
        writeline(f, l);
    end procedure;
end package body;
