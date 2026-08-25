module tb_comparator_score;
parameter data_width =2;
parameter score_width=8;
    reg clk;
    reg rst;
    reg enable;
    reg clear;
    reg [data_width-1:0] seq_a;
    reg [data_width-1:0] seq_b;
    wire signed [score_width-1:0] score ;
    
    comparator_score  uut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .clear(clear),
        .seq_a(seq_a),
        .seq_b(seq_b),
        .score(score)
    );
    initial begin
        clk=0;
        forever #5 clk=~clk;
    end
    initial begin
        rst =1;
        enable =0;
        clear=0;
        #5;
        
        rst =0;
        clear = 1;
        seq_a = 2'b11;
        seq_b = 2'b10; #10;
        clear=0;
        enable =1'b1;
         seq_a = 2'b11;
        seq_b = 2'b11;#10;
        enable =1'b1;
         seq_a = 2'b10;
        seq_b = 2'b10;#10;
        enable =1'b1;
         seq_a = 2'b10;
        seq_b = 2'b11;#10;
        enable =1'b1;
         seq_a = 2'b01;
        seq_b = 2'b10;#10;
        enable =1'b1;
         seq_a = 2'b10;
        seq_b = 2'b11;#10;
        $stop;
    end

endmodule
