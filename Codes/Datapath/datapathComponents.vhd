library std ;
use std.standard.all ;

library ieee;
use ieee.std_logic_1164.all;

package datapathComponents is
	component LH is 
	port ( input : in std_logic_vector(8 downto 0);
	       output : out std_logic_vector(15 downto 0) 
	     );
	end component;
	
	component adder_16bit is
	port ( 	ra , rb : in std_logic_vector(15 downto 0);
		rc : out std_logic_vector(15 downto 0);		
		zero_flag : out std_logic ;
		carry_flag : out std_logic
		);
	end component;
	
	component adder_1bit is
   	port(
		a,b,cin : in std_logic; 			--inputs
        	s,cout: out std_logic 				--outputs 
		); 			
	end component;
	
	component adder_4bit is
	port ( a4 , b4 : in std_logic_vector(3 downto 0);
		s4 : out std_logic_vector(3 downto 0);
		cin : in std_logic ;
		cout : out std_logic
	);
	end component;
	
	component alu_combined is
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
	end component;
	
	component and_gate_3input is 
	port( input : std_logic_vector(2 downto 0);
		  output : std_logic) ;
	end component;
	
	component mux is
		port(input0,input1,input2,input3,input4,input5,input6: in std_logic_vector(15 downto 0);
			  output: out std_logic_vector(15 downto 0);
			  selectPins: in std_logic_vector(2 downto 0));
	end component;
	
	component decoder is
		port(input: in std_logic_vector(2 downto 0);
			  output: out std_logic_vector(6 downto 0));
	end component;
	
	component register16 is
		port(dataIn: in std_logic_vector(15 downto 0);
			  enable: in std_logic;
			  dataOut: out std_logic_vector(15 downto 0);
			  clock: in std_logic;
			  reset: in std_logic);
	end component;
	
	
end datapathComponents;
