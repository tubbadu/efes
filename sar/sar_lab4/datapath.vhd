library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
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
end datapath;

architecture rtl of datapath is

    component nbit_sr is
        generic (
            NBIT: integer range 0 to 32 := 8
        );
        port (
            clock   :  in std_logic;
            resetn  :  in std_logic;
            init    :  in std_logic;
            enable  :  in std_logic;
            data    : out std_logic_vector(NBIT-1 downto 0)
        );
    end component nbit_sr;

    component nbit_reg is
        generic (
            NBIT: integer range 0 to 32
        );
        port (
            clock   :  in std_logic;
            resetn  :  in std_logic;
            clear   :  in std_logic;
            enable  :  in std_logic;
            datain  :  in std_logic_vector(NBIT-1 downto 0);
            dataout : out std_logic_vector(NBIT-1 downto 0)
        );
    end component nbit_reg;

    component counter4 is
        port (
            clock   :  in std_logic;
            resetn  :  in std_logic;
            init    :  in std_logic;
            enable  :  in std_logic;
            end_val :  in std_logic_vector(3 downto 0);
            tc      : out std_logic
        );
    end component counter4;

    signal sar_n: std_logic_vector(NBIT_tot-1 downto 0);
    signal data_n: std_logic_vector(NBIT_tot-1 downto 0);
    signal thr_n: std_logic_vector(NBIT_tot-1 downto 0);
    signal comp_n: std_logic_vector(NBIT_tot-1 downto 0);
    signal iter_n: std_logic_vector(NBIT_tot-1 downto 0);
    signal final_n: std_logic_vector(NBIT_tot-1 downto 0);
    signal final_init: std_logic;

begin

    final_init <= '0';

    shiftreg8: nbit_sr  generic map (NBIT_tot) port map (clock, resetn, init, shift_enable, sar_n);
    datareg8:  nbit_reg generic map (NBIT_tot) port map (clock, resetn, init, reg_enable, iter_n, data_n);
    finalreg8: nbit_reg generic map (NBIT_tot)  port map (clock, resetn, final_init, final_enable, final_n, digital_n);
    cnt4: counter4 port map (clock, resetn, init, count_enable, nbit, tc);

    thr_n <= sar_n or data_n;
    gen: for i in 0 to NBIT_tot-1 generate
        comp_n(i) <= sar_n(i) and comp;
    end generate;
    iter_n <= data_n or comp_n;
    dacout <= thr_n;
    final_n <= data_n;

end rtl;