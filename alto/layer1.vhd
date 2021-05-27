LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--Aquí se comprueba el funcionamiento de una sóla capa

ENTITY layer1 IS
    GENERIC (layer : INTEGER:=1);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        start : IN STD_LOGIC;

        IN0 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        IN1 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        IN2 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        IN3 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        IN4 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        IN5 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        IN6 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        IN7 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        IN8 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);

        validIN : STD_LOGIC;

        dataOUT : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        validOut : OUT STD_LOGIC
    );
END layer1;

ARCHITECTURE rtl OF layer1 IS

    CONSTANT rst_val : STD_LOGIC := '0';

    SIGNAL datain : STD_LOGIC_VECTOR(80 DOWNTO 0);

    COMPONENT L1_BNROM
        PORT (
            coefs : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            address : IN unsigned(3 DOWNTO 0));
    END COMPONENT;

    COMPONENT L1_WROM
        PORT (
            weight : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
            address : IN unsigned(weightsbitsAddress(1) - 1 DOWNTO 0));
    END COMPONENT;

    COMPONENT ConvControl
        GENERIC (
            layer : INTEGER
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            validIn : IN STD_LOGIC;

            startLBuffer : OUT STD_LOGIC;
            enableLBuffer : OUT STD_LOGIC;

            addressweight : OUT unsigned(weightsbitsAddress(LAYER) - 1 DOWNTO 0);
            addressbn : OUT unsigned(bits(filters(layer)/kernels(layer) - 1) - 1 DOWNTO 0);

            validOut : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT ConvDP
        GENERIC (layer : INTEGER);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            datain : IN STD_LOGIC_VECTOR((9 * layerbits(layer)) - 1 DOWNTO 0); --vector de datos de entrada
            Weights : IN STD_LOGIC_VECTOR(8 DOWNTO 0); --vector de 9 pesos binarios
            Ynorm : IN signed(15 DOWNTO 0); --coef1 de BN
            Bnorm : IN signed(15 DOWNTO 0); --coef2 de BN

            startLbuffer : IN STD_LOGIC; --mux LB
            enableLbuffer : IN STD_LOGIC;

            dataout : OUT STD_LOGIC_VECTOR(5 DOWNTO 0));
    END COMPONENT;

    COMPONENT MaxPoolControl
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
    END COMPONENT;

    COMPONENT MaxPoolDP
        GENERIC (Layer : INTEGER);
        PORT (
            clk, reset : IN STD_LOGIC;

            val_d1 : IN STD_LOGIC;
            enLBuffer : IN STD_LOGIC;

            datain : IN STD_LOGIC_VECTOR(5 DOWNTO 0);

            dataout : OUT STD_LOGIC_VECTOR(5DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT MemControl
        GENERIC (
            layer : INTEGER := 4);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            start : IN STD_LOGIC;

            we : IN STD_LOGIC;

            rMem : OUT unsigned(bits(kernels(layer)) - 1 DOWNTO 0); --qu� bloque se lee
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
            waddress : OUT unsigned(bitsAddress(layer) - 1 DOWNTO 0));
    END COMPONENT;

    COMPONENT MemDP
        GENERIC (layer : INTEGER);
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

    END COMPONENT;

    SIGNAL startLBuffer : STD_LOGIC;
    SIGNAL enableLBuffer : STD_LOGIC;
    SIGNAL addressweight : unsigned(weightsbitsAddress(layer) - 1 DOWNTO 0);
    SIGNAL addressbn : unsigned(bits(filters(layer)/kernels(layer) - 1) - 1 DOWNTO 0);
    SIGNAL validoutCV : STD_LOGIC;

    SIGNAL ROMweight : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL invROMweight : STD_LOGIC_VECTOR(8 DOWNTO 0);

    SIGNAL ROMcoefs : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL bias : SIGNED(15 DOWNTO 0);
    SIGNAL scale : SIGNED(15 DOWNTO 0);

    SIGNAL outCVDP : STD_LOGIC_VECTOR(5 DOWNTO 0);

    SIGNAL valid_d1 : STD_LOGIC;
    SIGNAL enLbuffer : STD_LOGIC;
    SIGNAL validoutMP : STD_LOGIC;

    SIGNAL outMPDP : STD_LOGIC_VECTOR(5 DOWNTO 0);

    SIGNAL weRAM : STD_LOGIC;
    SIGNAL wMemOdd : STD_LOGIC; --par o impar
    SIGNAL wBank : unsigned(3 DOWNTO 0); --a que banco
    SIGNAL waddress : unsigned(bitsAddress(layer) - 1 DOWNTO 0); --a que direccion

    SIGNAL rMem : unsigned(bits(kernels(layer)) - 1 DOWNTO 0); --qué bloque se lee
    SIGNAL rMemOdd : STD_LOGIC; 
    SIGNAL address0 : unsigned(bitsAddress(layer) - 1 DOWNTO 0);
    SIGNAL address1 : unsigned(bitsAddress(layer) - 1 DOWNTO 0);
    SIGNAL address2 : unsigned(bitsAddress(layer) - 1 DOWNTO 0);
    SIGNAL padding : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL kernelCol : unsigned(1 DOWNTO 0); --para ordenar el kernel
    SIGNAL kernelRow : unsigned(1 DOWNTO 0);
    SIGNAL enableKernel: STD_LOGIC;
    SIGNAL memoe : STD_LOGIC;


BEGIN

    datain <= IN8 & IN7 & IN6 & IN5 & IN4 & IN3 & IN2 & IN1 & IN0;

    ConvUC : ConvControl
    GENERIC MAP(Layer => Layer)
    PORT MAP(
        clk => clk, reset => reset,
        validIn => validIN,
        startLBuffer => startLBuffer, enableLBuffer => enableLBuffer,
        addressweight => addressweight,
        addressbn => addressbn,
        validOut => validoutCV);

    WROM : L1_WROM
    PORT MAP(
        weight => ROMweight,
        address => addressweight);

    invweight : PROCESS (ROMweight)
    BEGIN
        FOR i IN 0 TO 8 LOOP
            invROMweight(i) <= ROMweight(8 - i);
        END LOOP;
    END PROCESS invweight;

    BNROM : L1_BNROM
    PORT MAP(
        coefs => ROMcoefs,
        address => addressbn
    );

    bias <= SIGNED(ROMcoefs(31 DOWNTO 16));
    scale <= SIGNED(ROMcoefs(15 DOWNTO 0));

    ConvUP : ConvDP
    GENERIC MAP(Layer => Layer)
    PORT MAP(
        clk => clk, reset => reset,
        DataIn => datain,
        weights => invROMweight,
        Ynorm => scale,
        Bnorm => bias,
        startLBuffer => startLBuffer,
        enableLBuffer => enableLBuffer,
        dataout => outCVDP
    );

    MPUC : MaxPoolControl
    GENERIC MAP(Layer => layer)
    PORT MAP(
        clk => clk,
        reset => reset,
        validIn => validoutCV,
        val_d1 => valid_d1, enLBuffer => enLbuffer,
        validOut => validoutMP
    );

    MPDP : MaxPoolDP
    GENERIC MAP(Layer => layer)
    PORT MAP(
        clk => clk, reset => reset,
        val_d1 => valid_d1, enLbuffer => enLbuffer,
        datain => outCVDP,
        dataout => outMPDP
    );

    memUC : MemControl
    GENERIC MAP(LAYER => LAYER)
    PORT MAP(
        clk => clk, reset => reset,
        start => start, we => validoutMP,
        rmem => rmem,
        rmemodd => rmemodd,
        address0 => address0,
        address1 => address1,
        address2 => address2,
        padding => padding,
        kernelCol => kernelCol,
        kernelrow => kernelrow,
        enableKernel => enableKernel,
        validout => memoe,
        weram => weram,
        wmemodd => wmemodd,
        wBank => wBank,
        waddress => waddress
    );

    memUP : MemDP
    GENERIC MAP(LAYER => LAYER)
    PORT MAP(
        clk => clk, reset => reset,

        Din => outMPDP,

        rmem => rmem,
        rmemodd => rmemodd,
        address0 => address0,
        address1 => address1,
        address2 => address2,

        enableKernel => enableKernel,
        padding => padding,
        kernelCol => kernelCol,
        kernelrow => kernelrow,

        we => weram,
        wmemodd => wmemodd,
        wBank => wBank,
        waddress => waddress,

        Dout => OPEN
    );
END ARCHITECTURE rtl;