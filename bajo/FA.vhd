library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity FA is
 Port ( in_b1 : in STD_LOGIC;
 in_b2 : in STD_LOGIC;
 Cin : in STD_LOGIC;
 S : out STD_LOGIC;
 Cout : out STD_LOGIC);
end FA;
 
architecture gate_level of FA is
 
begin
 
 S <= in_b1 XOR in_b2 XOR Cin ;
 Cout <= (in_b1 AND in_b2) OR (Cin AND in_b1) OR (Cin AND in_b2) ;
 
end gate_level;
