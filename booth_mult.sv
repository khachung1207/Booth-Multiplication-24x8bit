module booth_mult (clk, rst_n, load, A, B, P);
  parameter A_WIDTH = 24;
  parameter B_WIDTH = 8;
  parameter P_WIDTH = A_WIDTH + B_WIDTH;
  
  input clk, rst_n;
  input load;
  input [A_WIDTH-1:0] A;
  input [B_WIDTH-1:0] B;
  output [P_WIDTH-1:0] P;
  
  //Declare internal signal
  //Write code here
  reg [A_WIDTH-1:0] A_reg;
  reg [P_WIDTH : 0] P_B_reg , P_B_reg_sra_1 ;
  wire booth_enc_2A, booth_enc_A, booth_enc_neg;
  reg [A_WIDTH:0] adderA, adderB; 
  wire [A_WIDTH:0]adderS;
  
  //A_WIDTH-bit Register for Multiplicand A
  //Write code here
  always @(posedge clk or posedge rst_n ) begin
    if (!rst_n) begin 
      A_reg <= 0;
      P_B_reg <= 0;
    end
    else if (load ) begin
      A_reg <= A;
      P_B_reg <= { B, 1'b0};
    end
    else begin
      A_reg <= A_reg;
      P_B_reg <= $signed({adderS, P_B_reg_sra_1[B_WIDTH-1:0]}) >>> 1 ;
    end
  end
    
  
  //(A_WIDTH + B_WIDTH + 1)-bit Register for Product (P) and Multiplier (B)
  //Write code here
  
  
  //Booth encoder
  //Write code here
  wire [2:0]booth_enc_in = {P_B_reg [2:0]};
  booth_encoder inst_booth_encoder(
    .booth_enc_in( booth_enc_in),
    .booth_enc_neg (booth_enc_neg),
    .booth_enc_A(booth_enc_A),
    .booth_enc_2A(booth_enc_2A)
  );
  
  
  //Shift Right Arithmetic
  //Write code here
  always @(*) begin
    P_B_reg_sra_1= $signed(P_B_reg) >>>1;
    adderA = P_B_reg_sra_1[P_WIDTH:B_WIDTH] ;
    
    if (booth_enc_A) adderB = { A_reg[A_WIDTH-1], A_reg };
    else if (booth_enc_2A) adderB = $signed({ A_reg[A_WIDTH-1], A_reg <<1 });
    else adderB = 0;
  end
  
  //Add_sub_unit
  //Write code here
  add_sub_unit ins_sub_unit(adderA, adderB, booth_enc_neg, adderS );
 
    
  
  
  //Determine output P
  //Write code here
  assign P= $signed(P_B_reg) >>>1;
  
  
endmodule