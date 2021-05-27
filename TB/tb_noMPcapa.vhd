LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY tb_noMPcapa IS
END;

ARCHITECTURE bench OF tb_noMPcapa IS

    COMPONENT noMPcapa
        GENERIC (layer : INTEGER := 2);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            start : IN STD_LOGIC);
    END COMPONENT;

    SIGNAL clk : STD_LOGIC;
    SIGNAL reset : STD_LOGIC;
    SIGNAL start : STD_LOGIC;

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL stop_the_clock : BOOLEAN;

BEGIN

    -- Insert values for generic parameters !!
    uut : noMPcapa GENERIC MAP(layer => 9)
    PORT MAP(
        clk => clk,
        reset => reset,
        start => start);

    stimulus : PROCESS
    BEGIN

        -- Put initialisation code here
        reset <= '0';
        start <= '0';

        WAIT FOR 35 ns;
        reset <= '1';
        WAIT FOR 10 ns;

        FOR I IN 1 TO 5000000 LOOP
            start <= '0';
            WAIT FOR 10 ns;
            start <= '1';
            WAIT FOR 130 ns;
        END LOOP;

        -- Put test bench stimulus code here

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