library std ;
use std.standard.all ;

library ieee;
use ieee.std_logic_1164.all;

package datapathComponents is

	component counter IS
		PORT
		(
			aclr		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			cnt_en		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
		);
	END component;

	component memory IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rden		: IN STD_LOGIC  := '1';
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	END component;
		
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
	
	component alu is
		port ( 	ra , rb : in std_logic_vector(15 downto 0);			-- input 
			rc : out std_logic_vector(15 downto 0);					-- output
			op2in: in std_logic_vector(1 downto 0);			-- last 2 bits of opcode
			op4in : in std_logic_vector(3 downto 0);			-- first 4 bits of opcode
			enable_carry : in std_logic;							-- enable carry register
			enable_zero : in std_logic;								-- enable zero register
			add_signal : in std_logic;
			clock : in std_logic ;
			reset : in std_logic;
			carry_flag : out std_logic;
			zero_flag : out std_logic 
			);
	end component;
	
	component and_gate_3input is 
	port( input : std_logic_vector(2 downto 0);
		  output : std_logic) ;
	end component;
	
	component mux2 is 
		generic (n : integer);
		port( in0,in1 : in std_logic_vector(n downto 0); 
				sel : in std_logic; 
				output : out std_logic_vector(n downto 0));
	end component;
	
	component mux3 is 
		generic (n : integer);
		port( in1,in2,in0 : in std_logic_vector(n downto 0); 
				sel : in std_logic_vector(1 downto 0); 
				output: out std_logic_vector(n downto 0));
	end component;
	
	component mux4 is 
		generic (n : integer);
		port( in1,in2,in3,in0 : in std_logic_vector(n downto 0); 
				sel : in std_logic_vector(1 downto 0); 
				output: out std_logic_vector(n downto 0));
	end component;
	
	component mux8 is 
		generic (n : integer);
		port( in1,in2,in3,in4,in5,in6,in7,in0 : in std_logic_vector(n downto 0); 
				sel : in std_logic_vector(2 downto 0); 
				output : out std_logic_vector(n downto 0));
	end component;
	
	component decoder is
		port(input: in std_logic_vector(2 downto 0);
			  output: out std_logic_vector(7 downto 0));
	end component;
	
		
	component nand_logic is 
		port ( ra, rb : in std_logic_vector(15 downto 0);
	       		rc : out std_logic_vector(15 downto 0);
	       		zero_flag : out std_logic 
	    	 );
	end component;
	
	component register16 is
		port(	dataIn: in std_logic_vector(15 downto 0);
			  enable: in std_logic;
			  dataOut: out std_logic_vector(15 downto 0);
			  clock: in std_logic;
			  reset: in std_logic);
	end component;

	component register8 is
		port(dataIn: in std_logic_vector(7 downto 0);
			  enable: in std_logic;
			  dataOut: out std_logic_vector(7 downto 0);
			  clock: in std_logic;
			  reset: in std_logic);
	end component;
	
	component registerBank is
	port(dataOut_A: out std_logic_vector(15 downto 0);
		  dataOut_B: out std_logic_vector(15 downto 0);
		  clock_rb : in std_logic;
		  regSel_A : in std_logic_vector(2 downto 0);
		  regSel_B : in std_logic_vector(2 downto 0);
		  dataIn	  : in std_logic_vector(15 downto 0);
		  dataInsel: in std_logic_vector(2 downto 0);
		  reset	  : in std_logic;
		  regWrite : in std_logic;
		  pc_in    : in std_logic_vector(15 downto 0);
		  r7_select: in std_logic);
	end component;
	
	component register_1bit is
		port(     dataIn: in std_logic;
			  enable: in std_logic;
			  dataOut: out std_logic;
			  clock: in std_logic;
			  reset: in std_logic);
	end component;
		
	component sign_extender_6bit is 
	port ( input : in std_logic_vector(5 downto 0);
	       output : out std_logic_vector(15 downto 0) 
	     );
	end component;
		
	
	component sign_extender_9bit is 
		port ( input : in std_logic_vector(8 downto 0);
		       output : out std_logic_vector(15 downto 0) 
	     	);
	end component;
		
	component subtractor_16bit is
	port ( 	ra , rb : in std_logic_vector(15 downto 0);
		rc : out std_logic_vector(15 downto 0);		
		zero_flag : out std_logic 
		);
	end component;
	
	
end datapathComponents;
