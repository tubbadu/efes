# Electronics for embedded systems - Group 02

> Gabriele Sanna 324140  
> Giulia Solito 329160  
> Ribaudo Alessandro 283309  
> Rong Zhu 327239  
> 
> TODO check if id numbers are correct!

## Laboratory 1

### Project 1: AND gate

#### file `lab1_1_efes.vhd`:
```vhdl
library ieee;
use ieee.std_logic_1164.all;


entity lab1_1_efes is
port (
	SW: in std_logic_vector(1 downto 0);
	LEDR : out std_logic_vector(0 downto 0)
);
end entity;

architecture behavior of lab1_1_efes is
begin
	LEDR(0) <= SW(0) and SW(1);
end architecture;
```

#### file `tb.vhd`:
```vhdl
library ieee;
use ieee.std_logic_1164.all;

entity tb is
end entity;

architecture behavior of tb is
	component lab1_1_efes
	port (
		A, B: in std_logic;
		C : out std_logic
	);
	end component;

	signal A, B, C: std_logic;
begin



	and_port: lab1_1_efes PORT MAP(
		A => A,
		B => B,
		C => C
	);

	values_process: process is
	begin
		A <= '1';
		B <= '1';
		wait for 20 ns;
		A <= '0';
		B <= '1';
		wait for 20 ns;
		A <= '0';
		B <= '0';
		wait for 20 ns;
		A <= '1';
		B <= '0';
		wait for 20 ns;
	end process values_process;
end architecture;
```

#### Code explanation:
we did something blablabla TODO write this text here

#### Timing analisys:

| Input 1 pin | Input 2 pin | Output pin | Constraint $t_{pd}$ | Worst case $t_{pd}$ |
| ----------- | ----------- | ---------- | ------------------- | ------------------- |
| 1           | 2           | 3          | 4                   | 5                   |
| 1           | 2           | 3          | 4                   | 5                   |
| 1           | 2           | 3          | 4                   | 5                   |

blablabla

### Project 2: 10 bit counter

#### file `lab1_2_efes.vhd`:
```vhdl
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
```

#### file `counter_2bits.vhd`:
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_2bits is 
 port(
	cnt : buffer unsigned(9 downto 0);
	resn,enable,clk: in std_logic
 );
end entity;

architecture behaviour of counter_2bits is

begin
	count_process: process (clk,resn) is
	begin
	
	if (resn = '0') then
	    cnt<="0000000000";
	elsif (clk'event and clk = '1') then
	  if (enable='1') then
	     cnt <= cnt+1;
	  end if;
	end if;

	end process;

end architecture;
```

#### file `and_gate.vhd`:
```vhdl
library ieee;
use ieee.std_logic_1164.all;


entity and_gate is
port (
	A, B: in std_logic;
	C : out std_logic
);
end entity;

architecture behavior of and_gate is
begin
	C <= A and B;
end architecture;
```

#### file `tb.vhd`:
```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end entity;

architecture behaviour of tb is

component lab1_2_efes
 port(
	clk, resn: in std_logic;
	A, B, C: out std_logic
 );
end component;

signal clk, A, B, C, resn: std_logic;

begin

testbench: lab1_2_efes port map(
	clk => clk,
	resn => resn,
	A => A,
	B => B,
	C => C
);

process is
begin
	clk <= '1';
	resn <= '0';
	wait for 20 ns;
	resn <= '1';
	wait for 20 ns;

	for i in 0 to 100 loop
		clk <= '0';
		wait for 20 ns;
		clk <= '1';
		wait for 20 ns;
	end loop;
end process;

end architecture;
```

#### Code explanation:
we did something blablabla TODO write this text here

#### Timing analisys: