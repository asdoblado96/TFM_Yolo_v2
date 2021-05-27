
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.MATH_REAL.all;


library STD;
use STD.TEXTIO.all;
 
ENTITY tb_YOLO_texto IS
END tb_YOLO_texto;
 
ARCHITECTURE behavior OF tb_YOLO_texto IS 
 
signal resetn   : std_logic;
signal clk      : std_logic;

constant clk_period : time := 10 ns;

component YOLO_v2_tiny is
   port(
      resetn   : in std_logic;
      start_sim    : in std_logic;
      clk      : in std_logic;
      -- Entradas de YOLO. 
      In0      : in std_logic_vector(5 downto 0);
      In1      : in std_logic_vector(5 downto 0);
      In2      : in std_logic_vector(5 downto 0);
      In3      : in std_logic_vector(5 downto 0);
      In4      : in std_logic_vector(5 downto 0);
      In5      : in std_logic_vector(5 downto 0);
      In6      : in std_logic_vector(5 downto 0);
      In7      : in std_logic_vector(5 downto 0);
      In8      : in std_logic_vector(5 downto 0);
      -- Salidas de YOLO.  
      Detect   : out std_logic;      
end component;
          
  
   -- Archivos de texto
   
   file entrada: TEXT is in  "/home/garrido/Mario/Matlab/FFTdata/DataIn.dat";
   file salida : TEXT is out "/home/garrido/Mario/Matlab/FFTdata/DataOut.dat";
      
   -- Senales de control

    signal simular: std_logic;
	signal start_sim: std_logic;
    signal start: std_logic;
   signal parte_real, parte_imaginaria: integer;
   constant latencia: integer:=                         -- ADJUST --
    signal Detect: std_logic;
 
BEGIN

PFFT: PFFT_DIF
   generic map(	
      n_etapas => n_etapas,
      P        => P,
      n_bits   => n_bits,
      membits  => membits,
      crecimiento => crecimiento)
   port map(
      n_reset  => n_reset,
      enable   => enable,
      clk      => clk,
      -- Entradas de la FFT. 
      datain   => datain,
      -- Salidas de la FFT.  
      dataout  => dataout);


YOLO: YOLO_v2_tiny is
   port map(
      resetn   => resetn,
      start    => start,
      clk      => clk,
      -- Entradas de YOLO. 
      In0      => DataIn(0),
      In1      => DataIn(1),
      In2      => DataIn(2),
      In3      => DataIn(3),
      In4      => DataIn(4),
      In5      => DataIn(5),
      In6      => DataIn(6),
      In7      => DataIn(7),
      In8      => DataIn(8),
      -- Salidas de YOLO.  
      Detect   => Detect);      
end component;

resetn <= '1', '0' after 10 ns, '1' after 28 ns; -- 100 ms; 
start  <= '0', '1' after 28 ns;

-- Clock process definitions
clk_process :process
begin
   clk   <= '0';
   wait for clk_period/2;
   clk   <= '1';
   wait for clk_period/2;
end process;


lectura: PROCESS

   variable linea_in: line; 
   variable dato_r: integer;
   variable dato_i: integer;

begin

	simular <= '1';
    start_sim <= '0';
   
    wait until n_reset = '0';  
	wait until n_reset = '1';   
   
   start_sim <= '1';
  
   while not endfile(entrada) loop
      
      for i in 0 to 8 loop
         --Parte real:
         readline(entrada,linea_in);
         read(linea_in,dato);

         DataIn(i) <= std_logic_vector(to_unsigned(dato_r, 6));
      end loop;   
   
      wait for clk_period;
   end loop;      
   
   -- YA HEMOS TERMINADO DE PASAR TODOS LOS DATOS DEL ARCHIVO:   
   -- Hacemos que las entradas valgan a partir de ahora cero.
   for i in 0 to 8 loop
        DataIn(i) <= (others => '0');
   end loop;      
								   
	wait for (latencia -1) * clk_period;
		simular <= '0';   -- dejamos de escribir en el archivo de salida
      
	wait for 4*clk_period;
	   readline(entrada,linea_in); -- generamos un error para que pare el simulador
      
	wait;
   
end process;
    

escritura: PROCESS
        
     	variable dato_salida : integer;
		variable signo: std_logic;
		variable dato_aux: std_logic_vector((n_bits + crecimiento) -1 downto 0);
	   variable linea_out : line;
		variable espacio: character := ' ';
		variable menos: character := '-';

     begin
     
      wait until start_sim = '1';
      
      wait for (latencia) * clk_period;    -- latencia del circuito	 ---- ADJUST ----	
      
		while simular = '1' loop
      
         --for i in 0 to P-1 loop

            dato_salida:= Detect;

--            dato_salida:= conv_integer(array_salidas(i)(2*(n_bits + crecimiento) -1 downto (n_bits + crecimiento))); 
--
--            signo := array_salidas(i)(2*(n_bits + crecimiento) -1);
--            
--            if signo = '0' then  	-- N�mero positivo
--               dato_salida:= conv_integer(array_salidas(i)(2*(n_bits + crecimiento) -1 downto (n_bits + crecimiento)));  	
--            else 				-- N�mero negativo
--               dato_aux:=	array_salidas(i)(2*(n_bits + crecimiento) -1 downto (n_bits + crecimiento));
--               dato_aux:= not dato_aux;
--               dato_salida:= conv_integer(dato_aux +1); 	-- obtenemos el valor absoluto del n�mero
--               write(linea_out,menos);				         -- escribimos el signo menos
--            end if;

            write(linea_out,dato_salida);				

            -- Separamos la parte real de la imaginaria mediante un espacio:

--            write(linea_out,espacio);
--
--            -- PARTE IMAGINARIA:
--
--            dato_salida:= conv_integer(array_salidas(i)((n_bits + crecimiento) -1 downto 0));  
--            
--            signo := array_salidas(i)((n_bits + crecimiento) -1);
--         
--            if signo = '0' then  	-- N�mero positivo
--               dato_salida:= conv_integer(array_salidas(i)((n_bits + crecimiento) -1 downto 0));  	
--            else 				-- N�mero negativo
--               dato_aux:=	array_salidas(i)((n_bits + crecimiento) -1 downto 0);
--               dato_aux:= not dato_aux;
--               dato_salida:= conv_integer(dato_aux +1); 	-- obtenemos el valor absoluto del n�mero
--               write(linea_out,menos);				         -- escribimos el signo menos
--            end if;
--
--            write(linea_out,dato_salida);				-- escribimos la parte imaginaria
      
            -- Escribimos en el archivo la l�nea que hemos compuesto:

            writeline(salida,linea_out);
        -- end loop;
         
         wait for clk_period;			-- Esperamos un ciclo de reloj
         
         
		end loop;				         -- Volvemos al principio del bucle
		
		wait;

END PROCESS;


END;

