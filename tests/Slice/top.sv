module top(input logic i, output logic o);

  typedef struct packed {
    logic [31:0] q;
  } qstruct_t;

  typedef struct packed {
    logic [31:0] d;
    logic        de;
  } rom_ctrl_hw2reg_digest_mreg_t;

  typedef struct packed {
    rom_ctrl_hw2reg_digest_mreg_t [7:0] digest; // [527:264]
  } rom_ctrl_regs_hw2reg_t;

  typedef struct packed {
    qstruct_t [7:0] digest; // [511:256]
    qstruct_t [7:0] exp_digest; // [255:0]
  } rom_ctrl_regs_reg2hw_t;

  rom_ctrl_regs_hw2reg_t hw2reg;
  rom_ctrl_regs_reg2hw_t reg2hw;

  logic [255:0] digest_q, exp_digest_q;
  logic [255:0] digest_d;


  for (genvar i = 0; i < 8; i++) begin: gen_csr_digest
    localparam int unsigned TopBitInt = 32 * i + 31;
    localparam bit [7:0] TopBit = TopBitInt[7:0];

    assign hw2reg.digest[i].d = digest_d[TopBit -: 32];

    assign digest_q[TopBit -: 32] = reg2hw.digest[i].q;
    assign exp_digest_q[TopBit -: 32] = reg2hw.exp_digest[i].q;
  end

endmodule
