library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity sign_extender_6bit is 
	port ( input : in std_logic_vector(5 downto 0);
	       output : out std_logic_vector(15 downto 0) 
	     );
end entity;

architecture form of sign_extender_6bit is
	
begin
	output(5 downto 0) <= input(5 downto 0) ;
	output(15 downto 6) <= (others => input(5));
	
end form;
