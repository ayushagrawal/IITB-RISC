library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity mux_3to1_16bit is 
	port( in1,in2,in3 : in std_logic_vector(15 downto 0); 
	      control_signals : in std_logic_vector(1 downto 0); 
	      out1: out std_logic_vector(15 downto 0));
end entity;

architecture Behave of mux_3to1_16bit is
	signal sel0,sel1 : std_logic_vector(15 downto 0);

begin 

sel0 <= (others => control_signals(1)) ;
sel1 <= (others => control_signals(0)) ;

out1 <= ((not sel0) and (not sel1) and (in1)) or ((not sel0) and sel1 and in2) or (sel0 and (not sel1) and in3);

end Behave;
