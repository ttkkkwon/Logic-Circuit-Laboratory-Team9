module systolic_3by3(
    input clk, rst,
    input reg [7:0] B11, B12, B13,
    input reg [7:0] B21, B22, B23,
    input reg [7:0] B31, B32, B33,
    input [7:0] left1, left2, left3,
    output [7:0] C11, C12,
    output [7:0] C21, C22,
    output [7:0] out
);

    wire [7:0] wire1, wire2, wire3, wire4, wire5, wire6, wire7, wire8, wire9, wire10, wire11, wire12, wire13, wire14, wire15, wire16, wire17;

    /*  in_a : 왼쪽에서 들어옴, in_b : 위쪽에서 들어옴
             up1   up2    up3
              |      |      |
    left1 => PE11  PE12   PE13 => out_a:wire1/wire2 /  | out_down:wire3/wire4/wire5
    left2 => PE21  PE22   PE23 => in_b:wire3/wire4/wire5 | out_a: wire6/wire7/ | out_down:wire8/wire9/wire10
    left3 => PE31  PE32   PE33 => in_b: wire8/wire9/wire10 | out_a: wire11,wire12 | out_down:wire13/wire14/wire15
              |      |      |

    왼쪽에서 a가 들어와서 오른쪽으로 a 그대로, 누적합 c가 나가고
    위쪽에서 b가 들어와서 아래쪽으로 b 그대로가 나간다.
    */

    SinglePEv1_comb PE11(.clk(clk), .rst(rst), .in_a(left1), .in_b(8'b0), .init(B33), .out_a(wire1), .out_down(wire3));   // B33
    SinglePEv1_comb PE12(.clk(clk), .rst(rst), .in_a(wire1), .in_b(8'b0), .init(B32), .out_a(wire2), .out_down(wire4));   // B32 
    SinglePEv1_comb PE13(.clk(clk), .rst(rst), .in_a(wire2), .in_b(8'b0), .init(B31), .out_a(), .out_down(wire5));   // B31
    
    SinglePEv1_comb PE21(.clk(clk), .rst(rst), .in_a(left2), .in_b(wire3), .init(B23), .out_a(wire6), .out_down(wire8)); // B23
    SinglePEv1_comb PE22(.clk(clk), .rst(rst), .in_a(wire6), .in_b(wire4), .init(B22), .out_a(wire7), .out_down(wire9));      // B22
    SinglePEv1_comb PE23(.clk(clk), .rst(rst), .in_a(wire7), .in_b(wire5), .init(B21), .out_a(), .out_down(wire10));      // B21

    SinglePEv1_comb PE31(.clk(clk), .rst(rst), .in_a(left3), .in_b(wire8), .init(B13), .out_a(wire11), .out_down(wire13)); // B13
    SinglePEv1_comb PE32(.clk(clk), .rst(rst), .in_a(wire11), .in_b(wire9), .init(B12), .out_a(wire12), .out_down(wire14));      // B12
    SinglePEv1_comb PE33(.clk(clk), .rst(rst), .in_a(wire12), .in_b(wire10), .init(B11), .out_a(), .out_down(wire15));      // B11
    
    assign out = wire13 + wire14 + wire15;
    // 5 cycle 시점에 out1, 2, 3 모두 더하면 : C22
    // 6 cycle 시점에 out1, 2, 3 모두 더하면 : C21
    // 9 cycle 시점에 out1, 2, 3 모두 더하면 : C12
    // 10 cycle 시점에 out1, 2, 3 모두 더하면 : C11

endmodule
