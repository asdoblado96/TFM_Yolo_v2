LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L4_1_BNROM IS
    PORT (
        coefs : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        address : IN unsigned(5 DOWNTO 0));
END L4_1_BNROM;

ARCHITECTURE RTL OF L4_1_BNROM IS

    TYPE ROM_mem IS ARRAY (0 TO 63) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

    CONSTANT ROM_content : ROM_mem :=
    (0=>"0000010100111000"&"0001001011101011",
    1=>"0001111000010010"&"0000110110100010",
    2=>"0001100011111111"&"0000111010100101",
    3=>"0000001111110000"&"0001011100101101",
    4=>"1111111011011100"&"0001010100010100",
    5=>"0000011011110010"&"0001010100000110",
    6=>"0000100011101011"&"0001010101010111",
    7=>"0000110011001110"&"0001010000000001",
    8=>"0000011001100111"&"0001010101000111",
    9=>"1111101100111011"&"0001100010000001",
    10=>"0000001000011000"&"0001010100001101",
    11=>"0000000001101101"&"0001100011100111",
    12=>"1110110001011101"&"0001000001110110",
    13=>"0000000001010011"&"0001101110110101",
    14=>"1111111101011101"&"0001100001100001",
    15=>"0001110010111111"&"0001001010100001",
    16=>"0000101011111011"&"0000111001010110",
    17=>"0000001100101100"&"0000111001110111",
    18=>"0000010001000000"&"0001001100101000",
    19=>"0000011001010100"&"0001010001001001",
    20=>"0001010111000111"&"0000101111010000",
    21=>"1101111001010000"&"0001100010111010",
    22=>"1100011111111001"&"0010000100001111",
    23=>"0000010110110110"&"0001100010111011",
    24=>"1111110100000101"&"0001010100111001",
    25=>"1111100111000010"&"0001101010011110",
    26=>"0000010010101001"&"0001011101111100",
    27=>"1111101110000000"&"0001100110101001",
    28=>"0000010001010101"&"0000111010110110",
    29=>"1111110111111101"&"0001001111111101",
    30=>"0000100111100101"&"0001100100110101",
    31=>"0000010111011111"&"0001000011000010",
    32=>"1111110001110001"&"0001001001001001",
    33=>"1111110101000101"&"0001010101101001",
    34=>"0000000101100100"&"0001100011111101",
    35=>"1111100100001111"&"0001000100110000",
    36=>"1111001000101010"&"0001100001000111",
    37=>"0001010011000100"&"0001010010010001",
    38=>"0000100000000100"&"0001011110110001",
    39=>"0001010010110110"&"0000111110000010",
    40=>"0000000010000001"&"0001010100100011",
    41=>"0000010111110010"&"0001001011101001",
    42=>"0000001001110000"&"0001010110000000",
    43=>"0000000100001111"&"0001001100010111",
    44=>"0000111110001100"&"0001100100011100",
    45=>"1111111000001101"&"0001000010101101",
    46=>"1111000011100111"&"0001001101100011",
    47=>"0001001110010111"&"0000111111110111",
    48=>"1111110111111101"&"0001011010010101",
    49=>"0001001111010010"&"0001011000001001",
    50=>"1111111100011010"&"0001010101110110",
    51=>"0000011001000011"&"0001101100101000",
    52=>"1111111000101100"&"0001010001101101",
    53=>"1110111011001010"&"0000101100011111",
    54=>"1111101011011000"&"0000110101101010",
    55=>"0001100110101010"&"0001011100001110",
    56=>"1111111110101001"&"0001001101100111",
    57=>"0000001010011010"&"0001010110000100",
    58=>"1111110000010011"&"0001101000100101",
    59=>"1110111101000011"&"0001100101010100",
    60=>"1101100110111011"&"0001001111100100",
    61=>"1110111010001001"&"0001111000111000",
    62=>"1111101000110001"&"0001101010110101",
    63=>"1111111100100110"&"0001001001010100");
    
BEGIN
    coefs <= ROM_content(to_integer(address));
END RTL;