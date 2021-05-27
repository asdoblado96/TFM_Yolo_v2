LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY MemDP_tb IS
END;

ARCHITECTURE bench OF MemDP_tb IS

    COMPONENT MemDP
        GENERIC (
            layer : INTEGER := 4);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            Din : IN STD_LOGIC_VECTOR((kernels(layer) * 6) - 1 DOWNTO 0);
            rMem : IN unsigned(bits(kernels(layer)) - 1 DOWNTO 0);
            rMemOdd : IN STD_LOGIC;
            address0 : IN unsigned(bitsAddress(layer) - 1 DOWNTO 0);
            address1 : IN unsigned(bitsAddress(layer) - 1 DOWNTO 0);
            address2 : IN unsigned(bitsAddress(layer) - 1 DOWNTO 0);
            oe : IN STD_LOGIC;
            padding : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            kernelCol : IN unsigned(1 DOWNTO 0);
            kernelRow : IN unsigned(1 DOWNTO 0);
            we : IN STD_LOGIC;
            wMemOdd : IN STD_LOGIC;
            wBank : IN unsigned(3 DOWNTO 0);
            waddress : IN unsigned(bitsAddress(layer) - 1 DOWNTO 0);
            Dout : OUT STD_LOGIC_VECTOR((9 * 6) - 1 DOWNTO 0));
    END COMPONENT;
    

    SIGNAL clk : STD_LOGIC;
        CONSTANT clock_period : TIME := 10 ns;
    SIGNAL stop_the_clock : BOOLEAN;
    SIGNAL reset : STD_LOGIC;
    SIGNAL Din : STD_LOGIC_VECTOR((kernels(1) * 6) - 1 DOWNTO 0);
    SIGNAL rMem : unsigned(bits(kernels(1)) - 1 DOWNTO 0);
    SIGNAL rMemOdd : STD_LOGIC;
    SIGNAL address0 : unsigned(bitsAddress(1) - 1 DOWNTO 0);
    SIGNAL address1 : unsigned(bitsAddress(1) - 1 DOWNTO 0);
    SIGNAL address2 : unsigned(bitsAddress(1) - 1 DOWNTO 0);
    SIGNAL oe : STD_LOGIC;
    SIGNAL padding : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL kernelCol : unsigned(1 DOWNTO 0);
    SIGNAL kernelRow : unsigned(1 DOWNTO 0);
    SIGNAL we : STD_LOGIC;
    SIGNAL wMemOdd : STD_LOGIC;
    SIGNAL wBank : unsigned(3 DOWNTO 0);
    SIGNAL waddress : unsigned(bitsAddress(1) - 1 DOWNTO 0);
    SIGNAL Dout : STD_LOGIC_VECTOR((9 * 6) - 1 DOWNTO 0);

BEGIN

    -- Insert values for generic parameters !!
    uut : MemDP GENERIC MAP(layer => 1)
    PORT MAP(
        clk => clk,
        reset => reset,
        Din => Din,
        rMem => rMem,
        rMemOdd => rMemOdd,
        address0 => address0,
        address1 => address1,
        address2 => address2,
        oe => oe,
        padding => padding,
        kernelCol => kernelCol,
        kernelRow => kernelRow,
        we => we,
        wMemOdd => wMemOdd,
        wBank => wBank,
        waddress => waddress,
        Dout => Dout);

    stimuli : PROCESS
    BEGIN
        -- EDIT Adapt initialization as needed
        --OE <= '0';
        --rmemodd <= '0';
        --rMem <= to_unsigned(0, bits(kernels(2)));
        --address0 <= to_unsigned(0, bitsAddress(2));
        --address1 <= to_unsigned(1, bitsAddress(2));
        --address2 <= to_unsigned(2, bitsAddress(2));
--
        --padding <= (OTHERS => '0');
        --kernelCol <= (OTHERS => '0');
        --kernelRow <= (OTHERS => '0');
--
        --Din <= "000001"&"111111";
--
        --we <= '0';
        --wMemOdd <= '0';
        --wBank <= (OTHERS => '0');
        --waddress <= (OTHERS => '0');

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '0';
        WAIT FOR 100 ns;
        reset <= '1';
        WAIT FOR 100 ns;

        ---- EDIT Add stimuli here
        --we <= '1';
        --wmemodd <= '1';
        --wbank <= "0011";
        --waddress <= (others => '0');
        --wait for 10 ns;
        --we <= '0';
        --rmem <= (others => '0');
        --rmemodd <= '1';
        --address0 <= (others => '0');
        --address1 <= (others => '0');
        --address2 <= (others => '0');
        --oe <= '1';
        --padding <= (others => '0');
        --wait for 10 ns;
        --rmem <= "01";
        --rmemodd <= '1';
        --address0 <= (others => '0');
        --address1 <= (others => '0');
        --address2 <= (others => '0');
        --oe <= '1';
        --padding <= (others => '0');
        --wait for 10 ns;

        WAIT FOR 100 * clock_period;

        -- Stop the clock and hence terminate the simulation
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