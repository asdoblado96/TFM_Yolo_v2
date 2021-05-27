LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--Bloque de control para la convolucion

ENTITY ConvControl IS
    GENERIC (
        layer : INTEGER
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        validIn : IN STD_LOGIC;

        startLBuffer : OUT STD_LOGIC; --LB mux control
        enableLBuffer : OUT STD_LOGIC;--LB enable

        addressweight : OUT unsigned(weightsbitsAddress(LAYER) - 1 DOWNTO 0);
        addressbn : OUT unsigned(bits(filters(layer)/kernels(layer) - 1) - 1 DOWNTO 0);

        validOut : OUT STD_LOGIC
    );

END ConvControl;

ARCHITECTURE rtl OF ConvControl IS

    CONSTANT rst_val : STD_LOGIC := '0';

    --Constantes

    CONSTANT Hr : INTEGER := rows(layer);
    CONSTANT Hc : INTEGER := columns(layer);
    CONSTANT Ch : INTEGER := channels(layer);
    CONSTANT F : INTEGER := filters(layer);
    CONSTANT K : INTEGER := kernels(layer);

    --Contadores

    SIGNAL count_col : unsigned(bits(Hc - 1) - 1 DOWNTO 0);
    SIGNAL count_row : unsigned(bits(Hr - 1) - 1 DOWNTO 0);
    SIGNAL count_filters : unsigned(bits(F - 1) - 1 DOWNTO 0);
    SIGNAL count_ch : unsigned(bits(Ch - 1) - 1 DOWNTO 0);

    SIGNAL count_pushing : unsigned(bits(Hc - 1) - 1 DOWNTO 0);

    --Señales de control

    SIGNAL s_startLBuffer : STD_LOGIC;
    SIGNAL pushing : STD_LOGIC;

    --Direcciones de pesos
    SIGNAL sweightaddress : unsigned(weightsbitsAddress(LAYER) - 1 DOWNTO 0);
    SIGNAL sBNaddress : unsigned(bits(F/K - 1) - 1 DOWNTO 0);
BEGIN

    addressweight <= sweightaddress;
    addressbn <= sBNaddress;

    clk_proc : PROCESS (clk, reset)
    BEGIN
        IF reset = rst_val THEN

            --reset de direcciones
            sweightaddress <= (OTHERS => '0');
            sBNaddress <= (OTHERS => '0');

            --reset de contadores
            count_col <= (OTHERS => '1');
            count_row <= (OTHERS => '0');
            count_filters <= (OTHERS => '0');
            count_ch <= (OTHERS => '0');

            --reset de señales
            pushing <= '0';
            count_pushing <= (OTHERS => '0');

        ELSIF rising_edge(clk) THEN

            --si llega un dato aumentamos contadores
            IF validIn = '1' THEN
                count_col <= count_col + 1;
                IF count_col = to_unsigned(Hc - 1, bits(Hc - 1)) THEN --cambio de canal
                    sweightaddress <= sweightaddress + 1;
                    count_col <= (OTHERS => '0');
                    count_ch <= count_ch + 1;
                    IF count_ch = to_unsigned(Ch - 1, bits(Ch - 1)) THEN --cambio de filtro
                        count_ch <= (OTHERS => '0');
                        count_filters <= count_filters + 1;
                            sBNaddress <= sBNaddress + 1;

                        IF count_filters = to_unsigned(F/K - 1, bits(F - 1)) THEN --cambio de fila
                            sBNaddress <= (others => '0');
                            sweightaddress <= (OTHERS => '0');
                            count_filters <= (OTHERS => '0');
                            count_row <= count_row + 1;
                            IF count_row = to_unsigned(Hr - 1, bits(Hr - 1)) THEN --ultimo dato
                                pushing <= '1'; --señal para vaciar el LB
                                count_row <= (OTHERS => '0');
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF;

            IF pushing = '1' THEN --estado final para sacar del LB los datos de la última fila del último filtro
                count_pushing <= count_pushing + 1;
                IF count_pushing = to_unsigned(Hc - 1, bits(Hc - 1)) THEN --si se han sacado Hc datos
                    count_pushing <= (OTHERS => '0');
                    pushing <= '0'; --se termina
                END IF;
            END IF;
        END IF;

    END PROCESS clk_proc;

    comb_proc : PROCESS (validIn, count_ch, count_filters, count_row, pushing)
    BEGIN

        IF validIn = '1' THEN
            enableLBuffer <= '1';
            IF count_ch = 0 THEN --los primeros datos
                s_startLBuffer <= '1'; --no deben usar los datos del LB
            ELSE
                s_startLBuffer <= '0';
            END IF;
        ELSE
            enableLBuffer <= '0';
            s_startLBuffer <= '0';
        END IF;

        IF pushing = '1' THEN --si estamos en pushing
            validOut <= '1'; --los datos son válidos siempre
        ELSIF validIN = '1' AND count_ch = 0 THEN --si la entrada es valida y es el primer canal
            IF count_filters = to_unsigned(0, bits(F - 1)) AND count_row = to_unsigned(0, bits(Hr - 1)) THEN
                validOut <= '0';
            ELSE
                validOut <= '1'; --los datos son válidos si no es la primera fila del primer filtro 
            END IF;
        ELSE
            validOut <= '0'; --si no es ninguno de los dos casos anteriores los datos no son válidos
        END IF;

    END PROCESS comb_proc;

    startLBuffer <= s_startLBuffer;

END ARCHITECTURE rtl;