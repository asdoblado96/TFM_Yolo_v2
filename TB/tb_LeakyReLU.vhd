LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY tb_LeakyReLU IS
END tb_LeakyReLU;

ARCHITECTURE tb OF tb_LeakyReLU IS

    COMPONENT LeakyReLU
        PORT (
            datain : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
    END COMPONENT;

    SIGNAL datain : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL dataout : STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN

    dut : LeakyReLU
    PORT MAP(
        datain => datain,
        dataout => dataout);

    stimuli : PROCESS
    BEGIN

        datain <= (OTHERS => '0');
        WAIT FOR 50 ns;

        datain <= "0000000000001010";
        WAIT FOR 50 ns;

        datain <= "1111111111110110";
        WAIT FOR 50 ns;

        datain <= "0000010011101000";
        WAIT FOR 50 ns;

        datain <= "1111101100011000";
        WAIT FOR 50 ns;

        WAIT;
    END PROCESS;

END tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

CONFIGURATION cfg_tb_LeakyReLU OF tb_LeakyReLU IS
    FOR tb
    END FOR;
END cfg_tb_LeakyReLU;