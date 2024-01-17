library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This code generates two signals, one on the red channel and the other on the blue channel of the VGA connector.
-- The blue channel (pin3 of VGA) is constant and set to 127 (01111111, 0x7f)
-- The red channel (pin1 of VGA) changes from a low value to a high value
--   * The low value is set using switches SW7-0
--   * The high value is the low value complemented
-- In this way the overdrive on the comparator can be changed by acting on the red channel value. The red channel
-- is always symmetric with respect to the blue channel.
-- The frequency of change of the red channel depends on a clock divisor, that is set using switches SW7-0 and by
-- pressing pushbutton KEY1, that store the data into a register. The clock divisor is actually on 12 bits, and
-- only the 8 MSBs are set in this way. The 4 LSBs are constantly set to 0.

-- LM393: pin8=Vdd, pin4=GND, pin1=out, pin2=in-, pin3=in+
-- The student is expected to mount the comparator on the breadboard, supply power at 5V (either using a power
-- supply or by taking the 5V from the header connector of the DE1-SoC board) and pull-up the output of the comparator
-- to Vdd using a 1kOhm resistor. The red channel goes to the in- terminal of the comparator, the blue channel goes
-- to the in+ terminal (or viceversa, it doesn't really matter). Connect GND from VGA (pin5) to GND of the breadboard.
-- Show the red channel (in- terminal, pin2) and the output (pin1) on the oscilloscope and measure the delay.
-- Check what happens for rising and falling edges.
-- Check what happens when varying the overdrive.

entity comparator_test is
    port (
        -- CLOCK
        CLOCK_50: in std_logic;
        -- SEG7
        HEX0_N : out std_logic_vector(6 downto 0);
        HEX1_N : out std_logic_vector(6 downto 0);
        HEX2_N : out std_logic_vector(6 downto 0);
        HEX3_N : out std_logic_vector(6 downto 0);
        -- KEY_N
        KEY_N : in std_logic_vector(3 downto 0);
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
end entity comparator_test;

architecture rtl of comparator_test is

    component nbit_reg is
    generic (
        NBIT: integer range 0 to 32 := 8
    );
    port (
        clock   :  in std_logic;
        resetn  :  in std_logic;
        clear   :  in std_logic;
        enable  :  in std_logic;
        datain  :  in std_logic_vector(NBIT - 1 downto 0);
        dataout : out std_logic_vector(NBIT - 1 downto 0)
    );
    end component nbit_reg;

    component hexdisp7seg is
        port (
            datain: in std_logic_vector(3 downto 0);
            seg7:  out std_logic_vector(6 downto 0)
        );
    end component hexdisp7seg;

    component nbit_cnt is
        generic (
            NBIT: integer range 0 to 32 := 8
        );
        port (
            clock   :  in std_logic;
            resetn  :  in std_logic;
            clear   :  in std_logic;
            enable  :  in std_logic;
            maxval  :  in std_logic_vector(NBIT-1 downto 0);
            dataout : out std_logic_vector(NBIT-1 downto 0);
            tc      : out std_logic
        );
    end component nbit_cnt;

    signal resetn: std_logic;
    signal clkdiv_reg_enable: std_logic;    -- enable the register only when pressing KEY1
    signal clkdivisor: std_logic_vector(11 downto 0);   -- the clock divisor, set the 8 MSBs using switches, the 4 LSBs are set to 0
    signal clkdivout: std_logic_vector(11 downto 0);   -- the current value of the clock divisor counter, not used
    signal slowclock: std_logic;    -- the slow clock, it makes a pulse at the terminal count of the clock divisor
    signal bitout: std_logic;    -- this bit goes from 0 to 1 and viceversa, according to the slowclock frequency
    signal clear_cnt: std_logic;   -- clear the counter to measure delay

begin

    resetn <= KEY_N(0);
    VGA_SYNC_N <= '0';
    VGA_BLANK_N <= '1';
    VGA_CLK <= CLOCK_50;
    VGA_G <= "00000000";  -- don't use the green channel, always set to 0
    VGA_B <= "01111111";  -- blue channel is at half dynamic range always

    -- KEY1 used to store the value of the clock divisor in a register
    clkdiv_reg_enable <= not KEY_N(1);
    clkdivisor(3 downto 0) <= "0000";
    clkdiv_reg: nbit_reg generic map (8) port map (CLOCK_50, resetn, '0', clkdiv_reg_enable, SW(7 downto 0), clkdivisor(11 downto 4));

    -- Divisor to generate the clock of test circuit. f_eqclk = 50000000 / (clkdivisor + 1)
    clkdiv: nbit_cnt generic map (12) port map (CLOCK_50, resetn, '0', '1', clkdivisor, clkdivout, slowclock);

    -- generate a bit that complements from 0 to 1 and viceversa, enabled by the slowclock
    process (CLOCK_50, resetn)
    begin
        if (resetn = '0') then
            bitout <= '0';
        elsif (rising_edge(CLOCK_50)) then
            if (slowclock = '1') then
                bitout <= not bitout;
                clear_cnt <= '1';
            else
                clear_cnt <= '0';
            end if;
        end if;
    end process;

    -- output red channel depending on the bitout
    with bitout select
    VGA_R <= SW(7 downto 0) when '0',
             not SW(7 downto 0) when '1',
             "00000000" when others;

    -- Right HEX displays is the min value of the red channel
    hd0: hexdisp7seg port map (SW(3 downto 0), HEX0_N);
    hd1: hexdisp7seg port map (SW(7 downto 4), HEX1_N);
    -- Middle HEX displays show the clkdivisor
    hd2: hexdisp7seg port map (clkdivisor( 7 downto 4), HEX2_N);
    hd3: hexdisp7seg port map (clkdivisor(11 downto 8), HEX3_N);

    -- GPIOs are inout. For GPIO_0(1) the output is set to 'Z', so it can be read as an input
    -- It may be used to look at the output of the comparator
    GPIO_0(1) <= 'Z';
    -- signal clear_cnt can be used to clear a counter when bitout flips. Then the counter should be stopped
    -- when the signal on GPIO_0(1) flips, and the reached value saved. This is the delay in clock ticks of
    -- the comparator.

    
end architecture rtl;