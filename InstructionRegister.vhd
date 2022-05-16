library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity InstructionRegister is
    PORT( 
      clk : in std_logic;
      rst : in std_logic;
      EN : in std_logic;
      D : in std_logic_vector(31 downto 0);
      Q1 : out std_logic_vector(5 downto 0);
      Q2 : out std_logic_vector(4 downto 0);
      Q3 : out std_logic_vector(4 downto 0);
      Q4 : out std_logic_vector(15 downto 0)
    );
end InstructionRegister;

architecture Behavioral of InstructionRegister is

begin

     CLKD : process(clk, rst)
     begin
        if(rst = '1') then
           Q1 <= "000000";
           Q2 <= "00000";
           Q3 <= "00000";
           Q4 <= x"0000";
        elsif(clk'event AND clk = '1') then
            if(En = '1') then
                Q1 <= D(31 downto 26);
                Q2 <= D(25 downto 21);
                Q3 <= D(20 downto 16);
                Q4 <= D(15 downto 0);
            end if;
        end if;
     end process CLKD;

end Behavioral;
