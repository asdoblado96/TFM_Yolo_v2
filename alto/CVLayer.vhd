LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--aqui compruebo la sinergia entre el bloque de control y el datapath para la capa de convolución

ENTITY CVLayer IS
    GENERIC (Layer : INTEGER := 2);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        datain : IN STD_LOGIC_VECTOR ((grid(Layer) * 6) - 1 DOWNTO 0); --vector de datos
        weights : IN STD_LOGIC_VECTOR ( grid(Layer) - 1 DOWNTO 0); --vector de pesos
        bias : IN signed ((2 * 16) - 1 DOWNTO 0); --coeficientes de la normalizacion

        validIn : IN STD_LOGIC;

        dataout : OUT STD_LOGIC_VECTOR (5 DOWNTO 0));
END CVLayer;

ARCHITECTURE rtl OF CVLayer IS

    CONSTANT rst_val : STD_LOGIC := '0';

    SIGNAL outCV : STD_LOGIC;
    SIGNAL startLBuffer : STD_LOGIC;
    SIGNAL enableLBuffer : STD_LOGIC;

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

            validOut : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT ConvDP
        GENERIC (Layer : INTEGER);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            datain : IN STD_LOGIC_VECTOR((grid(layer) * 6) - 1 DOWNTO 0);
            Weights : IN STD_LOGIC_VECTOR(grid(layer) - 1 DOWNTO 0);
            Ynorm : IN signed(15 DOWNTO 0);
            Bnorm : IN signed(15 DOWNTO 0);

            startLbuffer : IN STD_LOGIC;
            enableLbuffer : IN STD_LOGIC;

            dataout : OUT STD_LOGIC_VECTOR(5 DOWNTO 0));
    END COMPONENT;
BEGIN

    ConvUC : ConvControl
    GENERIC MAP(Layer => Layer)
    PORT MAP(
        clk => clk, reset => reset,
        validIn => ValidIn,
        startLBuffer => startLBuffer, enableLBuffer => enableLBuffer,
        validOut => outCV);

    ConvUP : ConvDP
    GENERIC MAP(LAYER => LAYER)
    PORT MAP(clk => clk, reset => reset,
    datain => datain, weights => weights, Ynorm =>bias(31 downto 16), Bnorm=>bias(15 downto 0),
    startLBuffer=> startLBuffer, enableLBuffer => enableLBuffer,
    dataout => dataout);

END ARCHITECTURE rtl;