library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nbit_sr is
    generic (
        NBIT: integer range 0 to 32 := 8
    );
    port (
        clock   :  in std_logic;
        resetn  :  in std_logic;
        init    :  in std_logic;
        enable  :  in std_logic;
        data    : out std_logic_vector(NBIT-1 downto 0)
    );
end entity nbit_sr;

architecture rtl of nbit_sr is

    signal sr: std_logic_vector(NBIT-1 downto 0);

begin

    process (clock, resetn)
    begin
        if (resetn = '0') then
            sr <= (others => '0');
        elsif (rising_edge(clock)) then
            if (init = '1') then
                sr(NBIT-1) <= '1';
                sr(NBIT-2 downto 0) <= (others => '0');
            elsif (enable = '1') then
                sr(NBIT-2 downto 0) <= sr(NBIT-1 downto 1);
                sr(NBIT-1) <= '0';
            end if;
        end if;
    end process;

    data <= sr;
    
end architecture rtl;