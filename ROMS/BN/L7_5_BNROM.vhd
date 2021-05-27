LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L7_5_BNROM IS
  PORT (
    coefs : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    address : IN unsigned(6 DOWNTO 0));
END L7_5_BNROM;

ARCHITECTURE RTL OF L7_5_BNROM IS

  TYPE ROM_mem IS ARRAY (0 TO 127) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  CONSTANT ROM_content : ROM_mem :=

  --Contenido bias || scale
  (0=>"1110011001101111"&"0010110011101110",
  1=>"1110111010100011"&"0010001101011101",
  2=>"1111000111000110"&"0010001010001011",
  3=>"1111100110001011"&"0001101101010001",
  4=>"1110010100000010"&"0010010001010100",
  5=>"1110111001111100"&"0010001101010010",
  6=>"1110110110000000"&"0010100001000101",
  7=>"1110111011000110"&"0010000011100101",
  8=>"1101110011101010"&"0010001100101111",
  9=>"1110101000011101"&"0010001010101000",
  10=>"1111010000011110"&"0010100001010001",
  11=>"1110110100000100"&"0010010101101111",
  12=>"1110101001101001"&"0010011110010111",
  13=>"1111011001100001"&"0010011010101011",
  14=>"1111111000100101"&"0010001100110100",
  15=>"1110111101010010"&"0010011000110000",
  16=>"1111100011100011"&"0010010101101001",
  17=>"1111000100100010"&"0010010000110001",
  18=>"1110110001011011"&"0010011011010100",
  19=>"1110111110100111"&"0010011110011100",
  20=>"1110100110100001"&"0001110110110101",
  21=>"1111101000101000"&"0010010000100001",
  22=>"1111001001101001"&"0011000111000111",
  23=>"1110100101110111"&"0010011111100001",
  24=>"1111001011110001"&"0010011001010011",
  25=>"1111001000010011"&"0010010101101111",
  26=>"1111000100100001"&"0010000011011001",
  27=>"1111000100000111"&"0010010101010100",
  28=>"1111011011110001"&"0010100011000010",
  29=>"1110001101000100"&"0010011100010111",
  30=>"1110111000110000"&"0010011010110010",
  31=>"1111101001100000"&"0010001000111011",
  32=>"1111100101110110"&"0010000010001100",
  33=>"1110100000010011"&"0010011001000111",
  34=>"1101101001010010"&"0010011011101101",
  35=>"1101111111000111"&"0010001010101001",
  36=>"1111010100101001"&"0010000111010000",
  37=>"1110111010110110"&"0010010101001011",
  38=>"1110101110101111"&"0010011011000101",
  39=>"1111011101100010"&"0010100001110110",
  40=>"1110010110100001"&"0001110111100001",
  41=>"1111100000101110"&"0010001011010010",
  42=>"1110011101010000"&"0010101100101111",
  43=>"1111000100110011"&"0010010110010010",
  44=>"1111000101101011"&"0010001001111001",
  45=>"1111000000001110"&"0010010001000000",
  46=>"1111011010110011"&"0010101100011000",
  47=>"1111000000110100"&"0010001110011001",
  48=>"1110111101010000"&"0010011101100001",
  49=>"1110111011110110"&"0010000000001110",
  50=>"1110100010111111"&"0011000101110110",
  51=>"1110100110001000"&"0010011011101110",
  52=>"1110011110101001"&"0010010001100101",
  53=>"1111101000100100"&"0010010100000000",
  54=>"1110100101100011"&"0010001110100111",
  55=>"1111101010001110"&"0010101001010110",
  56=>"1111000100000111"&"0010010010100101",
  57=>"1110001010110001"&"0010010111101011",
  58=>"1110110111000111"&"0010101011000111",
  59=>"1111001010011010"&"0010010011100110",
  60=>"1111011101000010"&"0010100110110011",
  61=>"1111000101010100"&"0010000110001000",
  62=>"1111001010111100"&"0010000111000100",
  63=>"1110001100010000"&"0010011000100010",
  64=>"1101110011101010"&"0010101010010000",
  65=>"1111000011101000"&"0010010010001100",
  66=>"1110100011011110"&"0010101001001110",
  67=>"1110101101010010"&"0010110110001100",
  68=>"1111001110001111"&"0010001000101000",
  69=>"1110111001000100"&"0010010111101111",
  70=>"1111100011101101"&"0010001100001000",
  71=>"1111110111001000"&"0010100100100000",
  72=>"1111101001010010"&"0010011010011110",
  73=>"1111100010100110"&"0010110010101100",
  74=>"1111000000100110"&"0010100010101101",
  75=>"1111100010100100"&"0010000000010100",
  76=>"1101101000110111"&"0010101100110010",
  77=>"1110100011100000"&"0010000100100001",
  78=>"1110111001110001"&"0010011111010110",
  79=>"1110100001001110"&"0010100101101100",
  80=>"1111111001011011"&"0010011110101100",
  81=>"1110111001011001"&"0010010010001110",
  82=>"1111001110111001"&"0010011001001001",
  83=>"1110101001101111"&"0010001011111101",
  84=>"1111001100100010"&"0010100100001110",
  85=>"1101101111111000"&"0010010010001001",
  86=>"1110000000010100"&"0010000010000010",
  87=>"1111011011001111"&"0010011111111111",
  88=>"1110101100001010"&"0010110101100100",
  89=>"1111001100000001"&"0010101101000111",
  90=>"1111011110001011"&"0010001000110110",
  91=>"1111001101011100"&"0010001101000001",
  92=>"1110011001010011"&"0010010111011101",
  93=>"1111010110110111"&"0010000011001000",
  94=>"1101101110100111"&"0010101110101011",
  95=>"1110111010000001"&"0010111111010011",
  96=>"1111000010111000"&"0010010110110100",
  97=>"1110111000101100"&"0001110110001100",
  98=>"1111011011011011"&"0010001111101111",
  99=>"1110111110100001"&"0010011001000100",
  100=>"1111001010010010"&"0010010001001110",
  101=>"1110101110100101"&"0010100011000001",
  102=>"0000001111110000"&"0010110111011011",
  103=>"1111001011110001"&"0010011101110101",
  104=>"1110000001101110"&"0010001001100110",
  105=>"1111010001100010"&"0010110001011000",
  106=>"1111011101000001"&"0010011111101010",
  107=>"1110101000101011"&"0010001001000110",
  108=>"1111100000001010"&"0010010001100110",
  109=>"1110101001101010"&"0010100110111000",
  110=>"1101110010000111"&"0010110001000011",
  111=>"1111000001001010"&"0010110101100110",
  112=>"1111000000111011"&"0010001001100111",
  113=>"1111001101010010"&"0001111110101101",
  114=>"1111001000010001"&"0010011101111001",
  115=>"1111001010001100"&"0010001010000101",
  116=>"1110111011001110"&"0010010100010011",
  117=>"1111100000111101"&"0010000111010010",
  118=>"1110111101001010"&"0010011100011000",
  119=>"1110010101001110"&"0010100100011110",
  120=>"1110101010011001"&"0010000010010100",
  121=>"1111001000010101"&"0010100000010101",
  122=>"1111000011100010"&"0010010100100011",
  123=>"1111011000001110"&"0010010000100000",
  124=>"1110000000111111"&"0010010011100100",
  125=>"1111100011010110"&"0010010011100001",
  126=>"1110111011011000"&"0001111110010011",
  127=>"1111010110010101"&"0010001101001111");

BEGIN
  coefs <= ROM_content(to_integer(address));
END RTL;