// clock_top.v
// 顶层模块：数字时钟（6位数码管显示 时:分:秒）
// 作者：严博文
// 时钟：50MHz，显示格式 HH:MM:SS

module clock_top (
    input  wire        clk,    // 系统时钟 50MHz
    input  wire        rst_n,  // 异步复位（低有效）
    output wire [5:0]  sel,    // 数码管位选（低有效）
    output wire [6:0]  seg     // 段选信号（低有效）
);

    wire [3:0] sec_l, sec_h;
    wire [3:0] min_l, min_h;
    wire [3:0] hour_l, hour_h;
    wire [2:0] digit_sel;
    wire [3:0] digit_data;

    // 时间计数模块
    time_counter u_counter (
        .clk    (clk),
        .rst_n  (rst_n),
        .sec_l  (sec_l),
        .sec_h  (sec_h),
        .min_l  (min_l),
        .min_h  (min_h),
        .hour_l (hour_l),
        .hour_h (hour_h)
    );

    // 扫描控制模块
    scan_ctrl6 u_scan (
        .clk       (clk),
        .rst_n     (rst_n),
        .digit_sel (digit_sel)
    );

    // 根据当前扫描位选择数据
    assign digit_data = (digit_sel == 3'd0) ? sec_l  :
                        (digit_sel == 3'd1) ? sec_h  :
                        (digit_sel == 3'd2) ? min_l  :
                        (digit_sel == 3'd3) ? min_h  :
                        (digit_sel == 3'd4) ? hour_l :
                                              hour_h ;

    // 位选译码（低有效，从右到左：秒个位→秒十位→分个位→分十位→时个位→时十位）
    assign sel = (digit_sel == 3'd0) ? 6'b111110 :
                 (digit_sel == 3'd1) ? 6'b111101 :
                 (digit_sel == 3'd2) ? 6'b111011 :
                 (digit_sel == 3'd3) ? 6'b110111 :
                 (digit_sel == 3'd4) ? 6'b101111 :
                                      6'b011111 ;

    // 七段译码
    seg_decoder u_dec (
        .bcd (digit_data),
        .seg (seg)
    );

endmodule
