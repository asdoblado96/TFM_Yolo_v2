
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.MATH_REAL.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

LIBRARY STD;
USE STD.TEXTIO.ALL;

ENTITY tb_layer1 IS
END tb_layer1;

ARCHITECTURE behavior OF tb_layer1 IS

    CONSTANT clk_period : TIME := 10 ns;

    COMPONENT layer1 IS
        GENERIC (layer : INTEGER);
        PORT (
            reset : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            validIN : IN STD_LOGIC;
            start : IN STD_LOGIC;
            -- Entradas de YOLO. 
            In0 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            In1 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            In2 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            In3 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            In4 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            In5 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            In6 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            In7 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            In8 : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            -- Salidas de YOLO.  
            DataOut : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            validOut : OUT STD_LOGIC);
    END COMPONENT;
    -- Senales de control
    SIGNAL reset : STD_LOGIC;
    SIGNAL clk : STD_LOGIC;
    CONSTANT latencia : INTEGER := delaymem(1);

    SIGNAL start : STD_LOGIC;
    SIGNAL ValidIn : STD_LOGIC;

    TYPE imgIN IS ARRAY (0 TO 8) OF STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL DataIn : imgIN;

    SIGNAL DataOut : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL validOut : STD_LOGIC;

BEGIN

    YOLO : layer1
    GENERIC MAP(layer => 1)
    PORT MAP(
        reset => reset,
        start => start,
        clk => clk,
        validIN => validIN,
        -- Entradas de YOLO. 
        In0 => DataIn(0),
        In1 => DataIn(1),
        In2 => DataIn(2),
        In3 => DataIn(3),
        In4 => DataIn(4),
        In5 => DataIn(5),
        In6 => DataIn(6),
        In7 => DataIn(7),
        In8 => DataIn(8),
        -- Salidas de YOLO.  
        DataOut => DataOut,
        validOut => validOut);

    stimulus : PROCESS
    BEGIN
        -- Put initialisation code here
        reset <= '0';
        DataIn <= (OTHERS => (OTHERS => '0'));
        validIN <= '0';
        start <= '0';

        WAIT FOR 5 ns;
        reset <= '1';
        start <= '1';
        validIN <= '1';
        DataIn <= (OTHERS => (OTHERS => '1'));

        WAIT FOR 83066890 ns;

        validIN <= '0';

        WAIT;
    END PROCESS;

    -- Clock process definitions
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

END;