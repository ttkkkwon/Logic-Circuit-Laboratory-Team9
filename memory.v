`timescale 1ns / 1ps

module memory (
    input  clk,
    input  rst_memory,   // 메모리 전용 리셋신호

    // PE 결과 입력
    input  [7:0]  PE_result,      //PE 결과 sequence 받아서 c11,c12..신호 올때마다 저장
    input         C11_PE, C12_PE, //저장신호
    input         C21_PE, C22_PE, //저장신호

    // 3×3 SA 결과 입력 
    input  [7:0]  SA3_result,   // SA3_result 결과 sequence 받아서 c11,c12..신호 올때마다 저장
    input         C11_3by3, C12_3by3, //저장신호
    input         C21_3by3, C22_3by3, //저장신호

    // 2×2 SA 결과 입력 
    input  [7:0]  SA2_result,  // SA2_result 결과 sequence 받아서 c11,c12..신호 올때마다 저장
    input         C11_2by2, C12_2by2, //저장신호
    input         C21_2by2, C22_2by2, //저장신호

    // 4×4 매트릭스 값 출력
    output reg [7:0]   a11, a12, a13, a14,
    output reg [7:0]   a21, a22, a23, a24,
    output reg [7:0]   a31, a32, a33, a34,
    output reg [7:0]   a41, a42, a43, a44,

    // 3×3 매트릭스 값 출력
    output reg [7:0]   b11, b12, b13,
    output reg [7:0]   b21, b22, b23,
    output reg [7:0]   b31, b32, b33,

    // C11,C12,C21,C22 값 출력
    output reg [7:0]   mem_C11_PE, mem_C12_PE,
    output reg [7:0]   mem_C21_PE, mem_C22_PE,
    output reg [7:0]   mem_C11_3by3, mem_C12_3by3,
    output reg [7:0]   mem_C21_3by3, mem_C22_3by3,
    output reg [7:0]   mem_C11_2by2, mem_C12_2by2,
    output reg [7:0]   mem_C21_2by2, mem_C22_2by2
);

///////////////////여기부터 시작 /////////////////

    //////////////// 시연때 줄 4x4, 3x3 매트릭스 값 직접 입력 ////////////////////
    localparam [7:0]
        IMG11 = 8'd1, IMG12 = 8'd2, IMG13 = 8'd3, IMG14 = 8'd4,
        IMG21 = 8'd5, IMG22 = 8'd6, IMG23 = 8'd7, IMG24 = 8'd8,
        IMG31 = 8'd9, IMG32 = 8'd10, IMG33 = 8'd11, IMG34 = 8'd12,
        IMG41 = 8'd13, IMG42 = 8'd14, IMG43 = 8'd15, IMG44 = 8'd16;

    localparam [7:0]
        FIL11 = 8'd1,  FIL12 = 8'd2,  FIL13 = 8'd3,
        FIL21 = 8'd4,  FIL22 = 8'd5,  FIL23 = 8'd6,
        FIL31 = 8'd7,  FIL32 = 8'd8,  FIL33 = 8'd9;
    ///////////////////////////////////////////////////////////////////////////   


    always @(posedge clk) 
    begin
        if (rst_memory) 
        begin
            // 4×4 값 localparam 에 적힌대로 넣어줌
            a11 <= IMG11; a12 <= IMG12; a13 <= IMG13; a14 <= IMG14;
            a21 <= IMG21; a22 <= IMG22; a23 <= IMG23; a24 <= IMG24;
            a31 <= IMG31; a32 <= IMG32; a33 <= IMG33; a34 <= IMG34;
            a41 <= IMG41; a42 <= IMG42; a43 <= IMG43; a44 <= IMG44;
            // 3×3 값 localparam 에 적힌대로 넣어줌
            b11 <= FIL11; b12 <= FIL12; b13 <= FIL13;
            b21 <= FIL21; b22 <= FIL22; b23 <= FIL23;
            b31 <= FIL31; b32 <= FIL32; b33 <= FIL33;
            // 레지스터 초기화
            mem_C11_PE    <= 0;  mem_C12_PE    <= 0;
            mem_C21_PE    <= 0;  mem_C22_PE    <= 0;
            mem_C11_3by3  <= 0;  mem_C12_3by3  <= 0;
            mem_C21_3by3  <= 0;  mem_C22_3by3  <= 0;
            mem_C11_2by2  <= 0;  mem_C12_2by2  <= 0;
            mem_C21_2by2  <= 0;  mem_C22_2by2  <= 0;
        end
        else
        begin
            // PE 결과 메모리에 저장
            if (C11_PE)   mem_C11_PE   <= PE_result;
            if (C12_PE)   mem_C12_PE   <= PE_result;
            if (C21_PE)   mem_C21_PE   <= PE_result;
            if (C22_PE)   mem_C22_PE   <= PE_result;

            // 3×3 SA 결과 메모리에 저장
            if (C11_3by3) mem_C11_3by3 <= SA3_result;
            if (C12_3by3) mem_C12_3by3 <= SA3_result;
            if (C21_3by3) mem_C21_3by3 <= SA3_result;
            if (C22_3by3) mem_C22_3by3 <= SA3_result;

            // 2×2 SA 결과 메모리에 저장
            if (C11_2by2) mem_C11_2by2 <= SA2_result;
            if (C12_2by2) mem_C12_2by2 <= SA2_result;
            if (C21_2by2) mem_C21_2by2 <= SA2_result;
            if (C22_2by2) mem_C22_2by2 <= SA2_result;
        end
    end

endmodule


