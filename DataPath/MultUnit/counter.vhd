library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
    GENERIC(
        N : Integer := 6);
    PORT(
        clk, rst, en : IN STD_LOGIC;
        out_count : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
        );
end counter;

architecture Behavioral of counter is
    signal count : std_logic_vector(N-1 downto 0);
begin
    process (clk, rst)
    begin
        if rst = '1' then
            count <= "000000";
        elsif (clk'EVENT AND clk = '1') then
            if (en = '1') then
                count <= count + 1;
             end if;
        end if;
    
    end process;
    
    out_count <= count;

end Behavioral;
