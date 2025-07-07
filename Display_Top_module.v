`timescale 1ns / 1ps

module Display_Top_module(
        input clk,
        input reset,
        input start_d,
        input [7:0] C_11_2x2, C_12_2x2, C_21_2x2, C_22_2x2,C_11_3x3,C_12_3x3,C_21_3x3,C_22_3x3,
        output [7:0] LED_out,
        output [7:0] Anode_activate
    );
    wire [7:0] convolution;
    disp_show_module disp_show (.clk(clk), .reset(reset),.convolution(convolution), .digit(Anode_activate), .seg_data(LED_out));
    
    disp_cont_module disp_control (.clk(clk), .reset(reset), .start_d(start_d), .num_A(C_11_2x2), .num_B(C_12_2x2), .num_C(C_21_2x2), .num_D(C_22_2x2), .num_E(C_11_3x3), .num_F(C_12_3x3), .num_G(C_21_3x3), .num_H(C_22_3x3), .convolution(convolution));
endmodule
