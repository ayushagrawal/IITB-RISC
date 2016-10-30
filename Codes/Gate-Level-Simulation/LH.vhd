library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity LH is 
	port ( input : in std_logic_vector(8 downto 0);
	       output : out std_logic_vector(15 downto 0) 
	     );
end entity;

architecture form of LH is
	
begin
	output(15 downto 7) <= input(8 downto 0) ;
	output(6 downto 0) <= "0000000";
	
end;
