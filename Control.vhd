library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control is
    PORT (
        rst : in std_logic;
        clk : in std_logic;
        
        -- signals from control unit
        PCWriteCond : out std_logic;
        PCWrite : out std_logic;
        IorD : out std_logic;
        MemWrite : out std_logic;
        MemtoReg : out std_logic_vector(3 downto 0);
        IRWrite : out std_logic;
        PCSource : out std_logic_vector(1 downto 0);
        ALUOp : out std_logic_vector(3 downto 0);
        ALUSrcB : out std_logic_vector(2 downto 0);
        ALUSrcA : out std_logic;
        RegWrite : out std_logic;
        RegDst : out std_logic_vector(1 downto 0);
        MultRst : out std_logic;
        shiftVal : out std_logic;
        BLTZALWrite : out std_logic;
        
        opcode : in std_logic_vector(5 downto 0); -- Mapped to control
        ALUControlOP : in std_logic_vector(5 downto 0);
        done : in std_logic -- Important in FSM
        
    );
end Control;

architecture Behavioral of Control is

    type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15);
    signal state : state_type;

begin

  process (clk, rst)
  begin
  
    if rst = '1' then
        state <= s0;
    elsif (rising_edge(clk)) then
        case state is
            when s0 => 
                state <= s1;
            when s1 =>
                if (opcode = "000010") or (opcode = "000000" and ALUControlOP = "001000") then -- J and JR (before R and I if statement)
                    state <= s9;
                elsif (opcode = "000000") and (ALUControlOP = "011001") then -- MULTU
                    state <= s12;
                elsif (opcode = "000000") and (ALUControlOP = "010010") then -- MFLO
                    state <= s13;
                elsif (opcode = "000000") and (ALUControlOP = "010000") then -- MFLO
                    state <= s14;
                elsif (opcode = "000000") or (opcode = "001000") or (opcode = "001101") or (opcode = "001010") then -- R and I type
                    state <= s6;
                elsif (opcode = "000101") then -- BNE
                    state <= s8;
                elsif (opcode = "001111") or (opcode = "101011") or (opcode = "100011") or (opcode = "100001") or (opcode = "100000") then -- LUI, SW, LW, LH, LB
                    state <= s2;
                elsif (opcode = "011100") and (ALUControlOP = "100001") then -- CLO
                    state <= s10;
                elsif (opcode = "000001") then -- BLTZAL
                    state <= s15;
                end if;
            when s6 => -- R and I type
                state <= s7;
            when s7 => -- R and I type
                state <= s0;
            when s8 => -- BNE
                state <= s0;
            when s9 => -- J and JR
                state <= s0;
            when s2 => -- LUI, SW, LW, LH, LB
                if (opcode = "101011") then
                    state <= s5; -- SW
                else
                    state <= s3; -- L
                end if;
            when s3 => -- LUI, LW, LH, LB
                state <= s4;
            when s4 => -- LUI, LW, LH, LB
                state <= s0;
            when s5 => -- LUI, LW, LH, LB
                state <= s0;
            when s10 => -- CLO
                state <= s11;
            when s11 => -- CLO
                state <= s0;
            when s12 => -- MULTU
                if (done = '1') then
                    state <= s0;
                else
                    state <= s12;
                end if;  
            when s13 => -- MFLO
                state <= s0;       
            when s14 => -- MFHI
                state <= s0;    
            when s15 => -- BLTZAL
                state <= s0;    
        end case;
    end if;

  end process;

    process (state)
    begin
        case state is
            when s0 =>
                PCWriteCond <= '0';
                PCWrite <= '1';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "0000";
                IRWrite <= '1';
                RegDst <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "001";
                ALUOp <= "0101"; -- Add unsigned to get new memory address (x+4)
                PCSource <= "00";   
                BLTZALWrite <= '0';             
            when s1 => -- Add offset incase the instruction is a branch (will not impact other states)
                PCWriteCond <= '0';
                
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "0000";
                IRWrite <= '0';
                RegDst <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                MultRst <= '1';
                --if (opcode = "000101") then
                    ALUSrcB <= "011"; -- This is necessary if the branch stage is taken
                    ALUOp <= "0101";
                    PCWrite <= '0';
                --else
                --    ALUSrcB <= "01";
                --    ALUOp <= "0101"; -- Add unsigned to get new memory address (x+4)
                --    PCWrite <= '1';
                --end if;
                
                PCSource <= "00";   
                BLTZALWrite <= '0';     
                
            when s2 => -- Calculate new memory address to load or store to
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "0000";
                IRWrite <= '0';
                RegDst <= "00";
                RegWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "010";
                ALUOp <= "0101";
                PCSource <= "00";  
                BLTZALWrite <= '0';   
                
            when s3 => -- Read correct Load address
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '1';
                MemWrite <= '0';
                MemtoReg <= "0000";
                IRWrite <= '0';
                RegDst <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "000";
                ALUOp <= "0000";
                PCSource <= "00"; 
                BLTZALWrite <= '0';    
                
            when s4 => -- Write to register file
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                
                if (opcode = "100011") then
                    MemtoReg <= "0001"; -- LW
                elsif (opcode = "100001") then
                    MemtoReg <= "0010"; -- LH
                elsif (opcode = "100000") then
                    MemtoReg <= "0011"; -- LB
                elsif (opcode = "001111") then
                    MemtoReg <= "0100"; -- LUI
                end if;
                
                
                IRWrite <= '0';
                RegDst <= "00";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= "000";
                ALUOp <= "0000";
                PCSource <= "00"; 
                BLTZALWrite <= '0';   
                
            when s5 => -- Store to memory
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '1';
                MemWrite <= '1';
                MemtoReg <= "0000";
                IRWrite <= '0';
                RegDst <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "000";
                ALUOp <= "0000";
                PCSource <= "00";  
                BLTZALWrite <= '0';   
                
            when s6 =>
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "0000";
                IRWrite <= '0';
                RegDst <= "00";
                RegWrite <= '0';
                ALUSrcA <= '1';
                
                
                if (opcode = "000000") then -- R type
                    ALUSrcB <= "000";
                    case ALUControlOP is
                        when "100001" => 
                            ALUOp <= "0101";  --ADDU
                        when "100100" => 
                            ALUOp <= "0000";  --AND
                        when "100010" => 
                            ALUOp <= "0110";  --SUB
                        when "000011" => 
                            ALUOp <= "1111";  --SRA
                            shiftVal <= '0';
                        when "000100" => 
                            ALUOp <= "1100";  --SLLV
                            shiftVal <= '1';
                        when "000000" => 
                            ALUOp <= "1100";  --SLL
                            shiftVal <= '0';
                        when others => 
                            ALUOp <= "0000";
                    end case;
                else -- I type
                    case opcode is
                        when "001000" => 
                            ALUSrcB <= "010";
                            ALUOp <= "0101";  --ADDI
                        when "001101" => 
                            ALUSrcB <= "100"; -- zero extended for ORI
                            ALUOp <= "0001";  --ORI
                        when others => 
                            ALUSrcB <= "010";
                            ALUOp <= "1010";  --SLTI
                    end case;
                end if;
                
                PCSource <= "00";  
                BLTZALWrite <= '0';   
            when s7 =>
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "0000";
                IRWrite <= '0';
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= "000";
                ALUOp <= "0000";
                PCSource <= "00";  
                
                if (opcode = "000000") then -- R type
                    RegDst <= "01";
                else -- I type
                    RegDst <= "00";
                end if;
                BLTZALWrite <= '0';   
                
            when s8 => -- BNE
                PCWriteCond <= '1';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "0000";
                IRWrite <= '0';
                RegDst <= "00";
                RegWrite <= '0';
                ALUSrcA <= '1';
                ALUSrcB <= "000";
                ALUOp <= "0110";
                PCSource <= "01"; 
                BLTZALWrite <= '0';   
                
            when s9 =>
                PCWriteCond <= '0';
                PCWrite <= '1';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "0000";
                IRWrite <= '0';
                RegDst <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "000";
                ALUOp <= "0000";
                
                if (opcode = "000000") then -- JR
                    PCSource <= "11"; 
                else -- J
                    PCSource <= "10"; 
                end if;
                BLTZALWrite <= '0';   
            when s10 =>
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "0000";
                IRWrite <= '0';
                RegDst <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "000";
                ALUOp <= "0000";
                PCSource <= "00";
                BLTZALWrite <= '0';   
                
            when s11 =>
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "0101";
                IRWrite <= '0';
                RegDst <= "01";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= "000";
                ALUOp <= "0000";
                PCSource <= "00"; 
                BLTZALWrite <= '0';   
                
            when s12 =>
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "0000";
                IRWrite <= '0';
                RegDst <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= "000";
                ALUOp <= "0000";
                PCSource <= "00"; 
                MultRst <= '0';
                BLTZALWrite <= '0';   
            when s13 =>
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "0110";
                IRWrite <= '0';
                RegDst <= "01";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= "000";
                ALUOp <= "0000";
                PCSource <= "00"; 
                BLTZALWrite <= '0';   
            when s14 =>
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "0111";
                IRWrite <= '0';
                RegDst <= "01";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= "000";
                ALUOp <= "0000";
                PCSource <= "00"; 
                BLTZALWrite <= '0';   
            when s15 =>
                PCWriteCond <= '0';
                PCWrite <= '0';
                IorD <= '0';
                MemWrite <= '0';
                MemtoReg <= "1000";
                IRWrite <= '0';
                RegDst <= "10";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= "000";
                ALUOp <= "0000";
                PCSource <= "01"; 
                BLTZALWrite <= '1';   
                
        end case;
    end process;
  

end Behavioral;
