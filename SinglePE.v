module SinglePEv1_comb(
    input clk, rst,
    input  [7:0] in_a,
    input  [7:0] in_b,
    input  [7:0] init,
    output reg [7:0] out_a,
    output reg [7:0] out_down
);
    // 1) Multiplier 인스턴스
    wire [15:0] mult_w;
    Multiplier Mult1 (
        .clk(clk), .rst(rst),
        .a(in_a),
        .b(init),
        .out(mult_w)
    );

    // 2) Adder 인스턴스
    wire [15:0] sum_w;
    Adder Ad1 (
        .a(mult_w[7:0]),   // Multiplier 결과 하위 8비트
        .b(in_b),
        .sum(sum_w),
        .cout()            // 캐리는 사용 안 함
    );

    // 3) 출렵
    //assign out_a    = in_a;
    //assign out_down = sum_w[7:0];  // init*in_a + in_b 의 하위 8비트
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            out_a    <= 8'b0;
            out_down <= 8'b0;
        end else begin
            out_a    <= in_a;
            out_down <= sum_w[7:0];  // init*in_a + in_b 의 하위 8비트
        end
    end
endmodule
