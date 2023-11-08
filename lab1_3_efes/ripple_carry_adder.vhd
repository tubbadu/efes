library ieee;
use ieee.std_logic_1164.all;

ENTITY ripple_carry_adder IS
  port(a,b: in std_logic_vector(3 DOWNTO 0); 
    cin: in std_logic;
    s: out std_logic_vector(3 DOWNTO 0);
	 cout: out std_logic); 
END ripple_carry_adder;

ARCHITECTURE structural OF ripple_carry_adder IS
SIGNAL f: std_logic_vector(0 TO 2);

COMPONENT fulladder IS
 port(a_full,b_full: in std_logic; 
    cin_full: in std_logic;
    s_full: out std_logic;
	 cout_full: out std_logic); 
END COMPONENT;

BEGIN
 fa0: fulladder PORT MAP (a_full => a(0), b_full => b(0), cin_full => cin, cout_full => f(0), s_full => s(0));
 fa1: fulladder PORT MAP (a_full => a(1), b_full => b(1), cin_full => f(0), cout_full => f(1), s_full => s(1));
 fa2: fulladder PORT MAP (a_full => a(2), b_full => b(2), cin_full => f(1), cout_full => f(2), s_full => s(2));
 fa3: fulladder PORT MAP (a_full => a(3), b_full => b(3), cin_full => f(2), cout_full => cout, s_full => s(3));
END ARCHITECTURE;