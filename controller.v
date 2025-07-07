`timescale 1ns / 1ps



module controller(
input clk, input rst,     // clk 100Mhz, rst 신호
input [7:0] a11, a12, a13, a14, a21, a22, a23, a24, a31, a32, a33, a34, a41, a42, a43, a44, // input 위치별 값
input [7:0] b11, b12, b13, b21, b22, b23, b31, b32, b33, // 필터 위치별 값

output reg rst_memory, rst_PE, rst_3by3, rst_2by2, rst_display, // 각 모듈 reset 신호
output reg on_PE, on_3by3, on_2by2, on_display, // 각 모듈 작동 신호
output reg [7:0] A_PE, W_PE, // PE에 넣을 값
output reg [7:0] A1_3by3, A2_3by3, A3_3by3, W1_3by3, W2_3by3, W3_3by3, // 3by3_sa 에 넣을 값
output reg [7:0] A1_2by2, A2_2by2, W1_2by2, W2_2by2, // 2by2_sa 에 넣을 값
output reg C11_PE, C12_PE, C21_PE, C22_PE,// PE 결과 저장 신호
output reg C11_3by3, C12_3by3, C21_3by3, C22_3by3,// PE 결과 저장 신호
output reg C11_2by2, C12_2by2, C21_2by2, C22_2by2 // PE 결과 저장 신호
    );

    reg [2:0] state; // 상태
    // 각 상태별 counter
    reg [5:0] cnt_PE;
    reg [5:0] cnt_3by3;
    reg [5:0] cnt_2by2;
    
    // 각 상태 이름 선언
    parameter start = 0; // S0 state
    parameter initialize_module = 1; // S1 state
    parameter computation_PE = 2; // S2 state
    parameter computation_3by3_sa = 3; // S3 state
    parameter computation_2by2_sa = 4; // S4 state
    parameter display = 5; // S5 state
    
    // 1) 상태 천이 조건문 
    // 각 상태별로 카운터가 있으며 카운터가 끝까지 가면 다음 상태로
    always @ (posedge clk)
    begin
        if (rst)
            state <= start;
        else begin
            case (state)
                start              : state <= initialize_module;
                initialize_module  : state <= computation_PE;
                computation_PE     : begin
                if (cnt_PE == 48) state <= computation_3by3_sa;
                else cnt_PE <= cnt_PE + 1;
                end
                computation_3by3_sa: begin
                if (cnt_3by3 == 32) state <= computation_2by2_sa;
                else cnt_3by3 <= cnt_3by3 + 1;
                end
                computation_2by2_sa: begin
                if (cnt_2by2 == 8) state <= display;
                else cnt_2by2 <= cnt_2by2 + 1;
                end
            endcase
        end
     end
     
     // 2) 각 상태별 행동 지정
     always @ (posedge clk)
     begin
        case (state)
            start : begin // SO 모든 변수 0으로 초기화
                rst_memory <= 0; rst_PE <= 0; rst_3by3 <= 0; rst_2by2 <= 0; rst_display <= 0;
                
                on_PE <= 0; on_3by3 <= 0; on_2by2 <= 0; on_display <= 0;
                
                cnt_PE <= 0; cnt_3by3 <= 0; cnt_2by2 <= 0;     
                
                A_PE <= 0; W_PE <= 0;
                A1_3by3 <= 0; W1_3by3 <= 0; A2_3by3 <= 0; W2_3by3 <= 0; A3_3by3 <= 0; W3_3by3 <= 0;
                A1_2by2 <= 0; W1_2by2 <= 0; A2_2by2 <= 0; W2_2by2 <= 0;
                
                C11_PE <= 0; C12_PE <= 0;  C21_PE <= 0; C22_PE <= 0;
                C11_3by3 <= 0; C12_3by3 <= 0;  C21_3by3 <= 0; C22_3by3 <= 0;
                C11_2by2 <= 0; C12_2by2 <= 0;  C21_2by2 <= 0; C22_2by2 <= 0;
            end
            initialize_module : begin // S1 각 모듈 초기화
                rst_memory <= 1;
                rst_PE <= 1;
                rst_3by3 <= 1;
                rst_2by2 <= 1;
            end
            computation_PE : begin // S2 PE 계산 시퀀스 보내기
                case (cnt_PE)
                0 : begin rst_PE <= 0; on_PE <= 1; end
                1 : begin A_PE <= a11 ; W_PE <= b33; end
                2 : begin A_PE <= a12 ; W_PE <= b32; end
                3 : begin A_PE <= a13 ; W_PE <= b31; end
                4 : begin A_PE <= a21 ; W_PE <= b23; end
                5 : begin A_PE <= a22 ; W_PE <= b22; end
                6 : begin A_PE <= a23 ; W_PE <= b21; end
                7 : begin A_PE <= a31 ; W_PE <= b13; end
                8 : begin A_PE <= a32 ; W_PE <= b12; end
                9 : begin A_PE <= a33 ; W_PE <= b11; end
               10 : begin C11_PE <= 1; end
               11 : begin C11_PE <= 0; rst_PE <= 1; end
               
               12 : begin rst_PE <= 0; end
               13 : begin A_PE <= a12 ; W_PE <= b33; end
               14 : begin A_PE <= a13 ; W_PE <= b32; end
               15 : begin A_PE <= a14 ; W_PE <= b31; end
               16 : begin A_PE <= a22 ; W_PE <= b23; end
               17 : begin A_PE <= a23 ; W_PE <= b22; end
               18 : begin A_PE <= a24 ; W_PE <= b21; end
               19 : begin A_PE <= a32 ; W_PE <= b13; end
               20 : begin A_PE <= a33 ; W_PE <= b12; end
               21 : begin A_PE <= a34 ; W_PE <= b11; end
               22 : begin C12_PE <= 1; end
               23 : begin C12_PE <= 0; rst_PE <= 1; end
               
               24 : begin rst_PE <= 0; end
               25 : begin A_PE <= a21 ; W_PE <= b33; end
               26 : begin A_PE <= a22 ; W_PE <= b32; end
               27 : begin A_PE <= a23 ; W_PE <= b31; end
               28 : begin A_PE <= a31 ; W_PE <= b23; end
               29 : begin A_PE <= a32 ; W_PE <= b22; end
               30 : begin A_PE <= a33 ; W_PE <= b21; end
               31 : begin A_PE <= a41 ; W_PE <= b13; end
               32 : begin A_PE <= a42 ; W_PE <= b12; end
               33 : begin A_PE <= a43 ; W_PE <= b11; end
               34 : begin C21_PE <= 1; end
               35 : begin C21_PE <= 0; rst_PE <= 1; end
              
               36 : begin rst_PE <= 0; end
               37 : begin A_PE <= a22 ; W_PE <= b33; end
               38 : begin A_PE <= a23 ; W_PE <= b32; end
               39 : begin A_PE <= a24 ; W_PE <= b31; end
               40 : begin A_PE <= a32 ; W_PE <= b23; end
               41 : begin A_PE <= a33 ; W_PE <= b22; end
               42 : begin A_PE <= a34 ; W_PE <= b21; end
               43 : begin A_PE <= a42 ; W_PE <= b13; end
               44 : begin A_PE <= a43 ; W_PE <= b12; end
               45 : begin A_PE <= a44 ; W_PE <= b11; end
               46 : begin C22_PE <= 1; end
               47 : begin C22_PE <= 0; rst_PE <= 1; on_PE <= 0; end           
                endcase
            end
            computation_3by3_sa : begin // S3 3by3 sa 계산 시퀀스 보내기 (시퀀스는 수정해야함)
                case (cnt_3by3)
                0 : begin rst_3by3 <= 0; on_PE <= 1; on_3by3 <=1; end
                1 : begin A1_3by3 <= a11; A2_3by3 <= 0; A3_3by3 <= 0; W1_3by3 <= b33; W2_3by3 <= 0; W3_3by3 <= 0; end
                2 : begin A1_3by3 <= a12; A2_3by3 <= a21; A3_3by3 <= 0; W1_3by3 <= b32; W2_3by3 <= b23; W3_3by3 <= 0; end
                3 : begin A1_3by3 <= a13; A2_3by3 <= a22; A3_3by3 <= a31; W1_3by3 <= b31; W2_3by3 <= b22; W3_3by3 <= b13; end
                4 : begin A1_3by3 <= 0; A2_3by3 <= a23; A3_3by3 <= a32; W1_3by3 <= 0; W2_3by3 <= b21; W3_3by3 <= b12; end
                5 : begin A1_3by3 <= 0; A2_3by3 <= 0; A3_3by3 <= a33; W1_3by3 <= 0; W2_3by3 <= 0; W3_3by3 <= b11; end
                6 : begin C11_3by3 <= 1; end
                7 : begin C11_3by3 <= 0; rst_3by3 <= 1; end
                
                8 : begin rst_3by3 <= 0; on_PE <= 1; on_3by3 <=1; end
                9 : begin A1_3by3 <= a12; A2_3by3 <= 0; A3_3by3 <= 0; W1_3by3 <= b33; W2_3by3 <= 0; W3_3by3 <= 0; end
               10 : begin A1_3by3 <= a13; A2_3by3 <= a22; A3_3by3 <= 0; W1_3by3 <= b32; W2_3by3 <= b23; W3_3by3 <= 0; end
               11 : begin A1_3by3 <= a14; A2_3by3 <= a23; A3_3by3 <= a32; W1_3by3 <= b31; W2_3by3 <= b22; W3_3by3 <= b13; end
               12 : begin A1_3by3 <= 0; A2_3by3 <= a24; A3_3by3 <= a33; W1_3by3 <= 0; W2_3by3 <= b21; W3_3by3 <= b12; end
               13 : begin A1_3by3 <= 0; A2_3by3 <= 0; A3_3by3 <= a34; W1_3by3 <= 0; W2_3by3 <= 0; W3_3by3 <= b11; end
               14 : begin C12_3by3 <= 1; end
               15 : begin C12_3by3 <= 0; rst_3by3 <= 1; end
                
               16 : begin rst_3by3 <= 0; on_PE <= 1; on_3by3 <=1; end
               17 : begin A1_3by3 <= a21; A2_3by3 <= 0; A3_3by3 <= 0; W1_3by3 <= b33; W2_3by3 <= 0; W3_3by3 <= 0; end
               18 : begin A1_3by3 <= a22; A2_3by3 <= a31; A3_3by3 <= 0; W1_3by3 <= b32; W2_3by3 <= b23; W3_3by3 <= 0; end
               19 : begin A1_3by3 <= a23; A2_3by3 <= a32; A3_3by3 <= a41; W1_3by3 <= b31; W2_3by3 <= b22; W3_3by3 <= b13; end
               20 : begin A1_3by3 <= 0; A2_3by3 <= a33; A3_3by3 <= a42; W1_3by3 <= 0; W2_3by3 <= b21; W3_3by3 <= b12; end
               21 : begin A1_3by3 <= 0; A2_3by3 <= 0; A3_3by3 <= a43; W1_3by3 <= 0; W2_3by3 <= 0; W3_3by3 <= b11; end
               22 : begin C21_3by3 <= 1; end
               23 : begin C21_3by3 <= 0; rst_3by3 <= 1; end
                
               24 : begin rst_3by3 <= 0; on_PE <= 1; on_3by3 <=1; end
               25 : begin A1_3by3 <= a22; A2_3by3 <= 0; A3_3by3 <= 0; W1_3by3 <= b33; W2_3by3 <= 0; W3_3by3 <= 0; end
               26 : begin A1_3by3 <= a23; A2_3by3 <= a32; A3_3by3 <= 0; W1_3by3 <= b32; W2_3by3 <= b23; W3_3by3 <= 0; end
               27 : begin A1_3by3 <= a24; A2_3by3 <= a33; A3_3by3 <= a42; W1_3by3 <= b31; W2_3by3 <= b22; W3_3by3 <= b13; end
               28 : begin A1_3by3 <= 0; A2_3by3 <= a34; A3_3by3 <= a43; W1_3by3 <= 0; W2_3by3 <= b21; W3_3by3 <= b12; end
               29 : begin A1_3by3 <= 0; A2_3by3 <= 0; A3_3by3 <= a44; W1_3by3 <= 0; W2_3by3 <= 0; W3_3by3 <= b11; end
               30 : begin C22_3by3 <= 1; end
               31 : begin C22_3by3 <= 0; rst_3by3 <= 1; on_PE <= 0; on_3by3 <=0; end                                                
                endcase
            end
            computation_2by2_sa : begin // S4 2by2 sa 계산 시퀀스 보내기 (시퀀스는 수정해야함)
                case (cnt_2by2)
                0 : begin rst_2by2 <= 0; on_PE <= 1; on_2by2 <=1; end
                1 : begin A1_2by2 <= 0; A2_2by2 <= 0; W1_3by3 <= 0; W2_3by3 <= 0; end
                2 : begin A1_2by2 <= 0; A2_2by2 <= 0; W1_3by3 <= 0; W2_3by3 <= 0; end
                3 : begin A1_2by2 <= 0; A2_2by2 <= 0; W1_3by3 <= 0; W2_3by3 <= 0; end
                4 : begin A1_2by2 <= 0; A2_2by2 <= 0; W1_3by3 <= 0; W2_3by3 <= 0; end
                5 : begin A1_2by2 <= 0; A2_2by2 <= 0; W1_3by3 <= 0; W2_3by3 <= 0; end
                7 : begin C11_2by2 <= 0; rst_2by2 <= 1; end
                endcase
            end
            display : begin // S5 display 모듈 작동 신호 보내기
                on_display <= 1;
            end
        endcase
    end
endmodule
