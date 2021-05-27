LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY HA IS
    PORT (
        in_b1 : IN STD_LOGIC;
        in_b2 : IN STD_LOGIC;
        S : OUT STD_LOGIC;
        Cout : OUT STD_LOGIC
    );
END HA;

ARCHITECTURE rtl OF HA IS
BEGIN

    S <= in_b1 XOR in_b2;
    Cout <= in_b1 AND in_b2;
    
END rtl;