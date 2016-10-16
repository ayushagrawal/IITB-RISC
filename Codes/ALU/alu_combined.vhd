library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity alu_combined is
	port ( 	ra , rb : in std_logic_vector(15 downto 0);
		rc : out std_logic_vector(15 downto 0);
		control_signals : in std_logic_vector(1 downto 0);
		clock : in std_logic ;
		enable_carry : in std_logic;
		enable_zero : in std_logic;
		carry_flag : out std_logic;
		reset : in std_logic;		
		zero_flag : out std_logic 
		);
end entity;

architecture formulas of alu_combined is
	
	component register_1bit is 
		port	( dataIn: in std_logic;
			  enable: in std_logic;
			  dataOut: out std_logic;
			  clock: in std_logic;
			  reset: in std_logic);
		end component;

	component adder_16bit is	
		port ( 	ra , rb : in std_logic_vector(15 downto 0);
			rc : out std_logic_vector(15 downto 0);	
			zero_flag : out std_logic ;
			carry_flag : out std_logic
			);
	end component;
	
	component subtractor_16bit is
		port ( 	ra , rb : in std_logic_vector(15 downto 0);
			rc : out std_logic_vector(15 downto 0);	
			zero_flag : out std_logic 
			);
	end component;

	component nand_logic is
	       port ( ra, rb : in std_logic_vector(15 downto 0);
	       rc : out std_logic_vector(15 downto 0);
	       zero_flag : out std_logic 
	     );
	end component;
	
	component mux is 
		port( 	in1,in2,in3 : in std_logic_vector(15 downto 0); 
	      		control_signals : in std_logic_vector(1 downto 0); 
	      		out1: out std_logic_vector(15 downto 0));
	end component;

	component mux_1bit is 
		port( 	in1,in2,in3 : in std_logic; 
		      	control_signals : in std_logic_vector(1 downto 0); 
	      		out1: out std_logic);
	end component;
	
	signal adder_output : std_logic_vector(15 downto 0);
	signal adder_carry, adder_zero : std_logic;

	signal subtractor_output : std_logic_vector(15 downto 0);
	signal subtractor_zero : std_logic;

	signal nand_output : std_logic_vector(15 downto 0);	
	signal nand_zero : std_logic ;

	signal rc1 : std_logic_vector(15 downto 0);
	signal zero_flag1 : std_logic;	
	signal carry_flag2 : std_logic;
	signal zero_flag2 : std_logic;
begin
    adder34 : adder_16bit port map (ra =>ra,rb => rb, rc =>adder_output, zero_flag =>adder_zero, carry_flag =>adder_carry);
    subtractor34 : subtractor_16bit port map (ra => ra, rb => rb, rc => subtractor_output, zero_flag => subtractor_zero);
    nand1 : nand_logic port map (ra => ra, rb => rb, rc => nand_output, zero_flag => nand_zero);
    mux1 : mux port map (in1 =>adder_output,in2 => subtractor_output, in3 => nand_output,control_signals => control_signals, out1 => rc1);
    mux2 : mux_1bit port map (in1 => adder_zero,in2 => subtractor_zero,in3 =>nand_zero,control_signals =>control_signals,out1 => zero_flag1);
	 reg1 : register_1bit port map(dataIn => zero_flag1,enable => enable_zero,dataOut => zero_flag2,clock => clock,reset => reset);
	 reg2 : register_1bit port map(dataIn => adder_carry,enable => enable_carry,dataOut => carry_flag2,clock => clock, reset => reset);
	 
	process(rc1,zero_flag2,carry_flag2)
	begin
	
    	rc <= rc1 ;	
		carry_flag <= carry_flag2 ;
		zero_flag <= zero_flag2 ;
    	 
   
end process ;
end formulas ;
