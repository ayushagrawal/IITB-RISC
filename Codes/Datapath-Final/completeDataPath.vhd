library ieee;
use ieee.std_logic_1164.all;

library work;
use work.dataPathComponents.all;

entity completeDataPath is
	port(pc_reg_crtl: 	in std_logic;
		  address_crtl: in std_logic_vector(1 downto 0);
		  counter_clr: in std_logic;
		  r7_select : in std_logic;
		  counter_enable: in std_logic;
		  wren: 	in std_logic;
		  rden: in std_logic;
		  B_sel_Rb: in std_logic;
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
		  enable_carry: in std_logic;
		  enable_zero: 	in std_logic;
		  pc_source_crtl: in std_logic;
		  reset: 	in std_logic;
		  ir_toFSM: 	out std_logic_vector(3 downto 0);
		  clock: 	in std_logic;
		  carry: 	out std_logic;						-- To the FSM
		  zero: 	out std_logic;						-- To the FSM
		  add_signal : in std_logic);						-- To the FSM -> error signal from priority encoder
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
	signal one_bit_crtl : std_logic_vector(0 downto 0);
	signal regSel_B : std_logic_vector(2 downto 0);
	signal counter_out : std_logic_vector(2 downto 0);
	signal store_crtl: std_logic;
	signal load_crtl: std_logic;

begin
	
	store_ctrl <= not((not ir_out(15))and (ir_out(14)) and (ir_out(13)) and (ir_out(12)));				--
	load_ctrl <= not((not ir_out(15)) and (ir_out(14)) and (ir_out(13)) and (not ir_out(12)));			--

	PC : register16 port map(dataIn => pcIn,
									 enable => pc_reg_crtl,
									 dataOut => pc_out ,
									 clock => clock,
									 reset => reset);
	adress_mux : mux3 generic map (n => 15) port map(in0 => alu_reg_out,
							 in1 => pc_out,
							 in2 => reg_A_out
							 sel => address_crtl, 
							 output => mem_address);
	RAM : memory port map(address => mem_address,
								 data => data_in, 
								 wren => (wren and (one_bit_crtl(0) or store_crtl)), 
								 rden => (rden and (one_bit_crtl(0) or load_crtl)),
								 q => mem_out,
								 clock => clock);
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
	rf_data_mux: mux3 generic map (n => 15) port map(in0 => mem_data_out,
													 in1 => alu_reg_out,
													 in2 => lh_out,
													 sel => reg_data_crtl, 
													 output => dataIn_rf);
	rf_in_sel: mux4 generic map (n => 2) port map(in0 => counter_out,
												 in1 => ir_out(8 downto 6),
												 in2 => ir_out(11 downto 9), 
												 in3 => ir_out(5 downto 3),
												 sel => reg_sel_crtl,
												 output => data_in_sel);
	RF: registerBank port map(	dataOut_A => RF_to_regA_in,
									  dataOut_B => reg_B_in,
									  clock_rb  => clock,
									  regSel_A  => ir_out(11 downto 9),
									  regSel_B  => regSel_B,
									  dataIn    => dataIn_rf,
									  dataInsel => data_in_sel,
									  reset	   => reset,
									  regWrite  => (regWrite and (one_bit_crtl(0) or load_crtl)),
									  pc_in		=> pc_out,
									  r7_select => r7_select);
	
	RB_B_mux : mux2 generic map (n => 2) port map(in0 => counter_out,
								in1 => ir_out(8 downto 6),
								sel => ((not counter_enable) or one_bit_crtl(0 downto 0)),
												  output=> regSel_B);
	
	RF_to_regA_mux : mux2  generic map (n => 15) port map (in0 => RF_to_regA_in ,			-- changes
						  in1 => alu_out,
						  sel => reg_A_sel,
						  output => reg_A_in);

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
					
	regA_regB_mem_data_in : mux2 generic map (n => 15) port map(in0 => reg_A_out,			-- changes
							in1 => reg_B_out,
							sel => mem_data_in_mux_ctrl,
						        output => data_in );	
	alu_A_mux: mux4 generic map (n => 15) port map(in0 => pc_out,					-- changes
												  in1 => reg_A_out,
												  in2 => se6to16_out,
												  in3 => x"0000",
												  sel => alu_a_sel, 
												  output => alu_a_in);
	alu_B_mux : mux4 generic map (n => 15) port map(in0 => reg_B_out,					  	-- changes
													in1 => se6to16_out,
													in2 => se9to16_out,
													in3 => "0000000000000001", 
													sel => alu_b_sel, 
													output => alu_b_in);
	ALU_1 : alu port map (ra => alu_a_in,
											rb => alu_b_in, 
											rc => alu_out,
											clock => clock,
											enable_carry => enable_carry,
											enable_zero => enable_zero,
											carry_flag => carry,
											add_signal => add_signal,
											op2in => ir_out(1 downto 0),
											op4in => ir_out(15 downto 12),
											reset => reset,		
											zero_flag => zero);
	ALU_register: register16 port map(dataIn => alu_out, 
									 enable => alu_reg_crtl, 
									 dataOut => alu_reg_out ,
									 clock => clock,
									 reset => reset);
	pc_mux_1 : mux2 generic map (n => 15) port map(in0 => alu_out,
													 in1 => alu_reg_out, 
													 sel => pc_source_crtl, 
													 output => pc_mux_2_in);
	pc_mux_2 : mux2 generic map (n => 15) port map(in0 => pc_mux_2_in,
													 in1 => dataIn_rf, 
													 sel => data_in_sel(0) and data_in_sel(1) and data_in_sel(2), 
													 output => pcIn);
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
	cntr_mux : mux8 generic map (n => 0) port map(in0 => ir_out(0 downto 0), 
										  in1 => ir_out(1 downto 1), 
										  in2 => ir_out(2 downto 2), 
										  in3 => ir_out(3 downto 3), 
										  in4 => ir_out(4 downto 4),  
										  in5 => ir_out(5 downto 5), 
										  in6 => ir_out(6 downto 6), 
										  in7 => ir_out(7 downto 7),
										  sel => counter_out,	-- Point of debugging
										  output => one_bit_crtl(0 downto 0));
end;
