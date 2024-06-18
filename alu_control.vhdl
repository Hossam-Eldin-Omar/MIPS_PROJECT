library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_control is 
    port 
    (
        alu_select: out std_logic_vector(2 downto 0);
        aluop:in std_logic_vector(1 downto 0);
        funct:in std_logic_vector (2 downto 0)

    );
end alu_control;

architecture Behavioral of alu_control is

begin
    process(aluop,funct)
    begin
        case aluop is 
            when "00"=>
            alu_select <= funct(2 downto 0);
            when "01"=>
            alu_select <= "001";
            when "10"=>
            alu_select <= "100";
            when "11"=>
            alu_select <= "000";
            when others =>
            alu_select <= "000";
        end case;
    end process;
end Behavioral;