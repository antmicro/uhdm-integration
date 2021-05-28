module dut
  import pkg1::*;
#(
  parameter named_type_t named_type = named_type_default
) (
  output struct1 var1,
  output pkg2::struct1 var2
);

  initial begin
    for (int i=0; i<7; i++) begin
      var1.first[i] = 1;
    end
  end
  assign var2.second = 127;

endmodule;
