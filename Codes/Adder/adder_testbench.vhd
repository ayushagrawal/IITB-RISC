library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
use IEEE.Numeric_STD.all;

entity adder_testbench is
end entity;

architecture Formulas of adder_testbench is 
	
component adder_16bit is
	port ( 	ra , rb : in std_logic_vector(15 downto 0);
		rc : out std_logic_vector(15 downto 0);	
		zero_flag : out std_logic ;
		carry_flag : out std_logic
		);
end component;

signal X,Y : std_logic_vector(15 downto 0) := x"0000" ;
signal Z : std_logic_vector(15 downto 0) := x"0000" ;
signal z_flag, carry_flag : std_logic := '0' ;

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
    File INFILE: text open read_mode is "TRACEFILE_adder.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS_adder.txt";

    ---------------------------------------------------
    -- edit the next two lines to customize
    variable input_vector: bit_vector (31 downto 0);
    variable output_vector: bit_vector (17 downto 0);
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin
	  while not endfile(INFILE) loop 
          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, input_vector);
	  read (INPUT_LINE, output_vector);

          -- from input-vector to DUT inputs -------
	  for i in 16 to 31 loop
	  X(i-16) <= to_std_logic(input_vector(i));
	  end loop;
          for j in 0 to 15 loop
	  Y(j) <= to_std_logic(input_vector(j)); 
	  end loop;	
          --------------------------------------
	  -- let circuit respond -----------
          wait for 50 ns;
	
	-- check outputs.
	for I in 0 to 15 loop
	  if (Z(I) /= to_std_logic(output_vector(I))) then
             write(OUTPUT_LINE,to_string("ERROR: in Z, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if ;
    	end loop;
		
	if (carry_flag /= to_std_logic(output_vector(17))) then
	     write(OUTPUT_LINE,to_string("ERROR: in carry_flag, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
	elsif (z_flag /= to_std_logic(output_vector(16))) then
	     write(OUTPUT_LINE,to_string("ERROR: in carry_flag, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
	end if;

	end loop;
    
assert (err_flag) report "SUCCESS, all tests passed." severity note;
assert (not err_flag) report "FAILURE, some tests failed." severity error;

wait;

end process;

dut: adder_16bit
  port map ( 	ra => X,
           	rb => Y,
           	rc => Z,
	   	zero_flag => z_flag,
	   	carry_flag => carry_flag );

end Formulas ;

