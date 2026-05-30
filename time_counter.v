// time_counter.v
// 时间计数模块：实现 时:分:秒 BCD计数
// 作者：严博文

module time_counter (
    input  wire       clk,    // 50MHz
    input  wire       rst_n,
    output reg  [3:0] sec_l,  // 秒个位 0~9
    output reg  [3:0] sec_h,  // 秒十位 0~5
    output reg  [3:0] min_l,  // 分个位 0~9
    output reg  [3:0] min_h,  // 分十位 0~5
    output reg  [3:0] hour_l, // 时个位 0~9
    output reg  [3:0] hour_h  // 时十位 0~2
);

    // 1秒计数器：50MHz × 1s = 50,000,000
    parameter ONE_SEC = 26'd49_999_999;

    reg [25:0] cnt;
    wire sec_tick; // 每秒产生一个脉冲

    assign sec_tick = (cnt == ONE_SEC);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 26'd0;
        else if (sec_tick)
            cnt <= 26'd0;
        else
            cnt <= cnt + 26'd1;
    end

    // 秒计数
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sec_l <= 4'd0;
            sec_h <= 4'd0;
        end else if (sec_tick) begin
            if (sec_l == 4'd9) begin
                sec_l <= 4'd0;
                if (sec_h == 4'd5)
                    sec_h <= 4'd0;
                else
                    sec_h <= sec_h + 4'd1;
            end else begin
                sec_l <= sec_l + 4'd1;
            end
        end
    end

    // 分计数（每60秒进位）
    wire min_tick = sec_tick && (sec_l == 4'd9) && (sec_h == 4'd5);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            min_l <= 4'd0;
            min_h <= 4'd0;
        end else if (min_tick) begin
            if (min_l == 4'd9) begin
                min_l <= 4'd0;
                if (min_h == 4'd5)
                    min_h <= 4'd0;
                else
                    min_h <= min_h + 4'd1;
            end else begin
                min_l <= min_l + 4'd1;
            end
        end
    end

    // 时计数（每60分进位，24小时制）
    wire hour_tick = min_tick && (min_l == 4'd9) && (min_h == 4'd5);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hour_l <= 4'd0;
            hour_h <= 4'd0;
        end else if (hour_tick) begin
            if (hour_h == 4'd2 && hour_l == 4'd3) begin
                // 23:59:59 -> 00:00:00
                hour_l <= 4'd0;
                hour_h <= 4'd0;
            end else if (hour_l == 4'd9) begin
                hour_l <= 4'd0;
                hour_h <= hour_h + 4'd1;
            end else begin
                hour_l <= hour_l + 4'd1;
            end
        end
    end

endmodule
