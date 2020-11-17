module top();
  logic       [31:0] fetch_addr_n;
  logic       [31:0] fetch_addr_n2;
  assign fetch_addr_n = 1'b0;
  assign fetch_addr_n = { fetch_addr_n2[31:1], 1'b0 };
  assign fetch_addr_n = { fetch_addr_n2[31:2], 2'b00 };
  assign fetch_addr_n = { fetch_addr_n2[31:1], 1'b1 };
  assign fetch_addr_n = { fetch_addr_n2[31:2], 2'b01 };
  assign fetch_addr_n = { fetch_addr_n2[31:1], 1'bx };
  assign fetch_addr_n = { fetch_addr_n2[31:2], 2'b0x };
  assign fetch_addr_n = { fetch_addr_n2[31:1], 1'bz };
  assign fetch_addr_n = { fetch_addr_n2[31:2], 2'b0z };

endmodule
