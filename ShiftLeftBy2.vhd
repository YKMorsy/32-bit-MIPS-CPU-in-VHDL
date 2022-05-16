library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftLeftBy2 is
    GENERIC(
        N : Integer := 32);
    PORT(
        D : in std_logic_vector(N-1 downto 0);
        Q : out std_logic_vector(N-1 downto 0)
    );
end ShiftLeftBy2;

architecture Behavioral of ShiftLeftBy2 is
begin
    
    Q <= D(N-3 downto 0) & "00";

end Behavioral;
