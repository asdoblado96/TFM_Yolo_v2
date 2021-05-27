LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--aqui compruebo la sinergia entre el bloque de control y el datapath para la capa de MaxPooling

ENTITY MPLayer IS
    GENERIC (layer : INTEGER := 1);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        dataIN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        validIN : IN STD_LOGIC;

        dataOUT : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        validOUT : OUT STD_LOGIC);
END MPLayer;

ARCHITECTURE rtl OF MPLayer IS

    CONSTANT rst_val : STD_LOGIC := '0';

    signal vald1: std_logic;
    signal enLBuff: std_logic;

    COMPONENT MaxPoolDP
        GENERIC (
            Layer : INTEGER := 1);
        PORT (
            clk, reset : IN STD_LOGIC;

            val_d1 : IN STD_LOGIC;
            enLBuffer : IN STD_LOGIC;

            datain : IN STD_LOGIC_VECTOR(5 DOWNTO 0);

            dataout : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT MaxPoolcontrol
        GENERIC (
            Layer : INTEGER := 1);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;

            validIn : IN STD_LOGIC;

            val_d1 : OUT STD_LOGIC;
            enLBuffer : OUT STD_LOGIC;

            validOut : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN

MPUC : MaxPoolControl
GENERIC MAP(Layer => layer)
PORT MAP(
    clk => clk,
    reset => reset,
    validIn => validIn,
    val_d1 => vald1, enLBuffer => enLBuff,
    validOut => validOut
);

MPUP : MaxPoolDP
GENERIC MAP(Layer => layer)
PORT MAP(
    clk => clk,
    reset => reset,
    val_d1 => vald1,
    enLBuffer => enLBuff,
    datain => datain,
    dataout => dataout);

END ARCHITECTURE rtl;