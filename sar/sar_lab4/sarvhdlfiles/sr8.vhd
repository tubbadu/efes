library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity sr8 is
    port (
        clock   :  in std_logic;
        resetn  :  in std_logic;
        init    :  in std_logic;
        enable  :  in std_logic;
        data    : out std_logic_vector(7 downto 0)
    );
end entity sr8;

architecture rtl of sr8 is

    signal sr: std_logic_vector(7 downto 0);

begin

    process (clock, resetn)
    begin
        if (resetn = '0') then
            sr <= (others => '0');
        elsif (rising_edge(clock)) then
            if (init = '1') then
                sr <= "10000000";
            elsif (enable = '1') then
                sr(6 downto 0) <= sr(7 downto 1);
                sr(7) <= '0';
            end if;
        end if;
    end process;

    data <= sr;
    
end architecture rtl;