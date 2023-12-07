library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vgaoscilloscope is
    generic (
        depth       : integer range 0 to 16383 := 2048;
        bitdepth    : integer range 0 to 14 := 11
    );
    port (
        clock       :  in std_logic;
        reset       :  in std_logic;
        -- Pixel clock
        pixelclock  :  in std_logic;
        -- Divisor for horizontal (time) scale
        div_tscale  :  in std_logic_vector(15 downto 0);
        -- Signals to be displayed on the screen
        input1      :  in std_logic;
        input2      :  in std_logic;
        input3      :  in std_logic;
        input4      :  in std_logic;
        -- Keys to enable Single Mode and Panning
        keys        :  in std_logic_vector(3 downto 0);
        -- VGA
        VGA_B       : out std_logic_vector(7 downto 0);
        VGA_BLANK_N : out std_logic;   -- Should be set to 1
        VGA_CLK     : out std_logic;
        VGA_G       : out std_logic_vector(7 downto 0);
        VGA_HS      : out std_logic;
        VGA_R       : out std_logic_vector(7 downto 0);
        VGA_SYNC_N  : out std_logic;   -- Should be set to 0
        VGA_VS      : out std_logic;
        --SW          : in std_logic_vector(9 downto 0);
        -- State LEDs
        leds        : out std_logic_vector(4 downto 0)
    );
end vgaoscilloscope;

architecture main of vgaoscilloscope is

    -- Values for 1024x768 @ 60Hz, pixel clock 65 MHz
    constant nxpixels    : integer range 0 to 4095 := 1024;
    constant nypixels    : integer range 0 to 2047 :=  768;
    constant ntotxpixels : integer range 0 to 4095 := 1344;
    constant ntotypixels : integer range 0 to 2047 :=  806;
    constant xfrontporch : integer range 0 to 4095 :=   24;
    constant xsyncpulse  : integer range 0 to 4095 :=  136;
    constant yfrontporch : integer range 0 to 2047 :=    3;
    constant ysyncpulse  : integer range 0 to 2047 :=    6;

    -- Values for 1280x1024 @ 60Hz, pixel clock 108 MHz
    --constant nxpixels    : integer range 0 to 4095 := 1280;
    --constant nypixels    : integer range 0 to 2047 := 1024;
    --constant ntotxpixels : integer range 0 to 4095 := 1688;
    --constant ntotypixels : integer range 0 to 2047 := 1066;
    --constant xfrontporch : integer range 0 to 4095 :=   48;
    --constant xsyncpulse  : integer range 0 to 4095 :=  112;
    --constant yfrontporch : integer range 0 to 2047 :=    1;
    --constant ysyncpulse  : integer range 0 to 2047 :=    3;

    -- Values for 1366x768 @ 60 Hz pixel clock 85.5 MHz
    --constant nxpixels    : integer range 0 to 4095 := 1366;
    --constant nypixels    : integer range 0 to 2047 :=  768;
    --constant ntotxpixels : integer range 0 to 4095 := 1792;
    --constant ntotypixels : integer range 0 to 2047 :=  798;
    --constant xfrontporch : integer range 0 to 4095 :=   70;
    --constant xsyncpulse  : integer range 0 to 4095 :=  143;
    --constant yfrontporch : integer range 0 to 2047 :=    3;
    --constant ysyncpulse  : integer range 0 to 2047 :=    3;

    -- Values for 1440x900 @ 60 Hz pixel clock 106.5 MHz (generated 108.3 MHz)
    --constant nxpixels    : integer range 0 to 4095 := 1440;
    --constant nypixels    : integer range 0 to 2047 :=  900;
    --constant ntotxpixels : integer range 0 to 4095 := 1904;
    --constant ntotypixels : integer range 0 to 2047 :=  932;
    --constant xfrontporch : integer range 0 to 4095 :=   80;
    --constant xsyncpulse  : integer range 0 to 4095 :=  152;
    --constant yfrontporch : integer range 0 to 2047 :=    1;
    --constant ysyncpulse  : integer range 0 to 2047 :=    3;
    -- Need to change the integer range for hpos and vpos in sync.vhd

    -- Values for 1680x1050 @ 60 Hz pixel clock 147 MHz (generated 144 MHz)
    --constant nxpixels    : integer range 0 to 4095 := 1680;
    --constant nypixels    : integer range 0 to 2047 := 1050;
    --constant ntotxpixels : integer range 0 to 4095 := 2256;
    --constant ntotypixels : integer range 0 to 2047 := 1087;
    --constant xfrontporch : integer range 0 to 4095 :=  104;
    --constant xsyncpulse  : integer range 0 to 4095 :=  184;
    --constant yfrontporch : integer range 0 to 2047 :=    1;
    --constant ysyncpulse  : integer range 0 to 2047 :=    3;

    -- Values for 1920x1080 @ 60 Hz pixel clock 148.5 Mhz (generated 144 MHz)
    --constant nxpixels    : integer range 0 to 4095 := 1920;
    --constant nypixels    : integer range 0 to 2047 := 1080;
    --constant ntotxpixels : integer range 0 to 4095 := 2200;
    --constant ntotypixels : integer range 0 to 2047 := 1125;
    --constant xfrontporch : integer range 0 to 4095 :=   88;
    --constant xsyncpulse  : integer range 0 to 4095 :=   44;
    --constant yfrontporch : integer range 0 to 2047 :=    4;
    --constant ysyncpulse  : integer range 0 to 2047 :=    5;

    component sync is
        generic (
            depth       : integer range 0 to 16383;
            nxpixels    : integer range 0 to 4095;
            nypixels    : integer range 0 to 2047;
            ntotxpixels : integer range 0 to 4095;
            ntotypixels : integer range 0 to 2047;
            xfrontporch : integer range 0 to 4095;
            xsyncpulse  : integer range 0 to 4095;
            yfrontporch : integer range 0 to 2047;
            ysyncpulse  : integer range 0 to 2047
        );
        port (
            clk      :  in std_logic;
            hsync    : out std_logic;
            vsync    : out std_logic;
            r        : out std_logic_vector(7 downto 0);
            g        : out std_logic_vector(7 downto 0);
            b        : out std_logic_vector(7 downto 0);
            keys     :  in std_logic_vector(3 downto 0);
            channel1 :  in std_logic_vector(depth - 1 downto 0);
            channel2 :  in std_logic_vector(depth - 1 downto 0);
            channel3 :  in std_logic_vector(depth - 1 downto 0);
            channel4 :  in std_logic_vector(depth - 1 downto 0)
        );
    end component sync;

    component divisor is
        port (
            clk    :  in std_logic;
            reset  :  in std_logic;
            clear  :  in std_logic;
            enable :  in std_logic;
            maxval :  in std_logic_vector(15 downto 0);
            tcount : out std_logic
        );
    end component divisor;

    component sampler is
        generic (
            depth   : integer range  0 to 16383
        );
        port (
            clk     :  in std_logic;
            reset   :  in std_logic;
            enable  :  in std_logic;
            source  :  in std_logic;
            channel : out std_logic_vector(depth - 1 downto 0)
        );
    end component sampler;

    component samples_counter is
        generic (
            bitdepth : integer range 0 to 14
        );
        port (
            clk      :  in std_logic;
            reset    :  in std_logic;
            clear    :  in std_logic;
            enable   :  in std_logic;
            maxval   :  in std_logic_vector(bitdepth - 1 downto 0);
            tcount   : out std_logic
        );
    end component samples_counter;

    component osc_fsm is
        port (
            leds         : out std_logic_vector(4 downto 0);
            clk          :  in std_logic;
            reset        :  in std_logic;
            trigsrc1     :  in std_logic;
            trigsrc2     :  in std_logic;
            tcount       :  in std_logic;
            keysingle    :  in std_logic;
            sampleenable : out std_logic;
            countclear   : out std_logic
        );
    end component osc_fsm;

    -- Signals to be displayed
    signal chan1: std_logic_vector(depth - 1 downto 0);
    signal chan2: std_logic_vector(depth - 1 downto 0);
    signal chan3: std_logic_vector(depth - 1 downto 0);
    signal chan4: std_logic_vector(depth - 1 downto 0);

    -- Signals for the divisor
    signal divclear, divenable: std_logic;
    signal divisor_tc: std_logic;

    -- Signals for the samplers
    signal sampler_enable: std_logic;

    -- Signals for the samples counter
    signal maxsamples: std_logic_vector(bitdepth - 1 downto 0);
    signal tempval: integer range 0 to depth - 1;
    signal scounter_tc: std_logic;

    -- Signals for the FSM
    signal fsm_sampler_enable: std_logic;
    signal fsm_scounter_clear: std_logic;

begin

    VGA_BLANK_N <= '1';
    VGA_SYNC_N  <= '0';
    VGA_CLK     <= pixelclock;

    s1: sync
        generic map (depth, nxpixels, nypixels, ntotxpixels, ntotypixels, xfrontporch, xsyncpulse, yfrontporch, ysyncpulse)
        port map (pixelclock, VGA_HS, VGA_VS, VGA_R, VGA_G, VGA_B, keys, chan1, chan2, chan3, chan4);

    divclear <= '0';
    divenable <= '1';
    d1: divisor
        port map (clock, reset, divclear, divenable, div_tscale, divisor_tc);

    sampler_enable <= fsm_sampler_enable and divisor_tc;
    m1: sampler
        generic map (depth)
        port map (clock, reset, sampler_enable, input1, chan1);
    m2: sampler
        generic map (depth)
        port map (clock, reset, sampler_enable, input2, chan2);
    m3: sampler
        generic map (depth)
        port map (clock, reset, sampler_enable, input3, chan3);
    m4: sampler
        generic map (depth)
        port map (clock, reset, sampler_enable, input4, chan4);

    tempval <= depth - 64;
    maxsamples <= std_logic_vector(to_unsigned(tempval, maxsamples'length));
    c1: samples_counter
        generic map (bitdepth)
        port map (clock, reset, fsm_scounter_clear, divisor_tc, maxsamples, scounter_tc);

    f1: osc_fsm
        port map (leds, clock, reset, input1, input2, scounter_tc, keys(3), fsm_sampler_enable, fsm_scounter_clear);

end architecture main;