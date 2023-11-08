library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_2bits is 
 port(
	cnt : buffer unsigned(9 downto 0);
	resn,enable,clk: in std_logic
 );
end entity;

architecture behaviour of counter_2bits is

begin
	count_process: process (clk,resn) is
	begin
	
	if (resn = '0') then
	    cnt<="0000000000";
	elsif (clk'event and clk = '1') then
	  if (enable='1') then
	     cnt <= cnt+1;
	  end if;
	end if;

	end process;

end architecture;
