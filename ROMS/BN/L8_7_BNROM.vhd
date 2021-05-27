LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L8_7_BNROM IS
  PORT (
    coefs : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    address : IN unsigned(5 DOWNTO 0));
END L8_7_BNROM;

ARCHITECTURE RTL OF L8_7_BNROM IS

  TYPE ROM_mem IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  CONSTANT ROM_content : ROM_mem :=

  --Contenido bias || scale
  (0=>"0000101101111100"&"0010010111110001",
  1=>"0000110000001111"&"0010001100010010",
  2=>"0000110110101110"&"0001111001010101",
  3=>"0001000111101000"&"0010000010010011",
  4=>"0000111010001001"&"0010000111011001",
  5=>"0010001111011110"&"0010010011001001",
  6=>"1111110100100100"&"0001111100101110",
  7=>"0001011000110100"&"0001110100111100",
  8=>"0001001101101110"&"0001101010111101",
  9=>"0000111111000010"&"0010011010101000",
  10=>"0000111011000110"&"0010011001111010",
  11=>"1101100100011100"&"0001000010000000",
  12=>"0001010000101111"&"0010001101011110",
  13=>"0001110011011101"&"0010000110000011",
  14=>"0010001000010001"&"0010011100000111",
  15=>"1111100111011010"&"0010001001000111",
  16=>"0001111110011011"&"0001110001100111",
  17=>"0000110111101110"&"0010010101001100",
  18=>"0001001100010011"&"0010000101110101",
  19=>"0001010110001000"&"0010000110110110",
  20=>"0000100001101001"&"0010000111010000",
  21=>"0001100110010110"&"0010000100001111",
  22=>"0001110011110001"&"0010001000111001",
  23=>"0001100010101101"&"0010011000100010",
  24=>"0000000001110001"&"0001101001111101",
  25=>"0010010101010111"&"0010010010111110",
  26=>"1111001001100100"&"0001101101100100",
  27=>"0001010001010111"&"0001111110000100",
  28=>"1111101001001111"&"0001101111101101",
  29=>"0001011011111001"&"0010010010101001",
  30=>"0010000110000001"&"0010000010011011",
  31=>"0001011010100100"&"0010100010101000",
  32=>"0001001011010101"&"0010011001110110",
  33=>"0000101010101110"&"0010000111111110",
  34=>"0010110011111101"&"0010010000001101",
  35=>"0000110000010101"&"0010100001011001",
  36=>"1110011001101001"&"0001001110010011",
  37=>"0010000010111111"&"0010011011011101",
  38=>"0010000110001001"&"0010001010111011",
  39=>"1111100010101001"&"0001011111111111",
  40=>"0001001010001111"&"0010001010110011",
  41=>"0001111010111100"&"0010010010000010",
  42=>"0001101111100111"&"0010011001010111",
  43=>"0000001111101100"&"0010000111011100",
  44=>"0001010000100001"&"0010011011110000",
  45=>"0000100110011000"&"0010010000111101",
  46=>"0011000111000100"&"0010001100010001",
  47=>"0010000010110111"&"0010000100010001",
  48=>"0000000111010000"&"0010000000101000",
  49=>"1111111100000100"&"0010100001001101",
  50=>"0000110111000010"&"0001110010110000",
  51=>"0010111010001100"&"0010000001110101",
  52=>"0000001011011110"&"0010001110010100",
  53=>"1111011111010011"&"0010010110101001",
  54=>"0000101000101000"&"0010001110110101",
  55=>"0000110100101001"&"0010000010111100",
  56=>"1111110001111011"&"0001111000001111",
  57=>"0000100100111110"&"0001111011110010",
  58=>"0001000001000000"&"0010000100001100",
  59=>"0001101011111010"&"0010001010010001",
  60=>"0001101011110110"&"0001111010000000",
  61=>"0000111010000001"&"0010011011111100",
  62=>"0010001010001001"&"0010010100110001",
  63=>"0001101000101001"&"0001101110101010");

BEGIN
  coefs <= ROM_content(to_integer(address));
END RTL;