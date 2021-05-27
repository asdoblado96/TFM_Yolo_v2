LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LeakyReLU IS
    PORT (
        datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY LeakyReLU;

ARCHITECTURE rtl OF LeakyReLU IS

BEGIN

    leaky : PROCESS (datain)
    BEGIN
        CASE datain(15) IS
            WHEN '0' => --si es positivo
                dataout <= datain; --salida tal cual

            WHEN OTHERS => -- si es negativo
                dataout <= datain(15) & datain(15) & datain(15) & datain(15 DOWNTO 3); --se multiplica x0.125
        END CASE;
    END PROCESS leaky;
END ARCHITECTURE rtl;