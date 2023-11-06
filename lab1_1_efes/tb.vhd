library ieee;
use ieee.std_logic_1164.all;

entity tb is
end entity;

architecture behavior of tb is
	component lab1_1_efes
	port (
		A, B: in std_logic;
		C : out std_logic
	);
	end component;

	signal A, B, C: std_logic;
begin



	and_port: lab1_1_efes PORT MAP(
		A => A,
		B => B,
		C => C
	);

	values_process: process is
	begin
		A <= '1';
		B <= '1';
		wait for 20 ns;
		A <= '0';
		B <= '1';
		wait for 20 ns;
		A <= '0';
		B <= '0';
		wait for 20 ns;
		A <= '1';
		B <= '0';
		wait for 20 ns;
	end process values_process;
end architecture;
