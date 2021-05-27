LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--Bloque de datapath para el MaxPooling

ENTITY MaxPoolDP IS
    GENERIC (
        Layer : INTEGER := 1);
    PORT (
        clk, reset : IN STD_LOGIC;

        val_d1 : IN STD_LOGIC;
        enLBuffer : IN STD_LOGIC;

        datain : IN STD_LOGIC_VECTOR(5 DOWNTO 0);

        dataout : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
END ENTITY MaxPoolDP;

ARCHITECTURE rtl OF MaxPoolDP IS

    CONSTANT rst_val : STD_LOGIC := '0';
    CONSTANT WL : INTEGER := 6; -- Word Length
    CONSTANT BL : INTEGER := ((filters(layer)/kernels(layer)) * columns(layer)/2);

    COMPONENT DelayMem
        GENERIC (
            BL : INTEGER := 1; -- Buffer Length
            WL : INTEGER := 1 -- Word Length
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            validIn : IN STD_LOGIC;
            Din : IN STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);
            Dout : OUT STD_LOGIC_VECTOR((WL - 1) DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT zeroes : STD_LOGIC_VECTOR((WL - 2) DOWNTO 0):=(OTHERS=>'0');

    SIGNAL s_datain : SIGNED((WL - 1) DOWNTO 0);

    SIGNAL max1, max2 : SIGNED((WL - 1) DOWNTO 0);

    SIGNAL d1 : STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);
    SIGNAL sd1 : SIGNED((WL - 1) DOWNTO 0);
    SIGNAL LBo : STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);
    SIGNAL sLBo : SIGNED((WL - 1) DOWNTO 0);
BEGIN

    s_datain <= SIGNED(datain);
    sLBo <= signed(LBo);
    sd1 <= signed(d1);

    sec : PROCESS (clk, reset)
    BEGIN
        IF reset = '0' THEN

            d1 <= '1' & zeroes; --menor posible

        ELSIF rising_edge(clk) THEN

            IF val_d1 = '1' THEN
                d1 <= datain;
            END IF;

        END IF;

    END PROCESS sec;

    MAX1p : PROCESS (sd1, s_datain)
    BEGIN
        IF (sd1 > s_datain) THEN
            max1 <= sd1;
        ELSE
            max1 <= s_datain;
        END IF;
    END PROCESS MAX1p;

    LinBuff : DelayMem
    GENERIC MAP(
        BL => BL, WL => WL)
    PORT MAP(
        clk => clk,
        reset => reset,
        validIn => enLBuffer,
        Din => STD_LOGIC_VECTOR(max1),
        Dout => LBo
    );
    
    MAX2p : PROCESS (sLBo, max1)
    BEGIN
        IF (sLBo > max1) THEN
            max2 <= sLBo;
        ELSE
            max2 <= max1;
        END IF;
    END PROCESS MAX2p;

    dataout <= STD_LOGIC_VECTOR(max2);

END ARCHITECTURE rtl;