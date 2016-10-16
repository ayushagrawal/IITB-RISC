library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity mux_2to1_8bit is 
	port( in0,in1 : in std_logic_vector(7 downto 0); 
	      sel : in std_logic; 
	      out1: out std_logic_vector(7 downto 0));
end entity;

architecture Behave of mux_2to1_8bit is
	signal sel0 : std_logic_vector(7 downto 0);

begin 

sel0 <= (others => sel) ;

out1 <= ((not sel0) and (in0)) or ((sel0) and (in1)) ;

end Behave;
