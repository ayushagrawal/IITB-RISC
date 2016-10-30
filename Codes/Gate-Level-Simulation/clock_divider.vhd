LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity CLOCK_DIVIDER is
    port(
        reset   :   in std_logic;
        clk :   in std_logic;
        half_clk    :   out std_logic
        );
end CLOCK_DIVIDER;


architecture CLOCK_DIVIDER of CLOCK_DIVIDER is
signal tick : std_logic;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            tick <= '0';
        elsif clk = '1' and clk'EVENT then
            if tick = '0' then
                tick <= '1';
            elsif tick = '1' then
                tick <= '0';
            end if;
        end if;
    end process;

    process(tick)
    begin
        half_clk <= tick;
    end process;

end CLOCK_DIVIDER;