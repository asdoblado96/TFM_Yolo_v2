LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY MaxPoolLayer_tb IS
END;

ARCHITECTURE bench OF MaxPoolLayer_tb IS

  COMPONENT MaxPoolLayer
    GENERIC (
      BL : INTEGER := 2;
      WL : INTEGER := 4;
      step : INTEGER := 2
    );
    PORT (
      clk, reset : IN STD_LOGIC;
      col_odd, row_odd : IN STD_LOGIC;
      Hc, count_row, count_col : IN INTEGER;
      dataval : OUT STD_LOGIC;
      datain : IN STD_LOGIC_VECTOR((WL - 1) DOWNTO 0);
      dataout : OUT STD_LOGIC_VECTOR((WL - 1) DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL clk, reset : STD_LOGIC;
  signal HC: integer;
  SIGNAL col_odd, row_odd : STD_LOGIC;
  SIGNAL count_row, count_col : INTEGER;
  SIGNAL dataval : STD_LOGIC;
  SIGNAL datain : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL dataout : STD_LOGIC_VECTOR(3 DOWNTO 0);

  CONSTANT clock_period : TIME := 10 ns;
  SIGNAL stop_the_clock : BOOLEAN;

BEGIN

  uut : MaxPoolLayer GENERIC MAP(BL => 3, WL => 4, step => 1)
  PORT MAP(
    clk => clk,
    reset => reset,
    Hc => Hc,
    col_odd => col_odd,
    row_odd => row_odd,
    count_col => count_col,
    count_row => count_row,
    dataval => dataval,
    datain => datain,
    dataout => dataout);

  stimulus : PROCESS
  BEGIN

    -- Put initialisation code here
    reset <= '0';
    row_odd <= '0';
    col_odd <= '0';
    count_col <= 0;
    count_row <= 0;
    Hc <= 4;
    WAIT FOR 45 ns;

    -- Put test bench stimulus code here
    reset <= '1';

    datain <= "1111";
    col_odd <= '1';
    row_odd <= '1';
    count_row <= 1;
    count_col <= 1;
    WAIT FOR clock_period;

    datain <= "1101";
    col_odd <= '0';
    count_col <= 2;

    WAIT FOR clock_period;

    datain <= "0011";
    col_odd <= '1';
    count_col <= 3;

    WAIT FOR clock_period;

    datain <= "0111";
    col_odd <= '0';
    count_col <= 4;

    WAIT FOR clock_period;

    datain <= "1101";
    col_odd <= '1';
    row_odd <= '0';
    count_col <= 1;
    count_row <= 2;

    WAIT FOR clock_period;

    datain <= "1010";
    col_odd <= '0';
    count_col <= 2;

    WAIT FOR clock_period;

    datain <= "0010";
    col_odd <= '1';
    count_col <= 3;

    WAIT FOR clock_period;

    datain <= "0001";
    col_odd <= '0';
    count_col <= 4;

    WAIT FOR clock_period;

    datain <= "0100";
    col_odd <= '1';
    row_odd <= '1';
    count_col <= 1;
    count_row <= 3;

    WAIT FOR clock_period;

    datain <= "0001";
    col_odd <= '0';
    count_col <= 2;

    WAIT FOR clock_period;

    datain <= "1011";
    col_odd <= '1';
    count_col <= 3;

    WAIT FOR clock_period;

    datain <= "0001";
    col_odd <= '0';
    count_col <= 4;

    WAIT FOR clock_period;

    datain <= "1111";
    col_odd <= '1';
    row_odd <= '0';
    count_col <= 1;
    count_row <= 4;

    WAIT FOR clock_period;

    datain <= "1100";
    col_odd <= '0';
    count_col <= 2;

    WAIT FOR clock_period;

    datain <= "0111";
    col_odd <= '1';
    count_col <= 3;

    WAIT FOR clock_period;

    datain <= "0000";
    col_odd <= '0';
    count_col <= 4;

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