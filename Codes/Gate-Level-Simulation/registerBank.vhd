library ieee;
use ieee.std_logic_1164.all;

library work;
use work.combinedComponents.all;

entity registerBank is
	port(dataOut_A: out std_logic_vector(15 downto 0);
		  dataOut_B: out std_logic_vector(15 downto 0);
		  clock_rb : in std_logic;
		  regSel_A : in std_logic_vector(2 downto 0);
		  regSel_B : in std_logic_vector(2 downto 0);
		  dataIn	  : in std_logic_vector(15 downto 0);
		  dataInsel: in std_logic_vector(2 downto 0);
		  reset	  : in std_logic;
		  regWrite : in std_logic;
		  pc_in    : in std_logic_vector(15 downto 0);
		  r7_select: in std_logic;
		  register0: out std_logic_vector(15 downto 0));
end entity;

architecture RB of registerBank is
	signal muxA_in0,muxA_in1,muxA_in2,muxA_in3,muxA_in4,muxA_in5,muxA_in6,muxA_in7,muxB_in0,muxB_in1,muxB_in2,muxB_in3,muxB_in4,muxB_in5,muxB_in6,muxB_in7: std_logic_vector(15 downto 0);
	signal enable : std_logic_vector(7 downto 0);
	signal r7_in : std_logic_vector(15 downto 0);
	signal r7_en : std_logic;
	signal en,re : std_logic_vector(6 downto 0);
begin
	inSel: decoder port map(input => dataInsel, output => enable);
	r7_en <= (enable(7) and regWrite) or r7_select ; 
	en <= enable(6 downto 0) and re; 
	re <= (others => regWrite);
	
	register_0 : register16 port map(dataIn => dataIn,enable => en(0) ,dataOut => muxA_in0 ,clock => clock_rb,reset => reset);
	register_1 : register16 port map(dataIn => dataIn,enable => en(1) ,dataOut => muxA_in1 ,clock => clock_rb,reset => reset);
	register_2 : register16 port map(dataIn => dataIn,enable => en(2) ,dataOut => muxA_in2 ,clock => clock_rb,reset => reset);
	register_3 : register16 port map(dataIn => dataIn,enable => en(3) ,dataOut => muxA_in3 ,clock => clock_rb,reset => reset);
	register_4 : register16 port map(dataIn => dataIn,enable => en(4) ,dataOut => muxA_in4 ,clock => clock_rb,reset => reset);
	register_5 : register16 port map(dataIn => dataIn,enable => en(5) ,dataOut => muxA_in5 ,clock => clock_rb,reset => reset);
	register_6 : register16 port map(dataIn => dataIn,enable => en(6) ,dataOut => muxA_in6 ,clock => clock_rb,reset => reset);
	register_7 : register16 port map(dataIn => r7_in ,enable => r7_en ,dataOut => muxA_in7 ,clock => clock_rb,reset => reset);
	
	r7_mux : mux2 generic map(n => 15) port map(in0 => dataIn, in1 => pc_in, sel => r7_select, output => r7_in);
	
	muxB_in0 <= muxA_in0;
	muxB_in1 <= muxA_in1;
	muxB_in2 <= muxA_in2;
	muxB_in3 <= muxA_in3;
	muxB_in4 <= muxA_in4;
	muxB_in5 <= muxA_in5;
	muxB_in6 <= muxA_in6;
	muxB_in7 <= muxA_in7;
	register0<= muxA_in0;
	
	muxA: mux8 generic map(n => 15) port map(in0 => muxA_in0, in1 => muxA_in1, in2 => muxA_in2, in3 => muxA_in3, in4 => muxA_in4, in5 => muxA_in5, in6 => muxA_in6, in7 => muxA_in7,
				 output => dataOut_A, sel => regSel_A);
	muxb: mux8 generic map(n => 15) port map(in0 => muxB_in0, in1 => muxB_in1, in2 => muxB_in2, in3 => muxB_in3, in4 => muxB_in4, in5 => muxB_in5, in6 => muxB_in6, in7 => muxB_in7,
				 output => dataOut_B, sel => regSel_B);
end;
