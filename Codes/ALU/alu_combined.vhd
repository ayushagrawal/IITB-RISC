library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity alu_combined is
	port ( 	ra , rb : in std_logic_vector(15 downto 0);
		rc : out std_logic_vector(15 downto 0);
		clock : in std_logic ;
		control_signals : in std_logic(1 downto 0);		
		zero_flag : out std_logic ;
		carry_flag : out std_logic
		);
end entity;

architecture formulas of alu_combined is
	
	component adder_16bit is	
		port ( 	ra , rb : in std_logic_vector(15 downto 0);
			rc : out std_logic_vector(15 downto 0);
			clock : in std_logic ;		
			zero_flag : out std_logic ;
			carry_flag : out std_logic
			);
	end component;
	
	component subtractor_16bit is
		port ( 	ra , rb : in std_logic_vector(15 downto 0);
			rc : out std_logic_vector(15 downto 0);
			clock : in std_logic ;	
			--carry_flag : out std_logic; 	
			zero_flag : out std_logic 
			);
	end component;

	component nand_logic is
	       port ( ra, rb : in std_logic_vector(15 downto 0);
	       rc : out std_logic_vector(15 downto 0);
	       clock : in std_logic ;
	       --carry_flag : out std_logic ;
	       zero_flag : out std_logic 
	     );
	end component;
	
	signal adder_output : std_logic_vector(15 downto 0);
	signal adder_carry, adder_zero : std_logic;

	signal subtractor_output : std_logic_vector(15 downto 0);
	signal subtractor_zero, subtractor_carry : std_logic;

	signal nand_output : std_logic_vector(15 downto 0);	
	signal nand_carry , nand_zero : std_logic ;

begin
	adder34 : adder_16bit port map (ra => ra, rb => rb, rc => adder_output, clock => clock, zero_flag => adder_zero, carry_flag => adder_carry);
	subtractor34 : subtractor_16bit port map (ra => ra, rb => rb, rc => subtractor_output, clock => clock, zero_flag => subtractor_zero);
	nand1 : nand_logic port map (ra => ra, rb => rb, rc => nand_output, clock => clock, zero_flag => nand_zero);

	process(clock)
	begin
	
	if (falling_edge(clock)) then
		if control_signals = "00" then			-- adder circuit
			rc <= adder_ouput ;
			zero_flag <= adder_zero ;
			carry_flag <= adder_carry ;

		elsif control_signals = "01" then 		-- subtractor circuit
			rc <= subtractor_output ;
			zero_flag <= subtractor_zero ;
			--carry_flag <= subtractor_carry ;        -- not needed

		elsif control_signals = "10" then		-- nand
			rc <= nand_output ;
			--carry_flag <= nand_carry ;		-- not needed
			zero_flag <= nand_zero ;	
		end if;	
	end if; 
end process ;
end formulas ;
