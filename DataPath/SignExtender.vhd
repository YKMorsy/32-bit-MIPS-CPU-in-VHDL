library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignExtender is
    PORT(
      D : in std_logic_vector(15 downto 0);
      Q : out std_logic_vector(31 downto 0)
    );
end SignExtender;

architecture Behavioral of SignExtender is
    signal extension : std_logic_vector(15 DOWNTO 0);
begin   
    
    extension <= (others => D(15));  -- sign extend
    
    Q <= extension & D;
    
end Behavioral;
