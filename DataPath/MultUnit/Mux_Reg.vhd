library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_Reg is
    PORT( 
        clk : IN std_logic;
        D   : IN std_logic;
        EN  : IN std_logic;
        Load : IN std_logic;
        rst : IN std_logic;
        Sin : IN std_logic;
        Q   : OUT std_logic
   );
end Mux_Reg;

ARCHITECTURE Behavioral of Mux_Reg is
BEGIN
     CLKD : process(clk, rst)
        Variable D_in: STD_LOGIC;
     begin
        if(rst = '1') then
           Q <= '0';
        elsif(clk'event AND clk = '1') then
            if(Load = '1') then
                D_in := D;
            else
                D_in := Sin;
            end if;
            if(En = '1') then
                Q <= D_in;
            end if;
        end if;
     end process CLKD;
END ARCHITECTURE;
