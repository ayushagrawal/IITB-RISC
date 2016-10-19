library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components_RB.all;

entity decoder is
	port(input: in std_logic_vector(2 downto 0);
		  output: out std_logic_vector(7 downto 0));
end entity;

architecture Decode of decoder is
begin
	process(input)
		variable inp: std_logic_vector(7 downto 0);
		begin
			-- Default Value
			inp := "00000001";
			if(input = "000") then
				inp := "00000001";
			elsif(input = "001") then
				inp := "00000010";
			elsif(input = "010") then
				inp := "00000100";
			elsif(input = "011") then
				inp := "00001000";
			elsif(input = "100") then
				inp := "00010000";
			elsif(input = "101") then
				inp := "00100000";
			elsif(input = "110") then
				inp := "01000000";
			else
				inp := "10000000";
			end if;
			output <= inp;
end process;
end;