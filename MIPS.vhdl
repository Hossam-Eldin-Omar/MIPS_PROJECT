library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity mips is
    port
    (
        clk,reset: in std_logic;
        pc_out,alu_result: out std_logic_vector(15 downto 0)
    );
end mips;



architecture behavioral of mips is
    signal pc_current: std_logic_vector(15 downto 0);
    signal pc_next,pc2: std_logic_vector(15 downto 0);
    signal instr: std_logic_vector(15 downto 0);
    signal reg_dst,mem_to_reg,alu_op: std_logic_vector(1 downto 0);
    signal jump,branch,mem_read,mem_write,alu_src,reg_write: std_logic;
    signal reg_write_dest: std_logic_vector(2 downto 0);
    signal reg_write_data: std_logic_vector(15 downto 0);
    signal reg_read_addr_1: std_logic_vector(2 downto 0);
    signal reg_read_data_1: std_logic_vector(15 downto 0);
    signal reg_read_addr_2: std_logic_vector(2 downto 0);
    signal reg_read_data_2: std_logic_vector(15 downto 0);
    signal sign_ext_im,read_data2,zero_ext_im,imm_ext: std_logic_vector(15 downto 0);
    signal JRControl: std_logic;
    signal ALU_Control: std_logic_vector(2 downto 0);
    signal ALU_out: std_logic_vector(15 downto 0);
    signal zero_flag,carry_flag: std_logic;
    signal im_shift_1, PC_j, PC_beq, PC_4beq,PC_4beqj,PC_jr: std_logic_vector(15 downto 0);
    signal beq_control: std_logic;
    signal jump_shift_1: std_logic_vector(14 downto 0);
    signal AR,mem_read_data: std_logic_vector(15 downto 0);
    signal no_sign_ext: std_logic_vector(15 downto 0);
    signal sign_or_zero: std_logic;
    signal tmp1: std_logic_vector(6 downto 0);
    signal tmp2: std_logic_vector(9 downto 0);
    signal z: std_logic_vector(15 downto 0):= x"0001";
    signal FR: std_logic_vector(7 downto 0);
    -- type reg_type is array (0 to 1) of std_logic_vector (7 downto 0);
    -- signal FR: reg_type;
begin
    process(clk,reset)
    begin
        if(reset='1') then
            pc_current <= x"0000";
            -- FR <= x"00";
        elsif(rising_edge(clk)) then
            pc_current <= pc_next;
        end if;
    end process;
    pc2 <= std_logic_vector ( unsigned (pc_current) + unsigned (z) );

    Instruction_Memory: entity work.Instruction_Memory
    port map
    (
    pc => pc_current,
    Instruction => instr
    );

    jump_shift_1 <= instr(13 downto 0) & '0';

    control: entity work.Control_unit
    port map
    (
        reset => reset,
        opcode => instr(15 downto 12),
        reg_dst => reg_dst,
        mem_to_reg => mem_to_reg,
        alu_op => alu_op,
        jump => jump,
        branch => branch,
        mem_read => mem_read,
        mem_write => mem_write,
        alu_src => alu_src,
        reg_write => reg_write,
        sign_or_zero => sign_or_zero
    );
    --regdest multiplexer
    reg_write_dest <= "111" when  reg_dst= "10" else --keda keda malhash lazma bec reg_write='0' when dest="10"
        instr(5 downto 3) when  reg_dst= "01" else
        instr(11 downto 9);
    -- register file instantiation of the MIPS Processor
    reg_read_addr_1 <= "000" when reg_dst="10" else -- reg_dst="10" store to memory from one register only
    "000" when reg_dst="11" else instr(8 downto 6); 
    reg_read_addr_2 <= instr(11 downto 9);
    register_file: entity work.register_file
    port map
    (
        clk => clk,
        rst => reset,
        reg_write_en => reg_write,
        reg_write_dest => reg_write_dest,
        reg_write_data => reg_write_data,
        reg_read_addr_1 => reg_read_addr_1,
        reg_read_data_1 => reg_read_data_1,
        reg_read_addr_2 => reg_read_addr_2,
        reg_read_data_2 => reg_read_data_2
    );

    -- sign extend
    tmp1 <= (others => instr(8));
    tmp2 <= (others => instr(5));
    sign_ext_im <=  (tmp1 & instr(8 downto 0)) when instr(15 downto 12) = "0111" else (tmp2 & instr(5 downto 0)); 
    zero_ext_im <= ("0000000"& instr(8 downto 0)) when instr(15 downto 12) = "0111" else ("0000000000"& instr(5 downto 0)); 
    imm_ext <= sign_ext_im when sign_or_zero='1' else zero_ext_im;

    -- JR control unit of the MIPS
    JRControl <= '1' when ((alu_op="00") and (instr(3 downto 0)="1000")) else '0';

    ALUControl: entity work.alu_control 
    port map
    (   
        aluop => alu_op,
        funct => instr(2 downto 0),
        alu_select => ALU_Control
    );
    
    --alu_src multiplexer 
    read_data2 <= imm_ext when alu_src='1' else reg_read_data_2;
    
    alu: entity work.alu_16bit 
    port map
    (
        inp_a => reg_read_data_1,
        inp_b => read_data2,
        sel => ALU_Control,
        out_alu => ALU_out,
        zero_flag => zero_flag,
        carry_flag => carry_flag
    );
    FR(0) <= zero_flag  when instr(15 downto 12) = "0001";
    -- or "0010" or "0011" or "0100" ) ;
    FR(1) <= carry_flag when instr(15 downto 12) = "0001";
    -- or "0010" or "0011" or "0100" ) ;

    beq_control<=(branch and zero_flag) when instr(15 downto 12)="1010" else
    (branch and ALU_out(15)) when instr(15 downto 12) ="1100" else
    (branch and not (ALU_out(15))) when instr(15 downto 12) ="1011" else
    (branch and FR(1)) when instr(15 downto 12)="1101" else
    (branch and FR(0)) when instr(15 downto 12)="1110" else '0';
    --(branch and carry_flag) when instr(15 downto 12)="1100" else 
    --(branch and (not (carry_flag))) when instr(15 downto 12)="1011" else '0';
    pc_beq<= ("0000000000" & instr(5 downto 0)) when beq_control = '1' else ("0000" & instr(11 downto 0)) when jump = '1' else pc2 ;
    pc_next <= pc_beq;
    Ar<=("00000000" & instr(7 downto 0));
    data_memory: entity work.Data_Memory 
    port map
    (
        clk => clk,
        mem_access_addr => Ar,
        mem_write_data => reg_read_data_2,
        mem_write_en => mem_write,
        mem_read => mem_read,
        mem_read_data => mem_read_data
    );
    
    reg_write_data <= pc2 when (mem_to_reg = "10") else
    mem_read_data when (mem_to_reg = "01") else ALU_out;

    -- output
    pc_out <= pc_current;
    alu_result <= ALU_out;

end behavioral; 
