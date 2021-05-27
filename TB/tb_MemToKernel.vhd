LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY tb_MemToKernel IS
END tb_MemToKernel;

ARCHITECTURE tb OF tb_MemToKernel IS

    COMPONENT MemToKernel
        GENERIC (
            layer : INTEGER := 1);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            oe : IN STD_LOGIC;
            padding : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            kernelCol : IN INTEGER;
            kernelRow : IN INTEGER;
            Din : IN STD_LOGIC_VECTOR ((grid(layer) * bits(layer)) - 1 DOWNTO 0);
            Dout : OUT STD_LOGIC_VECTOR (((grid(layer) * bits(layer))) - 1 DOWNTO 0));
    END COMPONENT;

    SIGNAL clk : STD_LOGIC;
    SIGNAL reset : STD_LOGIC;
    SIGNAL oe : STD_LOGIC;
    SIGNAL padding : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL kernelCol : INTEGER;
    SIGNAL kernelRow : INTEGER;
    SIGNAL Din : STD_LOGIC_VECTOR (9*6 - 1 DOWNTO 0);
    SIGNAL Dout : STD_LOGIC_VECTOR (9*6  - 1 DOWNTO 0);

    CONSTANT TbPeriod : TIME := 10 ns; -- EDIT Put right period here
    SIGNAL TbClock : STD_LOGIC := '0';
    SIGNAL TbSimEnded : STD_LOGIC := '0';

BEGIN

    dut : MemToKernel GENERIC MAP(layer => 10)
    PORT MAP(
        clk => clk,
        reset => reset,
        oe => oe,
        padding => padding,
        kernelCol => kernelCol,
        kernelRow => kernelRow,
        Din => Din,
        Dout => Dout);

    -- Clock generation
    TbClock <= NOT TbClock AFTER TbPeriod/2 WHEN TbSimEnded /= '1' ELSE
        '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : PROCESS
    BEGIN
        -- EDIT Adapt initialization as needed
        oe <= '0';
        padding <= (OTHERS => '0');
        kernelCol <= 0;
        kernelRow <= 0;
        Din <= (OTHERS => '0');

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '0';
        WAIT FOR 10 ns;
        reset <= '1';
        WAIT FOR 10 ns;

        -- EDIT Add stimuli here
        Din <= "001000" & "000111" & "000110" & "000101" & "000100" & "000011" & "000010" & "000001" & "000000";
        oe <= '1';
        kernelCol <= 0;
        padding <= "000";
        WAIT FOR 10 ns;
        kernelCol <= 1;
        WAIT FOR 10 ns;
        kernelCol <= 2;
        WAIT FOR 10 ns;
        kernelCol <= 3;
        WAIT FOR 10 ns;
        kernelCol <= 0;
        kernelRow <= 0;
        padding <= "111";
        WAIT FOR 10 ns;
        kernelRow <= 1;
        WAIT FOR 10 ns;
        kernelRow <= 2;
        WAIT FOR 10 ns;
        kernelRow <= 3;
        WAIT FOR 10 ns;
        kernelCol <= 0;
        kernelRow <= 0;
        padding <= "100";
        WAIT FOR 10 ns;
        kernelRow <= 1;
        WAIT FOR 10 ns;
        kernelRow <= 2;
        WAIT FOR 10 ns;
        kernelRow <= 3;
        WAIT FOR 10 ns;
        kernelCol <= 0;
        kernelRow <= 0;
        padding <= "001";
        WAIT FOR 10 ns;
        kernelRow <= 1;
        WAIT FOR 10 ns;
        kernelRow <= 2;
        WAIT FOR 10 ns;
        kernelRow <= 3;
        WAIT FOR 10 ns;

        WAIT FOR 100 * TbPeriod;
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        WAIT;
    END PROCESS;

END tb;