library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity mux8 is 
	generic (n : integer);
	port( in0,in1,in2,in3,in4,in5,in6,in7 : in std_logic_vector(n downto 0); 
	      control_signals : in std_logic_vector(2 downto 0); 
	      output : out std_logic_vector(n downto 0));
end entity;

architecture Behave of mux8 is
	signal sel0,sel1,sel2 : std_logic_vector(n downto 0);

begin 

sel0 <= (others => control_signals(0)) ;
sel1 <= (others => control_signals(1)) ;
sel2 <= (others => control_signals(2)) ;

output <= ((not sel0) and (not sel1) and (not sel2) and in0) or ((not sel0) and sel1 and (not sel2) and in1) or (sel0 and (not sel1) and (not sel2) and in2) or (sel0 and sel1 and (not sel2) and in3) or ((not sel0) and (not sel1) and sel2 and in4) or ((not sel0) and sel1 and sel2 and in5) or (sel0 and (not sel1) and sel2 and in6) or (sel0 and sel1 and sel2 and in7);

end Behave;
