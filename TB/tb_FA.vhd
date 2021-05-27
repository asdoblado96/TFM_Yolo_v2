LIBRARY ieee;--a
USE ieee.std_logic_1164.ALL;

ENTITY tb_FA IS
END tb_FA;

ARCHITECTURE tb OF tb_FA IS

    COMPONENT FA
        PORT (
            in_b1 : IN STD_LOGIC;
            in_b2 : IN STD_LOGIC;
            Cin : IN STD_LOGIC;
            S : OUT STD_LOGIC;
            Cout : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL in_b1 : STD_LOGIC;
    SIGNAL in_b2 : STD_LOGIC;
    SIGNAL Cin : STD_LOGIC;
    SIGNAL S : STD_LOGIC;
    SIGNAL Cout : STD_LOGIC;

BEGIN

    dut : FA
    PORT MAP(
        in_b1 => in_b1,
        in_b2 => in_b2,
        Cin => Cin,
        S => S,
        Cout => Cout);

    stimuli : PROCESS
    BEGIN
        -- EDIT Adapt initialization as needed
        in_b1 <= '0';
        in_b2 <= '0';
        Cin <= '0';
        WAIT FOR 100 ns;
        in_b1 <= '1';
        in_b2 <= '0';
        Cin <= '0';
        WAIT FOR 100 ns;
        in_b1 <= '1';
        in_b2 <= '1';
        Cin <= '0';
        WAIT FOR 100 ns;
        in_b1 <= '1';
        in_b2 <= '1';
        Cin <= '1';
        WAIT;
    END PROCESS;

END tb;