library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
use IEEE.Numeric_STD.all;

entity testbench_registerBank is
end entity;

architecture Formulas of testbench_registerBank is 
	
component registerBank is
	port(dataOut_A: out std_logic_vector(15 downto 0);
		  dataOut_B: out std_logic_vector(15 downto 0);
		  clock_rb : in std_logic;
		  regSel_A : in std_logic_vector(2 downto 0);
		  regSel_B : in std_logic_vector(2 downto 0);
		  dataIn	  : in std_logic_vector(15 downto 0);
		  dataInsel: in std_logic_vector(2 downto 0);
		  reset	  : in std_logic;
		  regWrite : in std_logic);
end component;

signal A : std_logic_vector(15 downto 0) := x"0000" ;
signal B : std_logic_vector(15 downto 0) := x"0000" ;
signal X : std_logic_vector(15 downto 0) := x"0000" ;
signal A_sel : std_logic_vector(2 downto 0) := "000" ;
signal B_sel : std_logic_vector(2 downto 0) := "000" ;
signal X_sel : std_logic_vector(2 downto 0) := "000" ;
signal clk,reset,regWrite : std_logic := '0' ;

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
    File INFILE: text open read_mode is "TRACEFILE_registerBank.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS_registerBank.txt";

    ---------------------------------------------------
    -- edit the next two lines to customize
    variable A_vector: bit_vector (15 downto 0);
	variable B_vector: bit_vector (15 downto 0);
	variable X_vector: bit_vector (15 downto 0);
	variable clock_vector: bit;
	variable reset_vector: bit;
	variable regWrite_vector: bit;
	variable A_sel_vector: bit_vector(2 downto 0);
	variable B_sel_vector: bit_vector)(2 downto 0);
	variable X_sel_vector: bit_vector)(2 downto 0);
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
		  read(INPUT_LINE,A_sel_vector);
          read (INPUT_LINE,B_sel_vector);
		  read(INPUT_LINE,X_sel_vector);
		  read(INPUT_LINE,regWrite_vector);
		  read(INPUT_LINE,X_vector);
		  
	  read (INPUT_LINE, A_vector);
	  read (INPUT_LINE, B_vector);

          -- from input-vector to DUT inputs -------
	  for i in 0 to 15 loop
	  X(i) <= to_std_logic(X_vector(i));
	  end loop;
	  for i in 0 to 2 loop
	  A_sel(i) <= to_std_logic(A_sel_vector(i));
	  end loop;
	  for i in 0 to 2 loop
	  B_sel(i) <= to_std_logic(B_sel_vector(i));
	  end loop;
	  for i in 0 to 2 loop
	  X_sel(i) <= to_std_logic(X_sel_vector(i));
	  end loop;
	  clk <= to_std_logic(clock_vector);
	  reset <= to_std_logic(reset_vector);
	  regWrite <= to_std_logic(regWrite_vector);
          --------------------------------------
	  -- let circuit respond -----------
          wait for 10 ns;
	
	-- check outputs.
	for I in 0 to 15 loop
	  if (A(I) /= to_std_logic(A_vector(I))) then
             write(OUTPUT_LINE,to_string("ERROR: in A, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if ;
    	end loop;
	  if (B(I) /= to_std_logic(B_vector(I))) then
             write(OUTPUT_LINE,to_string("ERROR: in B, line "));
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
  port map (dataOut_A => A,
		  dataOut_B => B,
		  clock_rb => clk,
		  regSel_A => A_sel,
		  regSel_B => B_sel,
		  dataIn	=> X,
		  dataInsel => X_sel,
		  reset	  => reset,
		  regWrite => regWrite);

end Formulas ;