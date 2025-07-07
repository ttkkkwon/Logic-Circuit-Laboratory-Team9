module SinglePE (
    input            clk,
    input            rst,
    input            sel,
    input      [7:0] in_a,
    input      [7:0] in_b,
    output     [7:0] out_a,
    output     [7:0] out
);
    wire [7:0] mult_result, out_sum, q_out_c;
    wire     [7:0] out_b,
    wire     [7:0] out_c,

    if(rst == 1'b1) assign q_out_c = 8'b0;

    // 1) 곱셈
    Multiplier Mult1(.clk(clk), .rst(rst),.a(in_a), .b(in_b),.out(mult_result));

    // 2) 곱셈 결과 + 이전 누적값
    Adder Ad1(.a(mult_result),.b(q_out_c),.sum(out_sum),.cout());

    // 3) 누적값 등록
    FF_8bit FF3(.clk(clk), .rst(rst), .a(out_sum), .out(q_out_c));

    // 4) 파이프라인 레지스터
    FF_8bit FF1(.clk(clk), .rst(rst), .a(in_a), .out(out_a));
    FF_8bit FF2(.clk(clk), .rst(rst), .a(in_b), .out(out_b));

    // 5) 출력 연결
    if(sel == 1'b0) assign out = out_b;
    else assign out = q_out_c;

endmodule