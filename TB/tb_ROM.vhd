LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY L1BNROM_tb IS
END;

ARCHITECTURE bench OF L1BNROM_tb IS

    COMPONENT L8WROM
        PORT (
            weight : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            address : IN unsigned(3 DOWNTO 0));
    END COMPONENT;

    SIGNAL weight : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL address : unsigned(3 DOWNTO 0);

BEGIN

    uut : L8WROM PORT MAP(
        weight => weight,
        address => address);

    stimulus : PROCESS
    BEGIN

        address <= "0000";
        WAIT FOR 10 ns;
        address <= "0001";

        WAIT;
    END PROCESS;
END;