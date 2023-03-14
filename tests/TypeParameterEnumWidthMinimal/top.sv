module top
(
);
  localparam int StateWidth = 9;
  typedef enum logic [StateWidth-1:0] {
    StActive = 9'b100100001
  } state_e;

endmodule : top
