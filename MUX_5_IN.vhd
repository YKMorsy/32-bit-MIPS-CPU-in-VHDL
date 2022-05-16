library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_5_IN is
    GENERIC(
        N : Integer := 32);
    PORT(
        sel : in std_logic_vector(2 downto 0);
        in1 : in std_logic_vector(N-1 downto 0);
        in2 : in std_logic_vector(N-1 downto 0);
        in3 : in std_logic_vector(N-1 downto 0);
        in4 : in std_logic_vector(N-1 downto 0);
        in5 : in std_logic_vector(N-1 downto 0);
        output : out std_logic_vector(N-1 downto 0)
    );
end MUX_5_IN;

architecture Behavioral of MUX_5_IN is
begin
    output <= in1 when (sel = "000") else
              in2 when (sel = "001") else
              in3 when (sel = "010") else
              in4 when (sel = "011") else
              in5;
end Behavioral;
