library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end entity;

architecture behavior of tb is

signal	CLOCK_50:  std_logic;
signal	resetn:  std_logic_vector(0 downto 0);
signal	enable:  std_logic_vector(0 downto 0);
signal	HEX0, HEX1, HEX2, HEX3:  std_logic_vector(0 to 6);
signal	tc:  std_logic_vector(0 downto 0);

component lab1_5_efes
port(
	CLOCK_50:  IN std_logic;
	KEY: IN std_logic_vector(0 downto 0);
	SW: IN std_logic_vector(0 downto 0);
	HEX0, HEX1, HEX2, HEX3: OUT std_logic_vector(0 to 6);
	lEDR: OUT std_logic_vector(0 downto 0)
);
end component;


begin
testbencho: lab1_5_efes port map(
	CLOCK_50 => CLOCK_50,
	KEY => resetn,
	SW => enable,
	HEX0 => HEX0,
	HEX1 => HEX1,
	HEX2 => HEX2,
	HEX3 => HEX3,
	LEDR => tc
);

clock_process: process 
begin
	CLOCK_50 <= '0';
	wait for 20 ns;
	CLOCK_50 <= '1';
	wait for 20 ns;
end process;

tb_process: process
begin
	resetn(0) <= '0';
	enable(0) <= '0';
	wait for 50 ns;
	resetn(0) <= '1';
	wait for 50 ns;
	enable(0) <= '1';
	wait for 5 ms;
	
end process;

end architecture;