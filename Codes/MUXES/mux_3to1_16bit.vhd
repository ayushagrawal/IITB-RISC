library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity mux_3to1_16bit is 
	port( in_00,in_01,in_10 : in std_logic_vector(15 downto 0); 
	      control_signals : in std_logic_vector(1 downto 0); 
	      out1: out std_logic_vector(15 downto 0));
end entity;

architecture Behave of mux_3to1_16bit is
	signal sel0,sel1 : std_logic_vector(15 downto 0);

begin 

sel0 <= (others => control_signals(1)) ;
sel1 <= (others => control_signals(0)) ;

out1 <= ((not sel0) and (not sel1) and (in_00)) or ((not sel0) and sel1 and in_01) or (sel0 and (not sel1) and in_10);

end Behave;
