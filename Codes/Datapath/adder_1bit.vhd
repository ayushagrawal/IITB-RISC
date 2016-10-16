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
   signal carry,W : std_logic ;
   
begin
   W <= (a and (not b)) or ((not a) and b) ;
   s <= (W and (not cin)) or ((not W) and cin) ;
   cout <= (a and b) or (a and cin) or (b and cin) ;
end Formulas;
