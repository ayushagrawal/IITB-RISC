library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity subtractor_16bit is
	port ( 	ra , rb : in std_logic_vector(15 downto 0);	
			rc : out std_logic_vector(15 downto 0);
		zero_flag : out std_logic 
		);
end entity;

architecture formulas of subtractor_16bit is
	signal temp : std_logic_vector(15 downto 0);
begin
	temp <= (ra xor rb);
	rc <= temp;
	zero_flag <= not(temp(0) or temp(1) or temp(2) or temp(3) or temp(4) or temp(5) or temp(6) or temp(7) or temp(8) or temp(9) or temp(10) or temp(11) or temp(12) or temp(13) or temp(14) or temp(15));
end formulas ;
