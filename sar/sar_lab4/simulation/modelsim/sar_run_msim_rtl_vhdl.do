transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {E:/intelFPGA_lite/projects_DE1-SoC/sar_lab4/udcnt8.vhd}
vcom -93 -work work {E:/intelFPGA_lite/projects_DE1-SoC/sar_lab4/nbit_sr.vhd}
vcom -93 -work work {E:/intelFPGA_lite/projects_DE1-SoC/sar_lab4/nbit_reg.vhd}
vcom -93 -work work {E:/intelFPGA_lite/projects_DE1-SoC/sar_lab4/hexdisp7seg.vhd}
vcom -93 -work work {E:/intelFPGA_lite/projects_DE1-SoC/sar_lab4/sarfsm.vhd}
vcom -93 -work work {E:/intelFPGA_lite/projects_DE1-SoC/sar_lab4/sar.vhd}
vcom -93 -work work {E:/intelFPGA_lite/projects_DE1-SoC/sar_lab4/datapath.vhd}
vcom -93 -work work {E:/intelFPGA_lite/projects_DE1-SoC/sar_lab4/counter4.vhd}
vcom -93 -work work {E:/intelFPGA_lite/projects_DE1-SoC/sar_lab4/nbit_cnt.vhd}

vcom -93 -work work {E:/intelFPGA_lite/projects_DE1-SoC/sar_lab4/testbench.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 10 us