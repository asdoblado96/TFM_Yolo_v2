LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L7_4_BNROM IS
  PORT (
    coefs : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    address : IN unsigned(6 DOWNTO 0));
END L7_4_BNROM;

ARCHITECTURE RTL OF L7_4_BNROM IS

  TYPE ROM_mem IS ARRAY (0 TO 127) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  CONSTANT ROM_content : ROM_mem :=

  --Contenido bias || scale
  (0=>"1111111000000011"&"0010010001000110",
  1=>"1111110101010001"&"0001111001011111",
  2=>"0000100001101100"&"0010011101011000",
  3=>"1110111110000101"&"0001101101001000",
  4=>"1111010111010011"&"0010101001100001",
  5=>"1110011001110001"&"0010011101111110",
  6=>"1110010011111001"&"0010110010010001",
  7=>"1111110001011100"&"0010001010011010",
  8=>"1101010110111110"&"0010101100101011",
  9=>"1101110000001010"&"0010010110111001",
  10=>"1111011101111010"&"0001111111101111",
  11=>"1110100011001110"&"0010010011011011",
  12=>"1111011101111100"&"0010000101001101",
  13=>"1110000100010000"&"0010101101111000",
  14=>"1111000011111110"&"0010010011101101",
  15=>"1111000110111001"&"0010100001110110",
  16=>"1110110101001011"&"0010010001000101",
  17=>"1110100010101111"&"0010010100010001",
  18=>"1110001000100100"&"0010001001111011",
  19=>"1111001000101001"&"0010011001000000",
  20=>"1110101110010100"&"0010010100111000",
  21=>"1110001001010110"&"0010010101000001",
  22=>"0000000101111100"&"0010001100011010",
  23=>"1110100001101001"&"0010010111010110",
  24=>"1101101111000011"&"0010011000001100",
  25=>"1110011001111101"&"0010101110101111",
  26=>"0000000000010010"&"0010010001111011",
  27=>"1110000001010010"&"0010010111001000",
  28=>"1111110010011001"&"0010011101000110",
  29=>"1110111100011010"&"0010001101111000",
  30=>"1110110000100100"&"0010100010010011",
  31=>"1111010000001010"&"0010111011010101",
  32=>"1110010111111111"&"0010001101010110",
  33=>"1110100000111010"&"0010101011001010",
  34=>"1111010100101101"&"0010000111111011",
  35=>"1110110110101001"&"0010001011010100",
  36=>"1101011000010010"&"0010011011101111",
  37=>"1111100101111111"&"0001111101101010",
  38=>"1101101100101011"&"0010100101100101",
  39=>"1110011100010011"&"0010011001101011",
  40=>"1111100011111100"&"0010100000111100",
  41=>"1111101001000111"&"0010000101011110",
  42=>"1111110001100111"&"0010000000110000",
  43=>"1110101111111111"&"0010010110000000",
  44=>"1101110110010001"&"0010011110010011",
  45=>"1110110011011001"&"0010011000110011",
  46=>"1111011011000101"&"0010011100100111",
  47=>"1110111000000011"&"0010001001110000",
  48=>"1111010011001010"&"0010001001110001",
  49=>"1111011101001010"&"0010001000111010",
  50=>"1110000011110010"&"0010001101100110",
  51=>"1111011010000101"&"0010001110001111",
  52=>"1110001110011111"&"0010011010011100",
  53=>"0000000011010001"&"0010001010101010",
  54=>"1111010110010001"&"0010001111111111",
  55=>"1110110101100110"&"0010001101100110",
  56=>"1110111110110100"&"0010010111110100",
  57=>"1110110001100101"&"0010010010011111",
  58=>"1110111001000001"&"0010010110010101",
  59=>"1110101101000001"&"0010110010111000",
  60=>"1111110000111011"&"0010101100000101",
  61=>"1110111111101110"&"0010011010000110",
  62=>"1111000100001010"&"0010001101101001",
  63=>"1110100101100011"&"0010100100011011",
  64=>"1110011110111001"&"0010100110110000",
  65=>"1110111101000000"&"0010010011110001",
  66=>"1111100011101100"&"0010001000000001",
  67=>"1111001010011011"&"0010100101010101",
  68=>"1111010011001010"&"0010010011101000",
  69=>"1110001010001001"&"0010011101000111",
  70=>"1111010110101101"&"0010100011101111",
  71=>"1101110100010000"&"0010001011110110",
  72=>"1111000110101010"&"0010101010001011",
  73=>"1111000001010100"&"0010011000111111",
  74=>"1111011101111011"&"0010010010110010",
  75=>"1111100010010010"&"0010010000001110",
  76=>"1101110101101100"&"0010001101111111",
  77=>"1110010000000000"&"0010100100100100",
  78=>"1110110011110001"&"0010011110000011",
  79=>"1110101011101110"&"0010001010000100",
  80=>"1111001000110001"&"0010010001001010",
  81=>"1111111001101011"&"0000111100010001",
  82=>"1110111101101001"&"0010011010000010",
  83=>"1110100101001110"&"0010011100011000",
  84=>"1110101101110000"&"0010001011011011",
  85=>"1110101111100011"&"0010101111011111",
  86=>"1110100101101100"&"0010000000100001",
  87=>"1110111001001011"&"0010001111101000",
  88=>"1110100111000100"&"0010011011000010",
  89=>"1110010000111000"&"0010011110011011",
  90=>"1110111110111001"&"0010010001101000",
  91=>"1110010010110010"&"0010101101111100",
  92=>"1111010110001000"&"0010001010101110",
  93=>"1111001110001010"&"0010010100000111",
  94=>"1111001011010101"&"0010001111010111",
  95=>"1110110001110111"&"0010110100011100",
  96=>"1111001110001111"&"0010101011110011",
  97=>"1111101100101101"&"0010000111001000",
  98=>"1111111111111011"&"0010000100111011",
  99=>"1111100010110001"&"0010110001110100",
  100=>"1111010010010111"&"0010010011010011",
  101=>"1111110110011011"&"0010010100101010",
  102=>"1110001110011101"&"0010010101100101",
  103=>"1110011100100011"&"0010101101010100",
  104=>"1111100001110101"&"0010000101111101",
  105=>"1111011100101111"&"0011001010111000",
  106=>"1110011100100001"&"0010001001000110",
  107=>"1110111111110010"&"0010101111110100",
  108=>"1111111011010000"&"0010011011000000",
  109=>"1110000011001010"&"0010100000011010",
  110=>"1110101100011010"&"0010010001110001",
  111=>"1110001100100110"&"0010010001010011",
  112=>"1111100000101101"&"0010010000101001",
  113=>"1110000001000011"&"0010111000100100",
  114=>"1110011100110111"&"0010001111111000",
  115=>"1110100011110110"&"0010001001111010",
  116=>"1111011110011111"&"0010001111000101",
  117=>"1111001000001111"&"0010110001111001",
  118=>"1110110100010010"&"0010011010111111",
  119=>"1110111111110010"&"0010110101001110",
  120=>"1101110010111001"&"0010100011011110",
  121=>"1111001001110111"&"0010010111110010",
  122=>"1111001001111111"&"0010011001000001",
  123=>"1111110010100001"&"0010001110101101",
  124=>"1110100010110111"&"0010001110110111",
  125=>"1110010101110110"&"0010011110000100",
  126=>"1110110011101000"&"0010110110111111",
  127=>"1111001100101001"&"0010010110000101");

BEGIN
  coefs <= ROM_content(to_integer(address));
END RTL;