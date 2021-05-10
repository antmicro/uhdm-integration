module top;
   import "DPI-C" function chandle malloc(int size);

   import "DPI-C" function void free(input chandle ptr);

     chandle a;

     initial begin
	a = malloc(10);
	free(a);
     end
endmodule
