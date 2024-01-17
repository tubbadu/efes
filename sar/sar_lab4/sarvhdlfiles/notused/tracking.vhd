library ieee;
use ieee.std_logic_1164.all;

entity tracking is
	port (
		clock, resetn: in std_logic;
		run: in std_logic;
		comp: in std_logic;
		nbit: in std_logic_vector(3 downto 0);
      bluein: in std_logic_vector(4 downto 0);
		clkdivisor: in std_logic_vector(7 downto 0);
		dacout: out std_logic_vector(9 downto 0);
		dacsync: out std_logic;
		dacblank: out std_logic;
		dacclk: out std_logic;
      sarclock: out std_logic;
		dacgreen: out std_logic_vector(9 downto 0);
		dacblue: out std_logic_vector(9 downto 0);
		done: out std_logic;
		adcout: out std_logic_vector(9 downto 0)
	);
end entity tracking;

architecture struct of tracking is

	component counterud10 is
		port (
         clock, resetn: in std_logic;
         init: in std_logic;
         updown: in std_logic;
         enable: in std_logic;
         cntout: out std_logic_vector(9 downto 0)
		);
	end component counterud10;

	component counter12 is
		port (
			clock, resetn: in std_logic;
			init: in std_logic;
			enable: in std_logic;
			end_val: in std_logic_vector(7 downto 0);
			tc: out std_logic
		);
	end component counter12;

	signal init, shift_enable, reg_enable, final_enable, count_enable, tc: std_logic;
	signal slowclock, clkdiv_enable, clkdiv_init: std_logic;
   signal tadcout: std_logic_vector(9 downto 0);

begin

	clkdiv_enable <= '1';
	clkdiv_init <= '0';
	dacsync <= '0';
	dacblank <= '1';
	dacgreen <= tadcout;
	adcout <= tadcout;
   dacout <= tadcout;
	dacblue <= bluein & "00000";
	dacclk <= clock;
   sarclock <= slowclock;
	done <= final_enable;
   init <= '0';
	clkdiv: counter12 port map (clock, resetn, clkdiv_init, clkdiv_enable, clkdivisor, slowclock);
   trackcnt: counterud10 port map (slowclock, resetn, init, comp, run, tadcout);
	
end struct;
