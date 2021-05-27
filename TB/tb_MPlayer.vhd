-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY MPLayer_tb IS
END;

ARCHITECTURE bench OF MPLayer_tb IS

    COMPONENT MPLayer
        GENERIC (layer : INTEGER := 1);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            dataIN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            validIN : IN STD_LOGIC;
            dataOUT : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            validOUT : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL clk : STD_LOGIC;
    SIGNAL reset : STD_LOGIC;
    SIGNAL dataIN : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL validIN : STD_LOGIC;
    SIGNAL dataOUT : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL validOUT : STD_LOGIC;

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL stop_the_clock : BOOLEAN;
BEGIN

    -- Insert values for generic parameters !!
    uut : MPLayer GENERIC MAP(layer =>2)
    PORT MAP(
        clk => clk,
        reset => reset,
        dataIN => dataIN,
        validIN => validIN,
        dataOUT => dataOUT,
        validOUT => validOUT);

    stimulus : PROCESS
    BEGIN

        -- Put initialisation code here
        reset <= '0';
        dataIn <= (OTHERS => '1');
        validIn <= '0';

        WAIT FOR 45 ns;

        -- Put test bench stimulus code here
        reset <= '1';
        WAIT FOR 50 ns;
        validIn <= '1';
        wait for 100 ns;
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