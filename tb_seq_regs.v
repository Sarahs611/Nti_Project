`timescale 1ns/1ps
module tb_seq_regs;

  parameter SEQ_LEN = 4;
  parameter CHAR_WIDTH = 2;

  reg clk;
  reg rst;
  reg load;

  reg [SEQ_LEN*CHAR_WIDTH-1:0] seq_a_in;
  reg [SEQ_LEN*CHAR_WIDTH-1:0] seq_b_in;

  reg [$clog2(SEQ_LEN)-1:0] index;

  wire [CHAR_WIDTH-1:0] seq_a_char;
  wire [CHAR_WIDTH-1:0] seq_b_char;


  // Instantiate your module
  seq_regs #(
    .SEQ_LEN(SEQ_LEN),
    .CHAR_WIDTH(CHAR_WIDTH)
  ) uut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .seq_a_in(seq_a_in),
    .seq_b_in(seq_b_in),
    .index(index),
    .seq_a_char(seq_a_char),
    .seq_b_char(seq_b_char)
  );


  // Clock generation
  always #5 clk = ~clk;


  initial begin

    // Initial values
    clk = 0;
    rst = 1;
    load = 0;
    index = 0;

    seq_a_in = 8'b11100100;  // ACGT
    seq_b_in = 8'b11110100;  // ACTT


    // Reset
    #10;
    rst = 0;

    // Load sequences
    #5;
    load = 1;

    #10;
    load = 0;


    // Check position 0
    index = 0;
    #5;
    $display("Index = %d | A = %b | B = %b",
             index, seq_a_char, seq_b_char);

    // Check position 1
    index = 1;
    #5;
    $display("Index = %d | A = %b | B = %b",
             index, seq_a_char, seq_b_char);

    // Check position 2
    index = 2;
    #5;
    $display("Index = %d | A = %b | B = %b",
             index, seq_a_char, seq_b_char);

    // Check position 3
    index = 3;
    #5;
    $display("Index = %d | A = %b | B = %b",
             index, seq_a_char, seq_b_char);


    #10;
    $stop;

  end

endmodule
