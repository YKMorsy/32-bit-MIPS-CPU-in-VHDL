library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MultTop is
    GENERIC(
        N : Integer := 64);
    PORT(
        A : IN STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        done : OUT STD_LOGIC;
        
        R : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );
end MultTop;

architecture Structural of MultTop is
    -- Declare component
    COMPONENT R_Shift_Reg IS
        GENERIC (
            N : positive := 32);
        PORT (
            D : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
            Sin : IN STD_LOGIC;  
            Load : IN STD_LOGIC; 
            EN : IN STD_LOGIC;
            clk : IN std_logic;
            rst : IN std_logic;
            Q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT L_Shift_Reg IS
        GENERIC (
            N : positive := 64);
        PORT (
            D : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
            Sin : IN STD_LOGIC;  
            Load : IN STD_LOGIC; 
            EN : IN STD_LOGIC;
            clk : IN std_logic;
            rst : IN std_logic;
            Q : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT Adder IS
    GENERIC(
        N : positive := 64);
    PORT(
        A : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        S : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT Register_Asynch IS
    GENERIC (
        N : positive := 64);
    PORT( 
        clk : IN std_logic;
        D   : IN std_logic_vector(N-1 downto 0);
        EN  : IN std_logic;
        rst : IN std_logic;
        Q   : OUT std_logic_vector(N-1 downto 0)
    );
    END COMPONENT;
    
    COMPONENT Counter IS
    GENERIC(
        N : Integer := 5);
    PORT(
        clk, rst, en : IN STD_LOGIC;
        out_count : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT Control_Unit IS
    GENERIC(
        N : Integer := 32);
    PORT(
        multiplier_in : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        counter_in : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        rst : IN std_logic;
        clk : IN std_logic;
        
        sin : OUT std_logic;
        load : OUT std_logic;
        done_out : OUT std_logic;
        prod_en : OUT std_logic;
        en : OUT std_logic
        );
    END COMPONENT;
    
    -- Intermediate signals
    signal sin_interm : std_logic;
    signal load_interm : std_logic;
    signal en_interm : std_logic;
    signal en_add_interm : std_logic;
    signal en_prod_interm : std_logic;
    signal Q_multiplier_interm : std_logic_vector((N/2)-1 downto 0);
    signal Q_multiplicand_interm : std_logic_vector(N-1 downto 0);
    signal product_out_interm : std_logic_vector(N-1 downto 0);
    signal product_in_interm : std_logic_vector(N-1 downto 0);
    signal count_out_interm : std_logic_vector(5 downto 0);
    
begin

    RShift : R_Shift_Reg 
    GENERIC MAP (
        N => N/2
    )
    PORT MAP (
        D => B,
        Sin => sin_interm, 
        Load => load_interm,
        EN => en_interm,
        clk => clk,
        rst => rst,
        Q => Q_multiplier_interm
    );
       
    LShift : L_Shift_Reg 
    GENERIC MAP (
        N => N
    )
    PORT MAP (
        D((N/2)-1 DOWNTO 0) => A,
        D(N-1 DOWNTO (N/2)) => x"00000000",
        Sin => sin_interm, 
        Load => load_interm,
        EN => en_interm,
        clk => clk,
        rst => rst,
        Q => Q_multiplicand_interm
    );
    
    Adder_1 : Adder 
    GENERIC MAP (
        N => N
    )
    PORT MAP (
        A => Q_multiplicand_interm,
        B => product_out_interm,
        S => product_in_interm
    );
    
    product : Register_Asynch 
    GENERIC MAP (
        N => N
    )
    PORT MAP (
        clk => clk,
        D => product_in_interm,
        EN => en_prod_interm,
        rst => rst,
        Q => product_out_interm
    );
    
    counter_1 : Counter 
    GENERIC MAP (
        N => 6
    )
    PORT MAP (
        clk => clk,
        rst => rst,
        en => en_interm,
        out_count => count_out_interm
    );
    
    controller : Control_Unit 
    GENERIC MAP (
        N => N/2
    )
    PORT MAP(
        multiplier_in => Q_multiplier_interm,
        counter_in => count_out_interm,
        rst => rst,
        clk => clk,
        sin => sin_interm,
        load => load_interm,
        done_out => done,
        prod_en => en_prod_interm,
        en => en_interm
    );
    
    R <= product_out_interm;

end Structural;
