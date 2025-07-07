`timescale 1ns / 1ps

module tb_memory;

    reg         clk;
    reg         rst_memory;

    // PE 결과
    reg  [7:0]  PE_result;
    reg         C11_PE, C12_PE, C21_PE, C22_PE;

    // 3×3 SA 결과
    reg  [7:0]  SA3_result;
    reg         C11_3by3, C12_3by3, C21_3by3, C22_3by3;

    // 2×2 SA 결과
    reg  [7:0]  SA2_result;
    reg         C11_2by2, C12_2by2, C21_2by2, C22_2by2;

    // 4×4 및 3×3 매트릭스 출력
    wire [7:0]  a11, a12, a13, a14;
    wire [7:0]  a21, a22, a23, a24;
    wire [7:0]  a31, a32, a33, a34;
    wire [7:0]  a41, a42, a43, a44;
    wire [7:0]  b11, b12, b13;
    wire [7:0]  b21, b22, b23;
    wire [7:0]  b31, b32, b33;

    // 메모리 저장 레지스터 출력
    wire [7:0]  mem_C11_PE, mem_C12_PE, mem_C21_PE, mem_C22_PE;
    wire [7:0]  mem_C11_3by3, mem_C12_3by3, mem_C21_3by3, mem_C22_3by3;
    wire [7:0]  mem_C11_2by2, mem_C12_2by2, mem_C21_2by2, mem_C22_2by2;

    // 메모리 인스턴스 생성
    memory uut (
        .clk         (clk),
        .rst_memory  (rst_memory),

        .PE_result   (PE_result),
        .C11_PE      (C11_PE),   .C12_PE      (C12_PE),
        .C21_PE      (C21_PE),   .C22_PE      (C22_PE),

        .SA3_result  (SA3_result),
        .C11_3by3    (C11_3by3), .C12_3by3    (C12_3by3),
        .C21_3by3    (C21_3by3), .C22_3by3    (C22_3by3),

        .SA2_result  (SA2_result),
        .C11_2by2    (C11_2by2), .C12_2by2    (C12_2by2),
        .C21_2by2    (C21_2by2), .C22_2by2    (C22_2by2),

        .a11(a11), .a12(a12), .a13(a13), .a14(a14),
        .a21(a21), .a22(a22), .a23(a23), .a24(a24),
        .a31(a31), .a32(a32), .a33(a33), .a34(a34),
        .a41(a41), .a42(a42), .a43(a43), .a44(a44),

        .b11(b11), .b12(b12), .b13(b13),
        .b21(b21), .b22(b22), .b23(b23),
        .b31(b31), .b32(b32), .b33(b33),

        .mem_C11_PE   (mem_C11_PE),   .mem_C12_PE   (mem_C12_PE),
        .mem_C21_PE   (mem_C21_PE),   .mem_C22_PE   (mem_C22_PE),
        .mem_C11_3by3 (mem_C11_3by3), .mem_C12_3by3 (mem_C12_3by3),
        .mem_C21_3by3 (mem_C21_3by3), .mem_C22_3by3 (mem_C22_3by3),
        .mem_C11_2by2 (mem_C11_2by2), .mem_C12_2by2 (mem_C12_2by2),
        .mem_C21_2by2 (mem_C21_2by2), .mem_C22_2by2 (mem_C22_2by2)
    );

    // 클럭 생성 (20ns 주기)
    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        // 초기화
        rst_memory = 1;
        PE_result  = 8'h00;
        SA3_result = 8'h00;
        SA2_result = 8'h00;
        {C11_PE, C12_PE, C21_PE, C22_PE}     = 4'b0;
        {C11_3by3, C12_3by3, C21_3by3, C22_3by3} = 4'b0;
        {C11_2by2, C12_2by2, C21_2by2, C22_2by2} = 4'b0;

        // 리셋 해제 전 잠시 대기
        #25;
        rst_memory = 0;
        #20;

        // ① reset 이후 4×4/3×3 로드 확인
        $display(">> After rst: a11=%0d, a44=%0d, b11=%0d, b33=%0d",
                  a11, a44, b11, b33);

        // ② PE 결과 쓰기 테스트
        PE_result = 8'hAA;
        C11_PE    = 1;
        #20;  C11_PE = 0;
        $display("mem_C11_PE = 0x%0h (expected 0xAA)", mem_C11_PE);

        // ③ 3×3 SA 결과 쓰기 테스트
        SA3_result = 8'hBB;
        C22_3by3   = 1;
        #20;  C22_3by3 = 0;
        $display("mem_C22_3by3 = 0x%0h (expected 0xBB)", mem_C22_3by3);

        // ④ 2×2 SA 결과 쓰기 테스트
        SA2_result = 8'hCC;
        C21_2by2   = 1;
        #20;  C21_2by2 = 0;
        $display("mem_C21_2by2 = 0x%0h (expected 0xCC)", mem_C21_2by2);

        // 시뮬레이션 종료
        #50;
        $finish;
    end

endmodule




