module comparator_score #(
    parameter data_width =2,
              score_width = 8
) (
    input clk,
    input rst,
    input enable,
    input clear,
    input [data_width-1:0] seq_a,
    input [data_width-1:0] seq_b,
    output reg signed [score_width-1:0] score
);
   
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            score <= 0;
        end
        else if (clear) begin
            score <= 0 ;
        end
        else if (enable) begin
            if (seq_a == seq_b) begin
                score <= score +1'b1;
            end else begin
                score <= score -1'b1;
            end
        end
    end
endmodule
