library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity sign_extender_9bit is 
	port ( input : in std_logic_vector(8 downto 0);
	       output : out std_logic_vector(15 downto 0) 
	     );
end entity;

architecture form of sign_extender_9bit is
	
begin
	output(8 downto 0) <= input(8 downto 0) ;
	output(15 downto 9) <= (others => input(8));
	
end form;
