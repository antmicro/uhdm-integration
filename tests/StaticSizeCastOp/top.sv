module top (
    output wire [ 7:0] out1,
    output wire [ 7:0] out2,
    output wire [15:0] out3,
    output wire [15:0] out4,
    output wire [15:0] out5,
    output wire [15:0] out6
);

  // 8-bit wide outputs.
  assign out1 = 1 << 15;
  assign out2 = 8'(1 << 15);

  // 16-bit wide outputs.
  assign out3 = 1 << 15;
  assign out4 = 8'(1 << 15);
  assign out5 = 16'(8'(1 << 15));
  assign out6 = {8{2'(1'b1)}};

endmodule : top
