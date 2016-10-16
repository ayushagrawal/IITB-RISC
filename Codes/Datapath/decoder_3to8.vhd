library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity decoder_3to8 is 
	port( input : std_logic_vector(2 downto 0);
		  output : std_logic_vector(7 downto 0)
		  );
end entity;

architecture Behave of decoder_3to8 is
	
begin 
process(input)
begin
	if (input = "000") then
		output <= 11111110 ;
	elsif (input = "001") then
		output <= 11111101 ;
	elsif (input = "010") then
		output <= 11111011 ;
	elsif (input = "011") then
		output <= 11110111 ;
	elsif (input = "100") then
		output <= 11101111 ;
	elsif (input = "101") then
		output <= 11011111 ;
	elsif (input = "110") then
		output <= 10111111 ;
	elsif (input = "111") then
		output <= 01111111 ;
	end if ;
			
end process	
end Behave;
