library ieee;
use ieee.std_logic_1164.all;

entity fsm_controller is 
  port (opcode					: in std_logic_vector(3 downto 0);
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
		  mem_data_crtl		: out std_logic;
		  reg_data_crtl		: out std_logic_vector(1 downto 0);
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
		  mem_data_in_mux_crtl: out std_logic;
		  R7_select				: out std_logic;
		  counter_enable		: out std_logic;
		  sign_ext_crtl			: out std_logic);
end;

architecture controller of fsm_controller is
	-- There will be a total of mout 2 + 11 states
	type states is (reset_state,fetch,decode,execute,store,adi_1,LHI_1,LW_1,LW_2,LW_3,SW_1,BEQ,JAL_1,JLR_1,LM_1,LM_2,SM_1);
  signal state_sig: states;
begin
process(opcode,clk,state_sig)
   variable nstate: states;
	variable Nreset_to_DataPath : std_logic;
	variable Npc_reg_crtl : std_logic;
	variable Naddress_crtl : std_logic_vector(1 downto 0);
	variable Nwren : std_logic;
	variable Nrden : std_logic;
	variable Nir_crtl : std_logic;
	variable Nmem_data_crtl : std_logic;
	variable Nreg_data_crtl : std_logic_vector(1 downto 0);
	variable Nreg_sel_crtl : std_logic_vector(1 downto 0);
	variable NregWrite : std_logic;
	variable Nreg_A_crtl : std_logic;
	variable Nreg_B_crtl : std_logic;
	variable Nalu_a_sel : std_logic_vector(1 downto 0);
	variable Nalu_b_sel : std_logic_vector(1 downto 0);
	variable Nalu_reg_crtl : std_logic;
	variable Nenable_carry : std_logic;
	variable Nenable_zero : std_logic;
	variable Npc_source_crtl : std_logic;
	variable Nreg_A_sel : std_logic;
	variable Nadd_signal : std_logic;
	variable Nmem_data_in_mux_crtl : std_logic;
	variable NR7_select : std_logic;
	variable Ncounter_enable : std_logic;
	variable Nsign_ext_crtl : std_logic;
begin
   -- default values. 
   nstate := state_sig;
	Nreset_to_DataPath := '0';
	Npc_reg_crtl := '0';
	Naddress_crtl := "01";
	Nwren := '0';
	Nrden := '0';
	Nir_crtl := '0';
	Nmem_data_crtl := '0';
	Nreg_data_crtl := "00";
	Nreg_sel_crtl := "01";
	NregWrite := '0';
	Nreg_A_crtl := '0';
	Nreg_B_crtl := '0';
	Nalu_a_sel := "01";
	Nalu_b_sel := "00";
	Nalu_reg_crtl := '0';
	Nenable_carry := '1';
	Nenable_zero := '1';
	Npc_source_crtl := '0';
	Nreg_A_sel := '0';
	Nadd_signal := '0';
	Nmem_data_in_mux_crtl := '0';
	NR7_select := '0';
	Ncounter_enable := '0';
	Nsign_ext_crtl := '0';
   -- code the next-state and output
   -- functions using sequential code
   -- compute variables nstate, vY
   -- Note that reset condition is not
   -- checked here..
   case state_sig is
	
-- STATE 0
		when reset_state =>
			Nreset_to_DataPath := '1';
			nstate := fetch;
			
-- STATE 1
      when  fetch => 
			-- Input the PC to the memory address and store the resulting output into the instruction register
			-- Part of instruction register is connected to control FSM
			-- Write the control statements here
			Naddress_crtl := "01";
			Nir_crtl := '1';
			Nalu_a_sel := "00";
			Nalu_b_sel := "11";
			Nadd_signal := '1';
			Npc_reg_crtl := '1';
			Npc_source_crtl := '0';
			Nalu_reg_crtl := '1';
			Nenable_carry := '0';
			Nenable_zero := '0';
			Nrden := '1';
			if(opcode = "0011") then
				nstate := LHI_1;
			elsif(opcode = "1000") then
				nstate := JAL_1;
			else
				nstate := decode;		
			end if;
			
-- STATE 2
		when decode =>
			-- Fetch the corresponding registers
			-- Find the incremented PC through the ALU for if the branch instruction is there
			-- and specify the next state based on decoding of this instruction
			Nreg_A_crtl := '1';
			Nreg_B_crtl := '1';
			Nreg_A_sel := '0';
			if (opcode = "0000" or opcode = "0010" or opcode = "1100") then
				-- R type of ADD or NAND ALU instruction
				nstate := execute;
			elsif (opcode = "0001") then
				-- I type of add ALU instruction
				nstate := adi_1;
			elsif (opcode = "0100" or opcode = "0101") then
				-- I type of Load instruction
				nstate := LW_1;
			elsif (opcode = "0110") then
				-- J type of Load Multiple instruction
				nstate := LM_1;	
			elsif (opcode = "0111") then
				-- J type of Store Multiple Instruction
				nstate := SM_1;
			elsif (opcode = "1001") then
				-- I type of Jump and link instrcution
				nstate := JAL_1;
			else
				nstate := fetch;
			 end if;
			 
-- STATE 3
		when execute =>
			-- Control Signals corresponding to ADD excecution
			Nalu_a_sel := "01";
			Nalu_b_sel := "00";
			Nalu_reg_crtl := '1';
			if (opcode = "1100") then
				nstate := BEQ;
			else
				nstate := store;
			end if;
			
-- STATE 4
		when store =>
			-- Control signals corresponding to store in register file
			Nreg_data_crtl := "01";
			Nreg_sel_crtl := "11";
			NregWrite := '1';
			NR7_select := '0';
			nstate := fetch;
		
-- STATE 5
		when adi_1 =>
			-- Control Signals corresponding to ADI excecution
			Nalu_a_sel := "01";
			Nalu_b_sel := "01";
			Nenable_carry := '0';
			Nenable_zero := '0';
			Nalu_reg_crtl := '1';
			nstate := store;
			
-- STATE 6
		when LHI_1 =>
			-- Control signals for LHI
			Nreg_data_crtl := "10";
			Nreg_sel_crtl := "10";
			NregWrite := '1';
			NR7_select := '0';
			nstate := fetch;
			
-- STATE 7
		when LW_1 =>
			-- Control signals for LHI
			Nalu_reg_crtl := '1';
			Nalu_b_sel := "00";
			Nalu_a_sel := "10";
			Nenable_carry := '0';
			Nenable_zero := '0';
			Nreg_A_crtl := '1';
			Nreg_A_sel := '0';
			Nadd_signal := '1';
			if (opcode = "0101") then
				nstate := SW_1;
			else
				nstate := LW_2;
			end if;
			
-- STATE 8
		when LW_2 =>
			-- Control signals for LHI
			Naddress_crtl := "00";
			Nmem_data_crtl := '1';
			nstate := LW_3;
			Nrden := '1';
			
-- STATE 9
		when LW_3 =>
			-- Control signals for LHI
			Nreg_sel_crtl := "10";
			Nreg_data_crtl := "00";
			NregWrite := '1';
			nstate := fetch;
			
-- STATE 10
		when SW_1 =>
			-- Control signals for LHI
			Naddress_crtl := "00";
			Nwren := '1';
			Nmem_data_in_mux_crtl := '0';
			NR7_select := '1';
			nstate := fetch;
		
-- STATE 11
		when BEQ =>
			-- Control signals for LHI
			if(zero = '1')
				Nalu_a_sel := "00";
				Nadd_signal := '1';
				Nalu_b_sel := "10";
				Npc_source_crtl := '0';
				Npc_reg_crtl := '1';
				NR7_select := '1';
			end if;
			nstate := fetch;
			
-- STATE 12
		when JAL_1 =>
			-- Control signals for LHI
			NregWrite := '1';
			Nreg_data_crtl := "01";
			Nreg_sel_crtl := "10";
			if(opcode  = "1001") then
				nstate := JLR_1;
			else
				nstate := BEQ;
			end if;
			
-- STATE 13
		when JLR_1 =>
			-- Control signals for LHI
			Nalu_a_sel := "11";
			Nadd_signal := '1';
			Nalu_b_sel := "00";
			Npc_source_crtl := '0';
			Npc_reg_crtl := '1';
			Nenable_carry := '0';
			Nenable_zero := '0';
			nstate := fetch;
			
-- STATE 14
		when LM_1 =>
			-- Control signals for load multiple
			Naddress_crtl := "10";
			Nrden := '1';
			Nmem_data_crtl := '1';
			Ncounter_enable := '1';
			Nalu_b_sel := "11";
			Nalu_a_sel := "01";
			Nalu_reg_crtl := '1';
			nstate := LM_2;
		
-- STATE 15
		when LM_2 =>
			Nreg_data_crtl := "00";
			Nreg_sel_crtl := "00";
			NregWrite := '1';
			Nreg_A_sel := '1';
			Nreg_A_crtl := '1';
			Ncounter_enable := '1';
			nstate := fetch;
		
-- STATE 16
		when SM_1 =>
			Nmem_data_crtl := '1';
			Nmem_data_in_mux_crtl := '0';
			Nwren := '1';
			Ncounter_enable := '1';
			Nalu_b_sel := "11";
			Nalu_a_sel := "01";
			Nalu_reg_crtl := '1';
			Naddress_crtl := "10";
			nstate := LM_2;
				
   end case;          
   
   -- apply nstate to state after
   -- delay. Note that the
   -- reset condition is checked
   -- here.
   if(clk'event and clk = '1') then
		if(reset = '1') then
			state_sig <= reset_state;
			-- Give the initial value or default value to the pseudo control signals i.e. nX
		else
		
			state_sig <= nstate;
		 -- Finally enter the output control signals here as: x <= nX
			reset_to_DataPath 	<= Nreset_to_DataPath;
			pc_reg_crtl				<= Npc_reg_crtl;
			address_crtl			<= Naddress_crtl;
			wren						<= Nwren;
			rden						<= Nrden;
			ir_crtl					<= Nir_crtl;
			mem_data_crtl			<= Nmem_data_crtl;
			reg_data_crtl			<= Nreg_data_crtl;
			reg_sel_crtl			<= Nreg_sel_crtl;
			regWrite					<= NregWrite;
			reg_A_crtl				<= Nreg_A_crtl;
			reg_B_crtl				<= Nreg_B_crtl;
			alu_a_sel				<= Nalu_a_sel;
			alu_b_sel				<= Nalu_b_sel;
			alu_reg_crtl			<= Nalu_reg_crtl;
			enable_carry			<= Nenable_carry;
			enable_zero				<= Nenable_zero;
			pc_source_crtl			<= Npc_source_crtl;
			reg_A_sel				<= Nreg_A_sel;
			add_signal				<= Nadd_signal;
			mem_data_in_mux_crtl <= Nmem_data_in_mux_crtl;
			R7_select				<= NR7_select;
			counter_enable			<= Ncounter_enable;
			sign_ext_crtl			<= Nsign_ext_crtl;
		end if;
	end if;
         
end process;
end;
