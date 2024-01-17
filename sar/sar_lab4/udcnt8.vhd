library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity udcnt8 is
    port (
        clock   :  in std_logic;
        resetn  :  in std_logic;
        clear   :  in std_logic;
        enable  :  in std_logic;
        dout    : out std_logic_vector(7 downto 0)
    );
end entity udcnt8;

architecture rtl of udcnt8 is

    signal count: std_logic_vector(7 downto 0);

begin

    process (clock, resetn)
        variable dir: std_logic;
    begin
        if (resetn = '0') then
            count <= (others => '0');
            dir := '0';
        elsif (rising_edge(clock)) then
            if (clear = '1') then
                count <= (others => '0');
                dir := '0';
            elsif (enable = '1') then
                if (count = "11111111") then
                    dir := '1';
                elsif (count = "00000000") then
                    dir := '0';
                end if;
                if (dir = '0') then
                    count <= count + 1;
                else
                    count <= count - 1;
                end if;
            end if;
        end if;
    end process;

    dout <= count;

end architecture rtl;