LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY MaxPoolControl_tb IS
END;

ARCHITECTURE bench OF MaxPoolControl_tb IS

    COMPONENT MaxPoolControl
        GENERIC (
            layer : INTEGER
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            validIn : IN STD_LOGIC;
            val_d1 : OUT STD_LOGIC;
            enLBuffer : OUT STD_LOGIC;
            validOut : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC;
    SIGNAL reset : STD_LOGIC;
    SIGNAL validIn : STD_LOGIC;
    SIGNAL val_d1 : STD_LOGIC;
    SIGNAL enLBuffer : STD_LOGIC;
    SIGNAL validOut : STD_LOGIC;

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL stop_the_clock : BOOLEAN;

BEGIN

    -- Insert values for generic parameters !!
    uut : MaxPoolControl GENERIC MAP(
        Layer => 5)
    PORT MAP(
        clk => clk,
        reset => reset,
        validIn => validIn,
        val_d1 => val_d1,
        enLBuffer => enLBuffer,
        validOut => validOut);

    stimulus : PROCESS
    BEGIN

        -- Put initialisation code here
        reset <= '0';
        validIn <= '0';
        -- Put test bench stimulus code here

        wait for 20 ns;

        reset <= '1';

        wait for 15 ns;

        validIn <= '1';

        wait for 1 us;

        validIn <= '0';

        wait for 40 ns;

        validIn <= '1';
        
        wait for 500000000 us;

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