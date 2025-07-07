`timescale 1ns / 1ps

module BCD_to_7seg(
        input [3:0] in,
        output reg [7:0] seg_data
    );
    always @(*) begin
        case (in) 
            4'b0001 : seg_data <= 8'b0110_0000;
            4'b0010 : seg_data <= 8'b1101_1010;
            4'b0011 : seg_data <= 8'b1111_0010;
            4'b0100 : seg_data <= 8'b0110_0110;
            4'b0101 : seg_data <= 8'b1011_0110;
            4'b0110 : seg_data <= 8'b0011_1110;
            4'b0111 : seg_data <= 8'b1110_0000;
            4'b1000 : seg_data <= 8'b1111_1110;
            4'b1001 : seg_data <= 8'b1110_0110;
            4'b0000 : seg_data <= 8'b1111_1100;
            default : seg_data <= 0;
            endcase
    end
endmodule
