library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Shift_Unit is
    GENERIC (
        WIDTH : positive := 32
    );
    PORT (
        A : in std_logic_vector(WIDTH-1 downto 0);
        ALUOp : in std_logic_vector(3 downto 0);
        SHAMT : in std_logic_vector (4 downto 0);
        ShiftR : out std_logic_vector(WIDTH-1 downto 0)
    );
end Shift_Unit;

architecture Behavioral of Shift_Unit is

    -- Intermediate signal for split input signals
    SIGNAL ALUOp_Split : std_logic_vector(1 downto 0);

    -- Intermediate signal for bit shifts
    SIGNAL L_0 : STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    SIGNAL L_1 : STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    SIGNAL L_2 : STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    SIGNAL L_3 : STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    SIGNAL L_4 : STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
    
    -- Fill signal for arithmetic right shifts
    SIGNAL Fill : STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);

begin
    
    ALUOp_Split <= ALUOp(1 downto 0);
    
    -- Fill value using MSB of A depending on ALUOp
    Fill <= (others => ALUOp_Split(0) and A(31));

    L_0 <= (A(WIDTH-2 downto 0) & '0') WHEN SHAMT(0) = '1' AND (ALUOp_Split(1) = '0') ELSE -- Left shift for logical left shift and arithmetic left shift    
           (Fill(0) & A(WIDTH-1 downto 1)) WHEN SHAMT(0) = '1' AND (ALUOp_Split(1) = '1') ELSE -- Right shift for logical or arithmetic right shift using fill value 
            A;
    L_1 <= (L_0(WIDTH-3 downto 0) & "00") WHEN SHAMT(1) = '1' AND (ALUOp_Split(1) = '0') ELSE
           (Fill(1 downto 0) & L_0(WIDTH-1 downto 2)) WHEN SHAMT(1) = '1' AND (ALUOp_Split(1) = '1') ELSE 
            L_0;        
    L_2 <= (L_1(WIDTH-5 downto 0) & "0000") WHEN SHAMT(2) = '1' AND (ALUOp_Split(1) = '0') ELSE
           (Fill(3 downto 0) & L_1(WIDTH-1 downto 4)) WHEN SHAMT(2) = '1' AND (ALUOp_Split(1) = '1') ELSE 
            L_1;
    L_3 <= (L_2(WIDTH-9 downto 0) & "00000000") WHEN SHAMT(3) = '1' AND (ALUOp_Split(1) = '0') ELSE
           (Fill(7 downto 0) & L_2(WIDTH-1 downto 8)) WHEN SHAMT(3) = '1' AND (ALUOp_Split(1) = '1') ELSE 
            L_2;
    L_4 <= (L_3(WIDTH-17 downto 0) & "0000000000000000") WHEN SHAMT(4) = '1' AND (ALUOp_Split(1) = '0') ELSE
           (Fill(15 downto 0) & L_3(WIDTH-1 downto 16)) WHEN SHAMT(4) = '1' AND (ALUOp_Split(1) = '1') ELSE 
            L_3;        
    ShiftR <= L_4;
    
end Behavioral;
