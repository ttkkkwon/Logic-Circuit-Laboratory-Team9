module Multiplier(clk, rst, a, b, out);
    input clk, rst;
    input [7:0] a, b;
    output [7:0] out;
    
    integer A;
    assign A = {24'b0, a};
    integer B;
    assign B = {24'b0, b};

    integer result;
    assign result = A * B;
    assign out = result[7:0];
   

endmodule