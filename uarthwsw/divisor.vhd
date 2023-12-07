library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity divisor is
    port (
        clk    :  in std_logic;
        reset  :  in std_logic;
        clear  :  in std_logic;
        enable :  in std_logic;
        maxval :  in std_logic_vector(15 downto 0);
        tcount : out std_logic
    );
end entity divisor;

architecture behav of divisor is

begin
    
    process (clk, reset)
        variable cnt: std_logic_vector(15 downto 0);
    begin
        if (reset = '1') then
            cnt := (others => '0');
            tcount <= '0';
        elsif (rising_edge(clk)) then
            if (clear = '1') then
                cnt := (others => '0');
                tcount <= '0';
            elsif (enable = '1') then
                if (cnt = maxval) then
                    cnt := (others => '0');
                    tcount <= '1';
                else
                    cnt := cnt + 1;
                    tcount <= '0';
                end if;
            end if;
        end if;
    end process;

end architecture behav;