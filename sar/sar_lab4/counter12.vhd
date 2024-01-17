library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counter12 is
    port (
        clock   :  in std_logic;
        resetn  :  in std_logic;
        init    :  in std_logic;
        enable  :  in std_logic;
        end_val :  in std_logic_vector(7 downto 0);
        tc      : out std_logic
    );
end entity counter12;

architecture rtl of counter12 is

    signal endVal_internal: std_logic_vector(11 downto 0);

begin
   
    endVal_internal <= end_val & "0000";

    process (clock, resetn)
        variable count: std_logic_vector(11 downto 0) := (others => '0');
    begin
        if (resetn = '0') then
            count := (others => '0');
            tc <= '0';
        elsif (rising_edge(clock)) then
            if (init = '1') then
                count := (others => '0');
                tc <= '0';
            elsif (enable = '1') then
                if (count = endVal_internal) then
                    tc <= '1';
                    count := (others => '0');
                else
                    count := count + 1;
                    tc <= '0';
                end if;
            end if;
        end if;
    end process;

end architecture rtl;