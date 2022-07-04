library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_2_IN is
    GENERIC(
        N : Integer := 5);
    PORT(
        sel : in std_logic;
        in1 : in std_logic_vector(N-1 downto 0);
        in2 : in std_logic_vector(N-1 downto 0);
        output : out std_logic_vector(N-1 downto 0)
    );
end MUX_2_IN;

architecture Behavioral of MUX_2_IN is

begin
    output <= in1 when (sel = '0') else
              in2 when (sel = '1');
end Behavioral;
