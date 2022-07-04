library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY Register_Asynch IS
    GENERIC (
        N : positive := 64
    );
    PORT( 
        clk : IN std_logic;
        D   : IN std_logic_vector(N-1 downto 0);
        EN  : IN std_logic;
        rst : IN std_logic;
        Q   : OUT std_logic_vector(N-1 downto 0)
   );
END Register_Asynch ;

ARCHITECTURE Behavioral OF Register_Asynch IS
BEGIN
     CLKD : process(clk, rst)
     begin
        if(rst = '1') then
           Q <= x"0000000000000000";
        elsif(clk'event AND clk = '1') then
           if(EN = '1') then
              Q <= D;
           end if;
        end if;
     end process CLKD;
END ARCHITECTURE;
