`timescale 1ns/1ns

module tb_systolic_3by3;
    // clock & reset
    reg clk, rst;

    // A11…A44는 이 예제에서 사용되지 않으니 모두 0으로 tie-off
    reg [7:0] A11, A12, A13, A14;
    reg [7:0] A21, A22, A23, A24;
    reg [7:0] A31, A32, A33, A34;
    reg [7:0] A41, A42, A43, A44;

    // filter coefficient B
    reg [7:0] B11, B12, B13;
    reg [7:0] B21, B22, B23;
    reg [7:0] B31, B32, B33;

    // streaming inputs
    reg [7:0] left1, left2, left3;

    // outputs
    wire [7:0] C11, C12, C21, C22;
    wire [7:0] out;


    // DUT 인스턴스
    systolic_3by3 dut (
        .clk    (clk),
        .rst    (rst),
        .B11    (B11),   .B12(B12), .B13(B13),
        .B21    (B21),   .B22(B22), .B23(B23),
        .B31    (B31),   .B32(B32), .B33(B33),
        .left1  (left1), .left2(left2), .left3(left3),
        .C11    (C11),   .C12(C12),
        .C21    (C21),   .C22(C22),
        .out    (out)
    );

    // 5ns period clock
    initial clk = 0;
    always #5 clk = !clk;

    initial begin
        // tie-off unused A
        //{A11,A12,A13,A14,
        // A21,A22,A23,A24,
        // A31,A32,A33,A34,
        // A41,A42,A43,A44} = {16{8'd0}};
        A11 = 8'd1; A12 = 8'd2; A13 = 8'd3; A14 = 8'd4;
        A21 = 8'd5; A22 = 8'd6; A23 = 8'd7; A24 = 8'd8;
        A31 = 8'd9; A32 = 8'd10; A33 = 8'd11; A34 = 8'd12;
        A41 = 8'd13; A42 = 8'd14; A43 = 8'd15; A44 = 8'd16;

        // 초기 reset
        rst = 1;
        #10 rst = 0;

        // 첫 번째 테스트 벡터
        // left  = [1,2,3], up = [4,5,6]
        // B 계수들은 1…9 로 채워 봅니다.
        left1 = 8'd8; left2 = 8'd0; left3 = 8'd0;
        B33   = 8'd9; B32   = 8'd8; B31   = 8'd7;
        B23   = 8'd6; B22   = 8'd5; B21   = 8'd4;
        B13   = 8'd3; B12   = 8'd2; B11   = 8'd1;

        #10;
        // 두 번째 벡터: 모두 10으로 채워 보기
        left1 = 8'd7; left2 = 8'd12; left3 = 8'd0;
        B33   = 8'd9; B32   = 8'd8; B31   = 8'd7;
        B23   = 8'd6; B22   = 8'd5; B21   = 8'd4;
        B13   = 8'd3; B12   = 8'd2; B11   = 8'd1;

        #10
        left1 = 8'd6; left2 = 8'd11; left3 = 8'd16;
        B33   = 8'd9; B32   = 8'd8; B31   = 8'd7;
        B23   = 8'd6; B22   = 8'd5; B21   = 8'd4;
        B13   = 8'd3; B12   = 8'd2; B11   = 8'd1;

        #10
        left1 = 8'd5; left2 = 8'd10; left3 = 8'd15;
        B33   = 8'd9; B32   = 8'd8; B31   = 8'd7;
        B23   = 8'd6; B22   = 8'd5; B21   = 8'd4;
        B13   = 8'd3; B12   = 8'd2; B11   = 8'd1;

        #10
        left1 = 8'd4; left2 = 8'd9; left3 = 8'd14;
        B33   = 8'd9; B32   = 8'd8; B31   = 8'd7;
        B23   = 8'd6; B22   = 8'd5; B21   = 8'd4;
        B13   = 8'd3; B12   = 8'd2; B11   = 8'd1;

        #10
        left1 = 8'd3; left2 = 8'd8; left3 = 8'd13;
        B33   = 8'd9; B32   = 8'd8; B31   = 8'd7;
        B23   = 8'd6; B22   = 8'd5; B21   = 8'd4;
        B13   = 8'd3; B12   = 8'd2; B11   = 8'd1;

        #10
        left1 = 8'd2; left2 = 8'd7; left3 = 8'd12;
        B33   = 8'd9; B32   = 8'd8; B31   = 8'd7;
        B23   = 8'd6; B22   = 8'd5; B21   = 8'd4;
        B13   = 8'd3; B12   = 8'd2; B11   = 8'd1;

        #10
        left1 = 8'd1; left2 = 8'd6; left3 = 8'd11;
        B33   = 8'd9; B32   = 8'd8; B31   = 8'd7;
        B23   = 8'd6; B22   = 8'd5; B21   = 8'd4;
        B13   = 8'd3; B12   = 8'd2; B11   = 8'd1;

        #10
        left1 = 8'd0; left2 = 8'd5; left3 = 8'd10;
        B33   = 8'd9; B32   = 8'd8; B31   = 8'd7;
        B23   = 8'd6; B22   = 8'd5; B21   = 8'd4;
        B13   = 8'd3; B12   = 8'd2; B11   = 8'd1;

        #10
        left1 = 8'd0; left2 = 8'd0; left3 = 8'd9;
        B33   = 8'd9; B32   = 8'd8; B31   = 8'd7;
        B23   = 8'd6; B22   = 8'd5; B21   = 8'd4;
        B13   = 8'd3; B12   = 8'd2; B11   = 8'd1;


        #10 $finish;
    end
endmodule

