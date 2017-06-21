// AUTHOR: NICHOLAS JENS 997941942
// LAB 6, PART 1 - BINARY CODE

module determinant(x1,y1,x2,y2,det);
  output reg [23:0] det;
  input signed[11:0] x1;
  input signed[11:0] y1;
  input signed[11:0] x2;
  input signed[11:0] y2;
  reg signed [23:0] a1;
  reg signed [23:0] a2;
  //wire [23:0] a3;
  
  always @(*) begin
    a1 = x1 * y2;
	a2 = x2 * y1;
	det = a1 - a2;
  end
  
endmodule
