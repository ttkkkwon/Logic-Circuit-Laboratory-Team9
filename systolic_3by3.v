module systolic_3by3(
    input clk, rst,
    input [7:0] A11, A12, A13, A14,
    input [7:0] A21, A22, A23, A24,
    input [7:0] A31, A32, A33, A34,
    input [7:0] A41, A42, A43, A44,
    input [7:0] B11, B12, B13,
    input [7:0] B21, B22, B23,
    input [7:0] B31, B32, B33,
    input [7:0] up1, up2, up3,
    input [7:0] left1, left2, left3,
    output [7:0] C11, C12,
    output [7:0] C21, C22


);

    wire [7:0] wire1, wire2, wire3, wire4, wire5, wire6, wire7, wire8, wire9, wire10, wire11, wire12, wire13, wire14, wire15;

    /*        up1   up2    up3
              |      |      |
    left1 => PE11  PE12   PE13 => a/c : wire9 / 
    left2 => PE21  PE22   PE23 =>
    left3 => PE31  PE32   PE33 =>
              |      |      |

    왼쪽에서 a가 들어와서 오른쪽으로 a 그대로, 누적합 c가 나가고
    위쪽에서 b가 들어와서 아래쪽으로 b 그대로가 나간다.
    */

    SinglePE PE11(.clk(clk), .rst(rst), .in_a(left1), .in_b(up1), .out_a(wire7), .out_b(wire1), .out_c());
    SinglePE PE12(.clk(clk), .rst(rst), .in_a(wire7), .in_b(up2), .out_a(wire8), .out_b(wire2), .out_c());
    SinglePE PE13(.clk(clk), .rst(rst), .in_a(wire8), .in_b(up3), .out_a(wire9), .out_b(wire3), .out_c());
    
endmodule
