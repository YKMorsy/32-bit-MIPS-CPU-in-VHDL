library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
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
end ALU;

architecture Structural of ALU is
    -- Declare component
    COMPONENT Logical_Unit IS
        GENERIC (
            WIDTH : positive := 32
        );
        
        PORT (
            A : in std_logic_vector(WIDTH-1 downto 0);
            B : in std_logic_vector(WIDTH-1 downto 0);
            ALUOp : in std_logic_vector(3 downto 0);
            LogicalR : out std_logic_vector(WIDTH-1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT Shift_Unit IS
        GENERIC (
            WIDTH : positive := 32
        );
        
        PORT (
            A : in std_logic_vector(WIDTH-1 downto 0);
            ALUOp : in std_logic_vector(3 downto 0);
            SHAMT : in std_logic_vector (4 downto 0);
            ShiftR : out std_logic_vector(WIDTH-1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT Comp_Unit IS
        GENERIC (
            WIDTH : positive := 32
        );
        PORT (
            A : in std_logic_vector(WIDTH-1 downto 0);
            B : in std_logic_vector(WIDTH-1 downto 0);
            ArithR : in std_logic_vector(WIDTH-1 downto 0);
            Carryout : in std_logic;
            ALUOp : in std_logic_vector(3 downto 0);
            CompR : out std_logic_vector(WIDTH-1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT Arith_Unit IS
        GENERIC (
          n       : positive := 32);
        PORT( 
          A       : IN     std_logic_vector (n-1 DOWNTO 0);
          B       : IN     std_logic_vector (n-1 DOWNTO 0);
          C_op    : IN     std_logic_vector (1 DOWNTO 0);
          CO      : OUT    std_logic;
          OFL     : OUT    std_logic;
          S       : OUT    std_logic_vector (n-1 DOWNTO 0);
          Z       : OUT    std_logic
        );
    END COMPONENT;
    
    -- Signals that will be mapped
    signal ArithR : std_logic_vector(WIDTH-1 downto 0);
    signal Carryout : std_logic;
    signal LogicalR : std_logic_vector(WIDTH-1 downto 0);
    signal CompR : std_logic_vector(WIDTH-1 downto 0);
    signal ShiftR : std_logic_vector(WIDTH-1 downto 0);
    signal z : std_logic;
    signal OFL : std_logic;
    
begin

    -- Mapping
    LU : Logical_Unit
    GENERIC map (
        WIDTH => WIDTH
    )
    port map (
      A => A,
      B => B,
      ALUOp => ALUOp,
      LogicalR => LogicalR);
      
    SU : Shift_Unit
    GENERIC map (
        WIDTH => WIDTH
    )
    port map (
      A => B, --- Changed from A=>B to work in MIPS-32 CPU
      ALUOp => ALUOp,
      SHAMT => SHAMT,
      ShiftR => ShiftR);
      
    CU : Comp_Unit
    GENERIC map (
        WIDTH => WIDTH
    )
    port map (
      A => A,
      B => B,
      ArithR => ArithR,
      Carryout => Carryout,
      ALUOp => ALUOp,
      CompR => CompR);
      
    AU : Arith_Unit
    GENERIC map (
        n => WIDTH
    )
    port map (
      A => A,
      B => B,
      C_op => ALUOp(1 downto 0),
      CO => Carryout,
      OFL => OFL,
      S => ArithR,
      z => z);
      
    -- Set result depending on ALUOp  
    R <= LogicalR WHEN ALUOp(3 downto 2) = "00" ELSE    
         ArithR WHEN ALUOp(3 downto 2) = "01" ELSE
         CompR WHEN ALUOp(3 downto 2) = "10" ELSE
         ShiftR;
         
    -- Set overflow and zero depending on ALUOp
    Zero <= z WHEN ALUOp(3 downto 2) = "01";
    Overflow <= OFL WHEN ALUOp(3 downto 2) = "01";
      
end Structural;
