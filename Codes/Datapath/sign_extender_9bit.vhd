library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity sign_extender_9bit is 
	port ( input : in std_logic_vector(9 downto 0);
	       output : out std_logic_vector(15 downto 0) 
	     );
end entity;

architecture form of sign_extender_9bit is
	
begin
	output(9 downto 0) <= input(9 downto 0) ;
	output(15 downto 10) <= (others => input(9));
	
end form;
