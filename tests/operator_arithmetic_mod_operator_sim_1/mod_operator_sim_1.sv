/*
:name: mod_operator_sim_1
:description: % operator test in simulation
:type: simulation parsing
:tags: 11.4.3
*/
module top();
wire [31:0] a;
wire [31:0] b;
wire [31:0] c;
assign a = 32'd4;
assign b = 32'd4;
assign c = a % b;
initial begin
    $display(":assert: (int(%s) == %d)", "4%4", c);
end
endmodule