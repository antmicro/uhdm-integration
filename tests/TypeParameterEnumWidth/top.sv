module test_module #(
  parameter type StateEnumT = logic
) (
  input  StateEnumT state_i
);
endmodule

module top
(
);
  localparam int StateWidth = 9;
  typedef enum logic [StateWidth-1:0] {
    StActive = 9'b100100001
  } state_e;

  state_e state_d;

  test_module #(
    .StateEnumT(state_e)
  ) u_state_regs (
    .state_i (state_d)
  );

endmodule : top
