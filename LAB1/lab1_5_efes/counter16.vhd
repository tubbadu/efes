library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter16 is
port(
	clk, rstn, enable: in std_logic;
	cnt: buffer unsigned (15 downto 0);
	tc: out std_logic
);
end entity;

architecture behavior of counter16 is

begin

	cntpr: process(clk, rstn)
	begin
		if(rstn='0') then
			cnt <= (others=>'0'); --"0000000000000000";
		elsif (clk'event and clk='1') then
			if(enable='1') then
				cnt <= cnt + 1;
			end if;
		end if;
	end process;
	
	tc <= '1' when (cnt = "1111111111111111") else '0';

end architecture;