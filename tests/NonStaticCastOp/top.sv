module top (
input wire [ 7:0] in7,
output wire [15:0] out7
);
assign out7 = {{8{2'(1'b1)}}, in7};
endmodule
