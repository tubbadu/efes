library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end entity;

architecture behaviour of tb is

component lab1_2_efes
 port(
	clk, resn: in std_logic;
	A, B, C: out std_logic
 );
end component;

signal clk, A, B, C, resn: std_logic;

begin

testbench: lab1_2_efes port map(
	clk => clk,
	resn => resn,
	A => A,
	B => B,
	C => C
);

process is
begin
	clk <= '1';
	resn <= '0';
	wait for 20 ns;
	resn <= '1';
	wait for 20 ns;

	for i in 0 to 100 loop
		clk <= '0';
		wait for 20 ns;
		clk <= '1';
		wait for 20 ns;
	end loop;
end process;

end architecture;
