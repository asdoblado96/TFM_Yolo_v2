LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY signedInverse IS
    GENERIC (N : INTEGER:=6);
    PORT (
        datain : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        Weights : IN STD_LOGIC;
        dataout : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
END ENTITY signedInverse;

ARCHITECTURE rtl OF signedInverse IS

    SIGNAL s_input : signed(N-1 DOWNTO 0);
    SIGNAL s_output : signed(N-1 DOWNTO 0);

BEGIN

    s_input <= signed(datain);

    MUX : PROCESS (Weights, s_input)
    BEGIN

        CASE Weights IS
            WHEN '1' => --si el peso es 1 la salida es tal cual
                s_output <= s_input;
            WHEN OTHERS => --sino la salida es negada en C2
                s_output <= NOT(s_input) + 1;
        END CASE;

    END PROCESS MUX;

    dataout <= STD_LOGIC_VECTOR(s_output);

END ARCHITECTURE rtl;