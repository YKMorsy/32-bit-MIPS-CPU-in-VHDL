library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_9_IN is
    GENERIC(
        N : Integer := 32);
    PORT(
        sel : in std_logic_vector(3 downto 0);
        in1 : in std_logic_vector(N-1 downto 0);
        in2 : in std_logic_vector(N-1 downto 0);
        in3 : in std_logic_vector(N-1 downto 0);
        in4 : in std_logic_vector(N-1 downto 0);
        in5 : in std_logic_vector(N-1 downto 0);
        in6 : in std_logic_vector(N-1 downto 0);
        in7 : in std_logic_vector(N-1 downto 0);
        in8 : in std_logic_vector(N-1 downto 0);
        in9 : in std_logic_vector(N-1 downto 0);
        output : out std_logic_vector(N-1 downto 0)
    );
end MUX_9_IN;

architecture Behavioral of MUX_9_IN is
begin
    output <= in1 when (sel = "0000") else
              in2 when (sel = "0001") else
              in3 when (sel = "0010") else
              in4 when (sel = "0011") else
              in5 when (sel = "0100") else
              in6 when (sel = "0101") else
              in7 when (sel = "0110") else
              in8 when (sel = "0111") else
              in9;
end Behavioral;
 