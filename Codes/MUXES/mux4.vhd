library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity mux4 is 
	generic (n : integer);
	port( in1,in2,in3,in4 : in std_logic_vector(n downto 0); 
	      control_signals : in std_logic_vector(1 downto 0); 
	      output: out std_logic_vector(n downto 0));
end entity;

architecture Behave of mux4 is
	signal sel0,sel1 : std_logic_vector(n downto 0);

begin 

sel0 <= (others => control_signals(0)) ;
sel1 <= (others => control_signals(1)) ;

output <= ((not sel0) and (not sel1) and in1) or ((not sel0) and sel1 and in2) or (sel0 and (not sel1) and in3) or (sel0 and sel1 and in4);

end Behave;
