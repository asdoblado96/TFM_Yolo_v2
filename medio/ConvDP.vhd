LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

--Bloque de datapath para la convolucion

ENTITY ConvDP IS
    GENERIC (layer : INTEGER := 1);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        datain : IN STD_LOGIC_VECTOR((9 * layerbits(layer)) - 1 DOWNTO 0); --vector de datos de entrada
        Weights : IN STD_LOGIC_VECTOR(8 DOWNTO 0); --vector de 9 pesos binarios
        Ynorm : IN signed(15 DOWNTO 0); --coef1 de BN
        Bnorm : IN signed(15 DOWNTO 0); --coef2 de BN

        startLbuffer : IN STD_LOGIC; --mux LB
        enableLbuffer : IN STD_LOGIC;

        dataout : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
END ENTITY ConvDP;

ARCHITECTURE rtl OF ConvDP IS

    CONSTANT bits : INTEGER := layerbits(layer);
    CONSTANT grid : INTEGER := 9;
    CONSTANT WL : INTEGER := bufferwidth(layer); -- ancho del buffer
    CONSTANT columns : INTEGER := columns(layer);

    COMPONENT signedInverse
        GENERIC (N : INTEGER);
        PORT (
            datain : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            Weights : IN STD_LOGIC;
            dataout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT ternaryAdder
        GENERIC (N : INTEGER);
        PORT (
            A, B, C : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(N + 1 DOWNTO 0)
        );
    END COMPONENT;

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

    COMPONENT LeakyReLU
        PORT (
            datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL out_signedInverse : STD_LOGIC_VECTOR((grid * bits) - 1 DOWNTO 0);

    SIGNAL out_teradder1 : STD_LOGIC_VECTOR((3 * (bits + 2)) - 1 DOWNTO 0);

    SIGNAL out_teradder2 : STD_LOGIC_VECTOR(bits + 4 - 1 DOWNTO 0);
    SIGNAL sout_teradder2 : signed(bits + 4 - 1 DOWNTO 0);

    SIGNAL out_mux_buffer : STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
    SIGNAL sout_mux_buffer : signed (WL - 1 DOWNTO 0);

    SIGNAL in_buffer : STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
    SIGNAL out_buffer : STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
    SIGNAL sout_buffer : SIGNED(WL - 1 DOWNTO 0);

    SIGNAL sout_MUL : signed(16 + WL - 1 DOWNTO 0);
    SIGNAL out_MUL : STD_LOGIC_VECTOR(16 + WL - 1 DOWNTO 0);
    SIGNAL qout_MUL : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_leakyReLU : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL out_add : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

    --Weight MUL---------------------------------------------------------------------

    sig_inv : FOR I IN 1 TO 9 GENERATE
        UX : signedInverse
        GENERIC MAP(N => bits)
        PORT MAP(
            datain => datain((I * bits) - 1 DOWNTO (I * bits) - bits),
            Weights => Weights(I - 1),
            dataout => out_signedInverse((I * bits) - 1 DOWNTO (I * bits) - bits)
        );
    END GENERATE sig_inv;

    --FIRST ADDERS-------------------------------------------------------------------

    ter_add1 : ternaryAdder
    GENERIC MAP(N => bits)
    PORT MAP(
        A => out_signedInverse(bits - 1 DOWNTO 0),
        B => out_signedInverse((2 * bits) - 1 DOWNTO bits),
        C => out_signedInverse((3 * bits) - 1 DOWNTO 2 * bits),
        dataout => out_teradder1((bits - 1) + 2 DOWNTO 0)
    );

    ter_add2 : ternaryAdder
    GENERIC MAP(N => bits)
    PORT MAP(
        A => out_signedInverse((4 * bits) - 1 DOWNTO 3 * bits),
        B => out_signedInverse((5 * bits) - 1 DOWNTO 4 * bits),
        C => out_signedInverse((6 * bits) - 1 DOWNTO 5 * bits),
        dataout => out_teradder1(2 * ((bits - 1) + 3) - 1 DOWNTO (bits - 1) + 3)
    );

    ter_add3 : ternaryAdder
    GENERIC MAP(N => bits)
    PORT MAP(
        A => out_signedInverse((7 * bits) - 1 DOWNTO 6 * bits),
        B => out_signedInverse((8 * bits) - 1 DOWNTO 7 * bits),
        C => out_signedInverse((9 * bits) - 1 DOWNTO 8 * bits),
        dataout => out_teradder1(3 * ((bits - 1) + 3) - 1 DOWNTO 2*((bits - 1) + 3))
    );

    --SECOND ADDER----------------------------------------------------------------

    ter_add4 : ternaryAdder
    GENERIC MAP(N => bits + 2)
    PORT MAP(
        A => out_teradder1((bits - 1) + 2 DOWNTO 0),
        B => out_teradder1(2 * ((bits - 1) + 3) - 1 DOWNTO (bits - 1) + 3),
        C => out_teradder1(3 * ((bits - 1) + 3) - 1 DOWNTO 2 * ((bits - 1) + 3)),
        dataout => out_teradder2
    );

    sout_teradder2 <= SIGNED(out_teradder2);

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

    in_buffer <= STD_LOGIC_VECTOR(sout_teradder2 + sout_mux_buffer);

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

    --BATCH NORMALIZATION MUL-----------------------------------------------------
    sout_MUL <= signed(out_buffer) * Ynorm;
    out_MUL <= STD_LOGIC_VECTOR(sout_MUL);
    qout_MUL <= out_MUL(16 + WL - 1 DOWNTO 16 + WL - 16); --quantification

    --Leaky ReLu------------------------------------------------------------------
    f_act : LeakyReLU
    PORT MAP(
        datain => qout_MUL,
        dataout => out_leakyReLU
    );

    --BATCH NORMALIZATION ADD-----------------------------------------------------
    out_add <= STD_LOGIC_VECTOR(signed(out_leakyReLU) + Bnorm);

    --OUTPUT QUANTIFIED-----------------------------------------------------
    dataout <= out_add(15 DOWNTO 10);

END ARCHITECTURE rtl;