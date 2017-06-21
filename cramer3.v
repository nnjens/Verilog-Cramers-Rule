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

module cramer3(HEX0,HEX1,HEX2,HEX4,HEX5,HEX6);
  output HEX0, HEX1, HEX2, HEX4, HEX5, HEX6;
  reg HEX0, HEX1, HEX2, HEX4, HEX5, HEX6;
  reg[23:0] valX;
  reg[23:0] valY;
  reg[23:0] valZ;
  //DETERMINANTS
  wire [23:0] D;
  wire [23:0] Dx;
  wire [23:0] Dy;
  wire [23:0] Dz;
  wire [23:0] D1;
  wire [23:0] D2;
  wire [23:0] D3;
  wire [23:0] D4;
  wire [23:0] D5;
  wire [23:0] D6;
  wire [23:0] D7;
  wire [23:0] D8;
  wire [23:0] D9;
  wire [23:0] D10;
  wire [23:0] D11;
  wire [23:0] D12;
  //MATRIX A
  wire signed[11:0] x1 = 12'd3;
  wire signed [11:0] y1 = 12'b0000_0000_0011;
  wire signed [11:0] z1 = 12'd0;
  wire signed[11:0] x2 = 12'd5;
  wire signed[11:0] y2 = 12'd1;
  wire signed [11:0] z2 = 12'd1;
   wire signed[11:0] x3 = 12'd5;
  wire signed[11:0] y3 = 12'd1;
  wire signed [11:0] z3 = 12'd1;
  //MATRIX B CONSTANTS
  wire signed[11:0] c1 = 12'd1;
  wire signed[11:0] c2 = 12'd17;
  wire signed[11:0] c3 = 12'd17;
  //always @(*) begin
  //determine D
  determinant(y2,z2,y3,z3,D1);
  determinant(x2,z2,x3,z3,D2);
  determinant(x2,y2,x3,y3,D3);
  //D = D1 * x1 - D2 * y1 + D3 * z1;
  //determine Dx
  determinant(y2,z2,y3,z3,D4);
  determinant(c2,z2,c3,z3,D5);
  determinant(c2,y2,c3,y3,D6);
  //Dx = D4 * c1 - D5 * y1 + D6 * z1;
  //determine Dy
  determinant(c2,z2,c3,z3,D7);
  determinant(x2,z2,x3,z3,D8);
  determinant(x2,c2,x3,c3,D9);
  //Dy = D7 * x1 - D8 * c1 + D9 * z1;
  //determine Dz
  determinant(y2,c2,y3,c3,D10);
  determinant(x2,c2,x3,c3,D11);
  determinant(x2,y2,x3,y3,D12);
  //Dz = D10 * x1 - D11 * y1 + D12 * c1;
  //solve valX/valY  
  always@(*) begin
  valX <= (Dx / D);
  valY <= (Dy / D);
  valZ <= (Dz / D);
  end
  
endmodule
