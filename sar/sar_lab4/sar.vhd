library ieee;
use ieee.std_logic_1164.all;

entity sar is
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
end entity sar;

architecture struct of sar is

    component datapath is
        generic (
            NBIT_tot: integer range 0 to 32 := 8
        );
        port (
            clock           :  in std_logic;
            resetn          :  in std_logic;
            init            :  in std_logic;
            shift_enable    :  in std_logic;
            reg_enable      :  in std_logic;
            final_enable    :  in std_logic;
            count_enable    :  in std_logic;
            comp            :  in std_logic;
            nbit            :  in std_logic_vector(3 downto 0);
            tc              : out std_logic;
            dacout          : out std_logic_vector(NBIT_tot-1 downto 0);
            digital_n       : out std_logic_vector(NBIT_tot-1 downto 0)
        );
    end component datapath;

    component sarfsm is
        port (
            clock           :  in std_logic;
            resetn          :  in std_logic;
            run             :  in std_logic;
            tc              :  in std_logic;
            init            : out std_logic;
            shift_enable    : out std_logic;
            reg_enable      : out std_logic;
            final_enable    : out std_logic;
            count_enable    : out std_logic
        );	
    end component sarfsm;

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

    --component counter12 is
    --    port (
    --        clock   :  in std_logic;
    --        resetn  :  in std_logic;
    --        init    :  in std_logic;
    --        enable  :  in std_logic;
    --        end_val :  in std_logic_vector(7 downto 0);
    --        tc      : out std_logic
    --    );
    --end component counter12;

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

    component udcnt8 is
        port (
            clock   :  in std_logic;
            resetn  :  in std_logic;
            clear   :  in std_logic;
            enable  :  in std_logic;
            dout    : out std_logic_vector(7 downto 0)
        );
    end component udcnt8;

    component hexdisp7seg is
        port (
            datain: in std_logic_vector(3 downto 0);
            seg7:  out std_logic_vector(6 downto 0)
        );
    end component hexdisp7seg;

    signal init, shift_enable, reg_enable, final_enable, count_enable, tc: std_logic;
    signal slowclock: std_logic;
    --signal clkdiv_cnt_enable: std_logic;
    signal tadcout: std_logic_vector(7 downto 0);    -- the final converted value
    signal resetn: std_logic;
    signal run: std_logic;
    signal regs_clear: std_logic;
    signal bluein: std_logic_vector(7 downto 0);
    signal clkdiv_reg_enable: std_logic;
    signal clkdivisor: std_logic_vector(11 downto 0);
    signal clkdivout: std_logic_vector(11 downto 0);
    signal clkdivud_reg_enable: std_logic;
    signal clkdivisorud: std_logic_vector(7 downto 0);
    signal slowclockud: std_logic;
    signal sar_nbit: std_logic_vector(3 downto 0);
    signal sar_nbit_reg_enable: std_logic;
    signal comp: std_logic;
    signal guess: std_logic_vector(7 downto 0);
    signal ud8out: std_logic_vector(7 downto 0);
    signal mask: std_logic_vector(7 downto 0);


begin

    resetn <= KEY_N(0);
    run <= SW(9);
    bluein <= SW(7 downto 0);
    GPIO_0(1) <= 'Z';

    VGA_SYNC_N <= '0';
    VGA_BLANK_N <= '1';
    VGA_CLK <= CLOCK_50;

    regs_clear <= '0';
    -- KEY1 used to store the value of the clock divisor in a register
    clkdiv_reg_enable <= not KEY_N(1);
    clkdivisor(3 downto  0) <= "0000";
    clkdiv_reg: nbit_reg generic map (8) port map (CLOCK_50, resetn, regs_clear, clkdiv_reg_enable, SW(7 downto 0), clkdivisor(11 downto 4));
    -- KEY2 used to store the value of the number of bits for the conversion in a register
    sar_nbit_reg_enable <= not KEY_N(2);
    sar_nbit_reg: nbit_reg generic map (4) port map (CLOCK_50, resetn, regs_clear, sar_nbit_reg_enable, SW(3 downto 0), sar_nbit);
    -- KEY3 used to store the value of the clock divisor for the triangular wave in a register
    --clkdivud_reg_enable <= not KEY_N(3);
    --clkdivud_reg: nbit_reg generic map (8) port map (CLOCK_50, resetn, regs_clear, clkdivud_reg_enable, SW(7 downto 0), clkdivisorud);

    -- Divisor to generate the clock of the SAR. f_sarclk = 50000000 / (clkdivisor*16 + 1)
    --clkdiv_cnt_enable <= '1';
    --clkdiv: counter12 port map (CLOCK_50, resetn, regs_clear, clkdiv_cnt_enable, clkdivisor, slowclock);
    clkdiv: nbit_cnt generic map (12) port map (CLOCK_50, resetn, '0', '1', clkdivisor, clkdivout, slowclock);
    -- Divisor to generate the clock of the triangular wave generator. f_sarclk = 50000000 / (clkdivisor*16 + 1)
    --clkdivud: counter12 port map (CLOCK_50, resetn, regs_clear, clkdiv_cnt_enable, clkdivisorud, slowclockud);

    -- Show the slow clock on GPIO_0(0) and on LEDR9. The slow clock is a pulse, with a very low duty cycle, not 50%
    GPIO_0(0) <= slowclock;
    LEDR(9) <= slowclock;
    comp <= GPIO_0(1);

    dp: datapath generic map (8) port map (slowclock, resetn, init, shift_enable, reg_enable, final_enable, count_enable, comp, sar_nbit, tc, guess, tadcout);
    fsm: sarfsm port map (slowclock, resetn, run, tc, init, shift_enable, reg_enable, final_enable, count_enable);

    -- This mask is used to make sure that the LSBs of the red channel are set to 0 when not used.
    -- This is especially needed because otherwise the first unused bit is set to 1 at the end of a conversion
    -- so the red channel appears higher than the correct value
    with sar_nbit select
        mask <= "11000000" when "0000",
                "11100000" when "0001",
                "11110000" when "0010",
                "11111000" when "0011",
                "11111100" when "0100",
                "11111110" when "0101",
                "11111111" when "0110",
                "11111111" when others;

    -- Show the final output value on the LEDs and on the green channel
    -- Show the intermediate guess on the the red channel, which should go to the comparator
    LEDR(7 downto 0) <= tadcout;
    VGA_G <= tadcout;
    VGA_R <= guess and mask;
    GPIO_0(2) <= final_enable;

    -- The 8 bit up/down counter generates a triangular waveform that can be sent to the blue channel using SW8
    ud0: udcnt8 port map (slowclock, resetn, '0', final_enable, ud8out);

    -- The blue channel can be used to generate a constant value, set using the switches, when SW8='0'
    -- Otherwise it is the output of the up/down counter when SW8='1'
    -- You may want to use a signal generator for a variable input instead of the blue channel
    with SW(8) select
    VGA_B <= bluein when '0',
             ud8out when '1',
             bluein when others;

    -- Right HEX displays are the final conversion
    hd0: hexdisp7seg port map (tadcout(3 downto 0), HEX0_N);
    hd1: hexdisp7seg port map (tadcout(7 downto 4), HEX1_N);
    -- Middle HEX displays show the clock divisor
    hd2: hexdisp7seg port map (clkdivisor(7 downto 4), HEX2_N);
    hd3: hexdisp7seg port map (clkdivisor(11 downto 8), HEX3_N);
    -- Left HEX displays show the number of bit of the conversion
    hd4: hexdisp7seg port map (sar_nbit, HEX4_N);
    hd5: hexdisp7seg port map ("0000", HEX5_N);

end struct;
