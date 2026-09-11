library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
port(S:in std_logic_vector(3 downto 0);
     A:in std_logic_vector(9 downto 0);
     Q:out std_logic);
end mux;
architecture Behavioral of mux is
begin

Q<=(not S(3) and not S(2) and not S(1) and not S(0) and A(0))or
   (not S(3) and not S(2) and not S(1) and     S(0) and A(1))or
   (not S(3) and not S(2) and     S(1) and not S(0) and A(2))or
   (not S(3) and not S(2) and     S(1) and     S(0) and A(3))or
   (not S(3) and     S(2) and not S(1) and not S(0) and A(4))or
   (not S(3) and     S(2) and not S(1) and     S(0) and A(5))or
   (not S(3) and     S(2) and     S(1) and not S(0) and A(6))or
   (not S(3) and     S(2) and     S(1) and     S(0) and A(7))or 
   (    S(3) and not S(2) and not S(1) and not S(0) and A(8))or
   (    S(3) and not S(2) and not S(1) and     S(0) and A(9));
   
    
end Behavioral;