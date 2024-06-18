library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  
-- VHDL code for the Instruction Memory of the MIPS Processor
entity Instruction_Memory is
port (
 pc: in std_logic_vector(15 downto 0);
 instruction: out  std_logic_vector(15 downto 0)
);
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is
signal rom_addr: std_logic_vector(3 downto 0);

 type ROM_type is array (0 to 15 ) of std_logic_vector(15 downto 0);
 constant rom_data: ROM_type:=(
   "0111001000000101", --0
   "0111010000000000", --1
   "0111011000000000", --2
   "0111100000000000", --3
   "0001010011010000", --4
   "0001000011011110", --5
   "0001000100100110", --6
   "1011011001000100", --7
   "0001100010010011", --8
   "0000000000000000",
   "0000000000000000", 
   "0000000000000000", 
   "0000000000000000", 
   "0000000000000000", 
   "0000000000000000", 
   "0000000000000000"  
  );
begin

 rom_addr <= pc(3 downto 0);
 instruction <= rom_data(to_integer(unsigned(rom_addr))) when pc < x"0010" else x"0000";

end Behavioral;