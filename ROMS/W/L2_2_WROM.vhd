LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L2_2_WROM IS
    PORT (
        weight : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
        address : IN unsigned(weightsbitsAddress(2)-1 DOWNTO 0));
END L2_2_WROM;

ARCHITECTURE RTL OF L2_2_WROM IS

    TYPE ROM_mem IS ARRAY (0 TO 255) OF STD_LOGIC_VECTOR(8 DOWNTO 0);

    CONSTANT ROM_content : ROM_mem := (0=>"111000000",
    1=>"000000111",
    2=>"001000111",
    3=>"111000111",
    4=>"111000111",
    5=>"111010001",
    6=>"000111000",
    7=>"111111000",
    8=>"111000000",
    9=>"110001011",
    10=>"111000111",
    11=>"001100100",
    12=>"110000111",
    13=>"000000010",
    14=>"000111000",
    15=>"111000110",
    16=>"000001111",
    17=>"111001000",
    18=>"001001111",
    19=>"110110111",
    20=>"101001101",
    21=>"111110011",
    22=>"101011000",
    23=>"101001001",
    24=>"000001111",
    25=>"111110111",
    26=>"001001001",
    27=>"111111111",
    28=>"111001000",
    29=>"001001001",
    30=>"000000001",
    31=>"110110110",
    32=>"110100111",
    33=>"000110110",
    34=>"011001000",
    35=>"111000100",
    36=>"000001011",
    37=>"010110000",
    38=>"000100000",
    39=>"000100110",
    40=>"111100011",
    41=>"000110100",
    42=>"000110110",
    43=>"000011010",
    44=>"000100010",
    45=>"110110110",
    46=>"100110000",
    47=>"000110110",
    48=>"111000000",
    49=>"000001111",
    50=>"111100000",
    51=>"000001111",
    52=>"000000000",
    53=>"101011111",
    54=>"100001011",
    55=>"111100000",
    56=>"111000000",
    57=>"001001110",
    58=>"000000100",
    59=>"110100011",
    60=>"000000111",
    61=>"101000001",
    62=>"111101111",
    63=>"000001111",
    64=>"111110000",
    65=>"000000111",
    66=>"000000111",
    67=>"000000111",
    68=>"110100010",
    69=>"110110000",
    70=>"000000000",
    71=>"111111110",
    72=>"111111000",
    73=>"001011011",
    74=>"110110100",
    75=>"110010000",
    76=>"110100000",
    77=>"010010010",
    78=>"000011111",
    79=>"100000000",
    80=>"000111111",
    81=>"110010100",
    82=>"111000000",
    83=>"111001000",
    84=>"111001001",
    85=>"001100111",
    86=>"001001100",
    87=>"000110111",
    88=>"000111111",
    89=>"001101110",
    90=>"111110111",
    91=>"001100111",
    92=>"111001000",
    93=>"101100110",
    94=>"000000100",
    95=>"001101000",
    96=>"000000101",
    97=>"000010010",
    98=>"111111111",
    99=>"000000000",
    100=>"000111011",
    101=>"111111000",
    102=>"110101101",
    103=>"111101011",
    104=>"111011111",
    105=>"101000001",
    106=>"010000000",
    107=>"111101000",
    108=>"111111111",
    109=>"101101101",
    110=>"100000111",
    111=>"000000000",
    112=>"100100100",
    113=>"000101001",
    114=>"111011011",
    115=>"001001111",
    116=>"001001010",
    117=>"101101101",
    118=>"000000011",
    119=>"110110110",
    120=>"110110110",
    121=>"110110100",
    122=>"101000101",
    123=>"100100100",
    124=>"001101001",
    125=>"111000111",
    126=>"011000001",
    127=>"100101110",
    128=>"011010101",
    129=>"010101001",
    130=>"111010110",
    131=>"001100100",
    132=>"010100100",
    133=>"011011110",
    134=>"001001100",
    135=>"101010010",
    136=>"011010101",
    137=>"101110010",
    138=>"010010101",
    139=>"110011101",
    140=>"100010001",
    141=>"100010100",
    142=>"101001010",
    143=>"110010010",
    144=>"011011001",
    145=>"100100110",
    146=>"100110111",
    147=>"100110110",
    148=>"000000100",
    149=>"101000111",
    150=>"000000000",
    151=>"011011001",
    152=>"011001101",
    153=>"000000100",
    154=>"001000110",
    155=>"100100111",
    156=>"100100110",
    157=>"111101100",
    158=>"111011111",
    159=>"001100100",
    160=>"001011111",
    161=>"110100100",
    162=>"111001000",
    163=>"111100100",
    164=>"110100110",
    165=>"100001011",
    166=>"100000001",
    167=>"001011011",
    168=>"001011011",
    169=>"000000001",
    170=>"111111110",
    171=>"001100101",
    172=>"110000000",
    173=>"101001101",
    174=>"100001001",
    175=>"101000010",
    176=>"011100111",
    177=>"100111100",
    178=>"110011001",
    179=>"100110001",
    180=>"100110011",
    181=>"101001110",
    182=>"101000100",
    183=>"011100110",
    184=>"001110011",
    185=>"000110001",
    186=>"000110001",
    187=>"110001110",
    188=>"011000001",
    189=>"111100011",
    190=>"110001110",
    191=>"001100011",
    192=>"011010011",
    193=>"100111100",
    194=>"000000001",
    195=>"111000111",
    196=>"010110000",
    197=>"011011011",
    198=>"001001001",
    199=>"011011011",
    200=>"001001001",
    201=>"001101101",
    202=>"100100100",
    203=>"000100000",
    204=>"100100100",
    205=>"111000111",
    206=>"110110110",
    207=>"001001001",
    208=>"000111101",
    209=>"111000000",
    210=>"111100000",
    211=>"000111111",
    212=>"100000000",
    213=>"111000111",
    214=>"101000000",
    215=>"000000010",
    216=>"000010010",
    217=>"001000000",
    218=>"101111111",
    219=>"100000000",
    220=>"111000100",
    221=>"101111111",
    222=>"111111111",
    223=>"111000111",
    224=>"101101100",
    225=>"011001001",
    226=>"100111100",
    227=>"000111101",
    228=>"100100100",
    229=>"011011011",
    230=>"000100100",
    231=>"101101101",
    232=>"101101101",
    233=>"000110011",
    234=>"111100100",
    235=>"001001001",
    236=>"001111101",
    237=>"101101101",
    238=>"100100110",
    239=>"000011101",
    240=>"101111111",
    241=>"011011111",
    242=>"000011011",
    243=>"000011011",
    244=>"100000000",
    245=>"111101011",
    246=>"111100101",
    247=>"000111100",
    248=>"001011011",
    249=>"101000000",
    250=>"000000001",
    251=>"110010000",
    252=>"110100100",
    253=>"101111100",
    254=>"100011110",
    255=>"010110010");

BEGIN
    weight <= ROM_content(to_integer(address));
END RTL;