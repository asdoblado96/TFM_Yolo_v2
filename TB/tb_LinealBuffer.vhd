LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY LinealBuffer_tb IS
END;

ARCHITECTURE bench OF LinealBuffer_tb IS

    COMPONENT LinealBuffer
        GENERIC (
            BL : INTEGER := 10;
            WL : INTEGER := 10
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            enable_LBuffer : IN STD_LOGIC;
            datain : IN STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR((WL - 1) DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clk,reset : STD_LOGIC;
    SIGNAL enable_LBuffer : STD_LOGIC;
    SIGNAL datain : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL dataout : STD_LOGIC_VECTOR(1 DOWNTO 0);

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL stop_the_clock : BOOLEAN;

BEGIN

    -- Insert values for generic parameters !!
    uut : LinealBuffer GENERIC MAP(
        BL => 4,
        WL => 2)
    PORT MAP(
        clk => clk,
        reset => reset,
        enable_LBuffer => enable_LBuffer,
        datain => datain,
        dataout => dataout);

    stimulus : PROCESS
    BEGIN

        -- Put initialisation code here
        reset <= '0';
        enable_LBuffer <= '0';
        datain <= (OTHERS => '0');
        WAIT FOR clock_period;

        -- Put test bench stimulus code here
        reset <= '1';
        enable_LBuffer <= '1';
        datain <= "01";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        datain <= "11";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        datain <= "00";
        WAIT FOR clock_period;
        enable_LBuffer <= '0';
        datain <= "00";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        datain <= "01";
        WAIT FOR clock_period;
        enable_LBuffer <= '0';
        datain <= "00";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        datain <= "00";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        datain <= "11";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        datain <= "00";
        WAIT FOR clock_period;
        enable_LBuffer <= '0';
        datain <= "00";
        WAIT FOR clock_period;
        enable_LBuffer <= '1';
        datain <= "01";
        WAIT FOR clock_period;
        enable_LBuffer <= '0';
        datain <= "00";
        WAIT FOR clock_period;
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