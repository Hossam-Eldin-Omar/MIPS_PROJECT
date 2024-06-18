library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  
-- VHDL code for Control Unit of the MIPS Processor
entity Control_unit is
port (
  opcode: in std_logic_vector(3 downto 0);
  reset: in std_logic;
  reg_dst,mem_to_reg,alu_op: out std_logic_vector(1 downto 0);
  jump,branch,mem_read,mem_write,alu_src,reg_write,sign_or_zero: out std_logic
 );
end Control_unit;

architecture behavioral of Control_unit is

begin
    process(reset,opcode)
    begin
        if(reset = '1') then
            reg_dst <= "00";
            mem_to_reg <= "00";
            alu_op <= "00";
            jump <= '0';
            branch <= '0';
            mem_read <= '0';
            mem_write <= '0';
            alu_src <= '0';
            reg_write <= '0';
            sign_or_zero <= '1';
        else 
        -- reg_write <= '0'; --set the register_write to zero every time an instruction is decoded
            case opcode is
                when"0001" => --R-Type instruction
                    reg_dst <= "01";
                    mem_to_reg <= "00";
                    alu_op <= "00";
                    jump <= '0';
                    branch <= '0';
                    mem_read <= '0';
                    mem_write <= '0';
                    alu_src <= '0';
                    reg_write <= '1';
                    sign_or_zero <= '1';
                when"0010" => --I-Type add immediate
                    reg_dst <= "00";
                    mem_to_reg <= "00";
                    alu_op <= "11";
                    jump <= '0';
                    branch <= '0';
                    mem_read <= '0';
                    mem_write <= '0';
                    alu_src <= '1';
                    reg_write <= '1';
                    sign_or_zero <= '1';
                when"0011" => --I-Type subtract immediate
                    reg_dst <= "00";
                    mem_to_reg <= "00";
                    alu_op <= "01";
                    jump <= '0';
                    branch <= '0';
                    mem_read <= '0';
                    mem_write <= '0';
                    alu_src <= '1';
                    reg_write <= '1';
                    sign_or_zero <= '1';
                when"0100" => --I-Type and immediate
                    reg_dst <= "00";
                    mem_to_reg <= "00";
                    alu_op <= "10";
                    jump <= '0';
                    branch <= '0';
                    mem_read <= '0';
                    mem_write <= '0';
                    alu_src <= '1';
                    reg_write <= '1';
                    sign_or_zero <= '1';
                when"0111" => --load immediate value
                    reg_dst <= "11";
                    mem_to_reg <= "00";
                    alu_op <= "11";
                    jump <= '0';
                    branch <= '0';
                    mem_read <= '1';
                    mem_write <= '0';
                    alu_src <= '1';
                    reg_write <= '1'; --after 10 ns
                    sign_or_zero <= '1';
                when"1000" => --load from memory
                    reg_dst <= "00";
                    mem_to_reg <= "01";
                    alu_op <= "11"; -- alu will add during ld adn st instructions
                    jump <= '0';
                    branch <= '0';
                    mem_read <= '1';
                    mem_write <= '0';
                    alu_src <= '0';
                    reg_write <= '1'; --after 10 ns
                    sign_or_zero <= '1';
                when"1001" => --store to memory
                    reg_dst <= "10"; --don't care
                    mem_to_reg <= "XX"; --don't care
                    alu_op <= "11"; --
                    jump <= '0';
                    branch <= '0';
                    mem_read <= '0'; 
                    mem_write <= '1';
                    alu_src <= '0';
                    reg_write <= '0';
                    sign_or_zero <= '1';
                when"1010" => --j-type Branch if equal
                    reg_dst <= "00";
                    mem_to_reg <= "00";
                    alu_op <= "01"; --subtract
                    jump <= '0';
                    branch <= '1';
                    mem_read <= '0';
                    mem_write <= '0';
                    alu_src <= '0';
                    reg_write <= '0';
                    sign_or_zero <= '1';
                when"1011" => --j-type Branch if greater than
                    reg_dst <= "00";
                    mem_to_reg <= "00";
                    alu_op <= "01"; --subtract
                    jump <= '0';
                    branch <= '1';
                    mem_read <= '0';
                    mem_write <= '0';
                    alu_src <= '0';
                    reg_write <= '0';
                    sign_or_zero <= '1';
                when"1100" => --j-type Branch if less than
                    reg_dst <= "00";
                    mem_to_reg <= "00";
                    alu_op <= "01"; --subtract
                    jump <= '0';
                    branch <= '1';
                    mem_read <= '0';
                    mem_write <= '0';
                    alu_src <= '0';
                    reg_write <= '0';
                    sign_or_zero <= '1';
                when"1101" => --j-type Branch on carry
                    reg_dst <= "10";
                    mem_to_reg <= "00";
                    alu_op <= "XX"; --subtract
                    jump <= '0';
                    branch <= '1';
                    mem_read <= '0';
                    mem_write <= '0';
                    alu_src <= '0';
                    reg_write <= '0';
                    sign_or_zero <= '1';
                when"1110" => --j-type Branch on zero
                    reg_dst <= "00";
                    mem_to_reg <= "00";
                    alu_op <= "01"; --subtract
                    jump <= '0';
                    branch <= '1';
                    mem_read <= '0';
                    mem_write <= '0';
                    alu_src <= '0';
                    reg_write <= '0';
                    sign_or_zero <= '1';
                when"1111" => --j-Type jump
                    reg_dst <= "XX";
                    mem_to_reg <= "XX";
                    alu_op <= "11"; --
                    mem_read <= '0';
                    jump <= '1';
                    branch <= '0';
                    mem_write <= '0';
                    alu_src <= '0';
                    reg_write <= '0';
                    sign_or_zero <= '1';
                when others => 
                    reg_dst <= "00";
                    mem_to_reg <= "00";
                    alu_op <= "00";
                    jump <= '0';
                    branch <= '0';
                    mem_read <= '0';
                    mem_write <= '0';
                    alu_src <= '0';
                    reg_write <= '0';
                    sign_or_zero <= '0';
            end case;        
        end if;    
    end process;
end behavioral;