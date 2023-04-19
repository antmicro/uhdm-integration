package my_package;

  typedef struct packed {
    logic a;
    logic b;
    logic c;
    logic d;
  } my_struct;

  parameter my_package::my_struct my_parameter = '{
    a: 1'b1,
    b: 1'b0,
    c: 1'b1,
    d: 1'b0
  };

endpackage : my_package

module my_module (
    output my_package::my_struct z,
    output logic y,
    output logic x,
    output logic w,
    output logic v,
    output my_package::my_struct zz,
    output logic yy,
    output logic xx,
    output logic ww,
    output logic vv
);

  my_package::my_struct test_struct;
 
  always_comb begin
    test_struct = '{
      a: 1'b0,
      b: 1'b1,
      c: 1'b0,
      d: 1'b1
    };
  end
 
  assign z = my_package::my_parameter;
  assign y = my_package::my_parameter.a;
  assign x = my_package::my_parameter.b;
  assign w = my_package::my_parameter.c;
  assign v = my_package::my_parameter.d;
  assign zz = test_struct;
  assign yy = test_struct.a;
  assign xx = test_struct.b;
  assign ww = test_struct.c;
  assign vv = test_struct.d;
 
endmodule : my_module
