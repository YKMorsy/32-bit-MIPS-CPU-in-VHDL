library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity CPU is
   PORT( 
      Reset : in std_logic;
      Clock : in std_logic;
      
      MemoryDataIn : in std_logic_vector(31 downto 0);
      
      MemoryAddress : out std_logic_vector(31 downto 0);
      MemoryDataOut : out std_logic_vector(31 downto 0);
      MemWrite : out std_logic
    );
end CPU;

architecture Structural of CPU is

    -- Declare components
    COMPONENT Control IS
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
            
            opCode : in std_logic_vector(5 downto 0); -- Mapped to control
            ALUControlOP : in std_logic_vector(5 downto 0);
            done : in std_logic
        );
    END COMPONENT;
    
    COMPONENT DataPath IS
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
            
            opCode : out std_logic_vector(5 downto 0); -- Mapped to control
            ALUControlOP : out std_logic_vector(5 downto 0);
            
            -- signal to memory
            Address : out std_logic_vector(31 downto 0);
            writeData : out std_logic_vector (31 downto 0);
            done : out std_logic -- Important in mult control
      );
    END COMPONENT;
    
    -- Intermediate Signals
    signal PCWriteCond : std_logic;
    signal PCWrite : std_logic;
    signal IorD : std_logic;
    signal MemtoReg : std_logic_vector(3 downto 0);
    signal IRWrite : std_logic;
    signal PCSource : std_logic_vector(1 downto 0);
    signal ALUOp : std_logic_vector(3 downto 0);
    signal ALUSrcB : std_logic_vector(2 downto 0);
    signal ALUSrcA : std_logic;
    signal RegWrite : std_logic;
    signal RegDst : std_logic_vector(1 downto 0);
    signal MultRst : std_logic;
    signal BLTZALWrite : std_logic;
    signal opCode : std_logic_vector(5 downto 0);
    signal ALUControlOP : std_logic_vector(5 downto 0);
    
    signal MemWriteInterm : std_logic;
    signal shiftVal : std_logic;
    
    signal done : std_logic;
    signal rstMult : std_logic;

begin

    ControlUnit : Control PORT MAP (clk => Clock, rst => Reset, PCWriteCond => PCWriteCond, PCWrite => PCWrite, IorD => IorD, shiftVal => shiftVal,
                                    MemWrite => MemWriteInterm, MemtoReg => MemtoReg, IRWrite => IRWrite, PCSource => PCSource, BLTZALWrite => BLTZALWrite,
                                    ALUOp => ALUOp, ALUSrcB => ALUSrcB, ALUSrcA => ALUSrcA, RegWrite => RegWrite, RegDst => RegDst, 
                                    MultRst => MultRst, opCode => opCode, ALUControlOP => ALUControlOP, done => done);
                                    
    DP : DataPath PORT MAP (clk => Clock, rst => Reset, PCWriteCond => PCWriteCond, PCWrite => PCWrite, IorD => IorD, shiftVal => shiftVal,
                                    MemWrite => MemWriteInterm, MemtoReg => MemtoReg, IRWrite => IRWrite, PCSource => PCSource, MemData => MemoryDataIn,
                                    ALUOp => ALUOp, ALUSrcB => ALUSrcB, ALUSrcA => ALUSrcA, RegWrite => RegWrite, RegDst => RegDst, BLTZALWrite => BLTZALWrite,
                                    MultRst => MultRst, opCode => opCode, ALUControlOP => ALUControlOP, Address => MemoryAddress, writeData => MemoryDataOut, done => done);
                                    
   MemWrite <= MemWriteInterm;
    
end Structural;
