library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity adder_16bit is
	port ( 	ra , rb : in std_logic_vector(15 downto 0);
		rc : out std_logic_vector(15 downto 0);
		clock : in std_logic ;		
		z_flag : out std_logic ;
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
	
	signal carry16 : std_logic_vector(4 downto 0);
	carry16(0) <= '0';
	
	begin
	process(clock)
	
	if(clock'event and clock = '1') then			-- sampling at rising edge of the clock

	adder5 : adder_4bit port map (a4 => a16(3 downto 0), b4 => b16(3 downto 0), cin => carry16(0), cout => carry16(1)) ;
	adder6 : adder_4bit port map (a4 => a16(7 downto 4), b4 => b16(7 downto 4), cin => carry16(1), cout => carry16(2));
	adder7 : adder_4bit port map (a4 => a16(11 downto 8), b4 => b16(11 downto 8), cin => carry16(2), cout => carry16(3));
	adder8 : adder_4bit port map (a4 => a16(15 downto 12), b4 => b16(15 downto 12), cin => carry16(3), cout => carry16(4));
	
	if(carry(16) = '1') then				-- assigning the carry flag
		carry_flag <= '1' ;
	else 
		carry_flag <= '0' ;
	end if ;
	
	if(rc = 0) then						-- assigning the zero flag
		zero_flag <= '1' ;
	else
		zero_flag <= '0' ;
	end if;

	end if;

end formulas ;
