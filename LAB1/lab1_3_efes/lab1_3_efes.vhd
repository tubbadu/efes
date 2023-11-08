library ieee;
use ieee.std_logic_1164.all;


entity lab1_3_efes is
port (
	SW: in std_logic_vector(7 DOWNTO 0);
	LEDR : out std_logic_vector(4 DOWNTO 0);
	KEY: in std_logic_vector(0 DOWNTO 0);
	HEX0: out std_logic_vector(0 TO 6));
end lab1_3_efes;

architecture behavior of lab1_3_efes is
SIGNAL input_decoder: std_logic_vector(3 DOWNTO 0);

COMPONENT ripple_carry_adder IS
  port(a,b: in std_logic_vector(3 DOWNTO 0); 
    cin: in std_logic;
    s: out std_logic_vector(3 DOWNTO 0);
	 cout: out std_logic); 
END COMPONENT;

COMPONENT disp IS
 PORT ( ing : IN STD_LOGIC_VECTOR( 3 DOWNTO 0);
 usc : OUT STD_LOGIC_VECTOR(0 to 6) ); 
END COMPONENT;

begin
LEDR(3 DOWNTO 0) <= input_decoder;
rca: ripple_carry_adder PORT MAP(a => SW(3 DOWNTO 0), b => SW(7 DOWNTO 4), cin => not KEY(0), cout => LEDR(4), s => input_decoder);
display: disp PORT MAP(ing => input_decoder, usc => HEX0);
end architecture;