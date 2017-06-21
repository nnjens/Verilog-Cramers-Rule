module RAM0(a, d, we, clk, q);

  input [11:0] d;
  input[6:0] a;
  input we, clk;
  output [11:0] q;
  reg [11:0] w;
  reg[11:0] mem0 [31:0];
  
  integer i;
  
  initial begin
    for(i = 0; i < 32; i = i + 1) begin
	  mem0[i] = i;
	  end
	end
	
	always@(posedge clk) begin
	if(we)
	  mem0[a] <= d;
	  w <= mem0[a];
	end
	assign q = w;
	
endmodule
module RAM1(a, d, we, clk, q);

  input [11:0] d;
  input[6:0] a;
  input we, clk;
  output [11:0] q;
  reg [11:0] w;
  reg[11:0] mem1 [31:0];
  
  integer i;
  
  initial begin
    for(i = 0; i < 32; i = i + 1) begin
	  mem1[i] = i;
	  end
	end
	
	always@(posedge clk) begin
	if(we)
	  mem1[a] <= d;
	  w <= mem1[a];
	end
	assign q = w;
	
endmodule
module memory(switch, key_);
  input[11:0] switch;
  input [3:0] key_;
  //output[0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6;
  
  reg[11:0] address;
  reg[11:0] data_in0;
  reg[11:0] data_in1;
  wire[11:0] ram0_out;
  wire[11:0] ram1_out;
  reg[11:0] data0_out;
  reg[11:0] data1_out;
  
  assign we = switch[17];
  assign ram_select = switch[16];
  assign clk = key_[0];
  
  always @(posedge clk) begin
    address = switch[14:11];
	data_in0 = switch[11:0];
	data_in1 = switch[11:0];
	
	if(we)
	  if(ram_select)begin
	    data1_out = ram1_out;
	  end
	  else begin
	    data0_out = ram0_out;
      end
	else begin
	  data1_out = ram1_out;
	  data0_out = ram0_out;
	end
  end
  
  RAM0(address, data_in0, we, clk, ram0_out);
  RAM1(address, data_in1, we, clk, ram1_out);
  
  /*hex_7seg(SW[13:10], HEX6);
  hex_7seg(SW[7:4], HEX5);
  hex_7seg(SW[3:0], HEX4);
  hex_7seg(data1_out[7:4], HEX3);
  hex_7seg(data1_out[3:0], HEX2);
  hex_7seg(data0_out[7:4], HEX1);
  hex_7seg(data0_out[3:0], HEX0);*/
  
endmodule

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

module cramer2(HEX0,HEX1,HEX2,HEX4,HEX5,HEX6);
  wire[16:0] SW;
  wire [2:0] KEY;
  localparam STATE_A = 3'd0, STATE_B = 3'd1, STATE_C = 3'd2, STATE_D = 3'd3,
    STATE_E = 3'd4; //7 STATES TOTAL
  output HEX0, HEX1, HEX2, HEX4, HEX5, HEX6;
  reg HEX0, HEX1, HEX2, HEX4, HEX5, HEX6;
  reg[23:0] valX;
  wire clk;
  reg[23:0] valY;
  //DETERMINANTS
  reg[23:0] D;
  reg [23:0] Dx;
  reg [23:0] Dy;
  //MATRIX A
  reg signed[11:0] x1 = 12'd3;
  reg signed [11:0] y1 = 12'b0000_0000_0011;
  reg signed[11:0] x2 = 12'd5;
  reg signed[11:0] y2 = 12'd1;
  //MATRIX B CONSTANTS
  reg signed[11:0] c1 = 12'd1;
  reg signed[11:0] c2 = 12'd17;
  reg [2:0] curState;
  reg [2:0] nextState;
  //always @(*) begin
  assign clk = KEY[0];
   assign reset = SW[0];
	
			  //determine D
		  determinant(x1,y1,x2,y2,D);
		  memory mm(D,clk);
		  //determine Dx
		  determinant(c1,y1,c2,y2,Dx);
		  memory(Dx,clk);
		  //determine Dy
		  determinant(x1,c1,x2,c2,Dy);
		  memory(Dy,clk);
		  //solve valX/valY 
    always@( * ) begin
    nextState = STATE_A;
    case(curState)
      STATE_A: 
          nextState = STATE_B;
      STATE_B: 
		  nextState = STATE_C;
	  STATE_C:
	      nextState = STATE_D;
	  STATE_D:
		  nextState = STATE_E;
 
	endcase
  end
  always@(posedge clk) begin
	if(reset) curState<= STATE_A;
	else curState <= nextState;
  end
  //OUT LOGIC
  always@(posedge clk) begin
    if(reset) begin valX <= 0; valY <=0; end
	else begin 
	  case(curState)
	  STATE_A: begin
				        valX <= (Dx / D);
			valY <= (Dy / D);
		end
	  STATE_B: begin
	        valX <= (Dx / D);
			valY <= (Dy / D);
		end
	  STATE_C: begin
	       hex_7seg(valX[11:8], HEX6);
		  hex_7seg(valX[7:4], HEX5);
		  hex_7seg(valY[3:0], HEX4);
		 
		  hex_7seg(valY[3:0], HEX2);
		  hex_7seg(valY[7:4], HEX1);
		  hex_7seg(valY[3:0], HEX0); 
	    end
	  endcase
	 end 
  end  
endmodule
