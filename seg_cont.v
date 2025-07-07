`timescale 1ns / 1ps

module seg_cont(
        input clk,
        input reset,
        input [7:0] seg_100,seg_10,seg_1,
        output reg [7:0] digit,
        output reg [7:0] seg_data
    );
    reg [31:0] count;
    reg clk_500hz;
    
    always @(posedge clk or negedge reset) begin
        if(!reset) begin count<=0;
                        clk_500hz<=0;
                   end
        else begin
            //if(count==99999) begin clk_500hz<=~clk_500hz;
              if(count==5) begin clk_500hz<=~clk_500hz;
                                      count <=0;
                                end
            else count <= count+1;
        end
    end
    
    always @(posedge clk_500hz or negedge reset) begin
        if(!reset) digit <=8'b1000_0000;
        else begin
            digit <= {digit[0],digit[7:1]};
        end
    end
    
    always @(*) begin
        case (digit)
        8'b0000_0001 : seg_data <= seg_1;
        8'b0000_0010 : seg_data <= seg_10;
        8'b0000_0100 : seg_data <= seg_100;
        8'b0000_1000 : seg_data <= 0;
        8'b0001_0000 : seg_data <= 0;
        8'b0010_0000 : seg_data <= 0;
        8'b0100_0000 : seg_data <= 0;
        8'b1000_0000 : seg_data <= 0;
        default : seg_data <=0;
        endcase
    end
endmodule
