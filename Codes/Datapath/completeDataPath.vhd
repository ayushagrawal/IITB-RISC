library ieee;
use ieee.std_logic_1164.all;

library work;
use work.dataPathComponents.all;

entity completeDataPath is
	port(pc_reg_crtl: 	in std_logic;
		  address_crtl: in std_logic;
		  counter_clr: in std_logic;
		  r7_select : in std_logic;
		  counter_enable: in std_logic;
		  store_crtl: in std_logic;
		  load_crtl: in std_logic;
		  wren: 	in std_logic;
		  rden: in std_logic;
		  ir_crtl: 	in std_logic;
		  mem_data_crtl: in std_logic;
		  mem_data_in_mux_ctrl : in std_logic;				--
		  reg_data_crtl: in std_logic_vector(1 downto 0);
		  reg_sel_crtl: in std_logic_vector(1 downto 0);
		  regWrite: 	in std_logic;
		  reg_A_sel : 	in std_logic;					--
		  reg_A_crtl: 	in std_logic;
		  reg_B_crtl: 	in std_logic;
		  alu_a_sel: 	in std_logic_vector(1 downto 0);
		  alu_b_sel: 	in std_logic_vector(1 downto 0);
		  alu_reg_crtl: in std_logic;
		  alu_crtl: 	in std_logic_vector(1 downto 0);
		  enable_carry: in std_logic;
		  enable_zero: 	in std_logic;
		  pc_source_crtl: in std_logic;
		  reset: 	in std_logic;
		  ir_toFSM: 	out std_logic_vector(3 downto 0);
		  clock: 	in std_logic;
		  carry: 	out std_logic;						-- To the FSM
		  zero: 	out std_logic;						-- To the FSM
		  error_PE: 	out std_logic);						-- To the FSM -> error signal from priority encoder
end entity;

architecture dp of completeDataPath is
	signal pcIn : std_logic_vector(15 downto 0);			-- Input to the PC register
	signal pc_out : std_logic_vector(15 downto 0);			-- Output of the PC
	signal mem_data: std_logic_vector(15 downto 0);			-- Input to memory
	signal mem_address: std_logic_vector(15 downto 0);		-- Address to the memory
	signal mem_out: std_logic_vector(15 downto 0); 			-- Output data from the memory
	signal ir_out: std_logic_vector(15 downto 0);			-- Intruction Register Out
	signal mem_data_out: std_logic_vector(15 downto 0);		-- Memory Data Register Out
	signal alu_reg_out: std_logic_vector(15 downto 0);		-- ALU Register Out
	signal lh_out: std_logic_vector(15 downto 0);			-- Load Higher Out
	signal priority_en_out: std_logic_vector(2 downto 0);		-- Priority Encoder Out
	signal data_in_sel: std_logic_vector(2 downto 0);		-- Register Bank Data in Select
	signal dataIn_rf: std_logic_vector(15 downto 0);		-- Register Bank Data in
	signal mem_in: std_logic_vector(15 downto 0);			-- Memory Data IN
	signal reg_A_out : std_logic_vector(15 downto 0);		-- Output of Register A
	signal reg_B_out : std_logic_vector(15 downto 0);		-- Output of Register B
	signal reg_A_in : std_logic_vector(15 downto 0);		-- Input of Register A
	signal reg_B_in : std_logic_vector(15 downto 0);		-- Input of Register B
	signal se6to16_out : std_logic_vector(15 downto 0);		-- Sign Extender 6 to 16
	signal se9to16_out : std_logic_vector(15 downto 0);		-- Sign Extender 9 to 16
	signal alu_a_in : std_logic_vector(15 downto 0);		-- Input to ALU A port
	signal alu_b_in : std_logic_vector(15 downto 0);		-- Input to ALU B port
	signal alu_out : std_logic_vector(15 downto 0);			-- Output of ALU 
	signal pc_mux_2_in : std_logic_vector(15 downto 0);		-- Input to PC mux
	--signal and_out: std_logic;					-- PC mux 2 control bit
	signal RF_to_regA_in : std_logic_vector(15 downto 0);		-- Input for RF_to_regA_mux from RF
	signal data_in : std_logic_vector(15 downto 0);			-- input to memory from regA_regB_mux
	signal one_bit_crtl : std_logic;
	signal regSel_B : std_logic_vector(2 downto 0);
begin
	
	PC : register16 port map(dataIn => pcIn,
									 enable => pc_reg_crtl,
									 dataOut => pc_out ,
									 clock => clock,
									 reset => reset);
	adress_mux : mux2 port map(in0 => alu_reg_out,
													 in1 => pc_out, 
													 sel => address_crtl, 
													 out1 => mem_address);
	RAM : memory port map(address => mem_address,
								 data => reg_A_out, 
								 wren => (wren and (one_bit_crtl or store_crtl)), 
								 rden => (rden and (one_bit_crtl or load_crtl)),
								 q => mem_out);
	IR : register16 port map(dataIn => mem_out, 
									 enable => ir_crtl, 
									 dataOut => ir_out ,
									 clock => clock,
									 reset => reset);
	Memory_data : register16 port map(dataIn => mem_out, 
											 enable => mem_data_crtl,
											 dataOut => mem_data_out,
											 clock => clock,
											 reset => reset);
	rf_data_mux: mux3 port map(in_00 => mem_data_out,
													 in_01 => alu_reg_out,
													 in_10 => lh_out,
													 control_signals => reg_data_crtl, 
													 out1 => dataIn_rf);
	rf_in_sel: mux4 port map(in_00 => priority_en_out,
												 in_01 => ir_out(8 downto 6),
												 in_10 => ir_out(11 downto 9), 
												 in_11 => ir_out(5 downto 3),
												 control_signals => reg_sel_crtl,
												 out1 => data_in_sel);
	RF: registerBank port map(	dataOut_A => RF_to_regA_in,
									  dataOut_B => reg_B_in,
									  clock_rb  => clock,
									  regSel_A  => ir_out(11 downto 9),
									  regSel_B  => regSel_B,
									  dataIn    => dataIn_rf,
									  dataInsel => data_in_sel,
									  reset	   => reset,
									  regWrite  => (regWrite and (one_bit_crtl or load_crtl)),
									  pc_in		=> pc_out,
									  r7_select => r7_select);
	
	RB_B_mux : mux2 port map(in0 => ir_out(8 downto 6),
												  in1 => counter_out,
												  sel => B_sel_RB,
												  out1=> regSel_B);
	
	RF_to_regA_mux : mux2 port map (in0 => RF_to_regA_in ,			-- changes
						  in1 => alu_out,
						  sel => reg_A_sel,
						  out1 => reg_A_in);

	Register_A : register16 port map(dataIn => reg_A_in, 						
					enable => reg_A_crtl, 
					dataOut => reg_A_out ,
					clock => clock,
					reset => reset);
	Register_B : register16 port map(dataIn => reg_B_in, 
					enable => reg_B_crtl, 
					dataOut => reg_B_out ,
					clock => clock,
					reset => reset);	
					
	regA_regB_mem_data_in : mux_2to1 port map(in0 => reg_A_out,			-- changes
							in1 => reg_B_out,
							sel => mem_data_in_mux_ctrl,
						        out1 => data_in );	
	alu_A_mux: mux4 port map(in_00 => pc_out,					-- changes
												  in_01 => reg_A_out,
												  in_10 => se6to16_out,
												  in_11 => x"0000",
												  control_signals => alu_a_sel, 
												  out1 => alu_a_in);
	alu_B_mux : mux4 port map(in_00 => reg_B_out,					  	-- changes
													in_01 => se6to16_out,
													in_10 => se9to16_out,
													in_11 => "0000000000000001", 
													control_signals => alu_b_sel, 
													out1 => alu_b_in);
	ALU : alu_combined port map (	ra => alu_a_in,
											rb => alu_b_in, 
											rc => alu_out,
											control_signals => alu_crtl,
											clock => clock,
											enable_carry => enable_carry,
											enable_zero => enable_zero,
											carry_flag => carry,
											reset => reset,		
											zero_flag => zero);
	ALU_register: register16 port map(dataIn => alu_out, 
									 enable => alu_reg_crtl, 
									 dataOut => alu_reg_out ,
									 clock => clock,
									 reset => reset);
	pc_mux_1 : mux2 port map(in0 => alu_out,
													 in1 => alu_reg_out, 
													 sel => pc_source_crtl, 
													 out1 => pc_mux_2_in);
	pc_mux_2 : mux2 port map(in0 => pc_mux_2_in,
													 in1 => dataIn_rf, 
													 sel => data_in_sel(0) and data_in_sel(1) and data_in_sel(2), 
													 out1 => pcIn);
	--and3In : and_gate_3input port map(input => data_in_sel,
	--											 output => and_out);
	se9to16 : sign_extender_9bit port map(input => ir_out(8 downto 0),
													  output => se9to16_out);
	se6to16 : sign_extender_6bit port map(input => ir_out(5 downto 0),
													  output => se6to16_out);
	load_higher : LH port map(input => ir_out(8 downto 0),
									  output => lh_out);
	
	
	ir_toFSM <= ir_out(15 downto 12);
	count : counter port map(aclr => counter_clr,
									 cnt_en => counter_enable,
									 clock => clock,
									 q => counter_out);
	cntr_mux : mux8 port map(in0 => ir_out(0), 
										  in1 => ir_out(1), 
										  in2 => ir_out(2), 
										  in3 => ir_out(3), 
										  in4 => ir_out(4), 
										  in4 => ir_out(4), 
										  in5 => ir_out(5), 
										  in6 => ir_out(6), 
										  in7 => ir_out(7),
										  sel => counter_out,	-- Point of debugging
										  output => one_bit_crtl);
end;
