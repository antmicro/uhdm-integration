module top(output reg a, output reg b);
   string c = "Test_string";
   string d;
   initial
      begin
	 d = "Test_assign";
	 if(c == "Test") begin
            a = 1;
	    b = 0;
	    c = "yes";
	 end else begin
            a = 0;
	    b = 1;
	    c = "no";
	 end
      end
endmodule
