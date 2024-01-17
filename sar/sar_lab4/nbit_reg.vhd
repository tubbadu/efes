library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nbit_reg is
    generic (
        NBIT: integer range 0 to 32 := 8
    );
    port (
        clock   :  in std_logic;
        resetn  :  in std_logic;
        clear    :  in std_logic;
        enable  :  in std_logic;
        datain  :  in std_logic_vector(NBIT - 1 downto 0);
        dataout : out std_logic_vector(NBIT - 1 downto 0)
    );
end entity nbit_reg;

architecture rtl of nbit_reg is
begin

    process (clock, resetn) is
    begin
        if (resetn = '0') then
            dataout <= (others => '0');
        elsif (rising_edge(clock)) then
            if (clear = '1') then
                dataout <= (others => '0');
            elsif (enable = '1') then
                dataout <= datain;
            end if;
        end if;
    end process;

end architecture rtl;