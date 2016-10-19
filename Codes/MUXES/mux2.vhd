library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity mux2 is 
	generic (n : integer);
	port( in1,in2 : in std_logic_vector(n downto 0); 
	      sel : in std_logic; 
	      output : out std_logic_vector(n downto 0));
end entity;

architecture Behave of mux2 is
	signal sel0 : std_logic_vector(n downto 0);

begin 

sel0 <= (others => sel) ;

output <= ((not sel0) and in1) or (sel0 and in2);

end Behave;
