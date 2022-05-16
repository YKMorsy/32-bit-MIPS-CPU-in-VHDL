library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity genReg is
    GENERIC(
        N : Integer := 5);
    PORT( 
      clk : in std_logic;
      rst : in std_logic;
      EN : in std_logic;
      D : in std_logic_vector(N-1 downto 0);
      Q : out std_logic_vector(N-1 downto 0)
    );
end genReg;

architecture Behavioral of genReg is

begin
     CLKD : process(clk, rst)
     begin
        if(rst = '1') then
           Q <= (others => '0');
        elsif(clk'event AND clk = '1') then
            if(En = '1') then
                Q <= D;
            end if;
        end if;
     end process CLKD;
end Behavioral;
