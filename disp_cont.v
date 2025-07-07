`timescale 1ns / 1ps

module disp_cont_module(
    input clk,
    input reset,
    input start_d,
    input [7:0] num_A,num_B,num_C,num_D,num_E,num_F,num_G,num_H,
    output reg [7:0] convolution,
    output reg next
);

    parameter S0=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, S7=7, S8=8;

    reg [31:0] cnt_clk;
    reg tick_1s;

    reg [3:0] state;
    reg [3:0] next_state;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            cnt_clk <= 0;
            tick_1s <= 0;
        end else if (state != S0) begin
            //if (cnt_clk == 99999999) begin
            if(cnt_clk==199) begin
                cnt_clk <= 0;
                tick_1s <= 1;
            end else begin
                cnt_clk <= cnt_clk + 1;
                tick_1s <= 0;
            end
        end else begin
            cnt_clk <= 0;
            tick_1s <= 0;
        end
    end

    always @(posedge clk or negedge reset) begin
        if (!reset) state <= S0;
        else state <= next_state;
    end

    always @(*) begin
        case(state)
            S0: if (start_d) next_state = S1; else next_state = S0;
            S1: if (tick_1s) next_state = S2; else next_state = S1;
            S2: if (tick_1s) next_state = S3; else next_state = S2;
            S3: if (tick_1s) next_state = S4; else next_state = S3;
            S4: if (tick_1s) next_state = S5; else next_state = S4;
            S5: if (tick_1s) next_state = S6; else next_state = S5;
            S6: if (tick_1s) next_state = S7; else next_state = S6;
            S7: if (tick_1s) next_state = S8; else next_state = S7;
            S8: if (tick_1s) next_state = S8; else next_state = S8;
            default: next_state = S0;
        endcase
    end

    always @(*) begin
        case(state)
            S1: convolution = num_A;
            S2: convolution = num_B;
            S3: convolution = num_C;
            S4: convolution = num_D;
            S5: convolution = num_E;
            S6: convolution = num_F;
            S7: convolution = num_G;
            S8: convolution = num_H;
            default: convolution = 8'b00000000;
        endcase
    end
endmodule
