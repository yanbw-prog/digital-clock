// seg_decoder.v
// 七段译码模块：将 BCD 码转换为七段显示码（共阳数码管，低有效）
// 端口定义与顶层 clock_top.v 中的例化保持一致：
//   seg_decoder u_dec ( .bcd(digit_data), .seg(seg) );
//
// 段码表与 verilog-digital-display 项目中的 seg_decoder 保持一致（低有效，0 表示点亮）
// 注：本文件系依据顶层 clock_top.v 的例化接口补齐（2026-09-04），
//     建议在 ISE / Vivado 中重新综合并仿真确认显示结果。
// 作者：严博文

module seg_decoder (
    input  wire [3:0] bcd, // BCD 输入（0~9）
    output reg  [6:0] seg  // 七段输出（低有效）
);

    always @(*) begin
        case (bcd)
            4'd0: seg = 7'b1000000; // 0
            4'd1: seg = 7'b1111001; // 1
            4'd2: seg = 7'b0100100; // 2
            4'd3: seg = 7'b0110000; // 3
            4'd4: seg = 7'b0011001; // 4
            4'd5: seg = 7'b0010010; // 5
            4'd6: seg = 7'b0000010; // 6
            4'd7: seg = 7'b1111000; // 7
            4'd8: seg = 7'b0000000; // 8
            4'd9: seg = 7'b0010000; // 9
            default: seg = 7'b1111111; // 其他输入：全灭
        endcase
    end

endmodule
