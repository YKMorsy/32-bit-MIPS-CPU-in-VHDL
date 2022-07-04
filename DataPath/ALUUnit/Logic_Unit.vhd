library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Logical_Unit is
    GENERIC (
        WIDTH : positive := 32
    );
    
    PORT (
    A : in std_logic_vector(WIDTH-1 downto 0);
    B : in std_logic_vector(WIDTH-1 downto 0);
    ALUOp : in std_logic_vector(3 downto 0);
    LogicalR : out std_logic_vector(WIDTH-1 downto 0)
    );
end Logical_Unit;

architecture Behavioral of Logical_Unit is

    -- Intermediate signal for split input signals
    SIGNAL ALUOp_Split : std_logic_vector(1 downto 0);
    
begin

    ALUOp_Split <= ALUOp(1 downto 0);
    
    --Select command depending on OP
    LogicalR <= A AND B WHEN ALUOp_Split = "00" ELSE
                A OR B WHEN ALUOp_Split = "01" ELSE
                A XOR B WHEN ALUOp_Split = "10" ELSE
                A NOR B; 
end Behavioral;
