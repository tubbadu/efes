LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY disp IS
 PORT ( ing : IN STD_LOGIC_VECTOR( 3 DOWNTO 0);
 usc : OUT STD_LOGIC_VECTOR(0 to 6) ); 
END disp;

ARCHITECTURE Behaviour OF disp IS -- funzioni logiche derivate dalla tabella di verità e dalle mappe di Karnaugh
 BEGIN
 usc(0) <= ((NOT ing(3)) AND (NOT ing(2)) AND (NOT ing(1)) AND ing(0)) OR ((NOT ing(3)) AND (NOT ing(0)) AND (NOT ing(1)) AND ing(2)) OR 
 (ing(3) AND ing(2) AND (NOT ing(1)) AND ing(0)) OR (ing(3) AND (NOT ing(2)) AND ing(1) AND ing(0));
 usc(1) <= ((NOT ing(3)) AND ing(2) AND (NOT ing(1)) AND ing(0)) OR ((NOT ing(0)) AND ing(1) AND ing(2)) OR 
 (ing(3) AND ing(2) AND (NOT ing(0))) OR (ing(3) AND ing(2) AND ing(1)) OR (ing(3) AND ing(0) AND ing(1));
 usc(2) <= ((NOT ing(3)) AND ing(1) AND (NOT ing(2)) AND (NOT ing(0))) OR (ing(3) AND ing(1) AND ing(2)) OR 
 (ing(3) AND ing(2) AND (NOT ing(0)));
 usc(3) <= ((NOT ing(3)) AND (NOT ing(2)) AND (NOT ing(1)) AND ing(0)) OR ((NOT ing(3)) AND (NOT ing(0)) AND (NOT ing(1)) AND ing(2)) OR 
 (ing(0) AND ing(2) AND ing(1)) OR (ing(3) AND (NOT ing(2)) AND ing(1) AND (NOT ing(0)));
 usc(4) <= ((NOT ing(2)) AND (NOT ing(1)) AND ing(0)) OR (((NOT ing(3)) AND (NOT ing(1)) AND ing(2))) OR ( (NOT ing(3)) AND ing(0));
 usc(5) <= ((NOT ing(3)) AND ing(1) AND (NOT ing(2))) OR (ing(3) AND ing(0) AND ing(2) AND (NOT ing(1))) OR 
 ((NOT ing(3)) AND ing(0) AND (NOT ing(2))) OR ((NOT ing(3)) AND ing(1) AND ing(0));
 usc(6) <= ((NOT ing(3)) AND (NOT ing(2)) AND (NOT ing(1))) OR ((NOT ing(3)) AND ing(1) AND ing(2) AND ing(0)) OR 
 (ing(3) AND ing(2) AND (NOT ing(0)) AND (NOT ing(1)));
END Behaviour ;