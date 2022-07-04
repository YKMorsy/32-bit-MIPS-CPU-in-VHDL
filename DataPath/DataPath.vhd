library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DataPath is
    PORT (
        rst : in std_logic;
        clk : in std_logic;
        
        -- signals from control unit
        PCWriteCond : in std_logic;
        PCWrite : in std_logic;
        IorD : in std_logic;
        MemWrite : in std_logic;
        MemtoReg : in std_logic_vector(3 downto 0);
        IRWrite : in std_logic;
        PCSource : in std_logic_vector(1 downto 0);
        ALUOp : in std_logic_vector(3 downto 0);
        ALUSrcB : in std_logic_vector(2 downto 0);
        ALUSrcA : in std_logic;
        RegWrite : in std_logic;
        RegDst : in std_logic_vector(1 downto 0);
        MultRst : in std_logic;
        shiftVal : in std_logic;
        BLTZALWrite : in std_logic;
        
        -- signal from memory
        MemData : in std_logic_vector(31 downto 0);
        
        opcode : out std_logic_vector(5 downto 0); -- Mapped to control
        ALUControlOP : out std_logic_vector(5 downto 0);
        
        -- signal to memory
        Address : out std_logic_vector(31 downto 0);
        writeData : out std_logic_vector (31 downto 0);
        
        done : out std_logic -- Important in mult control
        
        
    );
end DataPath;

architecture Structural of DataPath is

    -- Declare components
    
    COMPONENT ALU IS
        GENERIC (
            WIDTH : positive := 32
        );
        PORT (
            A : in std_logic_vector(WIDTH-1 downto 0);
            B : in std_logic_vector(WIDTH-1 downto 0);
            ALUOp : in std_logic_vector(3 downto 0);
            SHAMT : in std_logic_vector (4 downto 0);
            R : out std_logic_vector(WIDTH-1 downto 0);
            Overflow : out std_logic;
            Zero : out std_logic
        );
    END COMPONENT;
    
    COMPONENT MultTop IS
        GENERIC(
            N : Integer := 64);
        PORT(
            A : IN STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);
            rst : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            done : OUT STD_LOGIC;
            
            R : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT MUX_3_IN IS
        GENERIC(
            N : Integer := 32);
        PORT(
            sel : in std_logic_vector(1 downto 0);
            in1 : in std_logic_vector(N-1 downto 0);
            in2 : in std_logic_vector(N-1 downto 0);
            in3 : in std_logic_vector(N-1 downto 0);
            output : out std_logic_vector(N-1 downto 0)
        );
    END COMPONENT;

    COMPONENT MUX_2_IN IS
        GENERIC(
            N : Integer := 5);
        PORT(
            sel : in std_logic;
            in1 : in std_logic_vector(N-1 downto 0);
            in2 : in std_logic_vector(N-1 downto 0);
            output : out std_logic_vector(N-1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT MUX_4_IN IS
        GENERIC(
            N : Integer := 32);
        PORT(
            sel : in std_logic_vector(1 downto 0);
            in1 : in std_logic_vector(N-1 downto 0);
            in2 : in std_logic_vector(N-1 downto 0);
            in3 : in std_logic_vector(N-1 downto 0);
            in4 : in std_logic_vector(N-1 downto 0);
            output : out std_logic_vector(N-1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT MUX_5_IN IS
        GENERIC(
            N : Integer := 32);
        PORT(
            sel : in std_logic_vector(2 downto 0);
            in1 : in std_logic_vector(N-1 downto 0);
            in2 : in std_logic_vector(N-1 downto 0);
            in3 : in std_logic_vector(N-1 downto 0);
            in4 : in std_logic_vector(N-1 downto 0);
            in5 : in std_logic_vector(N-1 downto 0);
            output : out std_logic_vector(N-1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT MUX_9_IN IS
        GENERIC(
            N : Integer := 32);
        PORT(
            sel : in std_logic_vector(3 downto 0);
            in1 : in std_logic_vector(N-1 downto 0);
            in2 : in std_logic_vector(N-1 downto 0);
            in3 : in std_logic_vector(N-1 downto 0);
            in4 : in std_logic_vector(N-1 downto 0);
            in5 : in std_logic_vector(N-1 downto 0);
            in6 : in std_logic_vector(N-1 downto 0);
            in7 : in std_logic_vector(N-1 downto 0);
            in8 : in std_logic_vector(N-1 downto 0);
            in9 : in std_logic_vector(N-1 downto 0);
            output : out std_logic_vector(N-1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT InstructionRegister IS
        PORT( 
          clk : in std_logic;
          rst : in std_logic;
          EN : in std_logic;
          D : in std_logic_vector(31 downto 0);
          Q1 : out std_logic_vector(5 downto 0);
          Q2 : out std_logic_vector(4 downto 0);
          Q3 : out std_logic_vector(4 downto 0);
          Q4 : out std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    
    COMPONENT Register_File IS
        PORT( 
          r1 : in std_logic_vector(4 downto 0); -- Register 1 (address)
          r2 : in std_logic_vector(4 downto 0); -- Register 2 (address)
          wr : in std_logic_vector(4 downto 0); -- Write register address
          wd : in std_logic_vector(31 downto 0); -- Data to write to register
          regwrite : in std_logic; -- Control signal to write to register
          clk : in std_logic;
          rst : in std_logic;
          d1 : out std_logic_vector(31 downto 0); -- Output 
          d2 : out std_logic_vector(31 downto 0)
        );
    END COMPONENT;

    COMPONENT ShiftLeftBy2 IS
        GENERIC(
            N : Integer := 32);
        PORT(
            D : in std_logic_vector(N-1 downto 0);
            Q : out std_logic_vector(N-1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT ShiftLeftBy2Extend IS
        GENERIC(
            N : Integer := 26);
        PORT(
            D : in std_logic_vector(N-1 downto 0);
            Q : out std_logic_vector(N+1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT SignExtender IS
        PORT(
          D : in std_logic_vector(15 downto 0);
          Q : out std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    
    COMPONENT genReg IS
        GENERIC(
            N : Integer := 5);
        PORT( 
          clk : in std_logic;
          rst : in std_logic;
          EN : in std_logic;
          D : in std_logic_vector(N-1 downto 0);
          Q : out std_logic_vector(N-1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT CLO IS
        GENERIC(
            N : Integer := 32);
        PORT( 
          D : in std_logic_vector(N-1 downto 0);
          Q : out std_logic_vector(N-1 downto 0)
        );
    END COMPONENT;
    
    -- Intermediate signals
    signal pc_in_mux_out : std_logic_vector(31 downto 0);
    signal mux_in_pc_out : std_logic_vector(31 downto 0);
    signal alu_zero : std_logic;
    signal branch_cond : std_logic;
    
    signal pc_mux_in_alureg_out : std_logic_vector(31 downto 0);
    
    signal I_31_26 : std_logic_vector(5 downto 0);
    signal I_25_21 : std_logic_vector(4 downto 0);
    signal I_20_16 : std_logic_vector(4 downto 0);
    signal I_15_0 : std_logic_vector(15 downto 0);
    signal I_25_0 : std_logic_vector(25 downto 0);
    
    signal mem_mux_in_mem_reg_out : std_logic_vector(31 downto 0);
    
    signal write_data_in_data_mux_out : std_logic_vector(31 downto 0);
    signal write_reg_in_reg_mux_out : std_logic_vector(4 downto 0);
    
    signal read_data1 : std_logic_vector(31 downto 0);
    signal read_data2 : std_logic_vector(31 downto 0);
    
    signal sign_extended : std_logic_vector(31 downto 0);
    
    signal mux_in_shift_sign_out : std_logic_vector(31 downto 0);
    
    signal mux_in_a_reg_out : std_logic_vector(31 downto 0);
    signal mux_in_b_reg_out : std_logic_vector(31 downto 0);
    
    signal alu_in1_mux_out : std_logic_vector(31 downto 0);
    signal alu_in2_mux_out : std_logic_vector(31 downto 0);
    signal const_val : std_logic_vector(31 downto 0) := x"00000004";
    
    signal alu_result : std_logic_vector(31 downto 0);
    signal Overflow : std_logic; -- Not used
    
    --signal alu_reg_out : std_logic_vector(31 downto 0);
    
    signal mux_in_shift_instr : std_logic_vector(27 downto 0);
    
    signal mux_in_shift_pc : std_logic_vector(31 downto 0);
    
    signal mux_in_a_reg_out_shifted : std_logic_vector(31 downto 0);
    
    signal writeDataLoadHW : std_logic_vector(31 downto 0);
    signal writeDataLoadB : std_logic_vector(31 downto 0);
    
    signal zero_extended_I_15_0 : std_logic_vector(31 downto 0);
    
    signal HW_sign_extension : std_logic_vector(15 downto 0);
    signal B_sign_extension : std_logic_vector(23 downto 0);
    signal UI_shifted : std_logic_vector(31 downto 0);
    
    signal num_of_ones : std_logic_vector(31 downto 0);
    
    signal num_of_ones_to_wd : std_logic_vector(31 downto 0);
    
    signal mult_result : std_logic_vector(63 downto 0);
    signal Hi_val : std_logic_vector(31 downto 0);
    signal Lo_val : std_logic_vector(31 downto 0);
    
    signal done_interm : std_logic;
    
    signal sa_val : std_logic_vector(4 downto 0);
    signal SHAMT : std_logic_vector(4 downto 0);
    
begin

    -- Intermediate logic
    branch_cond <= ((PCWriteCond AND not(alu_zero)) or PCWrite or (BLTZALWrite AND mux_in_a_reg_out(31))); -- This condition is used for branching if equal
    mux_in_shift_pc <= mux_in_pc_out(31 downto 28) & mux_in_shift_instr;
    opcode <= I_31_26;
    I_25_0 <= I_25_21 & I_20_16 & I_15_0;
    HW_sign_extension <= (others => mem_mux_in_mem_reg_out(15));
    B_sign_extension <= (others => mem_mux_in_mem_reg_out(7));
    writeDataLoadHW <= "0000000000000000" & mem_mux_in_mem_reg_out(31 downto 16);
    writeDataLoadB <= B_sign_extension & mem_mux_in_mem_reg_out(7 downto 0);
    zero_extended_I_15_0 <= "0000000000000000" & I_15_0;
    UI_shifted <= I_15_0 & "0000000000000000";
    done <= done_interm;
    sa_val <= I_15_0(10 downto 6);
        
    -- Connect components
    ALUControlOP <= I_15_0(5 downto 0);
    writeData <= mux_in_b_reg_out;
    
    PC : genReg GENERIC MAP (N => 32) PORT MAP (clk => clk, rst => rst, EN => branch_cond, D => pc_in_mux_out, Q => mux_in_pc_out);
    PC_MUX : MUX_2_IN GENERIC MAP (N => 32) PORT MAP (sel => IorD, in1 => mux_in_pc_out, in2 => pc_mux_in_alureg_out, output => Address);
    IReg : InstructionRegister PORT MAP (clk => clk, rst => rst, EN => IRWrite, D => MemData, Q1 => I_31_26, Q2 => I_25_21, Q3 => I_20_16, Q4 => I_15_0);
    MemDataReg : genReg GENERIC MAP (N => 32) PORT MAP (clk => clk, rst => rst, EN => '1', D => MemData, Q => mem_mux_in_mem_reg_out);
    
    WriteDataMux : MUX_9_IN GENERIC MAP (N => 32) PORT MAP (sel => MemtoReg, in1 => pc_mux_in_alureg_out, in2 => mem_mux_in_mem_reg_out, 
                                                            in3 => writeDataLoadHW, in4 => writeDataLoadB, in5 => UI_shifted, in6 => num_of_ones_to_wd, 
                                                            in7 => Lo_val, in8 => Hi_val, in9 => mux_in_pc_out, output => write_data_in_data_mux_out);  
    
    WriteRegMux : MUX_3_IN GENERIC MAP (N => 5) PORT MAP (sel => RegDst, in1 => I_20_16, in2 => I_15_0(15 downto 11), in3 => "11111", output => write_reg_in_reg_mux_out);
    
    RegFile : Register_File PORT MAP (r1 => I_25_21, r2 => I_20_16, wr => write_reg_in_reg_mux_out, wd => write_data_in_data_mux_out, regwrite => RegWrite, clk => clk, rst => rst, d1 => read_data1, d2 => read_data2);
    SignExtend : SignExtender PORT MAP (D => I_15_0, Q => sign_extended);
    ShiftLeftSignExtended : ShiftLeftBy2 GENERIC MAP (N => 32) PORT MAP (D => sign_extended, Q => mux_in_shift_sign_out);
    AReg : genReg GENERIC MAP (N => 32) PORT MAP (clk => clk, rst => rst, EN => '1', D => read_data1, Q => mux_in_a_reg_out);    
    BReg : genReg GENERIC MAP (N => 32) PORT MAP (clk => clk, rst => rst, EN => '1', D => read_data2, Q => mux_in_b_reg_out);          
    MUXtoALU1 : MUX_2_IN GENERIC MAP (N => 32) PORT MAP (sel => ALUSrcA, in1 => mux_in_pc_out, in2 => mux_in_a_reg_out, output => alu_in1_mux_out);
    MUXtoALU2 : MUX_5_IN GENERIC MAP (N => 32) PORT MAP (sel => ALUSrcB, in1 => mux_in_b_reg_out, in2 => const_val, in3 => sign_extended, in4 => mux_in_shift_sign_out, in5 => zero_extended_I_15_0,output => alu_in2_mux_out);
    
    SA_MUX : MUX_2_IN GENERIC MAP (N => 5) PORT MAP (sel => shiftVal, in1 => sa_val, in2 => mux_in_a_reg_out(4 downto 0), output => SHAMT);   
    
    ALUUnit : ALU GENERIC MAP (WIDTH => 32) PORT MAP (A => alu_in1_mux_out, B => alu_in2_mux_out, ALUOp => ALUOp, SHAMT => SHAMT, Overflow => Overflow, zero => alu_zero, R => alu_result);
    ALUOut : genReg GENERIC MAP (N => 32) PORT MAP (clk => clk, rst => rst, EN => '1', D => alu_result, Q => pc_mux_in_alureg_out);
    
    CLOUnit : CLO GENERIC MAP (N => 32) PORT MAP (D => mux_in_a_reg_out, Q => num_of_ones);
    CLOOut : genReg GENERIC MAP (N => 32) PORT MAP (clk => clk, rst => rst, EN => '1', D => num_of_ones, Q => num_of_ones_to_wd);
    
    ShiftLeftInstr : ShiftLeftBy2Extend GENERIC MAP (N => 26) PORT MAP (D => I_25_0, Q => mux_in_shift_instr);
    ALU_OC_MUX : MUX_4_IN GENERIC MAP (N => 32) PORT MAP (sel => PCSource, in1 => alu_result, in2 => pc_mux_in_alureg_out, in3 => mux_in_shift_pc, in4 => mux_in_a_reg_out, output => pc_in_mux_out);
    
    ShiftLeft2 : ShiftLeftBy2 GENERIC MAP (N => 32) PORT MAP (D => mux_in_a_reg_out, Q => mux_in_a_reg_out_shifted); -- This if for JR (need to shift by two again to get right address)

    MULTUnit : MultTop GENERIC MAP (N => 64) PORT MAP (A => mux_in_a_reg_out, B => mux_in_b_reg_out, rst => MultRst, clk => clk, done => done_interm, R => mult_result);
    HiReg : genReg GENERIC MAP (N => 32) PORT MAP (clk => clk, rst => rst, EN => done_interm, D => mult_result(63 downto 32), Q => Hi_val);
    LoReg : genReg GENERIC MAP (N => 32) PORT MAP (clk => clk, rst => rst, EN => done_interm, D => mult_result(31 downto 0), Q => Lo_val);
    
      

end Structural;
