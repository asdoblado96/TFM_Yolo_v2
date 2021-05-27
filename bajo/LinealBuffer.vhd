LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LinealBuffer IS
    GENERIC (
        BL : INTEGER := 1;-- Buffer Length
        WL : INTEGER := 1-- Word Length
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable_LBuffer : IN STD_LOGIC;
        datain : IN STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR((WL - 1) DOWNTO 0)
    );
END ENTITY LinealBuffer;

ARCHITECTURE rtl OF LinealBuffer IS
    TYPE mem_t IS ARRAY(0 TO (BL - 1)) OF STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);

    SIGNAL content_LB : mem_t;
    CONSTANT res_val : STD_LOGIC := '0';

BEGIN

    moving : PROCESS (reset, clk)
    BEGIN
        IF reset = res_val THEN

            content_LB <= (OTHERS => (OTHERS => '0'));
            dataout <= (OTHERS => '0');

        ELSIF rising_edge(clk) THEN
            IF (enable_LBuffer = '1') THEN

                FOR I IN 0 TO (BL - 2) LOOP
                    content_LB((BL - 1) - I) <= content_LB((BL - 1) - (I + 1));
                END LOOP;

                content_LB(0) <= datain;
                dataout <=content_LB(BL - 1);

            END IF;
        END IF;

    END PROCESS moving;

END ARCHITECTURE rtl;