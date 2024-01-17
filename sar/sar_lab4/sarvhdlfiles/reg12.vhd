library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity reg12 is
    port (
        clock   :  in std_logic;
        resetn  :  in std_logic;
        init    :  in std_logic;
        enable  :  in std_logic;
        datain  :  in std_logic_vector(11 downto 0);
        dataout : out std_logic_vector(11 downto 0)
    );
end entity reg12;

architecture rtl of reg12 is
begin

    process (clock, resetn) is
    begin
        if (resetn = '0') then
            dataout <= (others => '0');
        elsif (rising_edge(clock)) then
            if (init = '1') then
                dataout <= (others => '0');
            elsif (enable = '1') then
                dataout <= datain;
            end if;
        end if;
    end process;

end architecture rtl;