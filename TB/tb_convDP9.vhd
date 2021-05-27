LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY ConvDP9_tb IS
END;

ARCHITECTURE bench OF ConvDP9_tb IS

    COMPONENT ConvDP9
        GENERIC (layer : INTEGER := 1);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            datain : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            Weights : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            BIAS : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            startLbuffer : IN STD_LOGIC;
            enableLbuffer : IN STD_LOGIC;
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL clk : STD_LOGIC;
    SIGNAL stop_the_clock : BOOLEAN;
    SIGNAL reset : STD_LOGIC;
    SIGNAL datain : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL Weights : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL BIAS : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL startLbuffer : STD_LOGIC;
    SIGNAL enableLbuffer : STD_LOGIC;
    SIGNAL dataout : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    -- Insert values for generic parameters !!
    uut : ConvDP9 GENERIC MAP(layer => 9)
    PORT MAP(
        clk => clk,
        reset => reset,
        datain => datain,
        Weights => Weights,
        BIAS => BIAS,
        startLbuffer => startLbuffer,
        enableLbuffer => enableLbuffer,
        dataout => dataout);

    clocking : PROCESS
    BEGIN
        WHILE NOT stop_the_clock LOOP
            clk <= '0', '1' AFTER clock_period / 2;
            WAIT FOR clock_period;
        END LOOP;
        WAIT;
    END PROCESS;

    stimulus : PROCESS
    BEGIN

        -- Put initialisation code here
        reset <= '0';
        datain <= (others => '0');
        Weights <= (others => '0');
        Bias <= (others => '0');
        startLbuffer <= '1';
        enableLBuffer <= '0';

        wait for 45 ns;
        -- Put test bench stimulus code here
        reset <= '1';
        datain <= "110011";
        Weights <= "10001100";
        Bias <= "0000110001001010";
        startLbuffer <= '1';
        enableLBuffer <= '1';

        wait for 130 ns;

        datain <= "000011";
        Weights <= "00000001";
        Bias <= "0000110001001010";
        startLbuffer <= '0';
        enableLBuffer <= '1';

        wait for 45 ns;


        WAIT;
    END PROCESS;
END;