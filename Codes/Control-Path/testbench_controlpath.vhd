library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;

entity testbench_controlpath is

end entity;

architecture Behave of testbench_controlpath is
	
	component fsm_controller is 
 	 port (opcode				: in std_logic_vector(3 downto 0);
		  reset				  	: in std_logic;
		  carry					: in std_logic;
		  zero					: in std_logic;
		  clk						: in std_logic;
		  -- Add control signals here
		  reset_to_DataPath 	: out std_logic;
		  pc_reg_crtl			: out std_logic;
		  address_crtl			: out std_logic_vector(1 downto 0);
		  wren					: out std_logic;
		  rden					: out std_logic;
		  ir_crtl				: out std_logic;
		  mem_data_crtl			: out std_logic;
		  reg_data_crtl			: out std_logic_vector(1 downto 0);
		  reg_sel_crtl			: out std_logic_vector(1 downto 0);
		  regWrite				: out std_logic;
		  reg_A_crtl			: out std_logic;
		  reg_B_crtl			: out std_logic;
		  alu_a_sel				: out std_logic_vector(1 downto 0);
		  alu_b_sel				: out std_logic_vector(1 downto 0);
		  alu_reg_crtl			: out std_logic;
		  enable_carry			: out std_logic;
		  enable_zero			: out std_logic;
		  pc_source_crtl		: out std_logic;
		  reg_A_sel				: out std_logic;
		  add_signal			: out std_logic;
		  mem_data_in_mux_crtl	: out std_logic;
		  R7_select				: out std_logic;
		  counter_enable		: out std_logic;
		  sign_ext_crtl			: out std_logic;
		  counter_clear			: out std_logic);
	end component;

  signal opcode : std_logic_vector(3 downto 0) := "0000";
  signal reset : std_logic := '0';
  signal clk : std_logic := '0';
  signal zero  : std_logic := '0';
  signal carry : std_logic := '0';

---------
	signal 	  reset_to_DataPath 	:  std_logic;
	signal	  pc_reg_crtl			:  std_logic;
	signal	  address_crtl			:  std_logic_vector(1 downto 0);
	signal	  wren					:  std_logic;
	signal	  rden					:  std_logic;
	signal	  ir_crtl				:  std_logic;
	signal	  mem_data_crtl			:  std_logic;
	signal	  reg_data_crtl			:  std_logic_vector(1 downto 0);
	signal	  reg_sel_crtl			:  std_logic_vector(1 downto 0);
	signal	  regWrite				:  std_logic;
	signal	  reg_A_crtl			:  std_logic;
	signal	  reg_B_crtl			:  std_logic;
	signal	  alu_a_sel				:  std_logic_vector(1 downto 0);
	signal	  alu_b_sel				:  std_logic_vector(1 downto 0);
	signal	  alu_reg_crtl			:  std_logic;
	signal	  enable_carry			:  std_logic;
	signal	  enable_zero			:  std_logic;
	signal	  pc_source_crtl		:  std_logic;
	signal	  reg_A_sel				:  std_logic;
	signal	  add_signal			:  std_logic;
	signal	  mem_data_in_mux_crtl	:  std_logic;
	signal	  R7_select				:  std_logic;
	signal	  counter_enable		:  std_logic;
	signal	  sign_ext_crtl			:  std_logic;
	signal	  counter_clear			:  std_logic;

  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin  
      ret_val := lx;
      return(ret_val);
  end to_string;

  function to_std_logic (x: bit) return std_logic is
  begin
	if(x = '1') then return ('1');
	else return('0'); end if;
  end to_std_logic;

begin

  process
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "TRACEFILE.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";
    
	--- input variables ------
	variable Nopcode : bit_vector(3 downto 0);
	variable Nreset : bit ;
	variable Ncarry : bit ;
	variable Nzero : bit ;
	variable Nclk : bit ;

	--- output variables -----
	variable Nreset_to_DataPath : bit;
	variable Npc_reg_crtl : bit;
	variable Naddress_crtl : bit_vector(1 downto 0);
	variable Nwren : bit;
	variable Nrden : bit;
	variable Nir_crtl : bit;
	variable Nmem_data_crtl : bit;
	variable Nreg_data_crtl : bit_vector(1 downto 0);
	variable Nreg_sel_crtl : bit_vector(1 downto 0);
	variable NregWrite : bit;
	variable Nreg_A_crtl : bit;
	variable Nreg_B_crtl : bit;
	variable Nalu_a_sel : bit_vector(1 downto 0);
	variable Nalu_b_sel : bit_vector(1 downto 0);
	variable Nalu_reg_crtl : bit;
	variable Nenable_carry : bit;
	variable Nenable_zero : bit;
	variable Npc_source_crtl : bit;
	variable Nreg_A_sel : bit;
	variable Nadd_signal : bit;
	variable Nmem_data_in_mux_crtl : bit;
	variable NR7_select : bit;
	variable Ncounter_enable : bit;
	variable Nsign_ext_crtl : bit;
	variable Ncounter_clear : bit;

    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin 
    while not endfile(INFILE) loop 
          -- clock = '0', inputs should be changed here.
          	LINE_COUNT := LINE_COUNT + 1;
	  		readLine (INFILE, INPUT_LINE);

			-- reading input from tracefile
	   	 	read (INPUT_LINE, Nreset);
          	read (INPUT_LINE, Nclk);
          	read (INPUT_LINE, Nopcode);
          	read (INPUT_LINE, Ncarry);
		  	read (INPUT_LINE, Nzero);
		
			-- reading output from tracefile
		 	read (INPUT_LINE, Nreset_to_DataPath);
	     	read (INPUT_LINE, Npc_reg_crtl);
			read (INPUT_LINE, Naddress_crtl);
			read (INPUT_LINE, Nwren);
			read (INPUT_LINE, Nrden);
			read (INPUT_LINE, Nir_crtl);
			read (INPUT_LINE, Nmem_data_crtl);
			read (INPUT_LINE, Nreg_data_crtl);
			read (INPUT_LINE, NregWrite);
			read (INPUT_LINE, Nreg_A_crtl);
			read (INPUT_LINE, Nreg_B_crtl);
			read (INPUT_LINE, Nalu_a_sel);
			read (INPUT_LINE, Nalu_b_sel);
			read (INPUT_LINE, Nalu_reg_crtl);
			read (INPUT_LINE, Nenable_carry);
			read (INPUT_LINE, Nenable_zero);
			read (INPUT_LINE, Npc_source_crtl);
			read (INPUT_LINE, Nreg_A_sel );
			read (INPUT_LINE, Nadd_signal);
			read (INPUT_LINE, Nmem_data_in_mux_crtl);
			read (INPUT_LINE, NR7_select);
			read (INPUT_LINE, Ncounter_enable);
			read (INPUT_LINE, Nsign_ext_crtl);
			read (INPUT_LINE, Ncounter_clear);
		
          	reset <= to_std_logic(Nreset);
          	clk <= to_std_logic(Nclk);
			carry <= to_std_logic(Ncarry);
			zero <= to_std_logic(Nzero);
	  		opcode(0) <= to_std_logic(Nopcode(0));
			opcode(1) <= to_std_logic(Nopcode(1));
			opcode(2) <= to_std_logic(Nopcode(2));
			opcode(3) <= to_std_logic(Nopcode(3));

	  wait for 5 ns;

	  -- check Mealy machine output and 
          -- compare with expected.
          if (reset_to_DataPath /= to_std_logic(Nreset_to_DataPath)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; 
          if (pc_reg_crtl /= to_std_logic(Npc_reg_crtl)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; 
          if (address_crtl(1) /= to_std_logic(Naddress_crtl(1))) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; 
          if (address_crtl(0) /= to_std_logic(Naddress_crtl(0))) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; 
          if (wren /= to_std_logic(Nwren)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; 
          if (rden /= to_std_logic(Nrden)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; 
          if (ir_crtl /= to_std_logic(Nir_crtl)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; 
          if (mem_data_crtl /= to_std_logic(Nmem_data_crtl)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; 
          if (reg_data_crtl(1) /= to_std_logic(Nreg_data_crtl(1))) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; 
          if (reg_data_crtl(0) /= to_std_logic(Nreg_data_crtl(0))) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; 
          if (regWrite /= to_std_logic(NregWrite)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; 
          if ( reg_A_crtl/= to_std_logic( Nreg_A_crtl)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; 
          if (reg_B_crtl /= to_std_logic(Nreg_B_crtl)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; ----------------------
          if (alu_a_sel(1) /= to_std_logic(Nalu_a_sel(1))) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          if (alu_a_sel(0) /= to_std_logic(Nalu_a_sel(0))) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          if (alu_b_sel(1) /= to_std_logic(Nalu_b_sel(1))) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          if (alu_b_sel(0) /= to_std_logic(Nalu_b_sel(0))) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          if (alu_reg_crtl /= to_std_logic(Nalu_reg_crtl)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          if (enable_carry /= to_std_logic(Nenable_carry)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          if (enable_zero /= to_std_logic(Nenable_zero)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          if (pc_source_crtl /= to_std_logic(Npc_source_crtl)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          if (reg_A_sel /= to_std_logic(Nreg_A_sel)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if; -----------------------------------------------------------
          if (add_signal /= to_std_logic(Nadd_signal)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          if (mem_data_in_mux_crtl /= to_std_logic(Nmem_data_in_mux_crtl)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          if (R7_select /= to_std_logic(NR7_select)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          if (counter_enable /= to_std_logic(Ncounter_enable)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          if (sign_ext_crtl /= to_std_logic(Nsign_ext_crtl)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          if (counter_clear /= to_std_logic(Ncounter_clear)) then
             write(OUTPUT_LINE,to_string("ERROR: line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;

        end loop;
    
	assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;
	
	wait;
  end process;
 
dut: fsm_controller 
 	 port map(
		  opcode => opcode,
		  reset => reset,
		  carry => carry,	
		  zero => zero,
		  clk => clk,
		  -- Add control signals here
		  reset_to_DataPath => reset_to_DataPath, 
		  pc_reg_crtl => pc_reg_crtl,
		  address_crtl => address_crtl,
		  wren => wren,
		  rden => rden,
		  ir_crtl => ir_crtl,				
		  mem_data_crtl => mem_data_crtl,
		  reg_data_crtl => reg_data_crtl,
		  reg_sel_crtl => reg_sel_crtl,
		  regWrite => regWrite,
		  reg_A_crtl => reg_A_crtl,
		  reg_B_crtl => reg_B_crtl,
		  alu_a_sel => alu_a_sel,
		  alu_b_sel => alu_b_sel,
		  alu_reg_crtl => alu_reg_crtl,
		  enable_carry => enable_carry,
		  enable_zero => enable_zero,
		  pc_source_crtl => pc_source_crtl,
		  reg_A_sel => reg_A_sel,
		  add_signal => add_signal,
		  mem_data_in_mux_crtl => mem_data_in_mux_crtl,
		  R7_select => R7_select,
		  counter_enable => counter_enable,
		  sign_ext_crtl => sign_ext_crtl,
		  counter_clear => counter_clear);

end Behave;
