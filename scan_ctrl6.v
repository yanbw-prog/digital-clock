// scan_ctrl6.v
// 6位数码管扫描控制模块
// 作者：严博文

module scan_ctrl6 (
    input  wire       clk,
    input  wire       rst_n,
    output reg  [2:0] digit_sel  // 0~5
);

    parameter DIV_CNT = 16'd49999; // 50MHz / 50000 = 1kHz

    reg [15:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 16'd0;
            digit_sel <= 3'd0;
        end else begin
            if (cnt == DIV_CNT) begin
                cnt <= 16'd0;
                if (digit_sel == 3'd5)
                    digit_sel <= 3'd0;
                else
                    digit_sel <= digit_sel + 3'd1;
            end else begin
                cnt <= cnt + 16'd1;
            end
        end
    end

endmodule
