library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Register_File is
   PORT( 
      r1 : in std_logic_vector(4 downto 0); -- Register 1 (address)
      r2 : in std_logic_vector(4 downto 0); -- Register 2 (address)
      wr : in std_logic_vector(4 downto 0); -- Write register address
      wd : in std_logic_vector(31 downto 0); -- Data to write to register
      
      regwrite : in std_logic; -- Control signal to write to register
      clk : in std_logic;
      rst : in std_logic;

      d1 : out std_logic_vector(31 downto 0); -- Output 
      d2 : out std_logic_vector(31 downto 0)
   );
end Register_File;

architecture Behavioral of Register_File is
  type arr is array(31 downto 0) of std_logic_vector(31 downto 0);  
  signal regArr : arr := (OTHERS => "00000000000000000000000000000000");
begin
     process(clk, rst, r1, r2, wr, wd)
     begin
        if(rst = '1') then
        
            d1 <= x"00000000";
            d2 <= x"00000000";     
           
            for i in 0 to 31 loop
                regArr(i) <= x"00000000";
            end loop;     
           
        else
        
            d1 <= regArr(to_integer(unsigned(r1)));
            d2 <= regArr(to_integer(unsigned(r2)));
           
          
            if regwrite = '1' and (clk'EVENT AND clk = '1') then
                regArr(to_integer(unsigned(wr))) <= wd;  -- Write
            end if;
            
        end if;
     end process;
end Behavioral;
