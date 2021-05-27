LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ternaryAdder IS
  GENERIC (N : INTEGER := 4); --numero de bits
  PORT (
    A, B, C : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    dataout : OUT STD_LOGIC_VECTOR(N + 1 DOWNTO 0)
  );
END ternaryAdder;

ARCHITECTURE rtl OF ternaryAdder IS

  COMPONENT FA
    PORT (
      in_b1 : IN STD_LOGIC;
      in_b2 : IN STD_LOGIC;
      Cin : IN STD_LOGIC;
      S : OUT STD_LOGIC;
      Cout : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT HA
    PORT (
      in_b1 : IN STD_LOGIC;
      in_b2 : IN STD_LOGIC;
      S : OUT STD_LOGIC;
      Cout : OUT STD_LOGIC
    );
  END COMPONENT;

  SIGNAL carry : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
  SIGNAL m_carry : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
  SIGNAL m_dataout : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
BEGIN

  FALINE : FOR I IN 0 TO (N - 1) GENERATE --vectores de FA

    UX : FA PORT MAP(
      in_b1 => A(I), --entrada 1
      in_b2 => B(I), --entrada 2
      Cin => C(I), --entrada 3
      S => m_dataout(I), --salida intermedia
      Cout => m_carry(I) --carry intermedio
    );
  END GENERATE FALINE;

  dataout(0) <= m_dataout(0); --salida final(0)

  VMA_LOWER_BIT : HA --primer elemento del VMA
  PORT MAP(
    in_b1 => m_carry(0), --carry intermedio
    in_b2 => m_dataout(1), --salida intermedia
    S => dataout(1), --salida final (1)
    Cout => carry(0) --carry final (0)
  );
  VMA_UPPER_BIT : HA --último elemento del VMA
  PORT MAP(
    in_b1 => m_carry(N - 1), --carry intermedio
    in_b2 => carry(N - 2), --salida intermedia
    S => dataout(N), --salida final (N)
    Cout => dataout(N + 1) --salida final (N+1)
  );

  GEN_VMA_MIDDLE : FOR I IN 0 TO (N - 3) GENERATE --elementos intermedios del VMA

    VMA_MIDDLE : FA PORT MAP(
      in_b1 => carry(I), --carry anterior
      in_b2 => m_carry(I + 1), --carry intermedio
      Cin => m_dataout(I + 2), --salida intermedia
      S => dataout(I + 2), --salidas finales
      Cout => carry(I + 1) --carry final
    );
  END GENERATE GEN_VMA_MIDDLE;

END rtl;