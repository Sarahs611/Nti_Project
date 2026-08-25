module fsm_controlF (  input  wire clk, input  wire rst,
    input  wire start, input  wire last_index,  output reg load,
    output reg index_rst, output reg counter_enable, output reg score_clear,
    output reg score_enable, output reg done
);

                            // FSM states
 parameter IDLE = 2'b00;
 parameter COMPARE = 2'b01;
 parameter DONE = 2'b10;

  reg [1:0] state;

    // State transition
 always @(posedge clk or posedge rst) begin
  if (rst)
     state <= IDLE;
     else begin
         case (state)
            IDLE: begin
               if (start)
                 state <= COMPARE;
                end

             COMPARE: begin
              if (last_index)
                   state <= DONE;
                end

             DONE: begin
                    state <= IDLE;
                end

             default:
               state <= IDLE;

     endcase
  end
 end

    // Control signals
 always @(*) begin

        // Default values
    load = 0;
    index_rst = 0;
    counter_enable = 0;
    score_clear = 0;
    score_enable = 0;
    done = 0;

   case (state)
      IDLE: begin
         if (start) begin
          load = 1;
          index_rst = 1;
          score_clear = 1;
         end
     end

      COMPARE: begin
       score_enable = 1;
       counter_enable = 1;
     end
         DONE: begin
           done = 1;
        end
        endcase
  end

endmodule
