LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L8_6_BNROM IS
  PORT (
    coefs : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    address : IN unsigned(5 DOWNTO 0));
END L8_6_BNROM;

ARCHITECTURE RTL OF L8_6_BNROM IS

  TYPE ROM_mem IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

  CONSTANT ROM_content : ROM_mem :=

  --Contenido bias || scale
  (0=>"0001100111110100"&"0001100101010111",
  1=>"0000010010011101"&"0010010101100000",
  2=>"0001010111100111"&"0001110110100001",
  3=>"0000101001100101"&"0001110010111100",
  4=>"0000011100101100"&"0001101110001111",
  5=>"0000001001111100"&"0001111111111110",
  6=>"0001010010000110"&"0010011000100001",
  7=>"0010000001110110"&"0010100001010001",
  8=>"0001100010111110"&"0010010110011111",
  9=>"0001100001110010"&"0010010000111010",
  10=>"1101110110101111"&"0010000110001011",
  11=>"0001110111101110"&"0010001001110010",
  12=>"0010010110110001"&"0010011001110001",
  13=>"0001100111100010"&"0010000110001010",
  14=>"0010010111000101"&"0010000001100100",
  15=>"0000010101100100"&"0010010000000011",
  16=>"0001010110100111"&"0010000100101110",
  17=>"0001001111110010"&"0010001110010101",
  18=>"0010010011001101"&"0010000001100011",
  19=>"0010001010000010"&"0010011000011010",
  20=>"0010000000100101"&"0010010011111101",
  21=>"0000100011010001"&"0001111001001110",
  22=>"0001110101100111"&"0010010010100010",
  23=>"1111110001111110"&"0010000111000101",
  24=>"0001001000011101"&"0010001101001011",
  25=>"0001010111010101"&"0001101000011011",
  26=>"0010101101100000"&"0001111001001010",
  27=>"0001000111010110"&"0010010101000111",
  28=>"0010000100000101"&"0010001100010001",
  29=>"0001011101010111"&"0001111100001100",
  30=>"0001010001011000"&"0001110111100011",
  31=>"0000111110001000"&"0010011110111101",
  32=>"0001011000001110"&"0010011100101100",
  33=>"0010000000101011"&"0010000001100111",
  34=>"0001110000010111"&"0010010010000001",
  35=>"1111100101110011"&"0010010111000111",
  36=>"0001011001101111"&"0001111011101011",
  37=>"0001010011011010"&"0010001000111111",
  38=>"0000110110010110"&"0001101100110101",
  39=>"1111111001000010"&"0001110011010001",
  40=>"0001001100001111"&"0001111001010110",
  41=>"0001100111100011"&"0001111111001110",
  42=>"0000101101111010"&"0001100101011101",
  43=>"0000000110010011"&"0010011101000100",
  44=>"0001101010110100"&"0010011010000010",
  45=>"0000010111100100"&"0001111111100101",
  46=>"0001000001000111"&"0010010100101101",
  47=>"0001010000011110"&"0010000111111011",
  48=>"0010011101011010"&"0001110110110100",
  49=>"0001001001111101"&"0010001010111010",
  50=>"0010011100000000"&"0010010010111001",
  51=>"0001010001110110"&"0010001110100101",
  52=>"0000111100111011"&"0010010110110111",
  53=>"0001100011101101"&"0010011010110101",
  54=>"0010010010000100"&"0010000000011111",
  55=>"0001101000000101"&"0001110011111110",
  56=>"0001100000001101"&"0010010010100101",
  57=>"1111110001010111"&"0010001101111110",
  58=>"0001011000111010"&"0010010101000100",
  59=>"1110011111101011"&"0001101100010111",
  60=>"0001101101100110"&"0010001001101001",
  61=>"0000111000000101"&"0010011000101111",
  62=>"0000011011010010"&"0001111110110011",
  63=>"0000000101011100"&"0010010101110011");

BEGIN
  coefs <= ROM_content(to_integer(address));
END RTL;