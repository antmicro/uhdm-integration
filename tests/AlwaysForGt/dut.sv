module dut();

logic [7:0] region_perm_check;
logic [7:0] access_fault;

always begin
  for (int r = 1; r >= 'u0; r=r-'u1) begin
      access_fault[r] = ~region_perm_check[r];
  end
end

endmodule
