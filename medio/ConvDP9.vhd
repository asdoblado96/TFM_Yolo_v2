LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--Bloque de datapath para la convolucion de la última capa

ENTITY ConvDP9 IS
    GENERIC (layer : INTEGER := 1);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        datain : IN STD_LOGIC_VECTOR(5 DOWNTO 0); --datos de 6 bits
        Weights : IN STD_LOGIC_VECTOR(7 DOWNTO 0); --pesos de 8 bits
        BIAS: IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        startLbuffer : IN STD_LOGIC;
        enableLbuffer : IN STD_LOGIC;

        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) --salida de 16
    );
END ENTITY ConvDP9;

ARCHITECTURE rtl OF ConvDP9 IS

    CONSTANT bits : INTEGER := 14;
    CONSTANT WL : INTEGER := bufferwidth(layer); -- Word Length
    CONSTANT columns : INTEGER := columns(layer);

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

    SIGNAL Sdatain : SIGNED(5 DOWNTO 0);
    SIGNAL Sweights : SIGNED(7 DOWNTO 0);

    SIGNAL sout_weight_mul : SIGNED(13 DOWNTO 0);
    SIGNAL out_weight_mul : STD_LOGIC_VECTOR(125 DOWNTO 0);

    SIGNAL out_mux_buffer : STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
    SIGNAL sout_mux_buffer : signed (WL - 1 DOWNTO 0);

    SIGNAL in_buffer : STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
    SIGNAL out_buffer : STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
    SIGNAL sout_buffer : SIGNED(WL - 1 DOWNTO 0);
    SIGNAL SBIAS: SIGNED(15 DOWNTO 0);

    SIGNAL out_add : STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
BEGIN

    --WEIGHT MULTIPLICATION-------------------------------------------------------
    sDataIn <= signed(datain);
    sWeights <= signed(Weights);

    sout_weight_mul <= SdataIn * sWeights;

    --LB BUFFER------------------------------------------------------------------

    --MUX
    muxBuffer : PROCESS (startLbuffer, out_buffer)
    BEGIN
        CASE startLbuffer IS
            WHEN '1' =>
                out_mux_buffer <= (OTHERS => '0');
            WHEN OTHERS =>
                out_mux_buffer <= out_buffer;
        END CASE;
    END PROCESS muxBuffer;

    sout_mux_buffer <= SIGNED(out_mux_buffer);

    in_buffer <= STD_LOGIC_VECTOR(sout_weight_mul + sout_mux_buffer);

    --BUFFER
    LinBuff : DelayMem
    GENERIC MAP(
        BL => columns, WL => WL)
    PORT MAP(
        clk => clk,
        reset => reset,
        validIn => enableLbuffer,
        Din => in_buffer,
        Dout => out_buffer
    );

    --Bias ADD-----------------------------------------------------
    SBIAS<=SIGNED(BIAS);
    out_add <= STD_LOGIC_VECTOR(signed(out_buffer) + SBIAS);

    --OUTPUT-----------------------------------------------------
    dataout <= out_add(WL-1 DOWNTO WL-16);

END ARCHITECTURE rtl;