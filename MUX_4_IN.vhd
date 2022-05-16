library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_4_IN is
    GENERIC(
        N : Integer := 32);
    PORT(
        sel : in std_logic_vector(1 downto 0);
        in1 : in std_logic_vector(N-1 downto 0);
        in2 : in std_logic_vector(N-1 downto 0);
        in3 : in std_logic_vector(N-1 downto 0);
        in4 : in std_logic_vector(N-1 downto 0);
        output : out std_logic_vector(N-1 downto 0)
    );
end MUX_4_IN;

architecture Behavioral of MUX_4_IN is

begin
    output <= in1 when (sel = "00") else
              in2 when (sel = "01") else
              in3 when (sel = "10") else
              in4;
end Behavioral;
