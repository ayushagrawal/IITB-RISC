library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity nand_logic is 
	port ( ra, rb : in std_logic_vector(15 downto 0);
	       rc : out std_logic_vector(15 downto 0);
	       clock : in std_logic ;
	       zero_flag : out std_logic 
	     );
end entity;

architecture form of nand_logic is
	signal rc1 : std_logic_vector(15 downto 0);
begin
	rc1 <= not(ra and rb);	
	
	process(clock)
	begin
	
	if (falling_edge(clock)) then
	rc <= rc1 ;
	if (rc1 = "0000000000000000") then
		zero_flag <= '1';
	else 
		zero_flag <= '0';
	end if;
	end if;
end process;
end form;
