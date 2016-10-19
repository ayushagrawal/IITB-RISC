library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity adder_1bit is
   port(
	a,b,cin : in std_logic; 			--inputs
        s,cout: out std_logic 				--outputs 
	); 			
end entity;

architecture Formulas of adder_1bit is   
begin
   s <= a xor b xor cin;
   cout <= (a and(b or  cin)) or (b and cin) ;
end Formulas;
