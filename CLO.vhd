library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CLO is
    GENERIC(
        N : Integer := 32);
    PORT( 
      D : in std_logic_vector(N-1 downto 0);
      Q : out std_logic_vector(N-1 downto 0)
    );
end CLO;

architecture Behavioral of CLO is
begin
    
    process(D)
    variable count : unsigned(N-1 downto 0) := "00000000000000000000000000000000";
    begin
    
        count := "00000000000000000000000000000000";
        
        for i in 0 to 31 loop -- Loop to count leading ones, exit when encounter 0
            if(D(31-i) = '1') then
                count := count + 1;
            else
                exit;
            end if;
        end loop;
        
        Q <= std_logic_vector(count);
        
    end process;

end Behavioral;
