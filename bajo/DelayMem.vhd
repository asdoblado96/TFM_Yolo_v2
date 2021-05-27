--Delay implemented with memories.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY DelayMem IS
   GENERIC (
      BL : INTEGER := 1;-- Longitud del buffer
      WL : INTEGER := 1-- Ancho de palabra
   );
   PORT (
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;

      validIn : IN STD_LOGIC;

      Din : IN STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
      Dout : OUT STD_LOGIC_VECTOR(WL - 1 DOWNTO 0));
END DelayMem;

ARCHITECTURE arch OF DelayMem IS

   TYPE memory IS ARRAY (BL - 1 DOWNTO 0) OF STD_LOGIC_VECTOR(WL - 1 DOWNTO 0);
   SIGNAL mem : memory;
   SIGNAL counter : unsigned(bits(BL - 1)-1 DOWNTO 0);

BEGIN

   Control : PROCESS (reset, clk)
   BEGIN
      IF reset = '0' THEN
         counter <= (OTHERS => '0');
      ELSIF rising_edge(clk) THEN
         IF validIn = '1' THEN
            IF counter = to_unsigned(BL - 1, bits(BL - 1)) THEN
               counter <= (OTHERS => '0');
            ELSE
               counter <= counter + 1;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   RW : PROCESS (clk)
   BEGIN
      IF rising_edge(clk) THEN
         IF validIn = '1' THEN
            mem(to_integer(counter)) <= Din;
         END IF;
      END IF;
   END PROCESS;

   Dout <= mem(to_integer(counter));

END arch;