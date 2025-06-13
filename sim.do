if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

vlog -work work FPU.sv
vlog -work work tb_FPU.sv

vsim -voptargs=+acc work.tb_FPU

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run 25ms