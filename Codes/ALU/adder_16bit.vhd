library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity adder_16bit is
	port ( 	ra , rb : in std_logic_vector(15 downto 0);
		rc : out std_logic_vector(15 downto 0);		
		zero_flag : out std_logic ;
		carry_flag : out std_logic
		);
end entity;

architecture formulas of adder_16bit is
	
	component adder_4bit is 
		port ( 	a4 , b4 : in std_logic_vector(3 downto 0);
			s4 : out std_logic_vector(3 downto 0);
			cin : in std_logic ;
			cout : out std_logic
		);
   	end component ; 
	
	signal carry16 : std_logic_vector(4 downto 0) := "00000";
	signal sum_var : std_logic_vector(15 downto 0);
	
	begin

adder5 : adder_4bit port map (a4 => ra(3 downto 0), b4 => rb(3 downto 0), cin => carry16(0), cout => carry16(1),s4 => sum_var(3 downto 0)) ;
adder6 : adder_4bit port map (a4 => ra(7 downto 4), b4 => rb(7 downto 4), cin => carry16(1), cout => carry16(2),s4 => sum_var(7 downto 4));
adder7 : adder_4bit port map (a4 => ra(11 downto 8), b4 => rb(11 downto 8),cin => carry16(2), cout => carry16(3),s4 => sum_var(11 downto 8));
adder8 : adder_4bit port map (a4 => ra(15 downto 12),b4 => rb(15 downto 12),cin => carry16(3),cout => carry16(4),s4 =>sum_var(15 downto 12));

	process(sum_var)
	begin
	rc <= sum_var;

	carry_flag <= carry16(4) ;

	zero_flag <= not(sum_var(0) or sum_var(1) or sum_var(2) or sum_var(3) or sum_var(4) or sum_var(5) or sum_var(6) or sum_var(7) or 	sum_var(8) or sum_var(9) or sum_var(10) or sum_var(11) or sum_var(12) or sum_var(13) or sum_var(14) or sum_var(15)) ;

end process;
end formulas ;
