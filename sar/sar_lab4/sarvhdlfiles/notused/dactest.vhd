library ieee;
use ieee.std_logic_1164.all;

entity dactest is
   port (
      clock50:  in  std_logic;
      digin:    in  std_logic_vector(9 downto 0);
      dacclk:   out std_logic;
      dacred:   out std_logic_vector(9 downto 0);
      dacgreen: out std_logic_vector(9 downto 0);
      dacblue:  out std_logic_vector(9 downto 0);
      valled:	 out std_logic_vector(9 downto 0);
      cntout:   out std_logic;
      clkout:   out std_logic;
      dacblank: out std_logic;
      dacsync:  out std_logic
   );
end dactest;

architecture rtl of dactest is

   component counter4 is
      port (
         clock:  in std_logic;
         reset:  in std_logic;
         cntout: out std_logic_vector(5 downto 0)
      );
   end component counter4;
   
   signal cntval: std_logic_vector(5 downto 0);
   signal reset: std_logic;

begin

   reset <= '1';
   --cntval <= "0000";
   mycnt: counter4 port map (clock50, reset, cntval);
   cntout <= cntval(5);
   clkout <= clock50;
   dacclk <= clock50;
   dacblank <= '1';
   dacsync <= '0';
   dacred <= digin;
   valled <= digin;
   dacblue(9) <= cntval(5);
   dacblue(8) <= cntval(5);
   dacblue(7) <= cntval(5);
   dacblue(6) <= cntval(5);
   dacblue(5) <= cntval(5);
   dacblue(4) <= cntval(5);
   dacblue(3) <= cntval(5);
   dacblue(2) <= cntval(5);
   dacblue(1) <= cntval(5);
   dacblue(0) <= cntval(5);
   dacgreen(9) <= cntval(5);
   dacgreen(8) <= cntval(4);
   dacgreen(7) <= cntval(3);
   dacgreen(6) <= cntval(2);
   dacgreen(5) <= cntval(1);
   dacgreen(4) <= cntval(0);
   dacgreen(3 downto 0) <= "0000";

end rtl;




library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counter4 is
	port (
      clock:  in std_logic;
      reset:  in std_logic;
      cntout: out std_logic_vector(5 downto 0)
	);
end entity counter4;

architecture rtl of counter4 is

begin

	process (clock, reset)
		variable count: std_logic_vector(5 downto 0) := (others => '0');
	begin
		if (reset = '0') then
			count := (others => '0');
		elsif (rising_edge(clock)) then
			count := count + 1;
		end if;
      cntout <= count;
	end process;
	
end architecture rtl;