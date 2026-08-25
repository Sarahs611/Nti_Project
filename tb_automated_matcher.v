`timescale 1ns/1ps

module tb_automated_matcher;
    parameter SEQ_LEN = 4;
    parameter CHAR_WIDTH = 2;
    parameter SCORE_WIDTH = 8;
    parameter NUM_TESTS = 50; 

    reg clk, rst, start;
    reg [(SEQ_LEN*CHAR_WIDTH)-1:0] seq_a;
    reg [(SEQ_LEN*CHAR_WIDTH)-1:0] seq_b;
    
    wire signed [SCORE_WIDTH-1:0] score;
    wire done;

    // Arrays to hold data read from MATLAB's files
    reg [(SEQ_LEN*CHAR_WIDTH)-1:0] mem_seq_a [0:NUM_TESTS-1];
    reg [(SEQ_LEN*CHAR_WIDTH)-1:0] mem_seq_b [0:NUM_TESTS-1];
    reg [SCORE_WIDTH-1:0] mem_expected_score [0:NUM_TESTS-1];

    genomic_matcher_top #( .SEQ_LEN(SEQ_LEN), .CHAR_WIDTH(CHAR_WIDTH), 
        .SCORE_WIDTH(SCORE_WIDTH) ) inst (
        .clk(clk), .rst(rst), .start(start),
        .seq_a_in(seq_a), .seq_b_in(seq_b),
        .final_score(score), .done(done)
    );

    always #5 clk = ~clk;

    integer i;
    integer errors;
    reg signed [SCORE_WIDTH-1:0] expected;

    initial begin
        //Load 
        $readmemb("seq_a.mem", mem_seq_a);
        $readmemb("seq_b.mem", mem_seq_b);
        $readmemb("expected_scores.mem", mem_expected_score);

        clk = 0; rst = 1; start = 0;
        errors = 0;
        
        #10 rst = 0;
        $display("-- Starting Automated Golden Model Verification --");

        for (i=0; i<NUM_TESTS; i=i+1) begin
            wait(done == 0); 
            @(negedge clk);
            
            // Feed  randomized data into the hardware
            seq_a = mem_seq_a[i];
            seq_b = mem_seq_b[i];
            expected = mem_expected_score[i];
            
            start = 1;
            #10 start = 0;
            
            wait(done == 1);
            
            //Compare Hardware output vs MATLAB expected output
            if (score !== expected) begin
                $display("ERROR at test %0d: seq_a=%b, seq_b=%b | Expected: %0d, Actual: %0d", 
                          i+1, seq_a, seq_b, expected, score);
                errors = errors + 1;
            end
        end

        //Print final results
        if (errors == 0)
            $display("SUCCESS: All %0d randomized tests passed and matched MATLAB perfectly!", NUM_TESTS);
        else
            $display("FAILED: %0d errors found.", errors);
            
        $display("Verification Complete");
        $stop;
    end
endmodule
