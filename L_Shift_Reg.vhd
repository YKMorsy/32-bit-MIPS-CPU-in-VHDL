library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity L_Shift_Reg is
    GENERIC(
        N : Integer := 64);
    PORT(
        D : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Sin : IN STD_LOGIC;  
        Load : IN STD_LOGIC; 
        EN : IN STD_LOGIC;
        clk : IN std_logic;
        rst : IN std_logic;
        Q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );
end L_Shift_Reg;

architecture Structural of L_Shift_Reg is
    COMPONENT Mux_Reg
        PORT (  clk : IN std_logic;
                D   : IN std_logic;
                EN  : IN std_logic;
                Load : IN std_logic;
                rst : IN std_logic;
                Sin : IN std_logic;
                Q   : OUT std_logic 
                );
    END COMPONENT;
    
    SIGNAL Q_interm : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
begin

    leftshift0 : Mux_Reg PORT MAP (
                                    clk => clk,
                                    D => D(0),
                                    EN => EN,
                                    Load => Load,
                                    rst => rst,
                                    Sin => '0',
                                    Q => Q_interm(0)
                                  );
                                   
    G: FOR i IN 1 TO N-1 GENERATE
    leftshift : Mux_Reg PORT MAP (
                                    clk => clk,
                                    D => D(i),
                                    EN => EN,
                                    Load => Load,
                                    rst => rst,
                                    Sin => Q_interm(i-1),
                                    Q => Q_interm(i)
                                  );
    END GENERATE;
    
   Q <= Q_interm;

end Structural;
