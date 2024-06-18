library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity alu_16bit is
    Port 
    ( 
        inp_a,inp_b : in STD_LOGIC_VECTOR(15 downto 0);
        sel : in STD_LOGIC_VECTOR (2 downto 0);
        out_alu : out STD_LOGIC_VECTOR(15 downto 0);
        zero_flag : out STD_LOGIC;
        carry_flag : out STD_LOGIC
    );
end alu_16bit;
 
architecture Behavioral of alu_16bit is
    signal result:std_logic_vector(16 downto 0);
    begin
    process(inp_a, inp_b, sel)
        begin
        case sel is
            when "000" =>
            result<= '0'& std_logic_vector(unsigned(inp_a) + unsigned(inp_b)); --addition
            when "001" =>
            result<= std_logic_vector (('0' & unsigned(inp_a)) - ('0' & unsigned(inp_b))); --subtraction
            when "010" =>
            result<= '0' & std_logic_vector((unsigned(inp_a(7 downto 0))) * (unsigned(inp_b(7 downto 0)))); --multiplication
            when "011" =>
            result<= '0' & std_logic_vector((unsigned(inp_a)) / (unsigned(inp_b))); --division
            when "100" =>
            result<='0' & (inp_a and inp_b); --AND gate
            when "101" =>
            result<= '0' & (inp_a or inp_b); --OR gate
            when "110" =>
            result<= std_logic_vector (('0' & unsigned(inp_a)) + 1) ; --increment inp_a
            when "111" =>
            result<= std_logic_vector (('0' & unsigned(inp_a)) - 1) ; --decrement inp_a
            when others => NULL;
        end case;
        
    end process;
    zero_flag<='1' when result(15 downto 0)<=x"0000" else '0';
    carry_flag<=result(16);
    out_alu<= result(15 downto 0);
end Behavioral;
