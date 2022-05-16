library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder is
    GENERIC(
        N : Integer := 64);
    PORT(
        A : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        S : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );
end Adder;

architecture Structural of Adder is
    SIGNAL cin_x : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    SIGNAL b_xor_k : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    COMPONENT Full_adder
        PORT (  x   :   IN  STD_LOGIC;
                y   :   IN  STD_LOGIC;
                cin   :   IN  STD_LOGIC;
                s   :   OUT  STD_LOGIC;
                cout   :   OUT  STD_LOGIC   );
    END COMPONENT;
begin
    
    b_xor_k(0) <= B(0) XOR '0';
    AddSub0 : Full_adder PORT MAP (
                                    x => A(0),
                                    y => b_xor_k(0),
                                    cin => '0',
                                    s => S(0),
                                    cout => cin_x(0)
                                   );
                                   
    G1: FOR i IN 1 TO N-1 GENERATE
    b_xor_k(i) <= B(i) XOR '0';
    AddSubs : Full_adder PORT MAP (
                                    x => A(i),
                                    y => b_xor_k(i),
                                    cin => cin_x(i-1),
                                    s => S(i),
                                    cout => cin_x(i)
                                   );
    END GENERATE;
    
end Structural;
