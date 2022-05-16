library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Unit is
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
        en : OUT std_logic;
        prod_en : OUT std_logic
        );
end Control_Unit;

architecture Behavioral of Control_Unit is
    
    type state is (S0, S1, S2);
    signal pr_state, nx_state: state;
    
    signal w : std_logic;
    

begin

    w <= multiplier_in(0);
    sin <= '0';
    
    process (rst, clk)
    begin
        if (rst = '1') then
            pr_state <= S0;
        elsif (rising_edge(clk)) then
            pr_state <= nx_state;
        end if;
    end process;
    
    process (w, counter_in, pr_state)
    begin
        case pr_state is
            when S0 =>
                if (w = '1') then
                    nx_state <= S1;
                else
                    nx_state <= S2;
                end if;
            when S1 =>
                if (w = '1' AND counter_in <= "100000") then
                    nx_state <= S1;
                elsif (w = '0' AND counter_in <= "100000") then
                    nx_state <= S2;
                end if;
            when S2 =>
                if (w = '1' AND counter_in <= "100000") then
                    nx_state <= S1;
                elsif (w = '0' AND counter_in <= "100000") then
                    nx_state <= S2;
                end if;
        end case;    
    end process;
    
    process (pr_state, w, counter_in)
    begin
        if pr_state = S0 then
            load <= '1';
            en <= '1';
            prod_en <= '0';
            done_out <= '0';
        elsif pr_state = S1 then
            if (w = '1' AND counter_in <= "100000") then
                load <= '0';
                en <= '1';
                prod_en <= '1';
                done_out <= '0';
            elsif (w = '0' AND counter_in <= "100000") then
                load <= '0';
                en <= '1';
                prod_en <= '0';
                done_out <= '0';
            else
                load <= '0';
                en <= '0';
                prod_en <= '0';
                done_out <= '1';
            end if;

        elsif pr_state = S2 then
            if (w = '1' AND counter_in <= "100000") then
                load <= '0';
                en <= '1';
                prod_en <= '1';
                done_out <= '0';
            elsif (w = '0' AND counter_in <= "100000") then
                load <= '0';
                en <= '1';
                prod_en <= '0';
                done_out <= '0';
            else
                load <= '0';
                en <= '0';
                prod_en <= '0';
                done_out <= '1';
            end if;
        end if;  
    end process;


end Behavioral;
