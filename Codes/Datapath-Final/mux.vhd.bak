library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components_RB.all;

entity mux is
	port(input0,input1,input2,input3,input4,input5,input6: in std_logic_vector(15 downto 0);
		  output: out std_logic_vector(15 downto 0);
		  selectPins: in std_logic_vector(2 downto 0));
end entity;

architecture Multiplexer of mux is
begin
	process(selectPins,input0,input1,input2,input3,input4,input5,input6)
		variable input: std_logic_vector(15 downto 0);
		begin
			if(selectPins = "000") then
				input := input0;
			elsif(selectPins = "001") then
				input := input1;
			elsif(selectPins = "010") then
				input := input2;
			elsif(selectPins = "011") then
				input := input3;
			elsif(selectPins = "100") then
				input := input4;
			elsif(selectPins = "101") then
				input := input5;
			elsif(selectPins = "110") then
				input := input6;
			else						-- Default Value
				input := input0;
			end if;
			output <= input;
end process;
end;