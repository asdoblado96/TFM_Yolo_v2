LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY RAM IS
    GENERIC (
        WL : INTEGER := 8; -- Word Length
        bitsAddress : INTEGER := 64);
    PORT (
        clk : IN STD_LOGIC;

        we : IN STD_LOGIC;

        Din : IN STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
        rAddr : IN unsigned(bitsAddress - 1 DOWNTO 0);
        wAddr : IN unsigned(bitsAddress - 1 DOWNTO 0);

        Dout : OUT STD_LOGIC_VECTOR(WL - 1 DOWNTO 0));
END RAM;
ARCHITECTURE arch OF RAM IS

    TYPE RAM_mem IS ARRAY (0 TO (2 ** bitsAddress) - 1) OF STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);

    SIGNAL RAM_content : RAM_mem;

BEGIN

    p_clk : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN


            IF WE = '1' THEN
                RAM_content(to_integer(unsigned(wAddr))) <= Din;
            END IF;

        END IF;
    END PROCESS;
    
                Dout <= RAM_content(to_integer(unsigned(rAddr)));

END arch;