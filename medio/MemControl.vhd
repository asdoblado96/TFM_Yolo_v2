LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--Bloque de control para la memoria

ENTITY MemControl IS
    GENERIC (
        layer : INTEGER := 4);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        start : IN STD_LOGIC;

        we : IN STD_LOGIC;

        rMem : OUT unsigned(bits(kernels(layer)) - 1 DOWNTO 0); --qué bloque se lee
        rMemOdd : OUT STD_LOGIC; --par o impar
        address0 : OUT unsigned(bitsAddress(layer) - 1 DOWNTO 0);
        --direcciones para cada banco
        address1 : OUT unsigned(bitsAddress(layer) - 1 DOWNTO 0);

        address2 : OUT unsigned(bitsAddress(layer) - 1 DOWNTO 0);

        padding : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        kernelCol : OUT unsigned(1 DOWNTO 0); --para ordenar el kernel
        kernelRow : OUT unsigned(1 DOWNTO 0);
        enableKernel : OUT STD_LOGIC;
        validOut : OUT STD_LOGIC;

        weRAM : OUT STD_LOGIC;
        wMemOdd : OUT STD_LOGIC; --par o impar
        wBank : OUT unsigned(3 DOWNTO 0); --a que banco
        waddress : OUT unsigned(bitsAddress(layer) - 1 DOWNTO 0)); --a que direccion
END MemControl;

ARCHITECTURE arch OF MemControl IS

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

    SIGNAL s_kernelCol : unsigned(1 DOWNTO 0);
    SIGNAL s_kernelRow : unsigned(1 DOWNTO 0);
    SIGNAL s_rmem : unsigned(bits(kernels(layer)) - 1 DOWNTO 0);

    --señales lectura contadores
    SIGNAL rcount_col : signed(bits(Hc - 1) DOWNTO 0);
    SIGNAL rcount_row : unsigned(bits(Hr - 1) - 1 DOWNTO 0);
    SIGNAL rcount_ch : unsigned(bits(Ch - 1) - 1 DOWNTO 0);
    SIGNAL rcount_chMEM : unsigned(bits(Ch/K - 1) - 1 DOWNTO 0);
    SIGNAL rcount_fil : unsigned(bits(Fnext/Knext - 1) - 1 DOWNTO 0);
    --señales lectura dirección
    CONSTANT raddOffset : unsigned(bitsAddress(layer) - 1 DOWNTO 0) := to_unsigned((INTEGER(ceil(real(Hc/3))) + 1) * (Ch/K), bitsAddress(layer));

    SIGNAL raddress : unsigned(bitsAddress(layer) - 1 DOWNTO 0);
    SIGNAL addrOffrow0 : unsigned(bitsAddress(layer) - 1 DOWNTO 0);
    SIGNAL addrOffrow1 : unsigned(bitsAddress(layer) - 1 DOWNTO 0);

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
    kernelCol <= s_kernelCol;
    kernelrow <= s_kernelRow;
    rmem <= s_rmem;
    rmemodd <= NOT(s_wmemodd); --la memoria de la que se lee es siempre la contraria a la que se escribe
    enableKernel <= oe;

    address0 <= raddress + addrOffrow0;
    address1 <= raddress + addrOffrow1;
    address2 <= raddress;

    clk_proc : PROCESS (clk, reset)
    BEGIN
        IF reset = '0' THEN

            count_delay <= (OTHERS => '0');
            delay <= to_unsigned(((layer + 1) * delaymem(layer)) - 1, bits(((layer + 1) * delaymem(layer)) - 1)); --delay inicial en función de la capa

            --lectura
            validOut <= '0';

            oe <= '0';

            rcount_col <= to_signed(-1, bits(Hc - 1) + 1); --desfase inicial para cargar el kernel
            rcount_ch <= (OTHERS => '0');
            rcount_chMEM <= (OTHERS => '0');

            rcount_fil <= (OTHERS => '0');
            rcount_row <= (OTHERS => '0');

            s_rmem <= (OTHERS => '0');
            s_kernelCol <= "00";
            s_kernelrow <= "01"; --el dato cero esta en la f1 del kernel

            raddress <= (OTHERS => '0');
            rbase <= (OTHERS => '0');
            rdir_deadline <= "111"; -- -1
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
                --validOut
                IF rcount_col = to_signed((Hc - 1), bits(Hc - 1) + 1) THEN
                    validOut <= '0';
                ELSE
                    validOut <= '1';
                END IF;

                --direccionymem
                rdir_deadline <= rdir_deadline + 1;

                IF rdir_deadline = "010" THEN
                    raddress <= raddress + 1;
                    rdir_deadline <= "000";
                END IF;

                IF rcount_col = to_signed((Hc - 1), bits(Hc - 1) + 1) THEN --cambia de canal (ya incluye +1 col de padding)
                    raddress <= raddress + 1;
                    rdir_deadline <= "111";
                    rcount_chMEM <= rcount_chMEM + 1;

                    IF rcount_chMEM = to_unsigned(Ch/K - 1, bits(Ch/K - 1)) THEN --cambia de memoria
                        rcount_chMEM <= (OTHERS => '0');
                        raddress <= rbase;
                        s_rmem <= s_rmem + 1;

                        IF s_rmem = to_unsigned(K - 1, bits(kernels(layer))) THEN ---cambia de fila y de memoria
                            s_rmem <= (OTHERS => '0');

                            IF rcount_fil = to_unsigned(Fnext/Knext - 1, bits(Fnext/Knext - 1)) THEN
                                addcount_row <= addcount_row + 1;

                                IF addcount_row = "10" THEN
                                    rbase <= raddress + 1;
                                    addcount_row <= (OTHERS => '0');
                                END IF;

                                IF rcount_row = to_unsigned(Hr - 1, bits(Hr - 1)) THEN -- ultimo dato
                                    rbase <= (OTHERS => '0');
                                    raddress <= (OTHERS => '0');
                                    rdir_deadline <= "111";
                                    addcount_row <= (OTHERS => '0');
                                END IF;
                            END IF;
                        END IF;

                    END IF;
                END IF;

                --contadores lectura
                rcount_col <= rcount_col + 1;
                IF rcount_col = to_signed((Hc - 1), bits(Hc - 1) + 1) THEN --cambia de canal (incluye +1 col de padding)
                    rcount_col <= to_signed(-1, bits(Hc - 1) + 1);
                    rcount_ch <= rcount_ch + 1;

                    IF rcount_ch = to_unsigned(Ch - 1, bits(Ch - 1)) THEN --cambia de filtro
                        rcount_ch <= (OTHERS => '0');
                        rcount_fil <= rcount_fil + 1;

                        IF rcount_fil = to_unsigned(Fnext/Knext - 1, bits(Fnext/Knext - 1)) THEN ---cambia de fila 
                            rcount_row <= rcount_row + 1;
                            rcount_fil <= (OTHERS => '0');

                            IF rcount_row = to_unsigned(Hr - 1, bits(Hr - 1)) THEN -- ultimo dato
                                rcount_row <= (OTHERS => '0');
                                rcount_col <= to_signed(-1, bits(Hc - 1) + 1);
                                rcount_ch <= (OTHERS => '0');
                                s_rmem <= (OTHERS => '0');
                                validOut <= '0';
                                oe <= '0'; --no se permite leer hasta pasado el siguiente delay
                            END IF;
                        END IF;
                    END IF;
                END IF;

                --kernelCol y Row
                CASE s_kernelCol IS
                    WHEN "00" => s_kernelCol <= "01";
                    WHEN "01" => s_kernelCol <= "10";
                    WHEN "10" => s_kernelCol <= "00";
                    WHEN OTHERS => s_kernelCol <= "00";
                END CASE;

                IF rcount_col = to_signed((Hc - 1), bits(Hc - 1) + 1) THEN --cambia de canal
                    s_kernelCol <= "00";
                END IF;

                IF s_rmem = to_unsigned(K - 1, bits(kernels(layer))) AND rcount_fil = to_unsigned(Fnext/Knext - 1, bits(Fnext/Knext - 1))
                    AND rcount_ch = to_unsigned(Ch - 1, bits(Ch - 1)) AND rcount_col = to_signed((Hc - 1), bits(Hc - 1) + 1) THEN ---cambia de fila
                    s_kernelrow <= s_kernelrow - 1;
                    IF s_kernelrow = "00" THEN
                        s_kernelrow <= "10";
                    END IF;
                    IF rcount_row = to_unsigned(Hr - 1, bits(Hr - 1)) THEN -- ultimo dato
                        s_kernelrow <= "01";
                        s_kernelCol <= "00";
                    END IF;
                END IF;
            ELSE
                validOut <= '0';
            END IF;
        END IF;
    END PROCESS clk_proc;

    --ReadingAddressOffsets
    addressOffsets : PROCESS (s_kernelRow, rcount_row)
    BEGIN

        CASE s_kernelRow IS
            WHEN "00" =>
                addrOffrow0 <= (OTHERS => '0');
                addrOffrow1 <= (OTHERS => '0');
            WHEN "01" =>
                addrOffrow0 <= raddOffset;
                addrOffrow1 <= raddOffset;
            WHEN "10" =>
                addrOffrow0 <= raddOffset;
                addrOffrow1 <= (OTHERS => '0');
            WHEN OTHERS =>
                addrOffrow0 <= (OTHERS => '0');
                addrOffrow1 <= (OTHERS => '0');
        END CASE;

        IF rcount_row = to_unsigned(0, bits(Hr - 1)) THEN
            addrOffrow0 <= (OTHERS => '0');
            addrOffrow1 <= (OTHERS => '0');
        END IF;
    END PROCESS addressOffsets;

    --padding
    padding_proc : PROCESS (rcount_row, rcount_col, rcount_ch, s_rmem)
    BEGIN
        IF rcount_col = to_signed((Hc - 1), bits(Hc - 1) + 1) THEN --final fila
            padding <= "111";
        ELSIF rcount_row = to_unsigned(0, bits(Hr - 1)) THEN --primera fila
            padding <= "100";
        ELSIF rcount_row = to_unsigned(Hr - 1, bits(Hr - 1)) THEN --ultima fila
            padding <= "001";
        ELSE
            padding <= "000";
        END IF;
    END PROCESS padding_proc;

END arch;