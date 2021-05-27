LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.math_real.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--Bloque de datapath para la memoria de la capa 0(input) a la 8

ENTITY MemDP IS
    GENERIC (
        layer : INTEGER := 4);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        Din : IN STD_LOGIC_VECTOR((kernels(layer) * 6) - 1 DOWNTO 0);

        rMem : IN unsigned(bits(kernels(layer)) - 1 DOWNTO 0);
        rMemOdd : IN STD_LOGIC;
        address0 : IN unsigned(bitsAddress(layer) - 1 DOWNTO 0);
        address1 : IN unsigned(bitsAddress(layer) - 1 DOWNTO 0);
        address2 : IN unsigned(bitsAddress(layer) - 1 DOWNTO 0);

        enableKernel : IN STD_LOGIC;
        padding : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        kernelCol : IN unsigned(1 DOWNTO 0);
        kernelRow : IN unsigned(1 DOWNTO 0);

        we : IN STD_LOGIC;
        wMemOdd : IN STD_LOGIC;
        wBank : IN unsigned(3 DOWNTO 0);
        waddress : IN unsigned(bitsAddress(layer) - 1 DOWNTO 0);

        Dout : OUT STD_LOGIC_VECTOR((9 * 6) - 1 DOWNTO 0));
END MemDP;

ARCHITECTURE arch OF MemDP IS

    CONSTANT databits : INTEGER := 6; --databits de datos
    CONSTANT bitsAddress : INTEGER := bitsAddress(layer);

    COMPONENT MemToKernel
        GENERIC (
            layer : INTEGER := 1);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            enableKernel : IN STD_LOGIC;

            padding : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            kernelCol : IN unsigned(1 DOWNTO 0);
            kernelRow : IN unsigned(1 DOWNTO 0);

            Din : IN STD_LOGIC_VECTOR(9 * databits - 1 DOWNTO 0);
            Dout : OUT STD_LOGIC_VECTOR(9 * databits - 1 DOWNTO 0));
    END COMPONENT;

    COMPONENT RAM
        GENERIC (
            WL : INTEGER := 8; -- Word Length
            bitsAddress : INTEGER := 64); -- Address Length
        PORT (
            clk : IN STD_LOGIC;

            we : IN STD_LOGIC;

            Din : IN STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
            rAddr : IN unsigned(bitsAddress - 1 DOWNTO 0);
            wAddr : IN unsigned(bitsAddress - 1 DOWNTO 0);

            Dout : OUT STD_LOGIC_VECTOR(WL - 1 DOWNTO 0));
    END COMPONENT;

    SIGNAL DataOutRAM : STD_LOGIC_VECTOR((grid(layer) * databits) - 1 DOWNTO 0);
    TYPE vectordataOutRAM IS ARRAY (kernels(layer) - 1 DOWNTO 0) OF STD_LOGIC_VECTOR((grid(layer) * databits) - 1 DOWNTO 0);

    SIGNAL vDataOutRAModd : vectordataOutRAM;
    SIGNAL vDataOutRAMeven : vectordataOutRAM;
    SIGNAL vDataOutRAM : vectordataOutRAM;
    SIGNAL weRAModd : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL weEXT : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL rmemoddEXT : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL wMemOddEXT : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL weRAMeven : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL weBank : STD_LOGIC_VECTOR(8 DOWNTO 0);

    SIGNAL std_raddress : unsigned(9 * bitsAddress - 1 DOWNTO 0);    
BEGIN
    weEXT <= (OTHERS => we);
    wMemOddEXT <= (OTHERS => wmemodd);
    weRAModd <= weEXT AND weBank AND wMemOddEXT;
    weRAMeven <= weEXT AND weBank AND NOT(wMemOddEXT);
    std_raddress <= address2 & address2 & address2 & address1 & address1 & address1 & address0 & address0 & address0;

    --KERNEL
    MemToKernelBlock : MemToKernel
    GENERIC MAP(Layer => Layer)
    PORT MAP(
        clk => clk, reset => reset, enableKernel => enableKernel, padding => padding,
        kernelCol => kernelCol, kernelRow => kernelRow, Din => DataOutRam, Dout => Dout);

    --BLOQUES DE MEMORIA
    block_gen : FOR I IN 0 TO kernels(layer) - 1 GENERATE

        --BANCOS DE MEMORIA
        mem_gen : FOR J IN 0 TO 8 GENERATE
            --IMPAR
            mem_odd : RAM GENERIC MAP(WL => databits, bitsAddress => bitsAddress)
            PORT MAP(
                clk => clk, we => weRAModd(J),
                Din => Din((I + 1) * databits - 1 DOWNTO I * databits),
                rAddr => std_raddress((J + 1) * bitsAddress - 1 DOWNTO J * bitsAddress),
                wAddr => waddress,
                Dout => vDataOutRAModd(I)(((J + 1) * databits) - 1 DOWNTO J * databits));

            --PAR
            mem_even : RAM GENERIC MAP(WL => databits, bitsAddress => bitsAddress)
            PORT MAP(
                clk => clk, we => weRAMeven(J),
                Din => Din((I + 1) * databits - 1 DOWNTO I * databits),
                rAddr => std_raddress((J + 1) * bitsAddress - 1 DOWNTO J * bitsAddress),
                wAddr => waddress,
                Dout => vDataOutRAMeven(I)(((J + 1) * databits) - 1 DOWNTO J * databits));
        END GENERATE mem_gen;
    END GENERATE block_gen;

    --CONVERSION WEBANK A VECTOR

    webank_proc : PROCESS (wBank, we)
    BEGIN
        CASE wbank IS
            WHEN "0000" => webank <= "000000001";
            WHEN "0001" => webank <= "000000010";
            WHEN "0010" => webank <= "000000100";
            WHEN "0011" => webank <= "000001000";
            WHEN "0100" => webank <= "000010000";
            WHEN "0101" => webank <= "000100000";
            WHEN "0110" => webank <= "001000000";
            WHEN "0111" => webank <= "010000000";
            WHEN "1000" => webank <= "100000000";
            WHEN OTHERS => webank <= (OTHERS => '0');
        END CASE;
    END PROCESS webank_proc;

    --SELECCION DE SALIDA 
    dataout_proc : PROCESS (rmemodd, vDataOutRAModd, vDataOutRAMeven)
    BEGIN
        CASE rmemodd IS
            WHEN '1' =>
                vDataOutRAM <= vDataOutRAModd;
            WHEN '0' =>
                vDataOutRAM <= vDataOutRAMeven;
            WHEN OTHERS =>
                vDataOutRAM <= (OTHERS => (OTHERS => '0'));
        END CASE;
    END PROCESS dataout_proc;

    dataoutram_proc : PROCESS (rmem, vDataOutRAM)
    BEGIN
        IF rmem >= to_unsigned(0, bits(kernels(layer))) THEN
            IF rmem <= to_unsigned(kernels(layer) - 1, bits(kernels(layer))) THEN
                DataOutRAM <= vDataOutRAM(to_integer(RMEM));
            ELSE
                DataOutRam <= (OTHERS => '0');
            END IF;
        ELSE
            DataOutRam <= (OTHERS => '0');
        END IF;
    END PROCESS dataoutram_proc;
END arch;