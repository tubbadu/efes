library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab1_2_efes is
 port(
	CLOCK_50: in std_logic;
	GPIO_0: out std_logic_vector(2 downto 0);
	KEY: in std_logic_vector(0 DOWNTO 0)
 );
end entity;

architecture behaviour of lab1_2_efes is

signal A, B, C, resn, clk: std_logic;

component counter_2bits  
 port(
	cnt : buffer unsigned(9 downto 0);
	resn,enable,clk: in std_logic
 );
end component;
component and_gate 
port (
	A, B: in std_logic;
	C : out std_logic
);
end component;

signal cnt:  unsigned(9 downto 0);
signal output: std_logic;
begin
counter_comp: counter_2bits port map(
	cnt => cnt,
	resn => resn,
	enable=>'1',
	clk=>clk
);

andgate_comp: and_gate port map(
	A=>cnt(9),
	B=>cnt(8),
	c=>output
);

A <= cnt(9);
B <= cnt(8);
C <= output;



resn <= KEY(0);
GPIO_0(0) <= A;
GPIO_0(1) <= B;
GPIO_0(2) <= C;
clk <= CLOCK_50;

end architecture;
