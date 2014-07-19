vsim -novopt work.tb_op_divisor

add wave  -hex sim:/tb_op_divisor/divisor/clk
add wave  -hex sim:/tb_op_divisor/divisor/rst


add wave -r -unsigned sim:/tb_op_divisor/divisor/s_in_valid
add wave -r -unsigned sim:/tb_op_divisor/divisor/s_out_valid
add wave -r -unsigned sim:/tb_op_divisor/divisor/dividend
add wave -r -unsigned sim:/tb_op_divisor/divisor/divisor 

add wave -r -unsigned sim:/tb_op_divisor/divisor/remain
add wave -r -unsigned sim:/tb_op_divisor/divisor/quotient

add wave  -unsigned sim:/tb_op_divisor/divisor/s_q00
add wave  -unsigned sim:/tb_op_divisor/divisor/s_q01
add wave  -unsigned sim:/tb_op_divisor/divisor/s_q02
add wave  -unsigned sim:/tb_op_divisor/divisor/s_q03
add wave  -unsigned sim:/tb_op_divisor/divisor/s_q04
add wave  -unsigned sim:/tb_op_divisor/divisor/s_q05
add wave  -unsigned sim:/tb_op_divisor/divisor/s_q06
add wave  -unsigned sim:/tb_op_divisor/divisor/s_q07
add wave  -unsigned sim:/tb_op_divisor/divisor/s_q08
add wave  -unsigned sim:/tb_op_divisor/divisor/s_q09

add wave  -unsigned sim:/tb_op_divisor/divisor/s_d00
add wave  -unsigned sim:/tb_op_divisor/divisor/s_d01
add wave  -unsigned sim:/tb_op_divisor/divisor/s_d02
add wave  -unsigned sim:/tb_op_divisor/divisor/s_d03
add wave  -unsigned sim:/tb_op_divisor/divisor/s_d04
add wave  -unsigned sim:/tb_op_divisor/divisor/s_d05
add wave  -unsigned sim:/tb_op_divisor/divisor/s_d06
add wave  -unsigned sim:/tb_op_divisor/divisor/s_d07
add wave  -unsigned sim:/tb_op_divisor/divisor/s_d08
add wave  -unsigned sim:/tb_op_divisor/divisor/s_d09
   
add wave  -unsigned sim:/tb_op_divisor/divisor/s_r00
add wave  -unsigned sim:/tb_op_divisor/divisor/s_r01
add wave  -unsigned sim:/tb_op_divisor/divisor/s_r02
add wave  -unsigned sim:/tb_op_divisor/divisor/s_r03
add wave  -unsigned sim:/tb_op_divisor/divisor/s_r04
add wave  -unsigned sim:/tb_op_divisor/divisor/s_r05
add wave  -unsigned sim:/tb_op_divisor/divisor/s_r06
add wave  -unsigned sim:/tb_op_divisor/divisor/s_r07
add wave  -unsigned sim:/tb_op_divisor/divisor/s_r08
add wave  -unsigned sim:/tb_op_divisor/divisor/s_r09


add wave -position 8 -unsigned sim:/tb_op_divisor/divisor/s_subfix
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_1_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_2_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_3_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_4_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_5_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_6_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_7_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_8_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_9_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_10_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_11_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_12_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_13_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_14_16
add wave -position 9 -unsigned sim:/tb_op_divisor/divisor/s_cmp_15_16
--
--add wave -r -hex /*

run 100000ns