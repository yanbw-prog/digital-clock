// tb_clock.v
// 数字时钟仿真测试文件
// 作者：严博文

`timescale 1ns / 1ps

module tb_clock;

    reg        clk;
    reg        rst_n;
    wire [5:0] sel;
    wire [6:0] seg;

    // 实例化顶层
    clock_top u_top (
        .clk   (clk),
        .rst_n (rst_n),
        .sel   (sel),
        .seg   (seg)
    );

    // 50MHz时钟
    initial clk = 0;
    always #10 clk = ~clk;

    // 激励：加速仿真，验证秒进位
    initial begin
        rst_n = 0;
        #100;
        rst_n = 1;
        // 仿真3秒（实际时间较长，可调小ONE_SEC参数加速）
        #3_000_000_000;
        $finish;
    end

    initial begin
        $dumpfile("tb_clock.vcd");
        $dumpvars(0, tb_clock);
    end

endmodule
