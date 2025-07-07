`timescale 1ns / 1ps

module Binary_to_BCD (
    input [7:0] Bin,
    output [3:0] out_3,
    output [3:0] out_2,
    output [3:0] out_1
);
    reg [12:1] BCD;
    reg [7:0] temp;
    integer i;

    always @(*) begin
        BCD = 0;
        temp = Bin;
        for (i = 0; i < 8; i = i + 1) begin
            if (BCD[12:9] > 4) BCD[12:9] = BCD[12:9] + 3;
            if (BCD[8:5]  > 4) BCD[8:5]  = BCD[8:5]  + 3;
            if (BCD[4:1]  > 4) BCD[4:1]  = BCD[4:1]  + 3;
            BCD = BCD << 1;
            BCD[1] = temp[7];
            temp = temp << 1;
        end
    end

    assign out_3 = BCD[12:9]; 
    assign out_2 = BCD[8:5];  
    assign out_1 = BCD[4:1];  
endmodule