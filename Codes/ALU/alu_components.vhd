library std ;
use std.standard.all ;

library ieee;
use ieee.std_logic_1164.all;

package alu_components is
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

	component adder_16bit is
		port ( 	ra , rb : in std_logic_vector(15 downto 0);
			rc : out std_logic_vector(15 downto 0);
			clock : in std_logic ;		
			zero_flag : out std_logic ;
			carry_flag : out std_logic
			);
	end component;

	component subtractor_16bit is
		port ( 	ra , rb : in std_logic_vector(15 downto 0);
			rc : out std_logic_vector(15 downto 0);
			clock : in std_logic ;	
			carry_flag : out std_logic; 	
			zero_flag : out std_logic 
			);
	end component;

	component nand_logic is
	       port ( ra, rb : in std_logic_vector(15 downto 0);
	       rc : out std_logic_vector(15 downto 0);
	       clock : in std_logic ;
	       carry_flag : out std_logic ;
	       zero_flag : out std_logic 
	     );
	end component;

end alu_components; 
