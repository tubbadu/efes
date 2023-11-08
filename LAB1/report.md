# Electronics for embedded systems - Group 02

> Gabriele Sanna XXXXXX
> Giulia Solito XXXXXX
> Ribaudo Alessandro 283309
> Rong Zhu XXXXXX

## Laboratory #1

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
