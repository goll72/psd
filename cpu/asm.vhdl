library ieee;

use ieee.std_logic_1164.all;

library work;

package asm is
    subtype opcode_t is std_logic_vector(3 downto 0);
    subtype regcode_t is std_logic_vector(1 downto 0);

    constant OP_AND : opcode_t := "0000";
    constant OP_OR : opcode_t := "0001";
    constant OP_NOT : opcode_t := "0010";
    constant OP_ADD : opcode_t := "0011";
    constant OP_SUB : opcode_t := "0100";
    constant OP_CMP : opcode_t := "0101";
    constant OP_JMP : opcode_t := "0110";
    constant OP_JEQ : opcode_t := "0111";
    constant OP_JGR : opcode_t := "1000";
    constant OP_LOAD : opcode_t := "1001";
    constant OP_STORE : opcode_t := "1010";
    constant OP_MOV : opcode_t := "1011";
    constant OP_IN : opcode_t := "1100";
    constant OP_OUT : opcode_t := "1101";
    constant OP_WAIT : opcode_t := "1110";
    constant OP_NOP : opcode_t := "1111";

    constant REG_A : regcode_t := "00";
    constant REG_B : regcode_t := "01";
    constant REG_R : regcode_t := "10";
    constant REG_I : regcode_t := "11";
end package;
