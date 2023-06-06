module bsg_mem_1r1w_synth_width_p16_els_p2_read_write_same_addr_p0
(
  w_clk_i,
  w_v_i,
  w_addr_i,
  w_data_i,
  r_addr_i,
  r_data_o
);

  input [0:0] w_addr_i;
  input [15:0] w_data_i;
  input [0:0] r_addr_i;
  output [15:0] r_data_o;
  input w_clk_i;
  input w_v_i;
  wire [15:0] r_data_o;
  wire N0,N1,N2,N3,N4,N5,N7,N8;
  wire [31:0] \nz.mem ;
  reg \nz.mem_31_sv2v_reg ,\nz.mem_15_sv2v_reg ;
  assign \nz.mem [31] = \nz.mem_31_sv2v_reg ;
  assign \nz.mem [15] = \nz.mem_15_sv2v_reg ;

  assign r_data_o[15] = (N3)? \nz.mem [15] :
                        (N0)? \nz.mem [31] : 1'b0;
  assign { N8, N7 } = (N1)? { w_addr_i[0:0], N5 } :
                      (N2)? { 1'b0, 1'b0 } : 1'b0;
  assign N1 = w_v_i;
  assign N2 = N4;
  assign N3 = ~r_addr_i[0];

  always @(posedge w_clk_i) begin
    if(N8) begin
      \nz.mem_31_sv2v_reg  <= w_data_i[15];
    end 
    if(N7) begin
      \nz.mem_15_sv2v_reg  <= w_data_i[15];
    end 
  end

endmodule


module bsg_two_fifo_width_p16_ready_THEN_valid_p1
(
  clk_i,
  reset_i,
  ready_o,
  data_i,
  v_i,
  v_o,
  data_o,
  yumi_i
);

  input [15:0] data_i;
  output [15:0] data_o;
  input clk_i;
  input reset_i;
  input v_i;
  input yumi_i;
  output ready_o;
  output v_o;
  wire [15:0] data_o;
  wire ready_o,v_o,tail_r,_0_net_,head_r,empty_r,full_r,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,
  N10,N11,N12,N13,N14;
  reg full_r_sv2v_reg,tail_r_sv2v_reg,head_r_sv2v_reg,empty_r_sv2v_reg;
  assign full_r = full_r_sv2v_reg;
  assign tail_r = tail_r_sv2v_reg;
  assign head_r = head_r_sv2v_reg;
  assign empty_r = empty_r_sv2v_reg;

  bsg_mem_1r1w_synth_width_p16_els_p2_read_write_same_addr_p0
  synth
  (
    .w_clk_i(clk_i),
    .w_v_i(v_i),
    .w_addr_i(tail_r),
    .w_data_i(data_i),
    .r_addr_i(head_r),
    .r_data_o(data_o)
  );

  assign _0_net_ = ~empty_r;
  assign v_o = ~empty_r;
  assign ready_o = ~full_r;
  assign N2 = ~head_r;
  assign N3 = N6 | N9;
  assign N6 = empty_r & N5;
  assign N5 = ~v_i;
  assign N9 = N8 & N5;

  always @(posedge clk_i) begin
    if(reset_i) begin
      full_r_sv2v_reg <= 1'b0;
      empty_r_sv2v_reg <= 1'b1;
    end else if(1'b1) begin
      full_r_sv2v_reg <= N4;
      empty_r_sv2v_reg <= N3;
    end 
    if(reset_i) begin
      head_r_sv2v_reg <= 1'b0;
    end else if(yumi_i) begin
      head_r_sv2v_reg <= N2;
    end 
  end

endmodule
