module seq_regs #(
  parameter SEQ_LEN    = 4,
  parameter CHAR_WIDTH = 2  // 2-bit ACGT encoding
)(
  input  wire   clk,
  input  wire   rst,
  input  wire   load,  // pulse to load a full sequence
  input  wire [SEQ_LEN*CHAR_WIDTH-1:0] seq_a_in,  // packed input bus
  input  wire [SEQ_LEN*CHAR_WIDTH-1:0] seq_b_in,
  input  wire [$clog2(SEQ_LEN)-1:0]    index,       // from Counter unit
  output wire [CHAR_WIDTH-1:0]         seq_a_char,
  output wire [CHAR_WIDTH-1:0]         seq_b_char
);

  reg [CHAR_WIDTH-1:0] seq_a [0:SEQ_LEN-1];
  reg [CHAR_WIDTH-1:0] seq_b [0:SEQ_LEN-1];

  integer i;
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      for (i = 0; i < SEQ_LEN; i = i + 1) begin
        seq_a[i] <= 0;
        seq_b[i] <= 0;
      end
    end else if (load) begin
      for (i = 0; i < SEQ_LEN; i = i + 1) begin
        seq_a[i] <= seq_a_in[i*CHAR_WIDTH +: CHAR_WIDTH];
        seq_b[i] <= seq_b_in[i*CHAR_WIDTH +: CHAR_WIDTH];
      end
    end
  end

  assign seq_a_char = seq_a[index];
  assign seq_b_char = seq_b[index];

endmodule
