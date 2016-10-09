library std ;
use std.standard.all ;

library ieee;
use ieee.std_logic_1164.all;

package adder_components is
	component adder_1bit is
		port( a,b,cin : in std_logic ;
		      s, cout : out std_logic
		);
	end component ;

	component adder_4bit is
		port ( a4 , b4 : in std_logic_vector(3 downto 0);
			s4 : out std_logic_vector(3 downto 0);
			cin : in std_logic ;
			cout : out std_logic
		);
	end component;

end adder_components; 
