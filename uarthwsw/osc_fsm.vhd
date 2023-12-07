library ieee;
use ieee.std_logic_1164.all;

entity osc_fsm is
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
end entity osc_fsm;

architecture rtl of osc_fsm is
    type osc_state_type is (OSC_INIT, OSC_WAITTRIGGER, OSC_START, OSC_STOP, OSC_SINGLE);
    signal osc_cur_state, osc_next_state: osc_state_type;

begin

    process (clk, reset)
    begin
        if (reset = '1') then
            osc_cur_state <= OSC_INIT;
        elsif (rising_edge(clk)) then
            osc_cur_state <= osc_next_state;
        else
            null;
        end if;
    end process;

    process (osc_cur_state, trigsrc1, trigsrc2, tcount, keysingle)
    begin
        -- Default is remain in current state
        osc_next_state <= osc_cur_state;

        case osc_cur_state is

            when OSC_INIT =>
                leds <= "00001";
                -- Set output
                sampleenable <= '1';
                countclear <= '1';
                -- Set next state
                if (trigsrc1 = '1' and trigsrc2 = '1') then
                    osc_next_state <= OSC_WAITTRIGGER;
                end if;

            when OSC_WAITTRIGGER =>
                leds <= "00010";
                -- Set output
                sampleenable <= '1';
                countclear <= '1';
                -- Set next state
                if (trigsrc1 = '0' or trigsrc2 = '0') then
                    osc_next_state <= OSC_START;
                end if;

            when OSC_START =>
                leds <= "00100";
                -- Set output
                sampleenable <= '1';
                countclear <= '0';
                -- Set next state
                if (tcount = '1') then
                    osc_next_state <= OSC_STOP;
                end if;

            when OSC_STOP =>
                leds <= "01000";
                -- Set output
                sampleenable <= '0';
                countclear <= '1';
                -- Set next state
                if (keysingle = '0') then
                    osc_next_state <= OSC_SINGLE;
                end if;

            when OSC_SINGLE =>
                leds <= "10000";
                -- Set output
                sampleenable <= '0';
                countclear <= '1';
                -- Set next state
                if (keysingle = '1') then
                    osc_next_state <= OSC_INIT;
                end if;

        end case;

    end process;

end architecture rtl;
