library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std; 
use std.standard.all;

entity alu is
	port ( 	ra , rb : in std_logic_vector(15 downto 0);			-- input 
		rc : out std_logic_vector(15 downto 0);					-- output
		op2in: in std_logic_vector(1 downto 0);			-- last 2 bits of opcode
		op4in : in std_logic_vector(3 downto 0);			-- first 4 bits of opcode
		enable_carry : in std_logic;							-- enable carry register
		enable_zero : in std_logic;								-- enable zero register
		add_signal : in std_logic;
		clock : in std_logic ;						
		carry_flag : out std_logic;
		zero_flag : out std_logic 
		);
end entity;

architecture formulas of alu is
	
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
		
	signal adder_output : std_logic_vector(15 downto 0);
	signal addc, addz : std_logic;

	signal subtractor_output : std_logic_vector(15 downto 0);
	signal subz   : std_logic;

	signal nand_output : std_logic_vector(15 downto 0);	
	signal nandz   : std_logic ;

	signal rc1 : std_logic_vector(15 downto 0);
	signal zero_temp  : std_logic;	
	signal carry_temp : std_logic;
	signal zero_flag1  : std_logic;
	signal carry_flag1  : std_logic;
	signal carry_flag2 : std_logic;
	signal zero_flag2 : std_logic;

begin
    add1 : adder_16bit port map (ra =>ra,rb => rb, rc =>adder_output, zero_flag =>addz, carry_flag =>addc);
    sub1 : subtractor_16bit port map (ra => ra, rb => rb, rc => subtractor_output, zero_flag => subz);
    nnd1 : nand_logic port map (ra => ra, rb => rb, rc => nand_output, zero_flag => nandz);
	
	zero_temp <= (addz and(not op4in(3))and(not op4in(2))and(not op4in(1))) or (subz and(op4in(3))and(op4in(2))and(not op4in(1))and(not 					op4in(0))) or (nandz and(not op4in(3))and(not op4in(2))and(op4in(1))and(not op4in(0)));
	carry_temp <= (addc)and(not op4in(3))and(not op4in(2))and(not op4in(1));
   	
	reg1 : register_1bit port map (dataIn => carry_temp,enable => enable_carry,dataOut => carry_flag1,clock => clock ,reset => reset);	
	reg2 : register_1bit port map (dataIn => zero_temp,enable => enable_zero, dataOut => zero_flag1,clock => clock, reset => reset);

	reg3 : register_1bit port map (dataIn => carry_temp,enable => enable_carry and op2in(1) and (not op2in(0)),dataOut => carry_flag2,
									clock => clock , reset => reset);
	reg4 : register_1bit port map (dataIn => carry_temp,enable => enable_zero and (not op2in(1)) and op2in(0),dataOut => zero_flag2,
									clock => clock, reset => reset);	
	process(adder_output,carry_flag1,zero_flag1,nand_output,op2in,op4in,add_signal,nand_output)
	variable carry_var	 : 	std_logic;
	variable zero_var 	 : 	std_logic;
	variable output_var  : 	std_logic_vector(15 downto 0);

	begin

if (add_signal = '1') then											-- for updating the PC
	output_var := adder_output ;

elsif (add_signal = '0') then
	if (op4in = "0000") then										-- add operations
		if(op2in = "00") then										-- ADD
			output_var := adder_output ;
			carry_var  := carry_flag1;
			zero_var  :=  zero_flag1;

		elsif(op2in = "10") then									-- ADC (??)
																	-- checks if carry flag is set
				output_var := adder_output ;
				carry_var  := carry_flag2;
				zero_var  :=  zero_flag2;
			end if;

		elsif(op2in = "01") then									-- ADZ (??)
			                               							-- checks if zero flag is set
				output_var := adder_output ;
				carry_var  := carry_flag2;
				zero_var  :=  zero_flag2;
			end if;
		end if;

	elsif (op4in = "0001") then										-- ADI
		output_var := adder_output ;
		carry_var  := carry_flag1;
		zero_var   := zero_flag1;
		
	elsif (op4in = "0010") then							       		 -- NAND operations
		if (op2in = "00") then										 -- NDU
		output_var := nand_output ;	
		zero_var   := zero_flag1;
		
		elsif (op2in = "10") then									  -- NDC (??)
									 								  -- check if carry flag is set
				output_var := nand_output ;	
				zero_var   := zero_flag2;
			end if;

		elsif (op2in = "01") then									  -- NDZ (??)
																	  -- check if zero flag is set
				output_var := nand_output ;	
				zero_var   := zero_flag2;
			end if;
		end if;
	
	elsif (op4in = "1100") then									-- BEQ
		zero_var := zero_flag1;
	end if;
end if;

	rc         <= output_var ;
	zero_flag  <= zero_var ;
	carry_flag <= carry_var ;
end process ;
end formulas ;
