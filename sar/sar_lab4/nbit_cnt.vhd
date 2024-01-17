library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nbit_cnt is
    generic (
        NBIT: integer range 0 to 32 := 8
    );
    port (
        clock   :  in std_logic;
        resetn  :  in std_logic;
        clear   :  in std_logic;
        enable  :  in std_logic;
        maxval  :  in std_logic_vector(NBIT-1 downto 0);
        dataout : out std_logic_vector(NBIT-1 downto 0);
        tc      : out std_logic
    );
end entity nbit_cnt;

architecture rtl of nbit_cnt is
    
    signal internal_count: unsigned(NBIT-1 downto 0);
    signal internal_max: unsigned(NBIT-1 downto 0);

begin

    internal_max <= unsigned(maxval);

    process (clock, resetn)
    begin
        if (resetn = '0') then
            internal_count <= (others => '0');
        elsif (rising_edge(clock)) then
            if (clear = '1') then
                internal_count <= (others => '0');
            elsif (enable = '1') then
                if (internal_count = internal_max) then
                    tc <= '1';
                    internal_count <= (others => '0');
                else
                    tc <= '0';
                    internal_count <= internal_count + 1;
                end if;
            end if;
        end if;

    end process;

    dataout <= std_logic_vector(internal_count);
    
end architecture rtl;