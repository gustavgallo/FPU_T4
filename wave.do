onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label reset /tb_FPU/reset
add wave -noupdate -color Red -label {clock 100khz} /tb_FPU/clock_100KHZ
add wave -noupdate -label op_A_in -radix hex /tb_FPU/op_A_in
add wave -noupdate -label op_B_in -radix hex /tb_FPU/op_B_in
add wave -noupdate -label data_out -radix hex /tb_FPU/data_out
add wave -noupdate -label status_out -radix binary /tb_FPU/status_out
add wave -noupdate -label EA -radix symbolic /tb_FPU/dut/EA
add wave -noupdate -label mant_a_full /tb_FPU/dut/mant_a_full
add wave -noupdate -label mant_b_full /tb_FPU/dut/mant_b_full
add wave -noupdate -label mant_a /tb_FPU/dut/mant_a
add wave -noupdate -label mant_b /tb_FPU/dut/mant_b
add wave -noupdate -label mant_a_aligned /tb_FPU/dut/mant_a_aligned
add wave -noupdate -label mant_b_aligned /tb_FPU/dut/mant_b_aligned
add wave -noupdate -label mant_res /tb_FPU/dut/mant_res
add wave -noupdate -label exp_diff /tb_FPU/dut/exp_diff
add wave -noupdate -label exp_res /tb_FPU/dut/exp_res
add wave -noupdate -label exp_a /tb_FPU/dut/exp_a
add wave -noupdate -label exp_b /tb_FPU/dut/exp_b

add wave -noupdate -label sign_res /tb_FPU/dut/sign_res




TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6347200 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
