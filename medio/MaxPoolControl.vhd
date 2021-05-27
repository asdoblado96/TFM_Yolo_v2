LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--Bloque de control para el MaxPooling

ENTITY MaxPoolControl IS
    GENERIC (
        Layer : INTEGER
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        validIn : IN STD_LOGIC;

        val_d1 : OUT STD_LOGIC;
        enLBuffer : OUT STD_LOGIC;

        validOut : OUT STD_LOGIC
    );

END MaxPoolControl;

ARCHITECTURE rtl OF MaxPoolControl IS

    CONSTANT rst_val : STD_LOGIC := '0';

    CONSTANT Hc : INTEGER := columns(layer);
    CONSTANT F : INTEGER := filters(layer);
    CONSTANT K : INTEGER := kernels(layer);

    SIGNAL count_col : unsigned(bits(Hc - 1) - 1 DOWNTO 0);
    SIGNAL count_ch : unsigned(bits(F/K - 1) - 1 DOWNTO 0);

    SIGNAL col_odd : STD_LOGIC;
    SIGNAL row_odd : STD_LOGIC;

BEGIN

    clk_proc : PROCESS (clk, reset)
    BEGIN

        IF reset = rst_val THEN

            col_odd <= '1';
            row_odd <= '1';

            count_col <= (OTHERS => '0');
            count_ch <= (OTHERS => '0');

        ELSIF rising_edge(clk) THEN

            IF validIn = '1' THEN
                col_odd <= NOT(col_odd);
                count_col <= count_col + 1;
                IF count_col = to_unsigned(Hc - 1, bits(Hc - 1)) THEN --final de fila
                    col_odd <= '1';
                    count_col <= (OTHERS => '0');
                    count_ch <= count_ch + 1;
                    IF count_ch = to_unsigned((F/K) - 1, bits(F/K - 1)) THEN --final del "canal" (realmente es el resultado de un filtro, o sea, el canal de la siguiente etapa)
                        count_ch <= (OTHERS => '0');
                        row_odd <= NOT(row_odd);
                    END IF;
                END IF;
            END IF;
        END IF;

    END PROCESS clk_proc;

    comb_proc : PROCESS (validIn, col_odd, row_odd, count_col)
    BEGIN

        IF validIn = '1' THEN
            val_d1 <= '1'; -- si el dato es valido se registra
            validOut <= (col_odd NOR row_odd);-- un dato es valido cuando es fila y columna par
            enLBuffer <= NOT(col_odd); --cada dos datos se registra uno en LB
        ELSE
            val_d1 <= '0';
            validOut <= '0';
            enLBuffer <= '0';
        END IF;
    END PROCESS comb_proc;
END ARCHITECTURE rtl;