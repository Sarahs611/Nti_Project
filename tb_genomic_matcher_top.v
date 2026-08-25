`timescale 1ns/1ps

module tb_genomic_matcher_top;
    parameter SEQ_LEN = 4;
    parameter CHAR_WIDTH = 2;
    parameter SCORE_WIDTH = 8;

    reg clk, rst, start;
    reg [(SEQ_LEN*CHAR_WIDTH)-1:0] seq_a;
    reg [(SEQ_LEN*CHAR_WIDTH)-1:0] seq_b;
    
    wire signed [SCORE_WIDTH-1:0] score;
    wire done;

    
    genomic_matcher_top #( .SEQ_LEN(SEQ_LEN), .CHAR_WIDTH(CHAR_WIDTH),
           .SCORE_WIDTH(SCORE_WIDTH) 
     ) inst (
        .clk(clk), .rst(rst), .start(start),
        .seq_a_in(seq_a), .seq_b_in(seq_b),
        .final_score(score), .done(done)
    );

    
 always #5 clk = ~clk;

   initial begin

      clk = 0; rst = 1; start = 0;
      seq_a = 0; seq_b = 0;
        
      #10 rst = 0;
      $display("-- Genomic Sequence Verification --");
      
      // Test 1: All Match (ACGT vs ACGT),(Expected Score:+4)
      // A=00, C=01, G=10, T=11 (Binary packed: 11_10_01_00)
        seq_a = 8'b11_10_01_00; 
        seq_b = 8'b11_10_01_00;
        #10 start = 1;
        #10 start = 0;
        wait(done == 1);
        $display("Test 1 (All Match) | Actual: %0d", score);
        #15;

      // Test 2: All Mismatch (ACGT vs TGCA),(Expected Score:-4)
      // seq_a: ACGT (11_10_01_00), seq_b: TGCA (00_01_10_11)
        seq_a = 8'b11_10_01_00;
        seq_b = 8'b00_01_10_11;
        start = 1;
        #10 start = 0;
        wait(done == 1);
        $display("Test 2 (All Mismatch) | Actual: %0d", score);
        #15;

      // Test 3: Mixed (ACGT vs ACTT), (Expected Score:+2)
      // seq_a: ACGT (11_10_01_00), seq_b: ACTT (11_11_01_00) 
        seq_a = 8'b11_10_01_00;
        seq_b = 8'b11_11_01_00;
        start = 1;
        #10 start = 0;
        wait(done == 1);
        $display("Test 3 (Mixed) | Actual: %0d", score);
        #15;

      // Test 4: Zero-Score Scenario (2 Matches, 2 Mismatches)
      // seq_a: CCAA (01_01_00_00), seq_b: GGAA (10_10_00_00)
        seq_a = 8'b01_01_00_00;
        seq_b = 8'b10_10_00_00;
        start = 1;
        #10 start = 0;
        wait(done == 1);
        $display("Test 4 (Zero-Score) | Actual: %0d", score);
        #15;

      // Test 5: Asynchronous Reset Mid-Transaction
      // Start a match, then hit reset before it finishes
        seq_a = 8'b11_10_01_00; 
        seq_b = 8'b11_10_01_00; 
        start = 1;
        #10 start = 0;
        
        // Wait 2 clock cycles to ensure FSM enter COMPARE state
        #20;
        
        rst = 1; 
        #10;
        rst = 0;
        
        // Check system safely cleared the score (Expected: 0)
        $display("Test 5 (Async Reset) | Actual: %0d", score);
        #15;

        $display(" Verification done ");
        $stop;
    end
endmodule
