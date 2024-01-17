library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counterud10 is
	port (
		clock, resetn: in std_logic;
		init: in std_logic;
      updown: in std_logic;
		enable: in std_logic;
      cntout: out std_logic_vector(9 downto 0)
	);
end entity counterud10;

architecture rtl of counterud10 is

begin
	process (clock, resetn)
		variable count: std_logic_vector(9 downto 0) := (others => '0');
	begin
		if (resetn = '0') then
			count := (others => '0');
		elsif (rising_edge(clock)) then
			if (init = '1') then
				count := (others => '0');
			elsif (enable = '1') then
				if (updown = '0') then
					count := count - 1;
				else
					count := count + 1;
				end if;
			end if;
		end if;
      cntout <= count;
	end process;

end architecture rtl;