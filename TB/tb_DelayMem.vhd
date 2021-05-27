-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY DelayMem_tb IS
END;

ARCHITECTURE bench OF DelayMem_tb IS

    COMPONENT DelayMem
        GENERIC (
            BL : INTEGER := 1;
            WL : INTEGER := 1
        );
        PORT (
            reset : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            validIn : IN STD_LOGIC;
            Din : IN STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
            Dout : OUT STD_LOGIC_VECTOR(WL - 1 DOWNTO 0));
    END COMPONENT;

    SIGNAL reset : STD_LOGIC;
    SIGNAL clk : STD_LOGIC;
    SIGNAL validIn : STD_LOGIC;
    SIGNAL Din : STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);
    SIGNAL Dout : STD_LOGIC_VECTOR(2 - 1 DOWNTO 0);

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL stop_the_clock : BOOLEAN;

BEGIN

    -- Insert values for generic parameters !!
    uut : DelayMem GENERIC MAP(
        BL => 4,
        WL => 2)
    PORT MAP(
        reset => reset,
        clk => clk,
        validIn => validIn,
        Din => Din,
        Dout => Dout);

    stimulus : PROCESS
    BEGIN

        -- Put initialisation code here
        validIn <= '0';
        Din <= (OTHERS => '0');
        reset <= '0';
        WAIT FOR 5 ns;
        reset <= '1';
        WAIT FOR 5 ns;
        validIn <= '1';
        Din <= "11";
        wait for 10 ns;
        Din <= "01";
        wait for 10 ns;
        Din <= "10";
        wait for 10 ns;
        Din <= "00";
        wait for 10 ns;
        Din <= "10";
        wait for 10 ns;
        Din <= "10";
        wait for 10 ns;

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