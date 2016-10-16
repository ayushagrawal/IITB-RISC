library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity mux_4to1_3bit is 
	port( in_00,in_11,in_01,in_10 : in std_logic_vector(2 downto 0); 
	      control_signals : in std_logic_vector(1 downto 0); 
	      out1: out std_logic_vector(2 downto 0));
end entity;

architecture Behave of mux_4to1_3bit is
	signal sel0,sel1 : std_logic_vector(2 downto 0);

begin 

sel0 <= (others => control_signals(1)) ;
sel1 <= (others => control_signals(0)) ;

out1 <= ((not sel0) and (not sel1) and in_00) or ((not sel0) and sel1 and in_01) or (sel0 and (not sel1) and in_10) or (sel0 and sel1 and in_11);

end Behave;
