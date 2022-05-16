library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Comp_Unit is
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
end Comp_Unit;

architecture Behavioral of Comp_Unit is
    -- Intermediate signal for split input signals
    SIGNAL A_Split : STD_LOGIC;
    SIGNAL B_Split : STD_LOGIC;
    SIGNAL ArithR_Split : STD_LOGIC;
    SIGNAL ALUOp_Split : std_logic_vector(1 downto 0);
begin
    
    -- Split signals
    A_Split <= A(WIDTH-1);
    B_Split <= B(WIDTH-1);
    ArithR_Split <= ArithR(WIDTH-1);
    ALUOp_Split <= ALUOp(1 downto 0);
    
    -- Result based on comparison bit
    CompR <= (X"00000000") WHEN (ALUOp_split(1) = '0') ELSE 
             (X"00000000") WHEN (ALUOp_Split = "10" AND A_Split = '0' AND B_Split = '0' AND ArithR_Split = '0') ELSE 
             (X"00000000") WHEN (ALUOp_Split = "10" AND A_Split = '1' AND B_Split = '1' AND ArithR_Split = '0') ELSE  
             (X"00000000") WHEN (ALUOp_Split = "10" AND A_Split = '0' AND B_Split = '1') ELSE  
             (X"00000000") WHEN (ALUOp_Split = "11" AND Carryout = '1') ELSE  
             
             (X"00000001") WHEN (ALUOp_Split = "10" AND A_Split = '0' AND B_Split = '0' AND ArithR_Split = '1') ELSE 
             (X"00000001") WHEN (ALUOp_Split = "10" AND A_Split = '1' AND B_Split = '1' AND ArithR_Split = '1') ELSE  
             (X"00000001") WHEN (ALUOp_Split = "10" AND A_Split = '1' AND B_Split = '0') ELSE  
             (X"00000001");
            
end Behavioral;
