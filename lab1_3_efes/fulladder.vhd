library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY fulladder IS
 port(a_full,b_full: in std_logic; 
    cin_full: in std_logic;
    s_full: out std_logic;
	 cout_full: out std_logic); 
END fulladder;

ARCHITECTURE structural OF fulladder IS
SIGNAL a_u, b_u, c_u, out_u: unsigned(1 DOWNTO 0);

BEGIN

a_u(0) <= a_full;
b_u(0) <= b_full;
c_u(0) <= cin_full;
s_full <= out_u(0);
  

a_u(1) <= '0';
b_u(1) <= '0';
c_u(1) <= '0';
cout_full <= out_u(1);

out_u <= a_u+b_u+c_u;

END ARCHITECTURE;