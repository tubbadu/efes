library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sampler is
    generic (
        depth   : integer range  0 to 16383
    );
    port (
        clk     :  in std_logic;
        reset   :  in std_logic;
        enable  :  in std_logic;
        source  :  in std_logic;
        channel : out std_logic_vector(depth - 1 downto 0)
    );
end entity sampler;

architecture rtl of sampler is

    signal reg : std_logic_vector(depth - 1 downto 0);

begin

    process (clk, reset)
    begin
        if (reset = '1') then
            reg <= (others => '0');
        elsif (rising_edge(clk)) then
            if (enable = '1') then
                reg(depth - 2 downto 0) <= reg(depth - 1 downto 1);
                reg(depth - 1) <= source;
            end if;
        end if;
    end process;

    channel <= reg;

end architecture rtl;
