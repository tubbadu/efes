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
-- only the 8 MSBs are set in this way. The 4 LSBs are constantly set to 0. The value of the clock divisor is
-- shown on the 7-segment displays.

-- LM393: pin8=Vdd, pin4=GND, pin1=out, pin2=in-, pin3=in+
-- The student is expected to mount the comparator on the breadboard, supply power at 5V (either using a power
-- supply or by taking the 5V from the header connector of the DE1-SoC board) and pull-up the output of the comparator
-- to Vdd using a 1kOhm resistor. The red channel goes to the in- terminal of the comparator, the blue channel goes
-- to the in+ terminal (or viceversa, it doesn't really matter). Connect GND from VGA (pin5) to GND of the breadboard.
-- Show the red channel (in- terminal, pin2) and the output (pin1) on the oscilloscope and measure the delay.
-- Check what happens for rising and falling edges.
-- Check what happens when varying the overdrive.

-- If you don't have an oscilloscope but you have a breadboard with the comparator, then you can use this code to
-- measure the delay. Connect the red channel to the minus pin and the blue channel to the plus pin of the comparator.
-- Connect the output of the comparator to the GPIO_0(1) pin on the left header connector. Set the divisor for the
-- red channel (for instance to the value 0x20, more if your comparator is really slow). Put SW7-0 all to 0 to have
-- the maximum overdrive.
-- To measure the rising transition (when the red makes a falling transition), put SW9=1 and press KEY3 (keep it
-- pressed for a second or so). The 4 right 7-segment displays show the value of a timer in hexadecimal, counting
-- clock ticks. Since the clock is at 50MHz, multiply the value by 20ns to get the delay.
-- To measure the falling transition (when the red makes a rising transition), put SW9=0 and press KEY3 (keep it
-- pressed for a second or so). The 4 right 7-segment displays show the value of a timer in hexadecimal, counting
-- clock ticks. Since the clock is at 50MHz, multiply the value by 20ns to get the delay.
-- Now change the overdrive by setting SW7-0 to some value (for instance to 64) and repeat the measures; the delay
-- should change. Try to find the maximum delay.

-- If the timer always reads zero, then it might be that the channels are connected inverted to the comparator.
-- Either exchange the two channels, or change the expression for timer_reg_enable at the end of the code.

entity comparator_test_noosc is
    port (
        -- CLOCK
        CLOCK_50: in std_logic;
        -- SEG7
        HEX0_N : out std_logic_vector(6 downto 0);
        HEX1_N : out std_logic_vector(6 downto 0);
        HEX2_N : out std_logic_vector(6 downto 0);
        HEX3_N : out std_logic_vector(6 downto 0);
        HEX4_N : out std_logic_vector(6 downto 0);
        HEX5_N : out std_logic_vector(6 downto 0);
        -- KEY_N
        KEY_N : in std_logic_vector(3 downto 0);
        -- SW
        SW : in std_logic_vector(9 downto 0);
        -- LED
        LEDR : out std_logic_vector(9 downto 0);
        -- ADC
        ADC_SCLK : out std_logic;
        ADC_CS_N : out std_logic;
        ADC_DOUT : in  std_logic;
        ADC_DIN  : out std_logic;
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
end entity comparator_test_noosc;

architecture rtl of comparator_test_noosc is

    component adc_controller is
        port (
            CLOCK    : in  std_logic                     := '0'; --                clk.clk
            ADC_SCLK : out std_logic;                            -- external_interface.SCLK
            ADC_CS_N : out std_logic;                            --                   .CS_N
            ADC_DOUT : in  std_logic                     := '0'; --                   .DOUT
            ADC_DIN  : out std_logic;                            --                   .DIN
            CH0      : out std_logic_vector(11 downto 0);        --           readings.CH0
            CH1      : out std_logic_vector(11 downto 0);        --                   .CH1
            CH2      : out std_logic_vector(11 downto 0);        --                   .CH2
            CH3      : out std_logic_vector(11 downto 0);        --                   .CH3
            CH4      : out std_logic_vector(11 downto 0);        --                   .CH4
            CH5      : out std_logic_vector(11 downto 0);        --                   .CH5
            CH6      : out std_logic_vector(11 downto 0);        --                   .CH6
            CH7      : out std_logic_vector(11 downto 0);        --                   .CH7
            RESET    : in  std_logic                     := '0'  --              reset.reset
        );
    end component adc_controller;

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
    signal timer_reg_enable: std_logic;    -- enables loading data on the timer register
    signal timer_cnt: std_logic_vector(15 downto 0);    -- the output of the timer counter
    signal timer_cnt_enable: std_logic;      -- enable of the timer
    signal timer_tc: std_logic;    -- the terminal count of the timer counter, not used
    signal comp: std_logic;     -- the output of the comparator
    signal delay: std_logic_vector(15 downto 0);   -- the measured delay

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

    LEDR(7 downto 0) <= SW(7 downto 0);

    -- Left HEX displays show the clkdivisor
    hd4: hexdisp7seg port map (clkdivisor( 7 downto 4), HEX4_N);
    hd5: hexdisp7seg port map (clkdivisor(11 downto 8), HEX5_N);

    -- GPIOs are inout. For GPIO_0(1) the output is set to 'Z', so it can be read as an input
    -- It may be used to look at the output of the comparator
    GPIO_0(1) <= 'Z';
    comp <= GPIO_0(1);

    -- The timer is a nbit counter, cleared when the red channel flips. The output of the counter is then latched in a register
    -- when KEY3 is pressed. Care should be taken to enable the counter and the register only when necessary
    timer_cnt_enable <= (SW(9) and (not comp)) or ((not SW(9)) and comp);
    timer: nbit_cnt generic map (16) port map (CLOCK_50, resetn, clear_cnt, timer_cnt_enable, "1111111111111111", timer_cnt, timer_tc);

    -- If the red in on the plus and the blue on the minus pins of the comparator, the output of the comparator is like the
    -- red, but with a delay in the transition. Use the following expression for timer_reg_enable
    -- timer_reg_enable <= (not KEY_N(3)) and (((not bitout) and SW(9) and comp) or (bitout and (not SW(9)) and (not comp)));
    -- If the red is on the minus and the blue on the plus pins of the comparator, the output of the comparator is complemented
    -- with respect to the red, with a delay in the transition. Use the following expression for timer_reg_enable
    timer_reg_enable <= (not KEY_N(3)) and (((not bitout) and SW(9) and comp) or (bitout and (not SW(9)) and (not comp)));
    timerreg: nbit_reg generic map (16) port map (CLOCK_50, resetn, '0', timer_reg_enable, timer_cnt, delay);

    -- Right HEX displays is the delay measure
    hd0: hexdisp7seg port map (delay( 3 downto  0), HEX0_N);
    hd1: hexdisp7seg port map (delay( 7 downto  4), HEX1_N);
    hd2: hexdisp7seg port map (delay(11 downto  8), HEX2_N);
    hd3: hexdisp7seg port map (delay(15 downto 12), HEX3_N);

    
end architecture rtl;