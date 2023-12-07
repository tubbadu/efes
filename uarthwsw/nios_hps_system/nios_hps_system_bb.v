
module nios_hps_system (
	clk_clk,
	hps_0_ddr_mem_a,
	hps_0_ddr_mem_ba,
	hps_0_ddr_mem_ck,
	hps_0_ddr_mem_ck_n,
	hps_0_ddr_mem_cke,
	hps_0_ddr_mem_cs_n,
	hps_0_ddr_mem_ras_n,
	hps_0_ddr_mem_cas_n,
	hps_0_ddr_mem_we_n,
	hps_0_ddr_mem_reset_n,
	hps_0_ddr_mem_dq,
	hps_0_ddr_mem_dqs,
	hps_0_ddr_mem_dqs_n,
	hps_0_ddr_mem_odt,
	hps_0_ddr_mem_dm,
	hps_0_ddr_oct_rzqin,
	hps_0_h2f_loan_io_in,
	hps_0_h2f_loan_io_out,
	hps_0_h2f_loan_io_oe,
	hps_0_io_hps_io_sdio_inst_CMD,
	hps_0_io_hps_io_sdio_inst_D0,
	hps_0_io_hps_io_sdio_inst_D1,
	hps_0_io_hps_io_sdio_inst_CLK,
	hps_0_io_hps_io_sdio_inst_D2,
	hps_0_io_hps_io_sdio_inst_D3,
	hps_0_io_hps_io_gpio_inst_LOANIO49,
	hps_0_io_hps_io_gpio_inst_LOANIO50,
	hps_0_io_hps_io_gpio_inst_LOANIO55,
	hps_0_io_hps_io_gpio_inst_LOANIO56,
	i2c_peripheral_sda_in,
	i2c_peripheral_scl_in,
	i2c_peripheral_sda_oe,
	i2c_peripheral_scl_oe,
	nios_7seg_export,
	nios_buttons_export,
	nios_header_conn_in_port,
	nios_header_conn_out_port,
	nios_i2cclk_export,
	nios_i2cdat_in_port,
	nios_i2cdat_out_port,
	nios_i2crw_export,
	nios_leds_export,
	nios_switches_export,
	nios_uartrx_export,
	nios_uarttx_export,
	pll_0_sdram_clk,
	reset_reset_n,
	sdram_controller_0_wire_addr,
	sdram_controller_0_wire_ba,
	sdram_controller_0_wire_cas_n,
	sdram_controller_0_wire_cke,
	sdram_controller_0_wire_cs_n,
	sdram_controller_0_wire_dq,
	sdram_controller_0_wire_dqm,
	sdram_controller_0_wire_ras_n,
	sdram_controller_0_wire_we_n,
	spi_peripheral_MISO,
	spi_peripheral_MOSI,
	spi_peripheral_SCLK,
	spi_peripheral_SS_n,
	uart_peripheral_rxd,
	uart_peripheral_txd,
	pll_1_65_clk,
	pll_1_108_clk,
	pll_1_86_clk,
	pll_1_162_clk,
	pll_1_144_clk,
	nios_oscdivisor_export);	

	input		clk_clk;
	output	[14:0]	hps_0_ddr_mem_a;
	output	[2:0]	hps_0_ddr_mem_ba;
	output		hps_0_ddr_mem_ck;
	output		hps_0_ddr_mem_ck_n;
	output		hps_0_ddr_mem_cke;
	output		hps_0_ddr_mem_cs_n;
	output		hps_0_ddr_mem_ras_n;
	output		hps_0_ddr_mem_cas_n;
	output		hps_0_ddr_mem_we_n;
	output		hps_0_ddr_mem_reset_n;
	inout	[31:0]	hps_0_ddr_mem_dq;
	inout	[3:0]	hps_0_ddr_mem_dqs;
	inout	[3:0]	hps_0_ddr_mem_dqs_n;
	output		hps_0_ddr_mem_odt;
	output	[3:0]	hps_0_ddr_mem_dm;
	input		hps_0_ddr_oct_rzqin;
	output	[66:0]	hps_0_h2f_loan_io_in;
	input	[66:0]	hps_0_h2f_loan_io_out;
	input	[66:0]	hps_0_h2f_loan_io_oe;
	inout		hps_0_io_hps_io_sdio_inst_CMD;
	inout		hps_0_io_hps_io_sdio_inst_D0;
	inout		hps_0_io_hps_io_sdio_inst_D1;
	output		hps_0_io_hps_io_sdio_inst_CLK;
	inout		hps_0_io_hps_io_sdio_inst_D2;
	inout		hps_0_io_hps_io_sdio_inst_D3;
	inout		hps_0_io_hps_io_gpio_inst_LOANIO49;
	inout		hps_0_io_hps_io_gpio_inst_LOANIO50;
	inout		hps_0_io_hps_io_gpio_inst_LOANIO55;
	inout		hps_0_io_hps_io_gpio_inst_LOANIO56;
	input		i2c_peripheral_sda_in;
	input		i2c_peripheral_scl_in;
	output		i2c_peripheral_sda_oe;
	output		i2c_peripheral_scl_oe;
	output	[23:0]	nios_7seg_export;
	input	[3:0]	nios_buttons_export;
	input	[31:0]	nios_header_conn_in_port;
	output	[31:0]	nios_header_conn_out_port;
	output		nios_i2cclk_export;
	input		nios_i2cdat_in_port;
	output		nios_i2cdat_out_port;
	output		nios_i2crw_export;
	output	[9:0]	nios_leds_export;
	input	[9:0]	nios_switches_export;
	input		nios_uartrx_export;
	output		nios_uarttx_export;
	output		pll_0_sdram_clk;
	input		reset_reset_n;
	output	[12:0]	sdram_controller_0_wire_addr;
	output	[1:0]	sdram_controller_0_wire_ba;
	output		sdram_controller_0_wire_cas_n;
	output		sdram_controller_0_wire_cke;
	output		sdram_controller_0_wire_cs_n;
	inout	[15:0]	sdram_controller_0_wire_dq;
	output	[1:0]	sdram_controller_0_wire_dqm;
	output		sdram_controller_0_wire_ras_n;
	output		sdram_controller_0_wire_we_n;
	input		spi_peripheral_MISO;
	output		spi_peripheral_MOSI;
	output		spi_peripheral_SCLK;
	output		spi_peripheral_SS_n;
	input		uart_peripheral_rxd;
	output		uart_peripheral_txd;
	output		pll_1_65_clk;
	output		pll_1_108_clk;
	output		pll_1_86_clk;
	output		pll_1_162_clk;
	output		pll_1_144_clk;
	output	[15:0]	nios_oscdivisor_export;
endmodule
