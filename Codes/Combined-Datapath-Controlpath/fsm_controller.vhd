library ieee;
use ieee.std_logic_1164.all;

entity fsm_controller is 
  port (opcode					: in std_logic_vector(3 downto 0);
		  reset				  	: in std_logic;
		  carry					: in std_logic;
		  zero					: in std_logic;
		  clk						: in std_logic;
		  lst_two_op			: in std_logic_vector(1 downto 0);
		  counter_overFlow 	: in std_logic;
		  -- Add control signals here
		  reset_to_DataPath 	: out std_logic;
		  pc_reg_ctrl			: out std_logic;
		  address_ctrl			: out std_logic_vector(1 downto 0);
		  wren					: out std_logic;
		  rden					: out std_logic;
		  ir_ctrl				: out std_logic;
		  mem_data_ctrl		: out std_logic;
		  reg_data_ctrl		: out std_logic_vector(1 downto 0);
		  reg_sel_ctrl			: out std_logic_vector(1 downto 0);
		  regWrite				: out std_logic;
		  reg_A_ctrl			: out std_logic;
		  reg_B_ctrl			: out std_logic;
		  alu_a_sel				: out std_logic_vector(1 downto 0);
		  alu_b_sel				: out std_logic_vector(1 downto 0);
		  alu_reg_ctrl			: out std_logic;
		  enable_carry			: out std_logic;
		  enable_zero			: out std_logic;
		  pc_source_ctrl		: out std_logic;
		  reg_A_sel				: out std_logic;
		  add_signal			: out std_logic;
		  mem_data_in_mux_ctrl	: out std_logic;
		  R7_select				: out std_logic;
		  counter_enable		: out std_logic;
		  sign_ext_ctrl		: out std_logic;
		  counter_clr			: out std_logic;
		  mc_ctrl				: out std_logic);
end;

architecture controller of fsm_controller is
	-- There will be a total of mout 2 + 11 states
	type states is (reset_state,fetch,decode,execute,store,adi_1,LHI_1,LW_1,LW_2,LW_3,SW_1,BEQ,JAL_1,JLR_1,LM_1,LM_2,SM_1);
  signal state_sig: states;
begin
process(opcode,clk,state_sig,zero,lst_two_op)
   variable nstate: states;
	variable Nreset_to_DataPath : std_logic;
	variable Npc_reg_ctrl : std_logic;
	variable Naddress_ctrl : std_logic_vector(1 downto 0);
	variable Nwren : std_logic;
	variable Nrden : std_logic;
	variable Nir_ctrl : std_logic;
	variable Nmem_data_ctrl : std_logic;
	variable Nreg_data_ctrl : std_logic_vector(1 downto 0);
	variable Nreg_sel_ctrl : std_logic_vector(1 downto 0);
	variable NregWrite : std_logic;
	variable Nreg_A_ctrl : std_logic;
	variable Nreg_B_ctrl : std_logic;
	variable Nalu_a_sel : std_logic_vector(1 downto 0);
	variable Nalu_b_sel : std_logic_vector(1 downto 0);
	variable Nalu_reg_ctrl : std_logic;
	variable Nenable_carry : std_logic;
	variable Nenable_zero : std_logic;
	variable Npc_source_ctrl : std_logic;
	variable Nreg_A_sel : std_logic;
	variable Nadd_signal : std_logic;
	variable Nmem_data_in_mux_ctrl : std_logic;
	variable NR7_select : std_logic;
	variable Ncounter_enable : std_logic;
	variable Nsign_ext_ctrl : std_logic;
	variable Ncounter_clear : std_logic;
	variable Nmc_ctrl : std_logic;
begin
   -- default values. 
   nstate := state_sig;
	Nreset_to_DataPath := '0';
	Npc_reg_ctrl := '0';
	Naddress_ctrl := "01";
	Nwren := '0';
	Nrden := '0';
	Nir_ctrl := '0';
	Nmem_data_ctrl := '0';
	Nreg_data_ctrl := "00";
	Nreg_sel_ctrl := "01";
	NregWrite := '0';
	Nreg_A_ctrl := '0';
	Nreg_B_ctrl := '0';
	Nalu_a_sel := "01";
	Nalu_b_sel := "00";
	Nalu_reg_ctrl := '0';
	Nenable_carry := '1';
	Nenable_zero := '1';
	Npc_source_ctrl := '0';
	Nreg_A_sel := '0';
	Nadd_signal := '0';
	Nmem_data_in_mux_ctrl := '0';
	NR7_select := '0';
	Ncounter_enable := '0';
	Nsign_ext_ctrl := '0';
	Ncounter_clear := '0';
	Nmc_ctrl := '1';
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
			Naddress_ctrl := "01";
			Nir_ctrl := '1';
			Nalu_a_sel := "00";
			Nalu_b_sel := "11";
			Nadd_signal := '1';
			Npc_reg_ctrl := '1';
			Npc_source_ctrl := '0';
			Nalu_reg_ctrl := '1';
			Nenable_carry := '0';
			Nenable_zero := '0';
			Nrden := '1';
			nstate := decode;		
			
-- STATE 2
		when decode =>
			-- Fetch the corresponding registers
			-- Find the incremented PC through the ALU for if the branch instruction is there
			-- and specify the next state based on decoding of this instruction
			Nreg_A_ctrl := '1';
			Nreg_B_ctrl := '1';
			Nreg_A_sel := '0';
			Ncounter_clear := '1';
			Nenable_carry := '0';
			Nenable_zero := '0';
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
				Nmc_ctrl := '0';
			elsif (opcode = "1001") then
				-- I type of Jump and link instrcution
				nstate := JAL_1;
			elsif(opcode = "0011") then
				nstate := LHI_1;
			elsif(opcode = "1000") then
				nstate := JAL_1;
			else
				nstate := fetch;
			 end if;
			 
-- STATE 3
		when execute =>
			-- Control Signals corresponding to ADD excecution
			Nalu_a_sel := "01";
			Nalu_b_sel := "00";
			Nalu_reg_ctrl := '1';
			if (opcode = "1100") then
				nstate := BEQ;
			elsif((lst_two_op = "00") or (lst_two_op = "10" and carry = '1') or (lst_two_op = "01" and zero = '1')) then
				nstate := store;
			else
				NR7_select := '1';
				Npc_source_ctrl := '0';
				nstate := fetch;
			end if;
			
-- STATE 4
		when store =>
			-- Control signals corresponding to store in register file
			if (opcode = "0001") then
				Nreg_sel_ctrl := "01";
			else
				Nreg_sel_ctrl := "11";
			end if;
			NregWrite := '1';
			NR7_select := '1';
			Npc_source_ctrl := '1';
			nstate := fetch;
			Nreg_data_ctrl := "01";
			Nenable_carry := '0';
			Nenable_zero := '0';
			if(opcode = "0111") then
				NregWrite := '0';
			end if;
		
-- STATE 5
		when adi_1 =>
			-- Control Signals corresponding to ADI excecution
			Nalu_a_sel := "01";
			Nalu_b_sel := "01";
			Nadd_signal := '1';
			Nsign_ext_ctrl := '0';
			Nenable_carry := '0';
			Nenable_zero := '0';
			Nalu_reg_ctrl := '1';
			nstate := store;
			
-- STATE 6
		when LHI_1 =>
			-- Control signals for LHI
			Nreg_data_ctrl := "10";
			Nreg_sel_ctrl := "10";
			NregWrite := '1';
			NR7_select := '1';
			Npc_source_ctrl := '1';
			nstate := fetch;
			
-- STATE 7
		when LW_1 =>
			-- Control signals for LHI
			Nalu_reg_ctrl := '1';
			Nalu_b_sel := "00";
			Nalu_a_sel := "10";
			Nenable_carry := '0';
			Nenable_zero := '0';
			Nreg_A_ctrl := '1';
			Nreg_A_sel := '0';
			Nadd_signal := '1';
			Nsign_ext_ctrl := '0';
			if (opcode = "0101") then
				nstate := SW_1;
			else
				nstate := LW_2;
			end if;
			
-- STATE 8
		when LW_2 =>
			-- Control signals for LHI
			Naddress_ctrl := "00";
			Nmem_data_ctrl := '1';
			nstate := LW_3;
			Nrden := '1';
			
-- STATE 9
		when LW_3 =>
			-- Control signals for LHI
			Nreg_sel_ctrl := "10";
			Nreg_data_ctrl := "00";
			NregWrite := '1';
			Npc_reg_ctrl := '1';
			NR7_select := '1';
			nstate := fetch;
			
-- STATE 10
		when SW_1 =>
			-- Control signals for LHI
			Naddress_ctrl := "00";
			Nwren := '1';
			Nmem_data_in_mux_ctrl := '0';
			NR7_select := '1';
			nstate := fetch;
		
-- STATE 11
		when BEQ =>
			-- Control signals for LHI
			if(opcode = "1100") then
				if(zero = '1') then
					Nalu_a_sel := "00";
					Nadd_signal := '1';
					Nenable_carry := '0';
					Nenable_zero := '0';
					Nalu_b_sel := "01";
					Npc_source_ctrl := '0';
					Npc_reg_ctrl := '1';
					Nsign_ext_ctrl := '0';
				end if;
				NR7_select := '1';
				nstate := fetch;
			else
				Nalu_a_sel := "00";
				Nadd_signal := '1';
				Nenable_carry := '0';
				Nenable_zero := '0';
				Nalu_b_sel := "01";
				Npc_source_ctrl := '0';
				Npc_reg_ctrl := '1';
				Nsign_ext_ctrl := '1';
				nstate := fetch;
				NR7_select := '1';
			end if;
			
-- STATE 12
		when JAL_1 =>
			-- Control signals for LHI
			NregWrite := '1';
			Nreg_data_ctrl := "01";
			Nreg_sel_ctrl := "10";
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
			Npc_source_ctrl := '0';
			Npc_reg_ctrl := '1';
			Nenable_carry := '0';
			Nenable_zero := '0';
			NR7_select := '1';
			nstate := fetch;
			
-- STATE 14
		when LM_1 =>
			-- Control signals for load multiple
			Naddress_ctrl := "10";
			Nrden := '1';
			Nmem_data_ctrl := '1';
			Ncounter_enable := '0';
			Nalu_b_sel := "10";
			Nalu_a_sel := "01";
			Nalu_reg_ctrl := '1';
			Nadd_signal := '1';
			Nenable_carry := '0';
			Nenable_zero := '0';
			Nreg_sel_ctrl := "00";
			nstate := LM_2;
		
-- STATE 15
		when LM_2 =>
			Nreg_data_ctrl := "00";
			Nreg_sel_ctrl := "00";
			Nreg_A_sel := '1';
			Nreg_A_ctrl := '1';
			Ncounter_enable := '1';
			if(opcode = "0110") then
				Npc_source_ctrl := '1';
				if(counter_overFlow = '1') then
					nstate := fetch;
					NR7_select := '1';
				else 
					nstate := LM_1;
					NregWrite := '1';
				end if;
			else
				Npc_source_ctrl := '0';
				if(counter_overFlow = '1') then
					nstate := store;
					NR7_select := '0';
				else 
					nstate := SM_1;
					NregWrite := '0';
					Nmc_ctrl := '0';
					Nreg_B_ctrl := '1';
				end if;
			end if;
		
-- STATE 16
		when SM_1 =>
			Nmem_data_in_mux_ctrl := '1';
			Nwren := '1';
			Ncounter_enable := '0';
			Nalu_b_sel := "10";
			Nalu_a_sel := "01";
			Nalu_reg_ctrl := '1';
			Naddress_ctrl := "10";
			Nadd_signal := '1';
			Nenable_carry := '0';
			Nenable_zero := '0';
			Nmc_ctrl := '0';
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
		end if;
	end if;
		 -- Finally enter the output control signals here as: x <= nX
		reset_to_DataPath 	<= Nreset_to_DataPath;
		pc_reg_ctrl				<= Npc_reg_ctrl;
		address_ctrl			<= Naddress_ctrl;
		wren						<= Nwren;
		rden						<= Nrden;
		ir_ctrl					<= Nir_ctrl;
		mem_data_ctrl			<= Nmem_data_ctrl;
		reg_data_ctrl			<= Nreg_data_ctrl;
		reg_sel_ctrl			<= Nreg_sel_ctrl;
		regWrite					<= NregWrite;
		reg_A_ctrl				<= Nreg_A_ctrl;
		reg_B_ctrl				<= Nreg_B_ctrl;
		alu_a_sel				<= Nalu_a_sel;
		alu_b_sel				<= Nalu_b_sel;
		alu_reg_ctrl			<= Nalu_reg_ctrl;
		enable_carry			<= Nenable_carry;
		enable_zero				<= Nenable_zero;
		pc_source_ctrl			<= Npc_source_ctrl;
		reg_A_sel				<= Nreg_A_sel;
		add_signal				<= Nadd_signal;
		mem_data_in_mux_ctrl 	<= Nmem_data_in_mux_ctrl;
		R7_select				<= NR7_select;
		counter_enable			<= Ncounter_enable;
		sign_ext_ctrl			<= Nsign_ext_ctrl;
		counter_clr			<= Ncounter_clear;
		mc_ctrl 					<= Nmc_ctrl;
         
end process;
end;