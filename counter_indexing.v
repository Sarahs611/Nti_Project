module counter_indexing 
#(
    parameter seq_len = 4
)(
    input  clk,
    input  rst,        // active-high 
    input  enable,      
    input  index_rst,   
    output reg  [$clog2(seq_len)-1:0]  index,
    output last_index
);


    always @(posedge clk or posedge rst) begin
        if (rst)
            index <= 0;
        else if (index_rst)
            index <= 0;
        else if (enable && !last_index )
            index <= index + 1;
    end

    assign last_index = (index == seq_len - 1);

endmodule