library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
use IEEE.Numeric_STD.all;

entity testbench_register is
end entity;

architecture Formulas of testbench_register is 
	
component register16 is
		port(dataIn: in std_logic_vector(15 downto 0);
			  enable: in std_logic;
			  dataOut: out std_logic_vector(15 downto 0);
			  clock: in std_logic;
			  reset: in std_logic);
	end component;

signal X : std_logic_vector(15 downto 0) := x"0000" ;
signal Y : std_logic_vector(15 downto 0) := x"0000" ;
signal clk,reset,enable : std_logic := '0' ;

function to_std_logic(x: bit) return std_logic is
     variable ret_val: std_logic;
 begin  
     if (x = '1') then
       ret_val := '1';
     else 
       ret_val := '0';
     end if;
     return(ret_val);
 end to_std_logic;

 function to_string(x: string) return string is
     variable ret_val: string(1 to x'length);
     alias lx : string (1 to x'length) is x;
 begin  
     ret_val := lx;
     return(ret_val);
 end to_string;

begin
  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "TRACEFILE_register.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS_register.txt";

    ---------------------------------------------------
    -- edit the next two lines to customize
    variable input_vector: bit_vector (15 downto 0);
	variable clock_vector: bit;
	variable enable_vector: bit;
	variable reset_vector: bit;
    variable output_vector: bit_vector (15 downto 0);
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin
	  while not endfile(INFILE) loop 
          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
		  read(INPUT_LINE, clock_vector);
		  read(INPUT_LINE, reset_vector);
		  read(INPUT_LINE,enable_vector);
          read (INPUT_LINE, input_vector);
		  
	  read (INPUT_LINE, output_vector);

          -- from input-vector to DUT inputs -------
	  for i in 0 to 15 loop
	  X(i) <= to_std_logic(input_vector(i));
	  end loop;
	  clk <= to_std_logic(clock_vector);
	  reset <= to_std_logic(reset_vector);
	  enable <= to_std_logic(enable_vector);
          --------------------------------------
	  -- let circuit respond -----------
          wait for 10 ns;
	
	-- check outputs.
	for I in 0 to 15 loop
	  if (Z(I) /= to_std_logic(output_vector(I))) then
             write(OUTPUT_LINE,to_string("ERROR: in Z, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if ;
    	end loop;

	end loop;
    
assert (err_flag) report "SUCCESS, all tests passed." severity note;
assert (not err_flag) report "FAILURE, some tests failed." severity error;

wait;

end process;

dut: register16
  port map ( 	dataIn => X,
           	dataOut => Y,
           	clock => clk,
	   	enable => enable,
			reset => reset);

end Formulas ;