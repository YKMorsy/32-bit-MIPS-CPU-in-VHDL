library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Full_Adder is
    PORT (  x   :   IN  STD_LOGIC;
            y   :   IN  STD_LOGIC;
            cin   :   IN  STD_LOGIC;
            s   :   OUT  STD_LOGIC;
            cout   :   OUT  STD_LOGIC   );
end Full_Adder;

architecture Full_Adder_Dataflow of Full_Adder is
begin
--    process (en)
--    begin
--        if en = '1' then
            s <= (x XOR y XOR cin);
            cout <= ((x AND y) OR (cin AND x) OR (cin AND y));
--        end if;
--    end process;
end Full_Adder_Dataflow;
