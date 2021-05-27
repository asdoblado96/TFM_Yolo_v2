
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.MATH_REAL.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

LIBRARY STD;
USE STD.TEXTIO.ALL;

ENTITY tb_YOLO IS
END tb_YOLO;

ARCHITECTURE behavior OF tb_YOLO IS

   SIGNAL reset : STD_LOGIC;
   SIGNAL clk : STD_LOGIC;

   CONSTANT clk_period : TIME := 10 ns;

   COMPONENT layer1 IS
      PORT (
      reset : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      validIN : IN STD_LOGIC;
      start : IN STD_LOGIC;
      -- Entradas de YOLO. 
      In0 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      In1 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      In2 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      In3 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      In4 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      In5 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      In6 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      In7 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      In8 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      -- Salidas de YOLO.  
      DataOut : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      validOut : OUT STD_LOGIC);
   END COMPONENT;
   -- Archivos de texto

   FILE entrada : TEXT IS IN "C:\Users\asdob\Google Drive\MUISE\TFM\matlab\ImageIn.txt";
   FILE salida : TEXT IS OUT "C:\Users\asdob\Google Drive\MUISE\TFM\matlab\ImageOut.txt";

   -- Senales de control
   CONSTANT latencia : INTEGER := delaymem(1);

   SIGNAL start : STD_LOGIC;
   SIGNAL ValidIn : STD_LOGIC;

   TYPE imgIN IS ARRAY (0 TO 8) OF STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL DataIn : imgIN;

   SIGNAL DataOut : STD_LOGIC_VECTOR(5 DOWNTO 0);
   SIGNAL validOut : STD_LOGIC;

   SIGNAL simular : STD_LOGIC;

BEGIN

   YOLO : layer1 
   PORT MAP(
      reset => reset,
      start => start,
      clk => clk,
      validIN => validIN,
      -- Entradas de YOLO. 
      In0 => DataIn(0),
      In1 => DataIn(1),
      In2 => DataIn(2),
      In3 => DataIn(3),
      In4 => DataIn(4),
      In5 => DataIn(5),
      In6 => DataIn(6),
      In7 => DataIn(7),
      In8 => DataIn(8),
      -- Salidas de YOLO.  
      DataOut => DataOut,
      validOut => validOut);

reset <= '1', '0' AFTER 10 ns, '1' AFTER 28 ns;

-- Clock process definitions
clk_process : PROCESS
BEGIN
   clk <= '0';
   WAIT FOR clk_period/2;
   clk <= '1';
   WAIT FOR clk_period/2;
END PROCESS;

lectura : PROCESS

   VARIABLE linea_in : line;
   VARIABLE dato : INTEGER;

BEGIN

   simular <= '1';

   WAIT UNTIL reset = '0';
   WAIT UNTIL reset = '1';

   start <= '1';
   validIn <= '1';

   WHILE NOT endfile(entrada) LOOP

      FOR i IN 0 TO 8 LOOP
         readline(entrada, linea_in);
         read(linea_in, dato);
         DataIn(i) <= STD_LOGIC_VECTOR(to_unsigned(dato, 6));
      END LOOP;
      WAIT FOR clk_period;
   END LOOP;

   FOR i IN 0 TO 8 LOOP
      DataIn(i) <= (OTHERS => '0');
   END LOOP;

   WAIT FOR (latencia - 1) * clk_period;
   simular <= '0'; -- dejamos de escribir en el archivo de salida

   WAIT FOR 4 * clk_period;
   readline(entrada, linea_in); -- generamos un error para que pare el simulador

   WAIT;
END PROCESS;

escritura : PROCESS

   VARIABLE dato_salida : INTEGER;
   VARIABLE linea_out : line;

BEGIN
   WAIT FOR (latencia) * clk_period; -- latencia del circuito	 ---- ADJUST ----	

   WHILE simular = '1' LOOP

      IF validOut = '1' THEN
         dato_salida := to_integer(signed(DataOut));
         write(linea_out, dato_salida);
         writeline(salida, linea_out);
      END IF;

      WAIT FOR clk_period; -- Esperamos un ciclo de reloj
   END LOOP; -- Volvemos al principio del bucle

   WAIT;

END PROCESS;
END;