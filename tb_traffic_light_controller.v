`timescale 1ns / 1ps

module tb_traffic_light_controller;

    // =========================================================================
    // Signal Declarations
    // =========================================================================
    reg clk;
    reg rst;
    
    wire YESIL1, SARI1, KIRMIZI1;
    wire YESIL2, SARI2, KIRMIZI2;
    wire YESIL3, SARI3, KIRMIZI3;
    wire YESIL4, SARI4, KIRMIZI4;
    wire SAG_OUT_1, SAG_OUT_2, SAG_OUT_3, SAG_OUT_4;

    // =========================================================================
    // Clock Generation (100MHz -> 10ns period)
    // =========================================================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // =========================================================================
    // DUT Instantiation
    // =========================================================================
    traffic_light_controller #(
        .CLK_FREQ(4),
        .GREEN_TIME(10),
        .YELLOW_TIME(2)
    ) dut (
        .clk(clk),
        .rst(rst),
        .YESIL1(YESIL1), .SARI1(SARI1), .KIRMIZI1(KIRMIZI1),
        .YESIL2(YESIL2), .SARI2(SARI2), .KIRMIZI2(KIRMIZI2),
        .YESIL3(YESIL3), .SARI3(SARI3), .KIRMIZI3(KIRMIZI3),
        .YESIL4(YESIL4), .SARI4(SARI4), .KIRMIZI4(KIRMIZI4),
        .SAG_OUT_1(SAG_OUT_1),
        .SAG_OUT_2(SAG_OUT_2),
        .SAG_OUT_3(SAG_OUT_3),
        .SAG_OUT_4(SAG_OUT_4)
    );

    // =========================================================================
    // Test Stimulus
    // =========================================================================
    initial begin
        $dumpfile("dalga.vcd");
        $dumpvars(0, tb_traffic_light_controller); // <<< KRİTİK SATIR

        rst = 1;
        #100;
        rst = 0;

        #3000;
        $display("Simulation Completed.");
        $finish;
    end

endmodule
