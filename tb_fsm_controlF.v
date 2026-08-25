`timescale 1ns/1ps

module tb_fsm_controlF;

    reg clk;
    reg rst;
    reg start;
    reg last_index;
    wire load;
    wire index_rst;
    wire counter_enable;
    wire score_clear;
    wire score_enable;
    wire done;

  
fsm_controlF uut ( .clk(clk), .rst(rst), .start(start), .last_index(last_index),
 .load(load), .index_rst(index_rst), .counter_enable(counter_enable),
 .score_clear(score_clear), .score_enable(score_enable), .done(done)
 );


    always #5 clk = ~clk;

    initial begin

        // Initial
        clk = 0;
        rst = 1;
        start = 0;
        last_index = 0;

        // Reset
        #10;
        rst = 0;

        #5;            // Start the operation
        start = 1;

        #10;
        start = 0;

        #20; // compare

          last_index = 1; // last index

        #10;
        last_index = 0;

        // Wait
        #10;
        $stop;
    end

endmodule
