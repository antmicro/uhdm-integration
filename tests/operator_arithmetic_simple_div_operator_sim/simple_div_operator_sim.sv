/*
:name: simple_div_operator_sim
:description: minimal / operator simulation test (without result verification)
:type: simulation parsing
:tags: 11.4.3
*/
module top(input [3:0] a, input [3:0] b, output [3:0] c);
    assign c = a / b;
endmodule