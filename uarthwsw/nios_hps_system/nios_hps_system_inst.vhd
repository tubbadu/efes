	component nios_hps_system is
		port (
			clk_clk                            : in    std_logic                     := 'X';             -- clk
			hps_0_ddr_mem_a                    : out   std_logic_vector(14 downto 0);                    -- mem_a
			hps_0_ddr_mem_ba                   : out   std_logic_vector(2 downto 0);                     -- mem_ba
			hps_0_ddr_mem_ck                   : out   std_logic;                                        -- mem_ck
			hps_0_ddr_mem_ck_n                 : out   std_logic;                                        -- mem_ck_n
			hps_0_ddr_mem_cke                  : out   std_logic;                                        -- mem_cke
			hps_0_ddr_mem_cs_n                 : out   std_logic;                                        -- mem_cs_n
			hps_0_ddr_mem_ras_n                : out   std_logic;                                        -- mem_ras_n
			hps_0_ddr_mem_cas_n                : out   std_logic;                                        -- mem_cas_n
			hps_0_ddr_mem_we_n                 : out   std_logic;                                        -- mem_we_n
			hps_0_ddr_mem_reset_n              : out   std_logic;                                        -- mem_reset_n
			hps_0_ddr_mem_dq                   : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			hps_0_ddr_mem_dqs                  : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			hps_0_ddr_mem_dqs_n                : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			hps_0_ddr_mem_odt                  : out   std_logic;                                        -- mem_odt
			hps_0_ddr_mem_dm                   : out   std_logic_vector(3 downto 0);                     -- mem_dm
			hps_0_ddr_oct_rzqin                : in    std_logic                     := 'X';             -- oct_rzqin
			hps_0_h2f_loan_io_in               : out   std_logic_vector(66 downto 0);                    -- in
			hps_0_h2f_loan_io_out              : in    std_logic_vector(66 downto 0) := (others => 'X'); -- out
			hps_0_h2f_loan_io_oe               : in    std_logic_vector(66 downto 0) := (others => 'X'); -- oe
			hps_0_io_hps_io_sdio_inst_CMD      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_0_io_hps_io_sdio_inst_D0       : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_0_io_hps_io_sdio_inst_D1       : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_0_io_hps_io_sdio_inst_CLK      : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_0_io_hps_io_sdio_inst_D2       : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_0_io_hps_io_sdio_inst_D3       : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_0_io_hps_io_gpio_inst_LOANIO49 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO49
			hps_0_io_hps_io_gpio_inst_LOANIO50 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO50
			hps_0_io_hps_io_gpio_inst_LOANIO55 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO55
			hps_0_io_hps_io_gpio_inst_LOANIO56 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO56
			i2c_peripheral_sda_in              : in    std_logic                     := 'X';             -- sda_in
			i2c_peripheral_scl_in              : in    std_logic                     := 'X';             -- scl_in
			i2c_peripheral_sda_oe              : out   std_logic;                                        -- sda_oe
			i2c_peripheral_scl_oe              : out   std_logic;                                        -- scl_oe
			nios_7seg_export                   : out   std_logic_vector(23 downto 0);                    -- export
			nios_buttons_export                : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			nios_header_conn_in_port           : in    std_logic_vector(31 downto 0) := (others => 'X'); -- in_port
			nios_header_conn_out_port          : out   std_logic_vector(31 downto 0);                    -- out_port
			nios_i2cclk_export                 : out   std_logic;                                        -- export
			nios_i2cdat_in_port                : in    std_logic                     := 'X';             -- in_port
			nios_i2cdat_out_port               : out   std_logic;                                        -- out_port
			nios_i2crw_export                  : out   std_logic;                                        -- export
			nios_leds_export                   : out   std_logic_vector(9 downto 0);                     -- export
			nios_switches_export               : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			nios_uartrx_export                 : in    std_logic                     := 'X';             -- export
			nios_uarttx_export                 : out   std_logic;                                        -- export
			pll_0_sdram_clk                    : out   std_logic;                                        -- clk
			reset_reset_n                      : in    std_logic                     := 'X';             -- reset_n
			sdram_controller_0_wire_addr       : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_controller_0_wire_ba         : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_controller_0_wire_cas_n      : out   std_logic;                                        -- cas_n
			sdram_controller_0_wire_cke        : out   std_logic;                                        -- cke
			sdram_controller_0_wire_cs_n       : out   std_logic;                                        -- cs_n
			sdram_controller_0_wire_dq         : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_controller_0_wire_dqm        : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_controller_0_wire_ras_n      : out   std_logic;                                        -- ras_n
			sdram_controller_0_wire_we_n       : out   std_logic;                                        -- we_n
			spi_peripheral_MISO                : in    std_logic                     := 'X';             -- MISO
			spi_peripheral_MOSI                : out   std_logic;                                        -- MOSI
			spi_peripheral_SCLK                : out   std_logic;                                        -- SCLK
			spi_peripheral_SS_n                : out   std_logic;                                        -- SS_n
			uart_peripheral_rxd                : in    std_logic                     := 'X';             -- rxd
			uart_peripheral_txd                : out   std_logic;                                        -- txd
			pll_1_65_clk                       : out   std_logic;                                        -- clk
			pll_1_108_clk                      : out   std_logic;                                        -- clk
			pll_1_86_clk                       : out   std_logic;                                        -- clk
			pll_1_162_clk                      : out   std_logic;                                        -- clk
			pll_1_144_clk                      : out   std_logic;                                        -- clk
			nios_oscdivisor_export             : out   std_logic_vector(15 downto 0)                     -- export
		);
	end component nios_hps_system;

	u0 : component nios_hps_system
		port map (
			clk_clk                            => CONNECTED_TO_clk_clk,                            --                     clk.clk
			hps_0_ddr_mem_a                    => CONNECTED_TO_hps_0_ddr_mem_a,                    --               hps_0_ddr.mem_a
			hps_0_ddr_mem_ba                   => CONNECTED_TO_hps_0_ddr_mem_ba,                   --                        .mem_ba
			hps_0_ddr_mem_ck                   => CONNECTED_TO_hps_0_ddr_mem_ck,                   --                        .mem_ck
			hps_0_ddr_mem_ck_n                 => CONNECTED_TO_hps_0_ddr_mem_ck_n,                 --                        .mem_ck_n
			hps_0_ddr_mem_cke                  => CONNECTED_TO_hps_0_ddr_mem_cke,                  --                        .mem_cke
			hps_0_ddr_mem_cs_n                 => CONNECTED_TO_hps_0_ddr_mem_cs_n,                 --                        .mem_cs_n
			hps_0_ddr_mem_ras_n                => CONNECTED_TO_hps_0_ddr_mem_ras_n,                --                        .mem_ras_n
			hps_0_ddr_mem_cas_n                => CONNECTED_TO_hps_0_ddr_mem_cas_n,                --                        .mem_cas_n
			hps_0_ddr_mem_we_n                 => CONNECTED_TO_hps_0_ddr_mem_we_n,                 --                        .mem_we_n
			hps_0_ddr_mem_reset_n              => CONNECTED_TO_hps_0_ddr_mem_reset_n,              --                        .mem_reset_n
			hps_0_ddr_mem_dq                   => CONNECTED_TO_hps_0_ddr_mem_dq,                   --                        .mem_dq
			hps_0_ddr_mem_dqs                  => CONNECTED_TO_hps_0_ddr_mem_dqs,                  --                        .mem_dqs
			hps_0_ddr_mem_dqs_n                => CONNECTED_TO_hps_0_ddr_mem_dqs_n,                --                        .mem_dqs_n
			hps_0_ddr_mem_odt                  => CONNECTED_TO_hps_0_ddr_mem_odt,                  --                        .mem_odt
			hps_0_ddr_mem_dm                   => CONNECTED_TO_hps_0_ddr_mem_dm,                   --                        .mem_dm
			hps_0_ddr_oct_rzqin                => CONNECTED_TO_hps_0_ddr_oct_rzqin,                --                        .oct_rzqin
			hps_0_h2f_loan_io_in               => CONNECTED_TO_hps_0_h2f_loan_io_in,               --       hps_0_h2f_loan_io.in
			hps_0_h2f_loan_io_out              => CONNECTED_TO_hps_0_h2f_loan_io_out,              --                        .out
			hps_0_h2f_loan_io_oe               => CONNECTED_TO_hps_0_h2f_loan_io_oe,               --                        .oe
			hps_0_io_hps_io_sdio_inst_CMD      => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_CMD,      --                hps_0_io.hps_io_sdio_inst_CMD
			hps_0_io_hps_io_sdio_inst_D0       => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_D0,       --                        .hps_io_sdio_inst_D0
			hps_0_io_hps_io_sdio_inst_D1       => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_D1,       --                        .hps_io_sdio_inst_D1
			hps_0_io_hps_io_sdio_inst_CLK      => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_CLK,      --                        .hps_io_sdio_inst_CLK
			hps_0_io_hps_io_sdio_inst_D2       => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_D2,       --                        .hps_io_sdio_inst_D2
			hps_0_io_hps_io_sdio_inst_D3       => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_D3,       --                        .hps_io_sdio_inst_D3
			hps_0_io_hps_io_gpio_inst_LOANIO49 => CONNECTED_TO_hps_0_io_hps_io_gpio_inst_LOANIO49, --                        .hps_io_gpio_inst_LOANIO49
			hps_0_io_hps_io_gpio_inst_LOANIO50 => CONNECTED_TO_hps_0_io_hps_io_gpio_inst_LOANIO50, --                        .hps_io_gpio_inst_LOANIO50
			hps_0_io_hps_io_gpio_inst_LOANIO55 => CONNECTED_TO_hps_0_io_hps_io_gpio_inst_LOANIO55, --                        .hps_io_gpio_inst_LOANIO55
			hps_0_io_hps_io_gpio_inst_LOANIO56 => CONNECTED_TO_hps_0_io_hps_io_gpio_inst_LOANIO56, --                        .hps_io_gpio_inst_LOANIO56
			i2c_peripheral_sda_in              => CONNECTED_TO_i2c_peripheral_sda_in,              --          i2c_peripheral.sda_in
			i2c_peripheral_scl_in              => CONNECTED_TO_i2c_peripheral_scl_in,              --                        .scl_in
			i2c_peripheral_sda_oe              => CONNECTED_TO_i2c_peripheral_sda_oe,              --                        .sda_oe
			i2c_peripheral_scl_oe              => CONNECTED_TO_i2c_peripheral_scl_oe,              --                        .scl_oe
			nios_7seg_export                   => CONNECTED_TO_nios_7seg_export,                   --               nios_7seg.export
			nios_buttons_export                => CONNECTED_TO_nios_buttons_export,                --            nios_buttons.export
			nios_header_conn_in_port           => CONNECTED_TO_nios_header_conn_in_port,           --        nios_header_conn.in_port
			nios_header_conn_out_port          => CONNECTED_TO_nios_header_conn_out_port,          --                        .out_port
			nios_i2cclk_export                 => CONNECTED_TO_nios_i2cclk_export,                 --             nios_i2cclk.export
			nios_i2cdat_in_port                => CONNECTED_TO_nios_i2cdat_in_port,                --             nios_i2cdat.in_port
			nios_i2cdat_out_port               => CONNECTED_TO_nios_i2cdat_out_port,               --                        .out_port
			nios_i2crw_export                  => CONNECTED_TO_nios_i2crw_export,                  --              nios_i2crw.export
			nios_leds_export                   => CONNECTED_TO_nios_leds_export,                   --               nios_leds.export
			nios_switches_export               => CONNECTED_TO_nios_switches_export,               --           nios_switches.export
			nios_uartrx_export                 => CONNECTED_TO_nios_uartrx_export,                 --             nios_uartrx.export
			nios_uarttx_export                 => CONNECTED_TO_nios_uarttx_export,                 --             nios_uarttx.export
			pll_0_sdram_clk                    => CONNECTED_TO_pll_0_sdram_clk,                    --             pll_0_sdram.clk
			reset_reset_n                      => CONNECTED_TO_reset_reset_n,                      --                   reset.reset_n
			sdram_controller_0_wire_addr       => CONNECTED_TO_sdram_controller_0_wire_addr,       -- sdram_controller_0_wire.addr
			sdram_controller_0_wire_ba         => CONNECTED_TO_sdram_controller_0_wire_ba,         --                        .ba
			sdram_controller_0_wire_cas_n      => CONNECTED_TO_sdram_controller_0_wire_cas_n,      --                        .cas_n
			sdram_controller_0_wire_cke        => CONNECTED_TO_sdram_controller_0_wire_cke,        --                        .cke
			sdram_controller_0_wire_cs_n       => CONNECTED_TO_sdram_controller_0_wire_cs_n,       --                        .cs_n
			sdram_controller_0_wire_dq         => CONNECTED_TO_sdram_controller_0_wire_dq,         --                        .dq
			sdram_controller_0_wire_dqm        => CONNECTED_TO_sdram_controller_0_wire_dqm,        --                        .dqm
			sdram_controller_0_wire_ras_n      => CONNECTED_TO_sdram_controller_0_wire_ras_n,      --                        .ras_n
			sdram_controller_0_wire_we_n       => CONNECTED_TO_sdram_controller_0_wire_we_n,       --                        .we_n
			spi_peripheral_MISO                => CONNECTED_TO_spi_peripheral_MISO,                --          spi_peripheral.MISO
			spi_peripheral_MOSI                => CONNECTED_TO_spi_peripheral_MOSI,                --                        .MOSI
			spi_peripheral_SCLK                => CONNECTED_TO_spi_peripheral_SCLK,                --                        .SCLK
			spi_peripheral_SS_n                => CONNECTED_TO_spi_peripheral_SS_n,                --                        .SS_n
			uart_peripheral_rxd                => CONNECTED_TO_uart_peripheral_rxd,                --         uart_peripheral.rxd
			uart_peripheral_txd                => CONNECTED_TO_uart_peripheral_txd,                --                        .txd
			pll_1_65_clk                       => CONNECTED_TO_pll_1_65_clk,                       --                pll_1_65.clk
			pll_1_108_clk                      => CONNECTED_TO_pll_1_108_clk,                      --               pll_1_108.clk
			pll_1_86_clk                       => CONNECTED_TO_pll_1_86_clk,                       --                pll_1_86.clk
			pll_1_162_clk                      => CONNECTED_TO_pll_1_162_clk,                      --               pll_1_162.clk
			pll_1_144_clk                      => CONNECTED_TO_pll_1_144_clk,                      --               pll_1_144.clk
			nios_oscdivisor_export             => CONNECTED_TO_nios_oscdivisor_export              --         nios_oscdivisor.export
		);

