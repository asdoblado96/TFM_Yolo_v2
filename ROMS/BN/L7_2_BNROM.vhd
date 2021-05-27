LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L7_2_BNROM IS
  PORT (
    coefs : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    address : IN unsigned(6 DOWNTO 0));
END L7_2_BNROM;

ARCHITECTURE RTL OF L7_2_BNROM IS

  TYPE ROM_mem IS ARRAY (0 TO 127) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  CONSTANT ROM_content : ROM_mem :=

  --Contenido bias || scale
  (0=>"1110111010110111"&"0010000100011010",
  1=>"1111011000101001"&"0010001010111100",
  2=>"1111001101101111"&"0010001010111000",
  3=>"1101110011111000"&"0010110100000010",
  4=>"1110011010111101"&"0010010101010001",
  5=>"1110001101111001"&"0011000011000010",
  6=>"1110111111000101"&"0010011010011110",
  7=>"1111101001100101"&"0010001110011000",
  8=>"0000000000001101"&"0010010101111011",
  9=>"1111011101101011"&"0010000000101101",
  10=>"1110100010001111"&"0010001011100000",
  11=>"1111000111101101"&"0010010101001111",
  12=>"1101111000111000"&"0010011011010001",
  13=>"1110100110101100"&"0010001100100000",
  14=>"1110110101000110"&"0010001010101111",
  15=>"1111100000100001"&"0010010001001100",
  16=>"1110100101000001"&"0010101010011001",
  17=>"1111111111111101"&"0010000111001010",
  18=>"1110100111010110"&"0010010110001101",
  19=>"1110111011111000"&"0010011101110000",
  20=>"1111011011010111"&"0010011010111001",
  21=>"1111010001010000"&"0010011001101111",
  22=>"1110111010010100"&"0010000110011101",
  23=>"1110101110111001"&"0010100101100111",
  24=>"1111001010001010"&"0010101100110000",
  25=>"1110101101011000"&"0010101010000100",
  26=>"1110001000000111"&"0010101100001010",
  27=>"1111000000001010"&"0010010011000110",
  28=>"1110010010010011"&"0010010101011101",
  29=>"1110111000001101"&"0010100000100110",
  30=>"1110100010111000"&"0010010111110111",
  31=>"1111110100011011"&"0011000000011010",
  32=>"1101111101101000"&"0010101100100101",
  33=>"1111011100000010"&"0010010101001011",
  34=>"1110001000011011"&"0010010010111000",
  35=>"1101100001111100"&"0010110111000111",
  36=>"1111101000011010"&"0010010000010000",
  37=>"1101001100000001"&"0010101011111000",
  38=>"1111100111101011"&"0010010100100001",
  39=>"1110011000101100"&"0010010011101010",
  40=>"1111101000011101"&"0010010010011110",
  41=>"1110100110010111"&"0010011110111010",
  42=>"1110111010000011"&"0010010111110000",
  43=>"1111111101100101"&"0010010010111110",
  44=>"1111010001001110"&"0010001001011010",
  45=>"1101011001000010"&"0010100110000010",
  46=>"1110001100110100"&"0010011000001001",
  47=>"1111011001010110"&"0010010100000001",
  48=>"1111000010101001"&"0010011000101010",
  49=>"1101110111010010"&"0010011011111011",
  50=>"1111010011000000"&"0010011000010100",
  51=>"1111000111010110"&"0010000101101000",
  52=>"0000001000111001"&"0010010001101100",
  53=>"1111000101100011"&"0010001111110011",
  54=>"1111011111001110"&"0001111111011000",
  55=>"1111110000001111"&"0010001001100001",
  56=>"1111101100111011"&"0010000001011110",
  57=>"1111110011101010"&"0010100010110001",
  58=>"1110100010101100"&"0010000011101001",
  59=>"1110000000100001"&"0010011010101100",
  60=>"1111011100010010"&"0010110100110010",
  61=>"1110011111000001"&"0010001101110111",
  62=>"1111000101101001"&"0010100010000010",
  63=>"1110111101100111"&"0010001111101100",
  64=>"1101101111000010"&"0010101011110011",
  65=>"1111110110110110"&"0010010000101110",
  66=>"1110011111001111"&"0010001010010101",
  67=>"1101111100000010"&"0010011111100111",
  68=>"1110111000101110"&"0010011001110111",
  69=>"1110110010010100"&"0010101100101000",
  70=>"1110101000100110"&"0010100110000101",
  71=>"1110010001011011"&"0010110100011001",
  72=>"1110110110001110"&"0010000111100001",
  73=>"1111001000100100"&"0010111100100110",
  74=>"1101111011000000"&"0010010101110000",
  75=>"1110001100000001"&"0010100011001010",
  76=>"1110100011011001"&"0010011110111000",
  77=>"1111100101101100"&"0010110100110001",
  78=>"1111001001100011"&"0010001011111010",
  79=>"1110001110100011"&"0010001110101101",
  80=>"1110110100000001"&"0010101100011000",
  81=>"1111000011101010"&"0010011111110111",
  82=>"1110100011011001"&"0010011001010001",
  83=>"1111100101101101"&"0010100010100100",
  84=>"1110010111100001"&"0010010100101101",
  85=>"1110111100101001"&"0010010000011110",
  86=>"1110110011000110"&"0010010110110001",
  87=>"1110100101111001"&"0010100100011001",
  88=>"1110110011110101"&"0010010001011101",
  89=>"1111010110100110"&"0010011001111010",
  90=>"1110001101100101"&"0010000001011100",
  91=>"1110101110100001"&"0010000100100110",
  92=>"1110100011101100"&"0010000101000001",
  93=>"1101110000000000"&"0010101000101110",
  94=>"1101110100011010"&"0010111100100100",
  95=>"1110101110110001"&"0010101101101111",
  96=>"1101110101001100"&"0010101010101011",
  97=>"1110101000001001"&"0010010101010000",
  98=>"1110100111001011"&"0010011001101000",
  99=>"1101011011000110"&"0010010011001001",
  100=>"1111001110000000"&"0010011100100111",
  101=>"1111010101100110"&"0010000000101110",
  102=>"1111100111000011"&"0001001100111110",
  103=>"1111111011111001"&"0010101001011100",
  104=>"1111000010000010"&"0010100011001101",
  105=>"1110101001001010"&"0010011111001001",
  106=>"1111000010001111"&"0010010011011111",
  107=>"1110011010110001"&"0010101100001100",
  108=>"0000001111111011"&"0010011100011111",
  109=>"1110101010100100"&"0010010000111101",
  110=>"1101111001111100"&"0010010011100010",
  111=>"1110011010010011"&"0010011000101010",
  112=>"1111010110111100"&"0010001111000011",
  113=>"1110110000111001"&"0010010010101100",
  114=>"1111010011100001"&"0010101001011101",
  115=>"1110010111111011"&"0010010011011111",
  116=>"1111011101011100"&"0010100001000000",
  117=>"1110111111111100"&"0010111100000010",
  118=>"1111110001000010"&"0010001010000000",
  119=>"1111001001000001"&"0010010000111100",
  120=>"1110111001011111"&"0010000111000101",
  121=>"1111000001010001"&"0010000100110011",
  122=>"1111001111001001"&"0010010011100011",
  123=>"1111001111101001"&"0001110101110011",
  124=>"1111001000100111"&"0010000100001111",
  125=>"1111001111011010"&"0010001111101011",
  126=>"1110010111000111"&"0010101000010011",
  127=>"1101111001100010"&"0010101000000100");

BEGIN
  coefs <= ROM_content(to_integer(address));
END RTL;