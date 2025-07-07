`timescale 1ns / 1ps

module disp_show_module(
        input clk,
        input reset,
        input [7:0] convolution,
        output [7:0] digit,
        output [7:0] seg_data
);
        wire [3:0] out_100,out_10,out_1;
        Binary_to_BCD Binary_to_BCD (.Bin(convolution), .out_3(out_100), .out_2(out_10), .out_1(out_1));
        
        wire [7:0] seg_100,seg_10,seg_1;
        BCD_to_7seg out_Hundred (.in(out_100) ,.seg_data(seg_100));
        BCD_to_7seg out_ten (.in(out_10) ,.seg_data(seg_10));
        BCD_to_7seg out_one (.in(out_1) ,.seg_data(seg_1));
        
        seg_cont seg_control (.clk(clk), .reset(reset), .seg_100(seg_100), .seg_10(seg_10), .seg_1(seg_1), .digit(digit), .seg_data(seg_data));
        
endmodule
