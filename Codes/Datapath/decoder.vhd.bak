library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components_RB.all;

entity decoder is
	port(input: in std_logic_vector(2 downto 0);
		  output: out std_logic_vector(6 downto 0));
end entity;

architecture Decode of decoder is
begin
	process(input)
		variable inp: std_logic_vector(6 downto 0);
		begin
			-- Default Value
			inp := "0000001";
			if(input = "000") then
				inp := "0000001";
			elsif(input = "001") then
				inp := "0000010";
			elsif(input = "010") then
				inp := "0000100";
			elsif(input = "011") then
				inp := "0001000";
			elsif(input = "100") then
				inp := "0010000";
			elsif(input = "101") then
				inp := "0100000";
			elsif(input = "110") then
				inp := "1000000";
			else
				inp := "0000000";
			end if;
			output <= inp;
end process;
end;