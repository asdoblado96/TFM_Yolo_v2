LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY tb_ConvControl IS
END;

ARCHITECTURE bench OF tb_ConvControl IS

  COMPONENT ConvControl
    GENERIC (
      layer : INTEGER
    );
    PORT (
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      validIn : IN STD_LOGIC;

      startLBuffer : OUT STD_LOGIC;
      enableLBuffer : OUT STD_LOGIC;
      validOut : OUT STD_LOGIC;
      addressweight : OUT unsigned(weightsbitsAddress(LAYER) - 1 DOWNTO 0);
        addressbn : OUT unsigned(bits(filters(layer)/kernels(layer) - 1) - 1 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL clk : STD_LOGIC;
  SIGNAL reset : STD_LOGIC;
  SIGNAL validIn : STD_LOGIC;
  SIGNAL startLBuffer : STD_LOGIC;
  SIGNAL enableLBuffer : STD_LOGIC;
  SIGNAL validOut : STD_LOGIC;
  SIGNAL addressweight : unsigned(weightsbitsAddress(1) - 1 DOWNTO 0);
  SIGNAL addressbn : unsigned(bits(filters(1)/kernels(1) - 1) - 1 DOWNTO 0);

  CONSTANT clock_period : TIME := 10 ns;
  SIGNAL stop_the_clock : BOOLEAN;

BEGIN

  -- Insert values for generic parameters !!
  uut : ConvControl GENERIC MAP(
    layer => 1)
  PORT MAP(
    clk => clk,
    reset => reset,
    validIn => validIn,
    startLBuffer => startLBuffer,
    enableLBuffer => enableLBuffer,
    validOut => validOut,
    addressweight => addressweight,
    addressbn => addressbn);

  stimulus : PROCESS
  BEGIN

    -- Put initialisation code here
    reset <= '0';
    validIn <= '0';
    WAIT FOR 20 ns;
    -- Put test bench stimulus code here

    reset <= '1';

    WAIT FOR 15 ns;

    validIn <= '1';

    WAIT FOR 1000 ms;

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