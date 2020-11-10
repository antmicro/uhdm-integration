module top(input logic [7:0] e[2]);
   PLLE2_ADV #(
     .TEST ("TEST PARAMETER")
   ) pll ();
endmodule

module PLLE2_ADV #(parameter TEST = "")();

endmodule
