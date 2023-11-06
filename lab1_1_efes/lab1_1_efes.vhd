library ieee;
use ieee.std_logic_1164.all;


entity lab1_1_efes is
port (
	A, B: in std_logic;
	C : out std_logic
);
end entity;

architecture behavior of lab1_1_efes is
begin
	C <= A and B;
end architecture;