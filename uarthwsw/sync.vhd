library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync is
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
end sync;


architecture main of sync is

-- See http://tinyvga.com/vga-timing
-- Sync stays low starting at the end of Front Porch for a duration of Sync Pulse
-- RGB stay low during Front Porch, Sync Pulse and Back Porch
-- 1280x1024 @ 60 Hz pixel clock 108 MHz
-- Horizontal Timing
--   Visible Area: 1280  (11.85us)
--   Front Porch:    48  (0.44us)
--   Sync Pulse:    112  (1.037us)
--   Back Porch:    248  (2.296us)
--   Whole Line:   1688  (15.63us)
-- Vertical Timing
--   Visible Area: 1024  (16.00ms)
--   Front Porch:     1  (15.64us)
--   Sync Pulse:      3  (46.89us)
--   Back Porch:     38  (593.9us)
--   Whole Line:   1066  (16.66ms)

-- 1024x768 @ 60 Hz pixel clock 65 MHz
-- Horizontal Timing
--   Visible Area: 1024  (15.75us)
--   Front Porch:    24  (0.369us)
--   Sync Pulse:    136  (2.093us)
--   Back Porch:    160  (2.46us)
--   Whole Line:   1344  (20.68us)
-- Vertical Timing
--   Visible Area:  768  (15.88ms)
--   Front Porch:     3  (62.03us)
--   Sync Pulse:      6  (124.06us)
--   Back Porch:     29  (599.6us)
--   Whole Line:    806  (16.66ms)

-- 1366x768 @ 60 Hz pixel clock 85.5 MHz
-- Horizontal Timing
--   Visible Area: 1366  (15.98us)
--   Front Porch:    70  (0.819us)
--   Sync Pulse:    143  (1.673us)
--   Back Porch:    213  (2.491us)
--   Whole Line:   1792  (20.96us)
-- Vertical Timing
--   Visible Area:  768  (16.097ms)
--   Front Porch:     3  (63.00us)
--   Sync Pulse:      3  (63.00us)
--   Back Porch:     24  (503.0us)
--   Whole Line:    798  (16.72ms)

-- 1920x1080 @ 60 Hz pixel clock 148.5 Mhz
--   Visible Area: 1920  (15.98us)
--   Front Porch:    88  (0.819us)
--   Sync Pulse:     44  (1.673us)
--   Back Porch:    148  (2.491us)
--   Whole Line:   2200  (20.96us)
-- Vertical Timing
--   Visible Area: 1080  (16.097ms)
--   Front Porch:     4  (63.00us)
--   Sync Pulse:      5  (63.00us)
--   Back Porch:     36  (503.0us)
--   Whole Line:   1125  (16.72ms)

    -- Procedure to draw a waveform
    procedure waveplot (
            signal chy    :  in integer range 0 to 2047;                -- y position of the bottom of the graph
            signal hpos   :  in integer range 0 to 4095;                -- current x position
            signal vpos   :  in integer range 0 to 2047;                -- current y position
            variable xloc :  in integer range 0 to depth - 1;           -- position in the channel array
            signal chan   :  in std_logic_vector(depth - 1 downto 0);   -- vector of data to be plotted
            signal draw   : out std_logic                               -- draw or not a pixel at xcur,ycur location
    ) is

    begin

        draw <= '0';
        if (vpos >= chy - 122 and vpos <= chy) then
            -- We are in the graph area for the channel, so we must check the value
            if (vpos = chy - 122 and chan(xloc) = '1') then
                draw <= '1';
            elsif (vpos = chy and chan(xloc) = '0') then
                draw <= '1';
            elsif (xloc > 0 and chan(xloc - 1) /= chan(xloc)) then
                draw <= '1';
            end if;
        end if;

    end waveplot;

    -- hpos and vpos are the current screen coordinates
    -- pixel (0,0) is at the top-left of the screen
    signal hpos: integer range 0 to 4095 := 0;
    signal vpos: integer range 0 to 2047 := 0;
    -- Signal chxy specifies the y coordinate of the bottom of each graph
    signal ch1y: integer range 0 to 2047 := 189;
    signal ch2y: integer range 0 to 2047 := 381;
    signal ch3y: integer range 0 to 2047 := 573;
    signal ch4y: integer range 0 to 2047 := 765;
    signal draw1, draw2, draw3, draw4: std_logic := '0';
    -- Signal to pan the display window over the acquired data
    signal xpan: integer range 0 to depth - 1 := 0;

begin

    process (clk)
        variable xpos, ypos: std_logic_vector(11 downto 0);
        variable xloc : integer range 0 to depth - 1;
        variable xmini: integer range 0 to depth - 1;
    begin

        if (clk'event and clk='1') then

            r <= (others => '0');
            g <= (others => '0');
            b <= (others => '0');

            -- Do anything at every pixel clock here

            if (hpos < nxpixels and vpos < nypixels) then

                -- We are in the display area (no porch, no sync)
                xloc := hpos + xpan;
                xmini := hpos * 16;

                -- Draw a grid
                xpos := std_logic_vector(to_unsigned(hpos, xpos'length)) and "000000111111";
                ypos := std_logic_vector(to_unsigned(vpos, ypos'length)) and "000000111111";
                if (xpos = "000000000000" and ypos = "000000000000") then
                    r <= "01110000";
                    g <= "01110000";
                    b <= "01110000";
                elsif ((xpos(3 downto 0) = "0000" and ypos = "000000000000") or (xpos = "000000000000" and ypos(3 downto 0) = "0000")) then
                    r <= "01000000";
                    g <= "01000000";
                    b <= "01000000";
                end if;

                -- Draw a mini version of the entire acquired data on the top of the screen
                if (xmini < depth and hpos < depth / 16) then
                    if (vpos > 0 and vpos < 60 and xmini > xpan and xmini < xpan + nxpixels) then
                        -- Shade the area that is currently displayed
                        r <= "01000000";
                        g <= "01000000";
                        b <= "01000000";
                    end if;
                    if (vpos =  5 and channel1(xmini) = '1') then
                        r <= (others => '1');
                        g <= (others => '1');
                    end if;
                    if (vpos = 10 and channel1(xmini) = '0') then
                        r <= (others => '1');
                        g <= (others => '1');
                    end if;
                    if (vpos = 20 and channel2(xmini) = '1') then
                        b <= (others => '1');
                    end if;
                    if (vpos = 25 and channel2(xmini) = '0') then
                        b <= (others => '1');
                    end if;
                    if (vpos = 35 and channel3(xmini) = '1') then
                        r <= (others => '1');
                    end if;
                    if (vpos = 40 and channel3(xmini) = '0') then
                        r <= (others => '1');
                    end if;
                    if (vpos = 50 and channel4(xmini) = '1') then
                        g <= (others => '1');
                    end if;
                    if (vpos = 55 and channel4(xmini) = '0') then
                        g <= (others => '1');
                    end if;
                end if;

                -- Draw the waveforms
                waveplot (ch1y, hpos, vpos, xloc, channel1, draw1);
                waveplot (ch2y, hpos, vpos, xloc, channel2, draw2);
                waveplot (ch3y, hpos, vpos, xloc, channel3, draw3);
                waveplot (ch4y, hpos, vpos, xloc, channel4, draw4);

                if (draw1 = '1') then
                    -- channel1 is on, draw in yellow
                    r <= (others => '1');
                    g <= (others => '1');
                end if;

                if (draw2 = '1') then
                    -- channel2 is on, draw in blue
                    b <= (others => '1');
                end if;

                if (draw3 = '1') then
                    -- channel3 is on, draw in red
                    r <= (others => '1');
                end if;

                if (draw4 = '1') then
                    -- channel4 is on, draw in green
                    g <= (others => '1');
                end if;

            end if;

            -- Increment pixel coordinates
            if (hpos < ntotxpixels) then
                hpos <= hpos + 1;
            else
                hpos <= 0;
                if (vpos < ntotypixels) then
                    vpos <= vpos + 1;
                else
                    vpos <= 0; 

                    -- Whatever you want to do during the vertical blank, put it here

                    -- Manage panning keys
                    if (keys(1) = '0' and xpan < depth - nxpixels - 7) then
                        xpan <= xpan + 8;
                    end if;
                    if (keys(2) = '0' and xpan > 7) then
                        xpan <= xpan - 8;
                    end if;

                end if;
            end if;

            if ((hpos >= nxpixels and hpos < ntotxpixels) or (vpos >= nypixels and vpos < ntotypixels)) then
                -- Sync or Porch (colors should be blank)
                r <= (others => '0');
                g <= (others => '0');
                b <= (others => '0');
            end if;
            
            if(hpos >= nxpixels+xfrontporch and hpos < nxpixels+xfrontporch+xsyncpulse) then
                -- Hsync (active low)
                hsync <= '0';
            else
                hsync <= '1';
            end if;

            if (vpos >= nypixels+yfrontporch and vpos < nypixels+yfrontporch+ysyncpulse) then
                -- Vsync (active low)
                vsync <= '0';
            else
                vsync <= '1';
            end if;

        end if;

    end process;
 
 end main;