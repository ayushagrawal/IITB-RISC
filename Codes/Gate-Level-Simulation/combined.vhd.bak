library ieee;
use ieee.std_logic_1164.all;

library work;
use work.combinedComponents.all;

entity combined is
	port	(	clock_c	:in STD_LOGIC;
		 		reset_c	:in STD_LOGIC
		);
end entity;

architecture combo of combined is


signal		  ir_toFSM:  std_logic_vector(3 downto 0);
signal		  carry: 	 std_logic;	
signal		  zero: 	 std_logic;
signal		  reset: 	 std_logic;
signal 		  pc_reg_ctrl: 	 std_logic;
signal		  address_ctrl:  std_logic_vector(1 downto 0);
signal		  wren: 	 std_logic;
signal		  rden:  std_logic;
signal		  ir_ctrl: 	 std_logic;
signal		  mem_data_ctrl:  std_logic;
signal		  reg_data_ctrl:  std_logic_vector(1 downto 0);
signal		  reg_sel_ctrl:  std_logic_vector(1 downto 0);
signal		  regWrite: 	 std_logic;
signal		  reg_A_ctrl: 	 std_logic;
signal		  reg_B_ctrl: 	 std_logic;
signal		  alu_a_sel: 	 std_logic_vector(1 downto 0);
signal		  alu_b_sel: 	 std_logic_vector(1 downto 0);
signal		  alu_reg_ctrl:  std_logic;
signal		  enable_carry:  std_logic;
signal		  enable_zero: 	 std_logic;
signal		  pc_source_ctrl:  std_logic;
signal		  reg_A_sel : 	 std_logic;
signal		  add_signal :  std_logic;
signal		  mem_data_in_mux_ctrl :  std_logic;				--
signal		  r7_select :  std_logic;
signal		  counter_clr:  std_logic;
signal		  counter_enable:  std_logic;	
signal		  sign_ext_ctrl : std_logic;								
signal		  lst_two_op	: std_logic_vector(1 downto 0);
signal 		  half_clock : std_logic;
signal		  counter_overFlow 	: std_logic;
signal 			mc_ctrl : std_logic;

begin

	clk_src : clock_divider port map(reset => reset_c,clk => clock_c, half_clk => half_clock);

	controller: fsm_controller port map
			(
			  opcode			=>ir_toFSM,
			  reset				=>reset_c,
			  carry				=>carry,
			  zero				=>zero,
			  clk				=> half_clock,
			  reset_to_DataPath	=>reset,
			  pc_reg_ctrl		=>pc_reg_ctrl,
			  address_ctrl		=>address_ctrl,
			  wren				=>wren,
			  rden				=>rden,
			  ir_ctrl			=>ir_ctrl,
			  mem_data_ctrl		=> mem_data_ctrl,
			  reg_data_ctrl		=> reg_data_ctrl,
			  reg_sel_ctrl		=> reg_sel_ctrl,
			  regWrite			=> regWrite,
			  reg_A_ctrl		=> reg_A_ctrl,
			  reg_B_ctrl		=> reg_B_ctrl,
			  alu_a_sel			=> alu_a_sel,
			  alu_b_sel			=> alu_b_sel,
			  alu_reg_ctrl		=> alu_reg_ctrl,
			  enable_carry		=> enable_carry,
			  enable_zero		=> enable_zero,
			  pc_source_ctrl	=>pc_source_ctrl,
			  reg_A_sel			=>reg_A_sel,
			  add_signal		=>add_signal,
			  mem_data_in_mux_ctrl	=>mem_data_in_mux_ctrl,
			  R7_select			=>r7_select,
			  counter_clr		=>counter_clr,
			  counter_enable	=>counter_enable,
			  sign_ext_ctrl	=> sign_ext_ctrl,
			  lst_two_op      => lst_two_op,
			  counter_overFlow=> counter_overFlow,
			  mc_ctrl => mc_ctrl
			);

	datapath: completeDataPath port map
			(
			  pc_reg_ctrl			=>pc_reg_ctrl,
			  address_ctrl			=>address_ctrl,
			  counter_clr			=>counter_clr,
			  r7_select				=>R7_select,
			  counter_enable		=>counter_enable,
			  wren					=>wren,
			  rden					=>rden,
			  ir_ctrl				=>ir_ctrl,
			  mem_data_in_mux_ctrl	=>mem_data_in_mux_ctrl,
			  mem_data_ctrl			=> mem_data_ctrl,
			  reg_data_ctrl			=> reg_data_ctrl,
			  reg_sel_ctrl			=> reg_sel_ctrl,
			  regWrite				=> regWrite,
			  reg_A_ctrl			=> reg_A_ctrl,
			  reg_B_ctrl			=> reg_B_ctrl,
			  alu_a_sel				=> alu_a_sel,
			  alu_b_sel				=> alu_b_sel,
			  alu_reg_ctrl			=> alu_reg_ctrl,
			  enable_carry			=> enable_carry,
			  enable_zero			=> enable_zero,
			  pc_source_ctrl		=>pc_source_ctrl,
			  reg_A_sel				=>reg_A_sel,
			  reset					=>reset,
			  ir_toFSM				=>ir_toFSM,
			  clock					=> half_clock,
			  carry					=>carry,
			  zero					=>zero,
			  add_signal			=>add_signal,
			  sign_ext_ctrl		=>sign_ext_ctrl,
			  lst_two_op			=> lst_two_op,
			  mem_clock				=> clock_c,
			  counter_overFlow=> counter_overFlow,
			  mc_ctrl => mc_ctrl
			);
end combo;