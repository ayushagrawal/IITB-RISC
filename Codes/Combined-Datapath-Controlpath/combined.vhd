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
signal 		  pc_reg_crtl: 	 std_logic;
signal		  address_crtl:  std_logic_vector(1 downto 0);
signal		  wren: 	 std_logic;
signal		  rden:  std_logic;
signal		  ir_crtl: 	 std_logic;
signal		  mem_data_crtl:  std_logic;
signal		  reg_data_crtl:  std_logic_vector(1 downto 0);
signal		  reg_sel_crtl:  std_logic_vector(1 downto 0);
signal		  regWrite: 	 std_logic;
signal		  reg_A_crtl: 	 std_logic;
signal		  reg_B_crtl: 	 std_logic;
signal		  alu_a_sel: 	 std_logic_vector(1 downto 0);
signal		  alu_b_sel: 	 std_logic_vector(1 downto 0);
signal		  alu_reg_crtl:  std_logic;
signal		  enable_carry:  std_logic;
signal		  enable_zero: 	 std_logic;
signal		  pc_source_crtl:  std_logic;
signal		  reg_A_sel : 	 std_logic;
signal		  add_signal :  std_logic;
signal		  mem_data_in_mux_crtl :  std_logic;				--
signal		  r7_select :  std_logic;
signal		  counter_clr:  std_logic;
signal		  counter_enable:  std_logic;									

begin

controller: fsm_controller port map
		(
		  opcode			=>ir_toFSM,
		  reset				=>reset_c,
		  carry				=>carry,
		  zero				=>zero,
		  clk				=>clock_c,
		  reset_to_DataPath	=>reset,
		  pc_reg_crtl		=>pc_reg_crtl,
		  address_crtl		=>address_crtl,
		  wren				=>wren,
		  rden				=>rden,
		  ir_crtl			=>ir_crtl,
		  mem_data_crtl		=> mem_data_crtl,
		  reg_data_crtl		=> reg_data_crtl,
		  reg_sel_crtl		=> reg_sel_crtl,
		  regWrite			=> regWrite,
		  reg_A_crtl		=> reg_A_crtl,
		  reg_B_crtl		=> reg_B_crtl,
		  alu_a_sel			=> alu_a_sel,
		  alu_b_sel			=> alu_b_sel,
		  alu_reg_crtl		=> alu_reg_crtl,
		  enable_carry		=> enable_carry,
		  enable_zero		=> enable_zero,
		  pc_source_crtl	=>pc_source_crtl,
		  reg_A_sel			=>reg_A_sel,
		  add_signal		=>add_signal,
		  mem_data_in_mux_crtl	=>mem_data_in_mux_crtl,
		  R7_select			=>r7_select,
		  counter_clear		=>counter_clr,
		  counter_enable	=>counter_enable
		);

datapath: completeDataPath port map
		(
		  pc_reg_crtl			=>pc_reg_crtl,
		  address_crtl			=>address_crtl,
		  counter_clr			=>counter_clr,
		  r7_select				=>R7_select,
		  counter_enable		=>counter_enable,
		  wren					=>wren,
		  rden					=>rden,
		  ir_crtl				=>ir_crtl,
		  mem_data_in_mux_ctrl	=>mem_data_in_mux_crtl,
		  mem_data_crtl			=> mem_data_crtl,
		  reg_data_crtl			=> reg_data_crtl,
		  reg_sel_crtl			=> reg_sel_crtl,
		  regWrite				=> regWrite,
		  reg_A_crtl			=> reg_A_crtl,
		  reg_B_crtl			=> reg_B_crtl,
		  alu_a_sel				=> alu_a_sel,
		  alu_b_sel				=> alu_b_sel,
		  alu_reg_crtl			=> alu_reg_crtl,
		  enable_carry			=> enable_carry,
		  enable_zero			=> enable_zero,
		  pc_source_crtl		=>pc_source_crtl,
		  reg_A_sel				=>reg_A_sel,
		  reset					=>reset,
		  ir_toFSM				=>ir_toFSM,
		  clock					=>clock_c,
		  carry					=>carry,
		  zero					=>zero,
		  add_signal			=>add_signal
		);
end combo;

