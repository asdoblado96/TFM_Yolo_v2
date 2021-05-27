-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

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
      layer : INTEGER := 4);
    PORT (
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      start : IN STD_LOGIC;
      we : IN STD_LOGIC;
      rMem : OUT unsigned(bits(kernels(1)) - 1 DOWNTO 0);
      rMemOdd : OUT STD_LOGIC;
      address0 : OUT unsigned(bitsAddress(1) - 1 DOWNTO 0);
      address1 : OUT unsigned(bitsAddress(1) - 1 DOWNTO 0);
      address2 : OUT unsigned(bitsAddress(1) - 1 DOWNTO 0);
      padding : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      kernelCol : OUT unsigned(1 DOWNTO 0);
      kernelRow : OUT unsigned(1 DOWNTO 0);
      enableKernel : OUT STD_LOGIC;
      validOut : OUT STD_LOGIC;
      weRAM : OUT STD_LOGIC;
      wMemOdd : OUT STD_LOGIC;
      wBank : OUT unsigned(3 DOWNTO 0);
      waddress : OUT unsigned(bitsAddress(1) - 1 DOWNTO 0));
  END COMPONENT;

  SIGNAL clk : STD_LOGIC;
  SIGNAL reset : STD_LOGIC;
  SIGNAL start : STD_LOGIC;
  SIGNAL we : STD_LOGIC;
  SIGNAL rMem : unsigned(bits(kernels(1)) - 1 DOWNTO 0);
  SIGNAL rMemOdd : STD_LOGIC;
  SIGNAL address0 : unsigned(bitsAddress(1) - 1 DOWNTO 0);
  SIGNAL address1 : unsigned(bitsAddress(1) - 1 DOWNTO 0);
  SIGNAL address2 : unsigned(bitsAddress(1) - 1 DOWNTO 0);
  SIGNAL padding : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL kernelCol : unsigned(1 DOWNTO 0);
  SIGNAL kernelRow : unsigned(1 DOWNTO 0);
  SIGNAL enableKernel : STD_LOGIC;
  SIGNAL validOut : STD_LOGIC;
  SIGNAL weRAM : STD_LOGIC;
  SIGNAL wMemOdd : STD_LOGIC;
  SIGNAL wBank : unsigned(3 DOWNTO 0);
  SIGNAL waddress : unsigned(bitsAddress(1) - 1 DOWNTO 0);

  CONSTANT clock_period : TIME := 10 ns;
  SIGNAL stop_the_clock : BOOLEAN;

BEGIN

  -- Insert values for generic parameters !!
  uut : MemControl GENERIC MAP(layer => 1)
  PORT MAP(
    clk => clk,
    reset => reset,
    start => start,
    we => we,
    rMem => rMem,
    rMemOdd => rMemOdd,
    address0 => address0,
    address1 => address1,
    address2 => address2,
    padding => padding,
    kernelCol => kernelCol,
    kernelRow => kernelRow,
    enableKernel => enableKernel,
    validOut => validOut,
    weRAM => weRAM,
    wMemOdd => wMemOdd,
    wBank => wBank,
    waddress => waddress);

  stimulus : PROCESS
  BEGIN

    -- Put initialisation code here

    reset <= '0';
    WAIT FOR 5 ns;
    reset <= '1';
    WAIT FOR 50 ns;
    start <= '1';
    we <= '1';

    WAIT FOR 5000000 ms;
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