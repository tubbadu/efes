library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab1_2_efes is
 port(
	clk, resn: in std_logic;
	A, B, C: out std_logic
 );
end entity;

architecture behaviour of lab1_2_efes is

component counter_2bits  
 port(
	cnt : buffer unsigned(1 downto 0);
	resn,enable,clk: in std_logic
 );
end component;
component and_gate 
port (
	A, B: in std_logic;
	C : out std_logic
);
end component;

signal cnt:  unsigned(1 downto 0);
signal output: std_logic;
begin
counter_comp: counter_2bits port map(
	cnt => cnt,
	resn => resn,
	enable=>'1',
	clk=>clk
);

andgate_comp: and_gate port map(
	A=>cnt(0),
	B=>cnt(1),
	c=>output
);

A <= cnt(0);
B <= cnt(1);
C <= output;

end architecture;
