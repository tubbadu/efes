library ieee;
use ieee.std_logic_1164.all;

-- This code allows to characterize the DAC using an oscilloscope or a voltmeter.
-- The red and green channels (pins 1 and 2 of the VGA connector) are set using SW7-0, identical.
-- The blue channel (pin3) changes from "00000000" to "11111111" continuosly with a
-- frequency f_blue = fclk / 64 = 50MHz / 64 = 780kHz
-- GPIO_0(1) shows the input to the blue channel of the DAC, while GPIO_0(5) the 50MHz clock.

-- The student is supposed to measure the red channel (or the green) for various values (at least
-- 32, but possibly more), statically. Then compute the best linear approximation and the various
-- errors, linear and non linear.
-- The blue channel can be compared to the GPIO_0(1) pin to measure the DAC delay. Keep in mind
-- that the value is actually latched by the DAC 1 clock cycle later than what the GPIO_0(1) shows,
-- so the real delay is the measured delay minus 20ns (i.e. 1 clock cycle). It should be around
-- a few nanoseconds. You can also measure the settling time, but this is a hard measure, as the
-- signal is very noisy. Always put the oscilloscope in HighRes and not Normal in the Acquire menu
-- to better see these signals.

entity dac_test is
    port (
        -- CLOCK
        CLOCK_50     :  in std_logic;
        -- SEG7
        HEX0_N : out std_logic_vector(6 downto 0);
        HEX1_N : out std_logic_vector(6 downto 0);
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
end entity dac_test;

architecture rtl of dac_test is

    component dactestcnt6 is
        port (
          clock:   in std_logic;
          resetn:  in std_logic;
          cntout: out std_logic_vector(5 downto 0)
        );
    end component dactestcnt6;

    component hexdisp7seg is
        port (
            datain: in std_logic_vector(3 downto 0);
            seg7:  out std_logic_vector(6 downto 0)
        );
    end component hexdisp7seg;

    signal cntout: std_logic_vector(5 downto 0);
    signal resetn: std_logic;
    signal dacinval: std_logic_vector(7 downto 0);

begin
    
    resetn <= KEY_N(0);

    dacinval <= SW(7 downto 0);

    VGA_SYNC_N <= '0';
    VGA_BLANK_N <= '1';
    VGA_CLK <= CLOCK_50;
    VGA_R <= dacinval;
    VGA_G <= dacinval;

    -- The 8 right LEDs show the DAC input value
    LEDR(7 downto 0) <= dacinval;

    -- Right HEX displays are the input value to the DAC
    hd0: hexdisp7seg port map (dacinval(3 downto 0), HEX0_N);
    hd1: hexdisp7seg port map (dacinval(7 downto 4), HEX1_N);

    cnt4: dactestcnt6 port map (CLOCK_50, resetn, cntout);

    GPIO_0(1) <= cntout(5);

    GPIO_0(5) <= CLOCK_50;

    VGA_B(7) <= cntout(5);
    VGA_B(6) <= cntout(5);
    VGA_B(5) <= cntout(5);
    VGA_B(4) <= cntout(5);
    VGA_B(3) <= cntout(5);
    VGA_B(2) <= cntout(5);
    VGA_B(1) <= cntout(5);
    VGA_B(0) <= cntout(5);

end architecture rtl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity dactestcnt6 is
    port (
      clock:   in std_logic;
      resetn:  in std_logic;
      cntout: out std_logic_vector(5 downto 0)
    );
end entity dactestcnt6;

architecture rtl of dactestcnt6 is

begin

    process (clock, resetn)
        variable count: std_logic_vector(5 downto 0) := (others => '0');
    begin
        if (resetn = '0') then
            count := (others => '0');
        elsif (rising_edge(clock)) then
            count := count + 1;
        end if;
        cntout <= count;
    end process;
    
end architecture rtl;