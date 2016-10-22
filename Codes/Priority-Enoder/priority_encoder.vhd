library ieee ;
use ieee . std_logic_1164 . all ;

entity priority_encoder is
	port ( 
	input : in std_logic_vector(7 downto 0) ;
	output: out std_logic_vector(2 downto 0);
	out_N : out std_logic) ;
end priority_encoder ;

architecture behave of priority_encoder is
begin

out_N <= not (input(7)or input(6)or input(5)or input(4)or input(3)or input(2)or input(1)or input(0) ) ;    -- set to 1 when all inputs are 1 or 														  else 0 in other cases
output(0) <= (input(1)and(not input(0)))or(input(3)and(not input(2))and(not input(1))and(not input(0)))or(input(5)and(not input(4))and(not input(3))and(not input(2))and(not input(1))and(not input(0)))or(input(7)and(not input(6))and(not input(5))and(not input(4))and(not input(3))and(not input(2))and(not input(1))and(not input(0)));
output(1) <= (input(2)and(not input(1))and(not input(0)))or(input(3)and(not input(2))and(not input(1))and(not input(0)))or(input(6)and(not input(5))and(not input(4))and(not input(3))and(not input(2))and(not input(1))and(not input(0)))or(input(7)and(not input(6))and(not input(5))and(not input(4))and(not input(3))and(not input(2))and(not input(1))and(not input(0))) ;
output(2) <= (input(4)and(not input(3))and(not input(2))and(not input(1))and(not input(0)))or(input(5)and(not input(4))and(not input(3))and (not input(2))and(not input(1))and(not input(0)))or(input(6)and(not input(5))and(not input(4))and(not input(3))and(not input(2))and(not input(1))and(not input(0)))or(input(7)and(not input(6))and(not input(5))and(not input(4))and(not input(3))and(not input(2))and(not input(1))and(not input(0))) ;

end behave ;
