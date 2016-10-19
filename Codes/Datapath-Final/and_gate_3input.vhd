library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity and_gate_3input is 
	port( input : in std_logic_vector(2 downto 0);
		  output : out std_logic) ;
end entity;

architecture Behave of and_gate_3input is
	
begin 

output <=input(0) and input(1) and input(2);
end Behave;
