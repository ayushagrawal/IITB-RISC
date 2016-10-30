library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity nand_logic is 
	port ( ra, rb : in std_logic_vector(15 downto 0);
	       rc : out std_logic_vector(15 downto 0);
	       zero_flag : out std_logic 
	     );
end entity;

architecture form of nand_logic is
	signal rc1 : std_logic_vector(15 downto 0);
begin
	rc1 <= ra nand rb;	
	rc <= rc1 ;
	zero_flag <= not(rc1(0) or rc1(1) or rc1(2) or rc1(3) or rc1(4) or rc1(5) or rc1(6) or rc1(7) or 	rc1(8) or rc1(9) or rc1(10) or rc1(11) or rc1(12) or rc1(13) or rc1(14) or rc1(15)) ;
	
end form;
