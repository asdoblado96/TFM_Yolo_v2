LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY Layer_tb IS
END;

ARCHITECTURE bench OF Layer_tb IS

    COMPONENT Layer
        GENERIC (L : INTEGER := 2);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            datain : IN STD_LOGIC_VECTOR ((grid(L) * 6) - 1 DOWNTO 0);
            weights : IN STD_LOGIC_VECTOR ((kernels(L) * (grid(L))) - 1 DOWNTO 0);
            bias : IN signed ((kernels(L) * 2 * 16) - 1 DOWNTO 0);
            start : IN STD_LOGIC;
            dataout : OUT signed ((kernels(L) * 6) - 1 DOWNTO 0));
    END COMPONENT;

    SIGNAL clk : STD_LOGIC;
    SIGNAL reset : STD_LOGIC;
    SIGNAL datain : STD_LOGIC_VECTOR (((9 * 6) - 1) DOWNTO 0);
    SIGNAL weights : STD_LOGIC_VECTOR ((2 * 9) - 1 DOWNTO 0);
    SIGNAL bias : signed ((2 * 2 * 16) - 1 DOWNTO 0);
    SIGNAL start : STD_LOGIC;
    SIGNAL dataout : signed ((2 * 6) - 1 DOWNTO 0);

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL stop_the_clock : BOOLEAN;

BEGIN

    -- Insert values for generic parameters !!
    uut : Layer GENERIC MAP(L => 5)
    PORT MAP(
        clk => clk,
        reset => reset,
        datain => datain,
        weights => weights,
        bias => bias,
        start => start,
        dataout => dataout);

    stimulus : PROCESS
    BEGIN

        -- Put initialisation code here

        reset <= '0';
        start <= '0';
        datain <= (OTHERS => '0');
        weights <= (OTHERS => '0');
        bias <= (OTHERS => '0');
        WAIT FOR 10 ns;

        -- Put test bench stimulus code here

        reset <= '1';
        WAIT FOR 20 ns;

        start <= '1';
        WAIT FOR 1 ms;
        reset <= '0';
        wait for 10 ns;
        stop_the_clock <= true;
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