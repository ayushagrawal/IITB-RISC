library ieee;
use ieee.std_logic_1164.all;

library work;
use work.dataPathComponents.all;

entity completeDataPath is
	port(pc_reg_crtl: 	in std_logic;
		  address_crtl: 	in std_logic;
		  we_crtl: 			in std_logic;
		  ir_crtl: 			in std_logic;
		  mem_data_crtl: 	in std_logic;
		  reg_data_crtl: 	in std_logic_vector(1 downto 0);
		  reg_sel_crtl: 	in std_logic_vector(1 downto 0);
		  regWrite: 		in std_logic;
		  reg_A_crtl: in std_logic;
		  reg_B_crtl: in std_logic;
		  alu_a_sel: in std_logic_vector(1 downto 0);
		  alu_b_sel: in std_logic;
		  alu_reg_crtl: in std_logic;
		  alu_crtl: in std_logic_vector(1 downto 0);
		  enable_carry: in std_logic;
		  enable_zero: in std_logic;
		  pc_source_crtl: in std_logic;
		  pe_crtl : in std_logic;
		  pe_mux_crtl : in std_logic;
		  reset: in std_logic;
		  ir_toFSM: out std_logic_vector(3 downto 0);
		  clock: in std_logic;
		  carry: out std_logic;										-- To the FSM
		  zero: out std_logic;										-- To the FSM
		  error_PE: out std_logic);								-- To the FSM -> error signal from priority encoder
end entity;

architecture dp of completeDataPath is
	signal pcIn : std_logic_vector(15 downto 0);				-- Input to the PC register
	signal pc_out : std_logic_vector(15 downto 0);			-- Output of the PC
	signal mem_data: std_logic_vector(15 downto 0);			-- Input to memory
	signal mem_address: std_logic_vector(15 downto 0);		-- Address to the memory
	signal mem_out: std_logic_vector(15 downto 0); 			-- Output data from the memory
	signal ir_out: std_logic_vector(15 downto 0);			-- Intruction Register Out
	signal mem_data_out: std_logic_vector(15 downto 0);	-- Memory Data Register Out
	signal alu_reg_out: std_logic_vector(15 downto 0);		-- ALU Register Out
	signal lh_out: std_logic_vector(15 downto 0);			-- Load Higher Out
	signal priority_en_out: std_logic_vector(2 downto 0);	-- Priority Encoder Out
	signal data_in_sel: std_logic_vector(2 downto 0);		-- Register Bank Data in Select
	signal dataIn_rf: std_logic_vector(15 downto 0);		-- Register Bank Data in
	signal mem_in: std_logic_vector(15 downto 0);			-- Memory Data IN
	signal reg_A_out : std_logic_vector(15 downto 0);		-- Output of Register A
	signal reg_B_out : std_logic_vector(15 downto 0);		-- Output of Register B
	signal reg_A_in : std_logic_vector(15 downto 0);		-- Input of Register A
	signal reg_B_in : std_logic_vector(15 downto 0);		-- Input of Register B
	signal se6to16_out : std_logic_vector(15 downto 0);	-- Sign Extender 6 to 16
	signal se9to16_out : std_logic_vector(15 downto 0);	-- Sign Extender 9 to 16
	signal alu_a_in : std_logic_vector(15 downto 0);		-- Input to ALU A port
	signal alu_b_in : std_logic_vector(15 downto 0);		-- Input to ALU B port
	signal alu_out : std_logic_vector(15 downto 0);			-- Output of ALU 
	signal pc_mux_2_in : std_logic_vector(15 downto 0);	-- Input to PC mux
	--signal and_out: std_logic;										-- PC mux 2 control bit
	signal pe_reg_out : std_logic_vector(7 downto 0);		-- Priority Encoder Register Output
	signal decode_pe_out : std_logic_vector(7 downto 0);	-- Decoder PE Output
	signal pe_mux_out : std_logic_vector(7 downto 0);		-- 
	signal pe_andOut : std_logic_vector(7 downto 0);
begin
	
	PC : register16 port map(dataIn => pcIn,
									 enable => pc_reg_crtl,
									 dataOut => pc_out ,
									 clock => clock,
									 reset => reset);
	adress_mux : mux_2to1_16bit port map(in0 => alu_reg_out,
													 in1 => pc_out, 
													 sel => address_crtl, 
													 out1 => mem_address);
	RAM : memory port map(address => mem_address,
								 data => reg_A_out, 
								 we => we_crtl, 
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
	rf_data_mux: mux_3to1_16bit port map(in_00 => mem_data_out,
													 in_01 => alu_reg_out,
													 in_10 => lh_out,
													 control_signals => reg_data_crtl, 
													 out1 => dataIn_rf);
	rf_in_sel: mux_4to1_3bit port map(in_00 => priority_en_out,
												 in_01 => ir_out(8 downto 6),
												 in_10 => ir_out(11 downto 9), 
												 in_11 => ir_out(5 downto 3),
												 control_signals => reg_sel_crtl,
												 out1 => data_in_sel);
	RF: registerBank port map(dataOut_A => reg_A_in,
									  dataOut_B => reg_B_in,
									  clock_rb  => clock,
									  regSel_A  => ir_out(11 downto 9),
									  regSel_B  => ir_out(8 downto 6),
									  dataIn	   => dataIn_rf,
									  dataInsel => data_in_sel,
									  reset	   => reset,
									  regWrite  => regWrite);
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
	alu_A_mux: mux_3to1_16bit port map(in_00 => reg_A_out,
													 in_01 => se6to16_out,
													 in_10 => se9to16_out,
													 control_signals => alu_a_sel, 
													 out1 => alu_a_in);
	alu_B_mux : mux_2to1_16bit port map(in0 => pc_out,
													 in1 => reg_B_out, 
													 sel => alu_b_sel, 
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
	pc_mux_1 : mux_2to1_16bit port map(in0 => alu_out,
													 in1 => alu_reg_out, 
													 sel => pc_source_crtl, 
													 out1 => pc_mux_2_in);
	pc_mux_2 : mux_2to1_16bit port map(in0 => pc_mux_2_in,
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
	priority_enc : priority_encoder port map(input => pe_reg_out,
														  output => priority_en_out,
														  out_N => error_PE);
	decode_PE : decoder_3to8 port map(input => priority_en_out,
												 output => decode_pe_out);
	PE_register : register8 port map(dataIn => pe_mux_out, 
									 enable => pe_crtl, 
									 dataOut => pe_reg_out,
									 clock => clock,
									 reset => reset);
	PE_mux : mux_2to1_8bit port map(in0 => pe_andOut,
													 in1 => ir_out(7 downto 0), 
													 sel => pe_mux_crtl, 
													 out1 => pe_mux_out);
	pe_andOut <= (pe_reg_out) and (decode_pe_out);
	ir_toFSM <= ir_out(15 downto 12);
end;