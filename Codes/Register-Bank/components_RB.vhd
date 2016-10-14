library ieee;
use ieee.std_logic_1164.all;

package components_RB is
	component mux is
		port(input0,input1,input2,input3,input4,input5,input6: in std_logic_vector(15 downto 0);
			  output: out std_logic_vector(15 downto 0);
			  selectPins: in std_logic_vector(2 downto 0));
	end component;
	
	component decoder is
		port(input: in std_logic_vector(2 downto 0);
			  output: out std_logic_vector(6 downto 0));
	end component;
	
	component register16 is
		port(dataIn: in std_logic_vector(15 downto 0);
			  enable: in std_logic;
			  dataOut: out std_logic_vector(15 downto 0);
			  clock: in std_logic;
			  reset: in std_logic);
	end component;
	
end package;