LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L5_1_BNROM IS
  PORT (
    coefs : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    address : IN unsigned(6 DOWNTO 0));
END L5_1_BNROM;

ARCHITECTURE RTL OF L5_1_BNROM IS

  TYPE ROM_mem IS ARRAY (0 TO 127) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  CONSTANT ROM_content : ROM_mem :=

  --Contenido bias || scale
  (0=>"1111110100011100"&"0001110001011011",
  1=>"1111100001110101"&"0001011001010101",
  2=>"0000110011110111"&"0001011100000100",
  3=>"1111101111101001"&"0001011110100101",
  4=>"0000000000011001"&"0001011000011100",
  5=>"1110111010100001"&"0001110100001011",
  6=>"1111111111001101"&"0001001111010110",
  7=>"0000101000101101"&"0001011111110110",
  8=>"1111011100101111"&"0001011111100011",
  9=>"1111000111111000"&"0001010011111100",
  10=>"1111100010000000"&"0001001101111110",
  11=>"1110111001110110"&"0001100100001000",
  12=>"0000100010100010"&"0000111111100010",
  13=>"1111100001010100"&"0001010100101111",
  14=>"1111101101111001"&"0001111000010110",
  15=>"1111110110100010"&"0001101001010010",
  16=>"1111101000000011"&"0001100100011011",
  17=>"1111101101000100"&"0001001101011100",
  18=>"1111100101100111"&"0001101001100010",
  19=>"1111011101001000"&"0001010110011001",
  20=>"0000101101100000"&"0001011011110110",
  21=>"1111110100111101"&"0001000110001101",
  22=>"0000000111010011"&"0001010001111100",
  23=>"0000011100001010"&"0001001011110100",
  24=>"1110010110001100"&"0001101001111111",
  25=>"1111110101100110"&"0001011000000110",
  26=>"1111010010011101"&"0001101100100111",
  27=>"1111101010001101"&"0000111111111011",
  28=>"1111000100101010"&"0001110011100010",
  29=>"1111110101111110"&"0001010011011010",
  30=>"1111011001111101"&"0001110001011011",
  31=>"0000110000110010"&"0000111111011101",
  32=>"1111011101101110"&"0001001001001101",
  33=>"1111001101101001"&"0001011000100001",
  34=>"0000000110111100"&"0010001100111101",
  35=>"0000010110010001"&"0001011101111011",
  36=>"0000000010001011"&"0001010111000111",
  37=>"1111010010100111"&"0001110000101000",
  38=>"0000110100110011"&"0001000001010000",
  39=>"1111110001110000"&"0001100110110011",
  40=>"0000111110110100"&"0001001111100111",
  41=>"0000001010001001"&"0001011101011111",
  42=>"1111000101111110"&"0001010000001000",
  43=>"1111100010011010"&"0001100101001111",
  44=>"1111101110001010"&"0001101011100111",
  45=>"0000000101000000"&"0001011100101100",
  46=>"1111100011110101"&"0001101011000101",
  47=>"0000010001101110"&"0001010010000000",
  48=>"1111111010100110"&"0001010001111101",
  49=>"1111110101100100"&"0001010100001100",
  50=>"1111110100101011"&"0001110100010011",
  51=>"1111110010100011"&"0001010110000100",
  52=>"1111010101110100"&"0001010000100001",
  53=>"1111101110101100"&"0001001110011000",
  54=>"0000000111010110"&"0001000011100101",
  55=>"1111110110010010"&"0001000111001101",
  56=>"1111111100011100"&"0001010001001001",
  57=>"1111101000110000"&"0001000000000111",
  58=>"1111010011000000"&"0001100010101011",
  59=>"1111101101001110"&"0001010101011000",
  60=>"1111100100010011"&"0001110011100000",
  61=>"1111100010101101"&"0001100101101010",
  62=>"1101001000110100"&"0001000110011100",
  63=>"1111100101001100"&"0001110010011100",
  64=>"0000010001010110"&"0001011011001110",
  65=>"1111011100011011"&"0001101100110000",
  66=>"1111101110010010"&"0001100001001101",
  67=>"1111100000100101"&"0001110100110101",
  68=>"1111111101000100"&"0001010101001001",
  69=>"1111110101010000"&"0001110111111011",
  70=>"1111000101111010"&"0001011111010011",
  71=>"1111010111001111"&"0010000001101111",
  72=>"1111101010011001"&"0001010111011001",
  73=>"1110000100010110"&"0001011111111001",
  74=>"1111110101110101"&"0001101011101011",
  75=>"1110101111111010"&"0001100111111100",
  76=>"1111101101000011"&"0001001110001110",
  77=>"1111111001110000"&"0001010100101110",
  78=>"0000000100011100"&"0001010110110101",
  79=>"1111100110001000"&"0001101011001110",
  80=>"1111111001000100"&"0001001010110010",
  81=>"0000001001101010"&"0001100010110101",
  82=>"0000011010111110"&"0001010110001000",
  83=>"1111101010101100"&"0001011101011101",
  84=>"1111110000111010"&"0001010110111010",
  85=>"1111101011100001"&"0001100001000011",
  86=>"1111111111001011"&"0001011110101010",
  87=>"0000111001000000"&"0001101011011111",
  88=>"0000000100001010"&"0001011111111001",
  89=>"1111111101011000"&"0001011100111001",
  90=>"1111111000111100"&"0001001111011011",
  91=>"1111100100011111"&"0001011001110100",
  92=>"1111110011011011"&"0000111010100111",
  93=>"1111111011101010"&"0001010111101111",
  94=>"0000111101010001"&"0000111000011011",
  95=>"1111011101001110"&"0001110100100010",
  96=>"1111000000110001"&"0001100101101111",
  97=>"1111001010100111"&"0001011100001111",
  98=>"0000000110000101"&"0001010100011110",
  99=>"1111111100111111"&"0001011101111110",
  100=>"1111100101111111"&"0001010110001110",
  101=>"0000001101010000"&"0001100100000111",
  102=>"1111100010101000"&"0001101011000110",
  103=>"0000000010011010"&"0001001011111000",
  104=>"0000000000111010"&"0001010011011000",
  105=>"1111111110100100"&"0001001111011100",
  106=>"0000001111101010"&"0001010010101111",
  107=>"1111110111000010"&"0001011010000110",
  108=>"0000011101011001"&"0001010111110001",
  109=>"0000101110011010"&"0001000000100011",
  110=>"1111101010010110"&"0001000110100010",
  111=>"1111001101010010"&"0001011011110011",
  112=>"0000000101111000"&"0001011001011001",
  113=>"1111110100001011"&"0001001111100110",
  114=>"0000000010111110"&"0001000100010101",
  115=>"0000110000001001"&"0001010100010101",
  116=>"0000011010000011"&"0001001000100000",
  117=>"1101101101010010"&"0001100111000100",
  118=>"1111100011110110"&"0001011100001001",
  119=>"0000001010001111"&"0001011110100010",
  120=>"1111111100011010"&"0001100100011110",
  121=>"0000001111000101"&"0001001100011101",
  122=>"1111110001000111"&"0001011010101001",
  123=>"1111111010100101"&"0001010000101101",
  124=>"1111010100000011"&"0001110000011001",
  125=>"1111111000110100"&"0001100010011010",
  126=>"0000000010100011"&"0001001110010100",
  127=>"0000110011011001"&"0001100000010111");

BEGIN
  coefs <= ROM_content(to_integer(address));
END RTL;