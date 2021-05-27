LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY CVLayer_tb IS
END;

ARCHITECTURE bench OF CVLayer_tb IS

    COMPONENT CVLayer
        GENERIC (Layer : INTEGER := 2);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            datain : IN STD_LOGIC_VECTOR ((grid(Layer) * 6) - 1 DOWNTO 0);
            weights : IN STD_LOGIC_VECTOR (grid(Layer) - 1 DOWNTO 0);
            bias : IN signed ((2 * 16) - 1 DOWNTO 0);
            validIn : IN STD_LOGIC;
            dataout : OUT STD_LOGIC_VECTOR (5 DOWNTO 0));
    END COMPONENT;

    SIGNAL clk : STD_LOGIC;
    SIGNAL reset : STD_LOGIC;
    SIGNAL datain : STD_LOGIC_VECTOR (9 * 6 - 1 DOWNTO 0);
    SIGNAL weights : STD_LOGIC_VECTOR (9 - 1 DOWNTO 0);
    SIGNAL bias : signed ((2 * 16) - 1 DOWNTO 0);
    SIGNAL validIn : STD_LOGIC;
    SIGNAL dataout : STD_LOGIC_VECTOR (5 DOWNTO 0);

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL stop_the_clock : BOOLEAN;
BEGIN

    -- Insert values for generic parameters !!
    uut : CVLayer GENERIC MAP(Layer => 8)
    PORT MAP(
        clk => clk,
        reset => reset,
        datain => datain,
        weights => weights,
        bias => bias,
        validIn => validIn,
        dataout => dataout);

    stimulus : PROCESS
    BEGIN

        -- Put initialisation code here
        reset <= '0';
        dataIn <= (OTHERS => '1');
        weights <= "100111001";
        bias <= "00011101101001010111110001110010";
        validIn <= '0';

        WAIT FOR 45 ns;

        -- Put test bench stimulus code here
        reset <= '1';
        WAIT FOR 50 ns;
        validIn <= '1';
        wait for 1500 us;
        dataIn <= (OTHERS => '0');

        WAIT;
    END PROCESS;

    clocking : PROCESS
    BEGIN
      WHILE NOT stop_the_clock LOOP
        clk <= '0', '1' AFTER clock_period / 2;
        WAIT FOR clock_period;
      END LOOP;
      WAIT;
    END PROCESS;
END;