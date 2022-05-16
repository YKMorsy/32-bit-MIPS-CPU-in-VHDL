library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftLeftBy2Extend is
    GENERIC(
        N : Integer := 26);
    PORT(
        D : in std_logic_vector(N-1 downto 0);
        Q : out std_logic_vector(N+1 downto 0)
    );
end ShiftLeftBy2Extend;

architecture Behavioral of ShiftLeftBy2Extend is
begin
    
    Q <= D & "00";

end Behavioral;
