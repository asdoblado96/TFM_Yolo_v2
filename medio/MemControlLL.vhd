LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--Bloque de control para la memoria de la última capa
--Se escribe igual
--Se leen los datos de uno en uno
--No hay padding
--No hay kernel window
--Sólo una dirección de lectura

ENTITY MemControlLL IS
    GENERIC (
        layer : INTEGER := 4);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        start : IN STD_LOGIC;

        we : IN STD_LOGIC;
        weRAM : OUT STD_LOGIC;
        wMemOdd : OUT STD_LOGIC; --par o impar
        wBank : OUT unsigned(3 DOWNTO 0); --a que banco
        waddress : OUT unsigned(bitsAddress(layer) - 1 DOWNTO 0);

        rMem : OUT unsigned(bits(kernels(layer)) - 1 DOWNTO 0); --qué bloque se lee
        rMemOdd : OUT STD_LOGIC; --par o impar
        rBank : OUT unsigned(3 DOWNTO 0);
        raddress : OUT unsigned(bitsAddress(layer) - 1 DOWNTO 0);

        validOut : OUT STD_LOGIC

    ); --a que direccion
END MemControlLL;

ARCHITECTURE arch OF MemControlLL IS

    --constantes
    CONSTANT Hc : INTEGER := columns(layer + 1);
    CONSTANT Hr : INTEGER := rows(layer + 1);

    CONSTANT Ch : INTEGER := filters(layer); --el numero de canales dependerá del numero de filtros en la etapa
    CONSTANT K : INTEGER := kernels(layer);

    CONSTANT Fnext : INTEGER := filters(layer + 1);--esto sirve a saber como leer la memoria para la siguiente etapa
    CONSTANT Knext : INTEGER := kernels(layer + 1);

    --señal de delay
    SIGNAL count_delay : unsigned(bits(((layer + 1) * delaymem(layer)) - 1) - 1 DOWNTO 0);
    SIGNAL delay : unsigned(bits(((layer + 1) * delaymem(layer)) - 1) - 1 DOWNTO 0);

    --señales lectura
    SIGNAL oe : STD_LOGIC;

    SIGNAL s_rmem : unsigned(bits(kernels(layer)) - 1 DOWNTO 0);
    SIGNAL s_rBank : unsigned(3 DOWNTO 0);
    SIGNAL s_rBankOff : unsigned(3 DOWNTO 0);

    --señales lectura contadores
    SIGNAL rcount_col : unsigned(bits(Hc - 1) - 1 DOWNTO 0);
    SIGNAL rcount_row : unsigned(bits(Hr - 1) - 1 DOWNTO 0);
    SIGNAL rcount_ch : unsigned(bits(Ch - 1) - 1 DOWNTO 0);
    SIGNAL rcount_chMEM : unsigned(bits(Ch/K - 1) - 1 DOWNTO 0);
    SIGNAL rcount_fil : unsigned(bits(Fnext/Knext - 1) - 1 DOWNTO 0);

    --señales lectura dirección
    SIGNAL s_raddress : unsigned(bitsAddress(layer) - 1 DOWNTO 0);
    SIGNAL rbase : unsigned(bitsAddress(layer) - 1 DOWNTO 0);
    SIGNAL rdir_deadline : signed(2 DOWNTO 0);

    SIGNAL addcount_row : unsigned(1 DOWNTO 0);

    --señales escritura
    SIGNAL s_wbank : unsigned(3 DOWNTO 0);
    SIGNAL s_waddress : unsigned(bitsAddress(layer) - 1 DOWNTO 0);
    SIGNAL waddressoffset : unsigned(bitsAddress(layer) - 1 DOWNTO 0);
    SIGNAL s_wmemodd : STD_LOGIC;

    --señales escritura contadores
    SIGNAL wcount_col : unsigned(bits(Hc - 1) - 1 DOWNTO 0);
    SIGNAL wcount_ch : unsigned(bits(Ch/K - 1) - 1 DOWNTO 0);
    SIGNAL wcount_data : unsigned(bits((Hr * Hc) * (Ch/K) - 1) DOWNTO 0);

    --señales escritura bancos
    SIGNAL wbankOffset : unsigned(3 DOWNTO 0);

BEGIN

    --ESCRITURA
    weRAM <= we;
    wBank <= s_wbank;
    wmemodd <= s_wmemodd;
    waddress <= s_waddress;

    --LECTURA
    raddress <= s_raddress;
    rmem <= s_rmem;
    rmemodd <= NOT(s_wmemodd); --la memoria de la que se lee es siempre la contraria a la que se escribe
    rBank <= s_rBank;

    validOut <= oe;


    clk_proc : PROCESS (clk, reset)
    BEGIN
        IF reset = '0' THEN

            count_delay <= (OTHERS => '0');
            delay <= to_unsigned(((layer + 1) * delaymem(layer)) - 1, bits(((layer + 1) * delaymem(layer)) - 1));--to_unsigned(20, bits(((layer + 1) * delaymem(layer)) - 1)); --delay inicial en función de la capa

            --lectura

            oe <= '0';

            rcount_col <= (OTHERS => '0'); --desfase inicial para cargar el kernel
            rcount_ch <= (OTHERS => '0');
            rcount_chMEM <= (OTHERS => '0');

            rcount_fil <= (OTHERS => '0');
            rcount_row <= (OTHERS => '0');

            s_rmem <= (OTHERS => '0');
            s_rBank <= (OTHERS => '0');
            s_rBankOff <= (OTHERS => '0');

            s_raddress <= (OTHERS => '0');
            rbase <= (OTHERS => '0');
            rdir_deadline <= "000"; -- -2
            addcount_row <= (OTHERS => '0');

            --escritura
            wcount_col <= (OTHERS => '0');
            wcount_ch <= (OTHERS => '0');
            wcount_data <= (OTHERS => '0');

            s_wmemodd <= '1'; --empezamos en la impar
            s_waddress <= (OTHERS => '0');
            s_wbank <= (OTHERS => '0');
            wbankOffset <= (OTHERS => '0');
            waddressoffset <= (OTHERS => '0');

        ELSIF rising_edge(clk) THEN

            IF START = '1' THEN
                count_delay <= count_delay + 1;
                IF count_delay = delay - 1 THEN
                    delay <= to_unsigned(delaymem(layer) - 1, bits(((layer + 1) * delaymem(layer)) - 1)); --a partir de aqui delay estandar para todas las capas
                    oe <= '1'; --y se permite la lectura
                    s_wmemodd <= NOT(s_wmemodd);
                    count_delay <= (OTHERS => '0');
                END IF;
            END IF;

            --escritura
            IF we = '1' THEN

                s_wbank <= s_wbank + 1;
                wcount_col <= wcount_col + 1;
                wcount_data <= wcount_data + 1;

                IF s_wbank = wbankOffset + 2 THEN --final del bloque 
                    s_wbank <= wbankOffset; --se vuelve al "primero"
                    s_waddress <= s_waddress + 1;
                END IF;

                IF wcount_data = to_unsigned((Hr * Hc) * (Ch/K) - 1, bits((Hr * Hc) * (Ch/K) - 1)) THEN --ultimo dato
                    wcount_data <= (OTHERS => '0');
                    wcount_ch <= (OTHERS => '0');
                    wcount_col <= (OTHERS => '0');
                    s_waddress <= (OTHERS => '0');
                    wbankOffset <= (OTHERS => '0');
                    s_wbank <= (OTHERS => '0');
                ELSIF wcount_col = to_unsigned(Hc - 1, bits(Hc - 1)) THEN -- final del canal
                    wcount_col <= (OTHERS => '0');
                    s_wbank <= wbankOffset; --se vuelve al "primero"
                    s_waddress <= s_waddress + 1;
                    wcount_ch <= wcount_ch + 1;
                    IF wcount_ch = to_unsigned((Ch/K) - 1, bits(Ch/K - 1)) THEN --final de la fila
                        wbankOffset <= wbankOffset + 3; --se actualiza el "primer bloque"
                        s_wbank <= wbankOffset + 3; -- y se vuelve a ese
                        s_waddress <= waddressoffset; --se vuelve a la "primera"
                        wcount_ch <= (OTHERS => '0');
                        IF wbankOffset = "0110" THEN --cada 3 filas
                            s_wbank <= (OTHERS => '0'); --vuelta al banco 0
                            wbankOffset <= (OTHERS => '0');
                            waddressoffset <= s_waddress + 1; --se añade un offset a la dirección
                            s_waddress <= s_waddress + 1;
                        END IF;
                    END IF;
                END IF;
            END IF;

            --lectura
            IF oe = '1' THEN

                s_rBank <= s_rBank + 1;

                --bank
                IF s_rBank = s_rBankOff + "0010" THEN
                    s_rBank <= s_rBankOff;
                END IF;

                --direccionymem
                rdir_deadline <= rdir_deadline + 1;

                IF rdir_deadline = "010" THEN
                    s_raddress <= s_raddress + 1;
                    rdir_deadline <= "000";
                END IF;

                IF rcount_col = to_unsigned((Hc - 1), bits(Hc - 1)) THEN --cambia de canal
                    s_raddress <= s_raddress + 1;
                    rdir_deadline <= "000";
                    rcount_chMEM <= rcount_chMEM + 1;
                    s_rBank <= s_rBankOff;

                    IF rcount_chMEM = to_unsigned(Ch/K - 1, bits(Ch/K - 1)) THEN --cambia de memoria
                        rcount_chMEM <= (OTHERS => '0');
                        s_raddress <= rbase;
                        s_rmem <= s_rmem + 1;

                        IF s_rmem = to_unsigned(K - 1, bits(kernels(layer))) THEN ---cambia de fila y de memoria
                            s_rmem <= (OTHERS => '0');

                            IF rcount_fil = to_unsigned(Fnext/Knext - 1, bits(Fnext/Knext - 1)) THEN
                                addcount_row <= addcount_row + 1;
                                s_rBankOff <= s_rBankOff + "0011";
                                s_rBank <= s_rBankOff + "0011";
    
                                IF s_rBankOff = "0110" THEN
                                    s_rBankOff <= (OTHERS => '0');
                                    s_rBank <= (OTHERS => '0');
                                END IF;

                                IF addcount_row = "10" THEN
                                    rbase <= s_raddress + 1;
                                    addcount_row <= (OTHERS => '0');
                                END IF;

                                IF rcount_row = to_unsigned(Hr - 1, bits(Hr - 1)) THEN -- ultimo dato
                                    rbase <= (OTHERS => '0');
                                    s_raddress <= (OTHERS => '0');
                                    rdir_deadline <= "000";
                                    addcount_row <= (OTHERS => '0');
                                    s_rBank <= (OTHERS => '0');

                                END IF;
                            END IF;
                        END IF;

                    END IF;
                END IF;

                --contadores lectura
                rcount_col <= rcount_col + 1;
                IF rcount_col = to_unsigned((Hc - 1), bits(Hc - 1)) THEN --cambia de canal (incluye +1 col de padding)
                    rcount_col <= to_unsigned(0, bits(Hc - 1));
                    rcount_ch <= rcount_ch + 1;

                    IF rcount_ch = to_unsigned(Ch - 1, bits(Ch - 1)) THEN --cambia de filtro
                        rcount_ch <= (OTHERS => '0');
                        rcount_fil <= rcount_fil + 1;

                        IF rcount_fil = to_unsigned(Fnext/Knext - 1, bits(Fnext/Knext - 1)) THEN ---cambia de fila 
                            rcount_row <= rcount_row + 1;
                            rcount_fil <= (OTHERS => '0');

                            IF rcount_row = to_unsigned(Hr - 1, bits(Hr - 1)) THEN -- ultimo dato
                                rcount_row <= (OTHERS => '0');
                                rcount_col <= to_unsigned(0, bits(Hc - 1));
                                rcount_ch <= (OTHERS => '0');
                                s_rmem <= (OTHERS => '0');
                                oe <= '0'; --no se permite leer hasta pasado el siguiente delay
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS clk_proc;
END arch;