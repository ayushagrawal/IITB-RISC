library ieee;
use ieee.std_logic_1164.all;

entity register_1bit is
		port(dataIn: in std_logic;
			  enable: in std_logic;
			  dataOut: out std_logic;
			  clock: in std_logic;
			  reset: in std_logic);
	end entity;

architecture reg of register_1bit is
begin
	process(clock,enable)
		variable data: std_logic;
	begin
		if(clock'event and clock = '1') then
			if(reset = '1') then
				data := '0';
			elsif(enable = '1') then
				data := dataIn;
			end if;
			dataOut <= data;
		end if;
	end process;
end;
