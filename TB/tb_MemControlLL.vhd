LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY MemControl_tb IS
END;

ARCHITECTURE bench OF MemControl_tb IS

  COMPONENT MemControl
    GENERIC (
      layer : INTEGER := 9);
    PORT (
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      start : IN STD_LOGIC;
      we : IN STD_LOGIC;
      weRAM : OUT STD_LOGIC;
      wMemOdd : OUT STD_LOGIC;
      wBank : OUT unsigned(3 DOWNTO 0);
      waddress : OUT unsigned(bitsAddress(8) - 1 DOWNTO 0);
      rMem : OUT unsigned(bits(kernels(8)) - 1 DOWNTO 0);
      rMemOdd : OUT STD_LOGIC;
      raddress : OUT unsigned(bitsAddress(8) - 1 DOWNTO 0);
      validOut : OUT STD_LOGIC
    );
  END COMPONENT;

  SIGNAL clk : STD_LOGIC;
  SIGNAL reset : STD_LOGIC;
  SIGNAL start : STD_LOGIC;
  SIGNAL we : STD_LOGIC;
  SIGNAL weRAM : STD_LOGIC;
  SIGNAL wMemOdd : STD_LOGIC;
  SIGNAL wBank : unsigned(3 DOWNTO 0);
  SIGNAL waddress : unsigned(bitsAddress(8) - 1 DOWNTO 0);
  SIGNAL rMem : unsigned(bits(kernels(8)) - 1 DOWNTO 0);
  SIGNAL rMemOdd : STD_LOGIC;
  SIGNAL raddress : unsigned(bitsAddress(8) - 1 DOWNTO 0);
  SIGNAL validOut : STD_LOGIC;

  CONSTANT clock_period : TIME := 10 ns;
  SIGNAL stop_the_clock : BOOLEAN;

BEGIN

  -- Insert values for generic parameters !!
  uut : MemControl GENERIC MAP(layer => 8)
  PORT MAP(
    clk => clk,
    reset => reset,
    start => start,
    we => we,
    weRAM => weRAM,
    wMemOdd => wMemOdd,
    wBank => wBank,
    waddress => waddress,
    rMem => rMem,
    rMemOdd => rMemOdd,
    raddress => raddress,
    validOut => validOut);

  stimulus : PROCESS
  BEGIN

    -- Put initialisation code here

    reset <= '0';
    we <= '0';
    WAIT FOR 5 ns;
    reset <= '1';
    WAIT FOR 5 ns;

    -- Put test bench stimulus code here
    start <= '1';
    we <= '1';

    WAIT;

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