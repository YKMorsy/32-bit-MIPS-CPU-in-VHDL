library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Splitter is
    GENERIC(
        N : Integer := 64);
    PORT(
        Input : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Out_0 : OUT STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);
        Out_1 : OUT STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0)
        );
end Splitter;

architecture Behavioral of Splitter is
begin

    Out_0 <= Input(N-1 DOWNTO N/2);
    Out_1 <= Input((N/2)-1 DOWNTO 0);

end Behavioral;
