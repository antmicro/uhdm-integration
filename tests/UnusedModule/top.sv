module top(input logic [7:0] e[2]);
   test i(.a(e));
endmodule

module test #(parameter useModule = 0)(
    input  logic [7:0] a[2]
);

   if (useModule == 1) begin
	   unused t (.a(a));
   end

endmodule

module unused (
    input  logic [7:0] a[2]
);
    assign b  = a[0][7:0];
endmodule
