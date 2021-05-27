LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_ternaryAdder IS
END tb_ternaryAdder;

ARCHITECTURE tb OF tb_ternaryAdder IS

    COMPONENT ternaryAdder
    GENERIC(N: INTEGER);
        PORT (
            A, B, C : IN STD_LOGIC_VECTOR((N - 1) DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR((N + 1) DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL A,B,C : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL dataout : STD_LOGIC_VECTOR(5 DOWNTO 0);

BEGIN

    dut : ternaryAdder
    GENERIC MAP (N =>4)
    PORT MAP(
        A => A,
        B => B,
        C => C,
        dataout => dataout);

    stimuli : PROCESS
    BEGIN
        -- EDIT Adapt initialization as needed
        A <= "0000";
        B <= "0000";
        C <= "0000";

        WAIT FOR 100 ns;
        A <= "0100";
        B <= "0010";
        C <= "0001";

        WAIT FOR 100 ns;
        A <= "1110";
        B <= "1010";
        C <= "0001";

        WAIT FOR 100 ns;
        A <= "0100";
        B <= "0010";
        C <= "1111";

        WAIT;
    END PROCESS;

END tb;