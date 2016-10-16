library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components_RB.all;

entity register8 is
		port(dataIn: in std_logic_vector(7 downto 0);
			  enable: in std_logic;
			  dataOut: out std_logic_vector(7 downto 0);
			  clock: in std_logic;
			  reset: in std_logic);
	end entity;

architecture reg of register8 is
begin
	process(clock,enable)
		variable data: std_logic_vector(7 downto 0);
	begin
		if(clock'event and clock = '1') then
			if(reset = '1') then
				data := "00000000";
			elsif(enable = '1') then
				data := dataIn;
			end if;
			dataOut <= data;
		end if;
	end process;
end;
