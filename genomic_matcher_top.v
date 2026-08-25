module genomic_matcher_top #( parameter SEQ_LEN = 4,
   parameter CHAR_WIDTH = 2,
   parameter SCORE_WIDTH = 8)
(
    input  wire clk,rst, start,
    input  wire [(SEQ_LEN*CHAR_WIDTH)-1:0] seq_a_in,
    input  wire [(SEQ_LEN*CHAR_WIDTH)-1:0] seq_b_in,
    output wire signed [SCORE_WIDTH-1:0] final_score,
    output wire done
);

    wire load, index_rst,counter_enable;
    wire score_clear,score_enable,last_index ;
   
    wire [$clog2(SEQ_LEN)-1:0] current_index;
    wire [CHAR_WIDTH-1:0] char_a;
    wire [CHAR_WIDTH-1:0] char_b;

 
    fsm_controlF inst_fsm (
        .clk(clk), .rst(rst), .start(start), .last_index(last_index),
        .load(load), .index_rst(index_rst), .counter_enable(counter_enable),
        .score_clear(score_clear), .score_enable(score_enable), .done(done)
    );

 
    seq_regs #( .SEQ_LEN(SEQ_LEN), .CHAR_WIDTH(CHAR_WIDTH)
    ) inst_regs (
        .clk(clk), .rst(rst), .load(load), .seq_a_in(seq_a_in), .seq_b_in(seq_b_in),
        .index(current_index), .seq_a_char(char_a), .seq_b_char(char_b)
    );

    counter_indexing #( .seq_len(SEQ_LEN)
    ) inst_counter (
        .clk(clk), .rst(rst), .enable(counter_enable), 
        .index_rst(index_rst),.index(current_index), 
        .last_index(last_index)
    );

    comparator_score #( .data_width(CHAR_WIDTH), .score_width(SCORE_WIDTH)
    ) inst_score (
        .clk(clk), .rst(rst), .enable(score_enable), .clear(score_clear),
        .seq_a(char_a), .seq_b(char_b), .score(final_score)
    );

endmodule
