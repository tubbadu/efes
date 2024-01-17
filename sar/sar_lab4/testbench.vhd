library ieee;
use ieee.std_logic_1164.all;

entity testbench is
end testbench;

architecture behav of testbench is

component sar is
    port (
        -- CLOCK
        CLOCK_50     :  in std_logic;
        -- SEG7
        HEX0_N : out std_logic_vector(6 downto 0);
        HEX1_N : out std_logic_vector(6 downto 0);
        HEX2_N : out std_logic_vector(6 downto 0);
        HEX3_N : out std_logic_vector(6 downto 0);
        HEX4_N : out std_logic_vector(6 downto 0);
        HEX5_N : out std_logic_vector(6 downto 0);
        -- KEY_N
        KEY_N : in std_logic_vector(3 downto 0);
        -- LED
        LEDR : out std_logic_vector(9 downto 0);
        -- SW
        SW : in std_logic_vector(9 downto 0);
        -- GPIO_0
        GPIO_0 : inout std_logic_vector(35 downto 0);
        -- VGA
        VGA_B       : out std_logic_vector(7 downto 0);
        VGA_BLANK_N : out std_logic;
        VGA_CLK     : out std_logic;
        VGA_G       : out std_logic_vector(7 downto 0);
        --VGA_HS      : out std_logic;
        VGA_R       : out std_logic_vector(7 downto 0);
        VGA_SYNC_N  : out std_logic
        --VGA_VS      : out std_logic
    );
end component sar;
	
    signal clock: std_logic := '0';
    signal hex0, hex1, hex2, hex3, hex4, hex5: std_logic_vector(6 downto 0);
    signal keys: std_logic_vector(3 downto 0);
    signal leds: std_logic_vector(9 downto 0);
    signal switches: std_logic_vector(9 downto 0);
    signal gpio_0: std_logic_vector(35 downto 0);
    signal dacsync, dacblank, dacclk: std_logic;
    signal dacgreen: std_logic_vector(7 downto 0);
    signal dacblue: std_logic_vector(7 downto 0);
    signal dacred: std_logic_vector(7 downto 0);

	constant clk_period: time := 20 ns;
	
begin

    --dut: sar port map (clock, resetn, run, comp, nbit, bluein, clkdivisor, dacout, dacsync, dacblank, dacclk, sarclock, dacgreen, dacblue, done, adcout);
    dut: sar port map (clock, hex0, hex1, hex2, hex3, hex4, hex5, keys, leds, switches, gpio_0, dacblue, dacblank, dacclk, dacgreen, dacred, dacsync);
		
	myclock: process is
		begin
			clock <= '1';
			wait for clk_period/2;
			clock <= '0';
			wait for clk_period/2;
		end process myclock;

	stimuli: process is
		begin
            keys <= "1111";
            switches <= "0000000000";
            gpio_0 <= (others => 'Z');
            gpio_0(1) <= '0';
			wait for 1 us;
            keys(0) <= '0';  -- RESET
			wait for 1 us;
            keys(0) <= '1';
			wait for 1.01 us;

            switches(7 downto 0) <= "00000001";   -- CLK DIVISOR
            wait for 40 ns;
            keys(1) <= '0';
            wait for 60 ns;
            keys(1) <= '1';
            wait for 60 ns;

            switches(7 downto 0) <= "00000101";   -- Number of bits
            wait for 40 ns;
            keys(2) <= '0';
            wait for 60 ns;
            keys(2) <= '1';
            wait for 60 ns;

			switches(9) <= '1';   -- RUN
			wait for 330 ns;
			wait for 340 ns;
			wait for 200 ns;
			gpio_0(1) <= '1';
			wait for 140 ns;
			wait for 340 ns;
			wait for 200 ns;
			gpio_0(1) <= '0';
			wait for 140 ns;
			wait for 340 ns;
			wait for 200 ns;
			gpio_0(1) <= '1';
			wait for 140 ns;
			wait for 200 ns;
			gpio_0(1) <= '0';
			wait for 140 ns;
			wait for 340 ns;
			wait for 340 ns;
			wait for 340 ns;
			wait for 340 ns;
			wait for 340 ns;
			wait for 340 ns;
			wait for 340 ns;
			wait for 340 ns;

		end process;
		
end behav;