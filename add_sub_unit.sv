module add_sub_unit  #(parameter WIDTH = 25 ) (A, B, SnA, S);
  //Write code here
  input [WIDTH-1:0] A, B;
  input SnA;
  output [WIDTH-1:0] S;

  assign S = {1'b0,A} + ({1'b0,B} ^ {(WIDTH){SnA}}) + SnA;
endmodule 

