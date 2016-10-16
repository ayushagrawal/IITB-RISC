library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity adder_4bit is
	port ( a4 , b4 : in std_logic_vector(3 downto 0);
		s4 : out std_logic_vector(3 downto 0);
		cin : in std_logic ;
		cout : out std_logic
	);
end entity;

architecture formulas of adder_4bit is
	component adder_1bit is 
		port (
			a,b,cin : in std_logic ;
			s,cout : out std_logic 
		);
   	end component ; 
	
	signal carry4 : std_logic_vector(3 downto 0) := "0000";
	
	begin
	adder1 : adder_1bit port map (a => a4(0), b => b4(0), cin => cin, cout => carry4(1), s => s4(0)) ;
	adder2 : adder_1bit port map (a => a4(1), b => b4(1), cin => carry4(1), cout => carry4(2), s => s4(1));
	adder3 : adder_1bit port map (a => a4(2), b => b4(2), cin => carry4(2), cout => carry4(3), s => s4(2));
	adder4 : adder_1bit port map (a => a4(3), b => b4(3), cin => carry4(3), cout => cout, s => s4(3));

end formulas ;
