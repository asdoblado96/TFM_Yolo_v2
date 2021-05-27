LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY work;
USE work.YOLO_pkg.ALL;

ENTITY L3_2_WROM IS
    PORT (
        weight : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
        address : IN unsigned(weightsbitsAddress(3)-1 DOWNTO 0));
END L3_2_WROM;

ARCHITECTURE RTL OF L3_2_WROM IS

    TYPE ROM_mem IS ARRAY (0 TO 1023) OF STD_LOGIC_VECTOR(8 DOWNTO 0);

    CONSTANT ROM_content : ROM_mem := (0=>"111101100",
    1=>"101101000",
    2=>"100011111",
    3=>"011111110",
    4=>"111100000",
    5=>"001111101",
    6=>"011111100",
    7=>"111100000",
    8=>"111100000",
    9=>"110111000",
    10=>"110100001",
    11=>"110100101",
    12=>"100000000",
    13=>"111111010",
    14=>"000011111",
    15=>"011101101",
    16=>"000000000",
    17=>"011011011",
    18=>"100000011",
    19=>"111111111",
    20=>"100111111",
    21=>"100100111",
    22=>"111110111",
    23=>"111010100",
    24=>"110111010",
    25=>"011011000",
    26=>"110111111",
    27=>"001000100",
    28=>"111011000",
    29=>"100101101",
    30=>"001110010",
    31=>"110100000",
    32=>"011001101",
    33=>"011100100",
    34=>"011011001",
    35=>"000000100",
    36=>"110011111",
    37=>"011011000",
    38=>"110111011",
    39=>"011101000",
    40=>"111001000",
    41=>"111111000",
    42=>"111111011",
    43=>"011001000",
    44=>"001000000",
    45=>"001100110",
    46=>"111111111",
    47=>"011001000",
    48=>"110000110",
    49=>"110111110",
    50=>"001100110",
    51=>"001000000",
    52=>"000000001",
    53=>"110111111",
    54=>"011000101",
    55=>"001100111",
    56=>"111111111",
    57=>"000000000",
    58=>"000000100",
    59=>"011000100",
    60=>"001000010",
    61=>"011000110",
    62=>"010000010",
    63=>"011011000",
    64=>"011001010",
    65=>"111100110",
    66=>"101001000",
    67=>"100111000",
    68=>"000110111",
    69=>"011000111",
    70=>"111011100",
    71=>"000110111",
    72=>"011000110",
    73=>"110010110",
    74=>"000011000",
    75=>"000100111",
    76=>"000100000",
    77=>"100000110",
    78=>"111000000",
    79=>"000100111",
    80=>"010111111",
    81=>"111001000",
    82=>"101111011",
    83=>"000111001",
    84=>"000111001",
    85=>"000010110",
    86=>"110011000",
    87=>"111011000",
    88=>"111011100",
    89=>"000100001",
    90=>"111011000",
    91=>"010100111",
    92=>"111010000",
    93=>"010110001",
    94=>"111101010",
    95=>"001110010",
    96=>"000111111",
    97=>"101000001",
    98=>"011111100",
    99=>"100110001",
    100=>"000011010",
    101=>"100110110",
    102=>"111001111",
    103=>"110010000",
    104=>"001111111",
    105=>"110110010",
    106=>"001001100",
    107=>"000110110",
    108=>"010111111",
    109=>"111011011",
    110=>"100110010",
    111=>"110100111",
    112=>"000010010",
    113=>"111100111",
    114=>"010011111",
    115=>"100111011",
    116=>"110111000",
    117=>"010111011",
    118=>"111111111",
    119=>"000111111",
    120=>"011000100",
    121=>"110111111",
    122=>"100100000",
    123=>"110010001",
    124=>"100110010",
    125=>"111111001",
    126=>"100010111",
    127=>"000110010",
    128=>"010000100",
    129=>"001001101",
    130=>"010100101",
    131=>"001000110",
    132=>"101011110",
    133=>"011000100",
    134=>"100011011",
    135=>"001100100",
    136=>"111011100",
    137=>"001000100",
    138=>"001110000",
    139=>"011000000",
    140=>"100000000",
    141=>"001100110",
    142=>"010001011",
    143=>"110011101",
    144=>"011000100",
    145=>"100011001",
    146=>"001100110",
    147=>"000100011",
    148=>"011000100",
    149=>"011100110",
    150=>"000000011",
    151=>"101110010",
    152=>"010010101",
    153=>"101110010",
    154=>"000001001",
    155=>"011001110",
    156=>"011000101",
    157=>"100101011",
    158=>"010000100",
    159=>"111110101",
    160=>"000000111",
    161=>"001001001",
    162=>"000000000",
    163=>"110011011",
    164=>"001000000",
    165=>"110110000",
    166=>"010100101",
    167=>"100100100",
    168=>"000000000",
    169=>"100100111",
    170=>"000000000",
    171=>"001000000",
    172=>"001001001",
    173=>"111111111",
    174=>"110011011",
    175=>"111111011",
    176=>"011101101",
    177=>"110010011",
    178=>"101101110",
    179=>"000000000",
    180=>"001000100",
    181=>"000000000",
    182=>"001001101",
    183=>"110110111",
    184=>"000000000",
    185=>"110111111",
    186=>"000100100",
    187=>"011001111",
    188=>"110001111",
    189=>"001001101",
    190=>"110111110",
    191=>"111111111",
    192=>"110100101",
    193=>"110000000",
    194=>"100001011",
    195=>"000100110",
    196=>"111011110",
    197=>"111100001",
    198=>"001111110",
    199=>"111001010",
    200=>"110000000",
    201=>"111000000",
    202=>"100000011",
    203=>"110100000",
    204=>"010000001",
    205=>"111111110",
    206=>"100000001",
    207=>"001000000",
    208=>"111000110",
    209=>"011111000",
    210=>"110100010",
    211=>"000000000",
    212=>"000001011",
    213=>"011111010",
    214=>"110100100",
    215=>"000000101",
    216=>"001001010",
    217=>"010111111",
    218=>"101111111",
    219=>"111110100",
    220=>"111111011",
    221=>"100000011",
    222=>"100001001",
    223=>"111001001",
    224=>"110010011",
    225=>"001001101",
    226=>"100100110",
    227=>"010010000",
    228=>"100110011",
    229=>"010011001",
    230=>"100110110",
    231=>"010011011",
    232=>"101110110",
    233=>"010011011",
    234=>"100110111",
    235=>"000001001",
    236=>"000000100",
    237=>"011001001",
    238=>"110011001",
    239=>"111011001",
    240=>"101100110",
    241=>"010010001",
    242=>"100101111",
    243=>"001101100",
    244=>"100110011",
    245=>"110010001",
    246=>"000100110",
    247=>"000100100",
    248=>"100100111",
    249=>"011001100",
    250=>"001100110",
    251=>"010001000",
    252=>"001010010",
    253=>"101110110",
    254=>"010010001",
    255=>"000000001",
    256=>"100100111",
    257=>"010010011",
    258=>"011001101",
    259=>"010010011",
    260=>"100100110",
    261=>"100010110",
    262=>"111101111",
    263=>"110010010",
    264=>"111011000",
    265=>"100100101",
    266=>"001000100",
    267=>"010010110",
    268=>"010000000",
    269=>"100000001",
    270=>"001001001",
    271=>"101001001",
    272=>"001001001",
    273=>"000100110",
    274=>"101001101",
    275=>"011001001",
    276=>"010010110",
    277=>"000010010",
    278=>"101101001",
    279=>"001011010",
    280=>"010010000",
    281=>"100100100",
    282=>"110110110",
    283=>"110100101",
    284=>"100100100",
    285=>"101101101",
    286=>"010101010",
    287=>"001000001",
    288=>"100000000",
    289=>"100110100",
    290=>"101111101",
    291=>"111111111",
    292=>"001101101",
    293=>"000000000",
    294=>"000001111",
    295=>"000101000",
    296=>"011101110",
    297=>"000101000",
    298=>"111111111",
    299=>"000001100",
    300=>"111111111",
    301=>"110111101",
    302=>"000100001",
    303=>"000000100",
    304=>"111111111",
    305=>"111101100",
    306=>"100111100",
    307=>"110000000",
    308=>"110101110",
    309=>"000000000",
    310=>"101100000",
    311=>"011000000",
    312=>"111111110",
    313=>"000001000",
    314=>"100001110",
    315=>"101111111",
    316=>"111011111",
    317=>"000111001",
    318=>"111011111",
    319=>"110111110",
    320=>"100101100",
    321=>"111001001",
    322=>"011000110",
    323=>"110010111",
    324=>"000010110",
    325=>"000100110",
    326=>"100100111",
    327=>"111001001",
    328=>"110100010",
    329=>"100100111",
    330=>"110110111",
    331=>"000100111",
    332=>"000100100",
    333=>"000010011",
    334=>"001000110",
    335=>"001000111",
    336=>"001111101",
    337=>"101100111",
    338=>"100110101",
    339=>"000101001",
    340=>"000000000",
    341=>"010000110",
    342=>"111011000",
    343=>"110101100",
    344=>"100001011",
    345=>"011100100",
    346=>"000000010",
    347=>"110111000",
    348=>"100110101",
    349=>"000000111",
    350=>"011001010",
    351=>"010110100",
    352=>"011111111",
    353=>"001000111",
    354=>"000000001",
    355=>"111000100",
    356=>"111111000",
    357=>"101001101",
    358=>"111111110",
    359=>"111000110",
    360=>"001100000",
    361=>"000000111",
    362=>"111100011",
    363=>"000000100",
    364=>"111000000",
    365=>"101111111",
    366=>"100100000",
    367=>"111001101",
    368=>"111111010",
    369=>"000000001",
    370=>"000100000",
    371=>"111111011",
    372=>"111000000",
    373=>"111000000",
    374=>"011111111",
    375=>"110100100",
    376=>"101101111",
    377=>"000101000",
    378=>"000000000",
    379=>"001111011",
    380=>"000001101",
    381=>"111111000",
    382=>"000011011",
    383=>"100000000",
    384=>"011011000",
    385=>"010011001",
    386=>"011000000",
    387=>"100100110",
    388=>"011011001",
    389=>"100010110",
    390=>"011011101",
    391=>"001111000",
    392=>"100011011",
    393=>"100101010",
    394=>"011001000",
    395=>"100010000",
    396=>"000000011",
    397=>"100100100",
    398=>"100100110",
    399=>"101101101",
    400=>"011011011",
    401=>"100100110",
    402=>"000011001",
    403=>"101101101",
    404=>"000001100",
    405=>"001011011",
    406=>"011011001",
    407=>"000100010",
    408=>"000101100",
    409=>"100000110",
    410=>"111001100",
    411=>"000000011",
    412=>"101100100",
    413=>"011011001",
    414=>"100100100",
    415=>"110100110",
    416=>"100100000",
    417=>"001001111",
    418=>"110110100",
    419=>"111100001",
    420=>"000000101",
    421=>"001001011",
    422=>"000001111",
    423=>"110100000",
    424=>"001111111",
    425=>"111110100",
    426=>"000001110",
    427=>"110100000",
    428=>"111010000",
    429=>"111111101",
    430=>"100000101",
    431=>"110000101",
    432=>"100100001",
    433=>"111100001",
    434=>"011010100",
    435=>"100000001",
    436=>"000000100",
    437=>"010110000",
    438=>"000001011",
    439=>"101111110",
    440=>"000001011",
    441=>"110110000",
    442=>"011011110",
    443=>"111111100",
    444=>"111000000",
    445=>"000101111",
    446=>"110010000",
    447=>"001011010",
    448=>"010111000",
    449=>"000011011",
    450=>"000100000",
    451=>"000100100",
    452=>"000100000",
    453=>"010000111",
    454=>"010111011",
    455=>"000011010",
    456=>"000000000",
    457=>"001001001",
    458=>"000000000",
    459=>"000000100",
    460=>"000000000",
    461=>"111111111",
    462=>"110111011",
    463=>"001001001",
    464=>"000000000",
    465=>"000101111",
    466=>"000111111",
    467=>"000000101",
    468=>"011011011",
    469=>"001111110",
    470=>"111111010",
    471=>"100100111",
    472=>"111111101",
    473=>"001111111",
    474=>"101111101",
    475=>"000000000",
    476=>"011111001",
    477=>"101010000",
    478=>"000000111",
    479=>"111111111",
    480=>"111100000",
    481=>"001100100",
    482=>"110110010",
    483=>"001001111",
    484=>"010000001",
    485=>"100111111",
    486=>"111100100",
    487=>"111100101",
    488=>"001001001",
    489=>"111110100",
    490=>"011011000",
    491=>"000000001",
    492=>"000000011",
    493=>"001001011",
    494=>"100101100",
    495=>"001010111",
    496=>"000011011",
    497=>"100110110",
    498=>"000000001",
    499=>"011000111",
    500=>"000011011",
    501=>"001001011",
    502=>"111100100",
    503=>"100100111",
    504=>"010001100",
    505=>"000011110",
    506=>"110110001",
    507=>"001011010",
    508=>"100101111",
    509=>"111001100",
    510=>"000111111",
    511=>"000010010",
    512=>"000000001",
    513=>"110111000",
    514=>"100010010",
    515=>"101011111",
    516=>"000000001",
    517=>"000000000",
    518=>"010111000",
    519=>"110011000",
    520=>"111000000",
    521=>"000000000",
    522=>"110111011",
    523=>"000000001",
    524=>"000000011",
    525=>"011010101",
    526=>"011011000",
    527=>"000011000",
    528=>"010000000",
    529=>"000000000",
    530=>"100111011",
    531=>"001111111",
    532=>"010111111",
    533=>"110011000",
    534=>"111000000",
    535=>"100100110",
    536=>"010010010",
    537=>"101101110",
    538=>"110110100",
    539=>"011000000",
    540=>"001001001",
    541=>"011001000",
    542=>"000111111",
    543=>"001001111",
    544=>"000110010",
    545=>"100000110",
    546=>"111111111",
    547=>"001000000",
    548=>"000000000",
    549=>"000100110",
    550=>"111000000",
    551=>"000110111",
    552=>"000101010",
    553=>"111111100",
    554=>"111001000",
    555=>"000111111",
    556=>"000001010",
    557=>"101111010",
    558=>"000110110",
    559=>"010000000",
    560=>"110010111",
    561=>"101110000",
    562=>"000010111",
    563=>"111111110",
    564=>"100111111",
    565=>"000000111",
    566=>"111100000",
    567=>"000110000",
    568=>"101010001",
    569=>"111110111",
    570=>"000001001",
    571=>"011000111",
    572=>"000110110",
    573=>"111001101",
    574=>"101010000",
    575=>"000110100",
    576=>"111000000",
    577=>"100000110",
    578=>"000000000",
    579=>"011111011",
    580=>"100000100",
    581=>"011001001",
    582=>"111110000",
    583=>"000101111",
    584=>"111110100",
    585=>"000001111",
    586=>"000000000",
    587=>"000100100",
    588=>"000000100",
    589=>"011111111",
    590=>"010111100",
    591=>"111011100",
    592=>"100100100",
    593=>"001001111",
    594=>"011100000",
    595=>"010110111",
    596=>"000000101",
    597=>"110111110",
    598=>"011000111",
    599=>"000100111",
    600=>"000000001",
    601=>"111111111",
    602=>"100100100",
    603=>"111110110",
    604=>"001000111",
    605=>"110110100",
    606=>"000000111",
    607=>"001001111",
    608=>"111001111",
    609=>"100100111",
    610=>"110100000",
    611=>"101111110",
    612=>"010100100",
    613=>"001100110",
    614=>"111110111",
    615=>"111000001",
    616=>"101001001",
    617=>"100011001",
    618=>"110011001",
    619=>"001000011",
    620=>"001000000",
    621=>"101111000",
    622=>"001110110",
    623=>"000010111",
    624=>"110011110",
    625=>"100110110",
    626=>"100001000",
    627=>"111011000",
    628=>"000001001",
    629=>"001000010",
    630=>"111100100",
    631=>"010011111",
    632=>"100111001",
    633=>"000001110",
    634=>"110110001",
    635=>"000100110",
    636=>"000111000",
    637=>"111000011",
    638=>"000000100",
    639=>"000001001",
    640=>"000000001",
    641=>"000010010",
    642=>"100000011",
    643=>"011010111",
    644=>"010001011",
    645=>"000111010",
    646=>"100000000",
    647=>"000000001",
    648=>"111010000",
    649=>"000000000",
    650=>"100001110",
    651=>"000001001",
    652=>"010010111",
    653=>"001100100",
    654=>"110111111",
    655=>"000000000",
    656=>"110111110",
    657=>"010010000",
    658=>"110100110",
    659=>"011001011",
    660=>"010000000",
    661=>"010110110",
    662=>"100000101",
    663=>"100100010",
    664=>"110011011",
    665=>"110110000",
    666=>"111111111",
    667=>"001000000",
    668=>"011011000",
    669=>"000101001",
    670=>"000001100",
    671=>"000010000",
    672=>"001001101",
    673=>"001001100",
    674=>"000000000",
    675=>"010110111",
    676=>"001001110",
    677=>"011011110",
    678=>"100101101",
    679=>"011011010",
    680=>"110001001",
    681=>"001001011",
    682=>"001010100",
    683=>"001011010",
    684=>"000010000",
    685=>"100000001",
    686=>"011011011",
    687=>"100110100",
    688=>"011011101",
    689=>"111110110",
    690=>"001111001",
    691=>"010010110",
    692=>"010010110",
    693=>"100100000",
    694=>"101100100",
    695=>"000000010",
    696=>"010010010",
    697=>"100001001",
    698=>"011010110",
    699=>"110001001",
    700=>"111111111",
    701=>"100101001",
    702=>"000000010",
    703=>"000000100",
    704=>"101101101",
    705=>"101001101",
    706=>"000100010",
    707=>"111011000",
    708=>"000101110",
    709=>"100100100",
    710=>"011011011",
    711=>"100100100",
    712=>"110110100",
    713=>"100101111",
    714=>"000110110",
    715=>"100100100",
    716=>"100100100",
    717=>"111000000",
    718=>"011001011",
    719=>"000100000",
    720=>"100100100",
    721=>"011011011",
    722=>"110110110",
    723=>"001001011",
    724=>"000100110",
    725=>"011110000",
    726=>"111001101",
    727=>"111001111",
    728=>"001111110",
    729=>"111011000",
    730=>"001001111",
    731=>"111110000",
    732=>"000101001",
    733=>"110100100",
    734=>"000110110",
    735=>"000100000",
    736=>"000011000",
    737=>"001010101",
    738=>"100000011",
    739=>"111111111",
    740=>"100001011",
    741=>"010011010",
    742=>"001001111",
    743=>"101100101",
    744=>"101111111",
    745=>"110111111",
    746=>"000000000",
    747=>"110100000",
    748=>"000000000",
    749=>"000000000",
    750=>"111111111",
    751=>"000100110",
    752=>"000000000",
    753=>"110111000",
    754=>"000000000",
    755=>"111111111",
    756=>"101111100",
    757=>"111111111",
    758=>"011111000",
    759=>"000100000",
    760=>"000000000",
    761=>"111111111",
    762=>"111110111",
    763=>"010000000",
    764=>"110011000",
    765=>"000000010",
    766=>"110101000",
    767=>"111110001",
    768=>"111110000",
    769=>"000000111",
    770=>"000000111",
    771=>"101011001",
    772=>"000111111",
    773=>"000000111",
    774=>"111011000",
    775=>"111100000",
    776=>"001100000",
    777=>"111011000",
    778=>"001001000",
    779=>"110000001",
    780=>"000000100",
    781=>"001111101",
    782=>"011011011",
    783=>"000110111",
    784=>"000111101",
    785=>"100000111",
    786=>"001000100",
    787=>"011111111",
    788=>"001010111",
    789=>"100000111",
    790=>"110100000",
    791=>"000010100",
    792=>"111011100",
    793=>"110110001",
    794=>"111000101",
    795=>"000110000",
    796=>"000000110",
    797=>"101111100",
    798=>"000111000",
    799=>"000011011",
    800=>"000110111",
    801=>"110100100",
    802=>"110011010",
    803=>"101110111",
    804=>"000001010",
    805=>"000001011",
    806=>"111011100",
    807=>"100100110",
    808=>"100001000",
    809=>"000001011",
    810=>"011111011",
    811=>"011001001",
    812=>"001001001",
    813=>"010110010",
    814=>"001100001",
    815=>"011111001",
    816=>"111101100",
    817=>"010100010",
    818=>"101000110",
    819=>"000001011",
    820=>"100000100",
    821=>"000000000",
    822=>"000110110",
    823=>"010000001",
    824=>"011010011",
    825=>"010001000",
    826=>"001000001",
    827=>"001111010",
    828=>"110101000",
    829=>"001000000",
    830=>"101011110",
    831=>"000011111",
    832=>"111001011",
    833=>"110100000",
    834=>"100100000",
    835=>"001011111",
    836=>"010110100",
    837=>"010100100",
    838=>"001011110",
    839=>"101101000",
    840=>"011011000",
    841=>"110110001",
    842=>"110100000",
    843=>"110100000",
    844=>"010000000",
    845=>"001001111",
    846=>"111110110",
    847=>"001001110",
    848=>"001001011",
    849=>"110101101",
    850=>"000100100",
    851=>"110110100",
    852=>"110100000",
    853=>"001001011",
    854=>"001011011",
    855=>"110110101",
    856=>"110100100",
    857=>"001011110",
    858=>"110100000",
    859=>"011011111",
    860=>"100001111",
    861=>"001011011",
    862=>"000100100",
    863=>"110100000",
    864=>"001001001",
    865=>"110100100",
    866=>"110110110",
    867=>"010001001",
    868=>"100100000",
    869=>"110100100",
    870=>"101101111",
    871=>"011011011",
    872=>"001101100",
    873=>"001011011",
    874=>"001011100",
    875=>"010110000",
    876=>"010000000",
    877=>"101101110",
    878=>"100000101",
    879=>"110011111",
    880=>"110100001",
    881=>"010100011",
    882=>"001010010",
    883=>"001001001",
    884=>"001011000",
    885=>"010100001",
    886=>"100100001",
    887=>"111011011",
    888=>"000001000",
    889=>"110110110",
    890=>"011011110",
    891=>"111111111",
    892=>"110000000",
    893=>"101101001",
    894=>"010010100",
    895=>"100001001",
    896=>"110011111",
    897=>"101100110",
    898=>"111011011",
    899=>"011100111",
    900=>"010011001",
    901=>"000000110",
    902=>"110111101",
    903=>"101001000",
    904=>"010001101",
    905=>"110001100",
    906=>"111111001",
    907=>"101101110",
    908=>"000000000",
    909=>"000100100",
    910=>"111111111",
    911=>"111011101",
    912=>"010111001",
    913=>"011011111",
    914=>"100001010",
    915=>"011111100",
    916=>"001011111",
    917=>"101100111",
    918=>"101111111",
    919=>"000100000",
    920=>"100000001",
    921=>"111111110",
    922=>"111011011",
    923=>"011000110",
    924=>"000000000",
    925=>"110110100",
    926=>"000000000",
    927=>"111110001",
    928=>"010110000",
    929=>"000110101",
    930=>"111110110",
    931=>"000000000",
    932=>"111111110",
    933=>"011110100",
    934=>"100101001",
    935=>"011110110",
    936=>"001111110",
    937=>"011011110",
    938=>"111111101",
    939=>"010111100",
    940=>"001000000",
    941=>"000000001",
    942=>"111111111",
    943=>"000000001",
    944=>"010111000",
    945=>"010111111",
    946=>"000000100",
    947=>"111110110",
    948=>"011111110",
    949=>"000000000",
    950=>"111111001",
    951=>"011111111",
    952=>"111111110",
    953=>"000000001",
    954=>"111111111",
    955=>"000000000",
    956=>"110110110",
    957=>"111001000",
    958=>"010110110",
    959=>"000110000",
    960=>"001011101",
    961=>"000111100",
    962=>"010010100",
    963=>"100100001",
    964=>"101011010",
    965=>"010010110",
    966=>"101101111",
    967=>"011111000",
    968=>"110100100",
    969=>"001011110",
    970=>"000000000",
    971=>"000010000",
    972=>"010000000",
    973=>"100001001",
    974=>"010110101",
    975=>"100101001",
    976=>"110101101",
    977=>"001001010",
    978=>"000110010",
    979=>"110110100",
    980=>"000101101",
    981=>"101001011",
    982=>"001001111",
    983=>"010100000",
    984=>"011110100",
    985=>"101001010",
    986=>"101001010",
    987=>"111001011",
    988=>"000101010",
    989=>"100101001",
    990=>"110010100",
    991=>"011010100",
    992=>"111000000",
    993=>"011111010",
    994=>"001011111",
    995=>"000000000",
    996=>"111110000",
    997=>"000000001",
    998=>"110110000",
    999=>"111111000",
    1000=>"100101001",
    1001=>"001000000",
    1002=>"100000000",
    1003=>"111111111",
    1004=>"001001001",
    1005=>"000001001",
    1006=>"111100100",
    1007=>"111001001",
    1008=>"101000110",
    1009=>"011110110",
    1010=>"111101101",
    1011=>"001001000",
    1012=>"000000000",
    1013=>"111111111",
    1014=>"111110000",
    1015=>"000001001",
    1016=>"000100100",
    1017=>"011000001",
    1018=>"011101111",
    1019=>"101101000",
    1020=>"100100110",
    1021=>"111110000",
    1022=>"101011111",
    1023=>"101000010");

BEGIN
    weight <= ROM_content(to_integer(address));
END RTL;