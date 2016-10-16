library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components_RB.all;

entity registerBank is
	port(dataOut_A: out std_logic_vector(15 downto 0);
		  dataOut_B: out std_logic_vector(15 downto 0);
		  clock_rb : in std_logic;
		  regSel_A : in std_logic_vector(2 downto 0);
		  regSel_B : in std_logic_vector(2 downto 0);
		  dataIn	  : in std_logic_vector(15 downto 0);
		  dataInsel: in std_logic_vector(2 downto 0);
		  reset	  : in std_logic;
		  regWrite : in std_logic);
end entity;

architecture RB of registerBank is
	signal muxA_in0,muxA_in1,muxA_in2,muxA_in3,muxA_in4,muxA_in5,muxA_in6,muxA_in7,muxA_in8,muxA_in9,muxA_in10,muxA_in11,muxA_in12,muxA_in13,muxA_in14,muxA_in15,muxB_in0,muxB_in1,muxB_in2,muxB_in3,muxB_in4,muxB_in5,muxB_in6,muxB_in7,muxB_in8,muxB_in9,muxB_in10,muxB_in11,muxB_in12,muxB_in13,muxB_in14,muxB_in15: std_logic_vector(15 downto 0);
	signal enable : std_logic_vector(6 downto 0);
begin
	inSel: decoder port map(input => dataInsel, output => enable);
	
	register0 : register16 port map(dataIn => dataIn,enable => (enable(0) and regWrite) ,dataOut => muxA_in0 ,clock => clock_rb,reset => reset);
	register1 : register16 port map(dataIn => dataIn,enable => (enable(1) and regWrite) ,dataOut => muxA_in1 ,clock => clock_rb,reset => reset);
	register2 : register16 port map(dataIn => dataIn,enable => (enable(2) and regWrite) ,dataOut => muxA_in2 ,clock => clock_rb,reset => reset);
	register3 : register16 port map(dataIn => dataIn,enable => (enable(3) and regWrite) ,dataOut => muxA_in3 ,clock => clock_rb,reset => reset);
	register4 : register16 port map(dataIn => dataIn,enable => (enable(4) and regWrite) ,dataOut => muxA_in4 ,clock => clock_rb,reset => reset);
	register5 : register16 port map(dataIn => dataIn,enable => (enable(5) and regWrite) ,dataOut => muxA_in5 ,clock => clock_rb,reset => reset);
	register6 : register16 port map(dataIn => dataIn,enable => (enable(6) and regWrite) ,dataOut => muxA_in6 ,clock => clock_rb,reset => reset);
	
	muxB_in0 <= muxA_in0;
	muxB_in1 <= muxA_in1;
	muxB_in2 <= muxA_in2;
	muxB_in3 <= muxA_in3;
	muxB_in4 <= muxA_in4;
	muxB_in5 <= muxA_in5;
	muxB_in6 <= muxA_in6;
	
	muxA: mux port map(input0 => muxA_in0, input1 => muxA_in1, input2 => muxA_in2, input3 => muxA_in3, input4 => muxA_in4, input5 => muxA_in5, input6 => muxA_in6,
				 output => dataOut_A, selectPins => regSel_A);
	muxb: mux port map(input0 => muxB_in0, input1 => muxB_in1, input2 => muxB_in2, input3 => muxB_in3, input4 => muxB_in4, input5 => muxB_in5, input6 => muxB_in6,
				 output => dataOut_B, selectPins => regSel_B);
end;