 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab1_5_efes is
port(
	CLOCK_50:  IN std_logic;
	KEY: IN std_logic_vector(0 downto 0);
	SW: IN std_logic_vector(0 downto 0);
	HEX0, HEX1, HEX2, HEX3: OUT std_logic_vector(0 to 6);
	lEDR: OUT std_logic_vector(0 downto 0)
);
end entity;

architecture behavior of lab1_5_efes is
signal count: unsigned(15 downto 0);

component counter16
port(
	clk, rstn, enable: in std_logic;
	cnt: buffer unsigned (15 downto 0);
	tc: out std_logic
);
end component;

component disp
 PORT ( 
	ing : IN STD_LOGIC_VECTOR( 3 DOWNTO 0);
	usc : OUT STD_LOGIC_VECTOR(0 to 6)
); 
END component;

begin

pippo: counter16 port map(
	clk => CLOCK_50,
	rstn => KEY(0),
	enable => SW(0),
	cnt => count,
	tc => LEDR(0)
);

disp0: disp port map(
	ing => std_logic_vector(count(3 downto 0)),
	usc => HEX0
);
disp1: disp port map(
	ing => std_logic_vector(count(7 downto 4)),
	usc => HEX1
);
disp2: disp port map(
	ing => std_logic_vector(count(11 downto 8)),
	usc => HEX2
);
disp3: disp port map(
	ing => std_logic_vector(count(15 downto 12)),
	usc => HEX3
);



end architecture;