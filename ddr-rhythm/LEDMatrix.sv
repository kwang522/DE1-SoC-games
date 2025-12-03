module LEDMatrix(clk, reset, speed, r1, r2, r3, r4, sig1, sig2, sig3, sig4, RedPixels, score, en);
    input logic clk, reset;
    input logic r1, r2, r3, r4;
	 input logic sig1, sig2, sig3, sig4;
	 input logic [9:0] speed;
	 input logic en;
    output logic [15:0][15:0] RedPixels;
    output logic [19:0] score;
	
    integer i, j; 
    
    always_ff @(posedge clk) begin
        if (reset) begin
            RedPixels <= '0;
				score <= '0;			
        end else begin  
			  
			  if (r1) begin
					for (i = 14; i < 16; i = i + 1) begin
						 for (j = 12; j < 16; j = j + 1) begin
							  RedPixels[i][j] <= 1'b1;
						 end
					end
			  end
			  

			  if (r2) begin
					for (i = 14; i < 16; i = i + 1) begin
						 for (j = 8; j < 12; j = j + 1) begin
							  RedPixels[i][j] <= 1'b1;
						 end
					end
			  end
				 
			
			  if (r3) begin
					for (i = 14; i < 16; i = i + 1) begin
						 for (j = 4; j < 8; j = j + 1) begin
							  RedPixels[i][j] <= 1'b1;
						 end
					end
			  end
				

			  if (r4) begin
					for (i = 14; i < 16; i = i + 1) begin
						 for (j = 0; j < 4; j = j + 1) begin
							  RedPixels[i][j] <= 1'b1;
						 end
					end
			  end	   
			  
			  if (score > 1000000) begin
					score <= 0;
			  end
			  
			  
			  if (en) begin
				  
				  if (RedPixels[1][0] == 1'b1 && RedPixels[1][4] == 1'b1 && RedPixels[1][8] == 1'b1 && RedPixels[1][12] == 1'b1) begin
						score <= score - 8;
				  end else if (RedPixels[1][4] == 1'b1 && RedPixels[1][8] == 1'b1 && RedPixels[1][12] == 1'b1) begin
						score <= score - 6;
				  end else if (RedPixels[1][0] == 1'b1 && RedPixels[1][8] == 1'b1 && RedPixels[1][12] == 1'b1) begin
						score <= score - 6;
				  end	else if (RedPixels[1][0] == 1'b1 && RedPixels[1][4] == 1'b1 && RedPixels[1][12] == 1'b1) begin
						score <= score - 6;
				  end else if (RedPixels[1][0] == 1'b1 && RedPixels[1][4] == 1'b1 && RedPixels[1][8] == 1'b1) begin
						score <= score - 6;
				  end else if (RedPixels[1][8] == 1'b1 && RedPixels[1][12] == 1'b1) begin
						score <= score - 4;
				  end else if (RedPixels[1][4] == 1'b1 && RedPixels[1][12] == 1'b1) begin
						score <= score - 4;
				  end	else if (RedPixels[1][4] == 1'b1 && RedPixels[1][8] == 1'b1) begin
						score <= score - 4;
				  end else if (RedPixels[1][0] == 1'b1 && RedPixels[1][12] == 1'b1) begin
						score <= score - 4;
				  end else if (RedPixels[1][0] == 1'b1 && RedPixels[1][8] == 1'b1) begin
						score <= score - 4;
				  end else if (RedPixels[1][0] == 1'b1 && RedPixels[1][4] == 1'b1) begin
						score <= score - 4;
				  end	else if (RedPixels[1][12] == 1'b1) begin
						score <= score - 2;
				  end else if (RedPixels[1][8] == 1'b1) begin
						score <= score - 2;
				  end else if (RedPixels[1][4] == 1'b1) begin
						score <= score - 2;
				  end else if (RedPixels[1][0] == 1'b1) begin
						score <= score - 2;
				  end
			  
				  
					for (i = 0; i < 14; i = i + 1) begin
						 for (j = 12; j < 16; j = j + 1) begin
							  RedPixels[i][j] <= RedPixels[i+2][j];
						 end
					end
				 
					for (i = 14; i < 16; i = i + 1) begin
						 for (j = 12; j < 16; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					
					for (i = 0; i < 14; i = i + 1) begin
						 for (j = 8; j < 12; j = j + 1) begin
							  RedPixels[i][j] <= RedPixels[i+2][j];
						 end
					end
				 
					for (i = 14; i < 16; i = i + 1) begin
						 for (j = 8; j < 12; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end

					for (i = 0; i < 14; i = i + 1) begin
						 for (j = 4; j < 8; j = j + 1) begin
							  RedPixels[i][j] <= RedPixels[i+2][j];
						 end
					end
				 
					for (i = 14; i < 16; i = i + 1) begin
						 for (j = 4; j < 8; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					
					for (i = 0; i < 14; i = i + 1) begin
						 for (j = 0; j < 4; j = j + 1) begin
							  RedPixels[i][j] <= RedPixels[i+2][j];
						 end
					end
				 
					for (i = 14; i < 16; i = i + 1) begin
						 for (j = 0; j < 4; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end				
			  end
			  
						
			  if (sig1 && RedPixels[3][12] == 1'b1 && RedPixels[1][12] == 1'b0) begin
					for (i = 2; i < 4; i = i + 1) begin
						 for (j = 12; j < 16; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 2;
			  end
			  
			  

			  if (sig2 && RedPixels[3][8] == 1'b1 && RedPixels[1][8] == 1'b0) begin
					for (i = 2; i < 4; i = i + 1) begin
						 for (j = 8; j < 12; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 2;				
			  end

			  
			  if (sig3 && RedPixels[3][4] == 1'b1 && RedPixels[1][4] == 1'b0) begin
					for (i = 2; i < 4; i = i + 1) begin
						 for (j = 4; j < 8; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 2;				
			  end

			  
			  if (sig4 && RedPixels[3][0] == 1'b1 && RedPixels[1][0] == 1'b0) begin
					for (i = 2; i < 4; i = i + 1) begin
						 for (j = 0; j < 4; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 2;				
			  end
			  
						
			  if (sig1 && RedPixels[3][12] == 1'b1 && RedPixels[1][12] == 1'b1) begin
					for (i = 0; i < 2; i = i + 1) begin
						 for (j = 12; j < 16; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;
			  end
			  
			  
			  if (sig2 && RedPixels[3][8] == 1'b1 && RedPixels[1][8] == 1'b1) begin
					for (i = 0; i < 2; i = i + 1) begin
						 for (j = 8; j < 12; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end

			  
			  if (sig3 && RedPixels[3][4] == 1'b1 && RedPixels[1][4] == 1'b1) begin
					for (i = 0; i < 2; i = i + 1) begin
						 for (j = 4; j < 8; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end

			  if (sig4 && RedPixels[3][0] == 1'b1 && RedPixels[1][0] == 1'b1) begin
					for (i = 0; i < 2; i = i + 1) begin
						 for (j = 0; j < 4; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end		  
			  
			  
			  if (sig1 && RedPixels[3][12] == 1'b0 && RedPixels[5][12] == 1'b1 && RedPixels[1][12] == 1'b0) begin
					for (i = 4; i < 6; i = i + 1) begin
						 for (j = 12; j < 16; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end
			  
			  
			  if (sig1 && RedPixels[3][12] == 1'b0 && RedPixels[1][12] == 1'b1 && RedPixels[5][12] == 1'b0) begin
					for (i = 0; i < 2; i = i + 1) begin
						 for (j = 12; j < 16; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end
			  

			  if (sig1 && RedPixels[3][12] == 1'b0 && RedPixels[5][12] == 1'b1 && RedPixels[1][12] == 1'b1) begin
					for (i = 0; i < 2; i = i + 1) begin
						 for (j = 12; j < 16; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end		  
					  
			  
			  if (sig2 && RedPixels[3][8] == 1'b0 && RedPixels[5][8] == 1'b1 && RedPixels[1][8] == 1'b0) begin
					for (i = 4; i < 6; i = i + 1) begin
						 for (j = 8; j < 12; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end
			  
			  
			  if (sig2 && RedPixels[3][8] == 1'b0 && RedPixels[1][8] == 1'b1 && RedPixels[5][8] == 1'b0) begin
					for (i = 0; i < 2; i = i + 1) begin
						 for (j = 8; j < 12; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end
			  
			  
			  if (sig2 && RedPixels[3][8] == 1'b0 && RedPixels[5][8] == 1'b1 && RedPixels[1][8] == 1'b1) begin
					for (i = 0; i < 2; i = i + 1) begin
						 for (j = 8; j < 12; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end		  
					  
					  
			  if (sig3 && RedPixels[3][4] == 1'b0 && RedPixels[5][4] == 1'b1 && RedPixels[1][4] == 1'b0) begin
					for (i = 4; i < 6; i = i + 1) begin
						 for (j = 4; j < 8; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end
			  
			  
			  if (sig3 && RedPixels[3][4] == 1'b0 && RedPixels[1][4] == 1'b1 && RedPixels[5][4] == 1'b0) begin
					for (i = 0; i < 2; i = i + 1) begin
						 for (j = 4; j < 8; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end
		
		
			  if (sig3 && RedPixels[3][4] == 1'b0 && RedPixels[5][4] == 1'b1 && RedPixels[1][4] == 1'b1) begin
					for (i = 0; i < 2; i = i + 1) begin
						 for (j = 4; j < 8; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end		  
					  

			  if (sig4 && RedPixels[3][0] == 1'b0 && RedPixels[5][0] == 1'b1 && RedPixels[1][0] == 1'b0) begin
					for (i = 4; i < 6; i = i + 1) begin
						 for (j = 0; j < 4; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end
			  

			  if (sig4 && RedPixels[3][0] == 1'b0 && RedPixels[1][0] == 1'b1 && RedPixels[5][0] == 1'b0) begin
					for (i = 0; i < 2; i = i + 1) begin
						 for (j = 0; j < 4; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;			
			  end

		
			  if (sig4 && RedPixels[3][0] == 1'b0 && RedPixels[5][0] == 1'b1 && RedPixels[1][0] == 1'b1) begin
					for (i = 0; i < 2; i = i + 1) begin
						 for (j = 0; j < 4; j = j + 1) begin
							  RedPixels[i][j] <= 1'b0;
						 end
					end
					score <= score + 1;				
			  end		  
					  

			  if (sig1 && RedPixels[3][12] == 1'b0 && RedPixels[1][12] == 1'b0 && RedPixels[5][12] == 1'b0) begin
					score <= score - 2;				
			  end
				
				
			  if (sig2 && RedPixels[3][8] == 1'b0 && RedPixels[1][8] == 1'b0 && RedPixels[5][8] == 1'b0) begin
					score <= score - 2;			
			  end
				
				
			  if (sig3 && RedPixels[3][4] == 1'b0 && RedPixels[1][4] == 1'b0 && RedPixels[5][4] == 1'b0) begin
					score <= score - 2;			
			  end
				
				
			  if (sig4 && RedPixels[3][0] == 1'b0 && RedPixels[1][0] == 1'b0 && RedPixels[5][0] == 1'b0) begin
					score <= score - 2;				
			  end
			  
		 end  
    end
endmodule


module LEDMatrix_testbench();
    logic clk, reset;
    logic r1, r2, r3, r4;
	 logic sig1, sig2, sig3, sig4;
	 logic [9:0] speed;
	 logic en;
    logic [15:0][15:0] RedPixels;
    logic [19:0] score;
	 
	 
	 LEDMatrix dut (.clk, .reset, .speed, .r1, .r2, .r3, .r4, .sig1, .sig2, .sig3, .sig4, .RedPixels, .score, .en);
	 
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	 	
	
	initial begin
								  @(posedge clk);							  						  
		reset <= 1; 		  @(posedge clk);
		reset <= 0;         @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);		
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);				
		speed <= 512; en <= 1; r1 <= 1; r2 <= 1; sig1 <= 1; sig2 <= 1;		  repeat (2000) @(posedge clk);
		speed <= 512; en <= 0; r1 <= 1; r2 <= 1; sig1 <= 1; sig2 <= 1;		  repeat (2000) @(posedge clk);
		speed <= 512; en <= 0; r1 <= 0; r2 <= 0; sig1 <= 1; sig2 <= 1;		  repeat (2000) @(posedge clk);			
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		speed <= 768; en <= 1; r3 <= 1; r4 <= 1; sig3 <= 1; sig4 <= 1;		  repeat (2000) @(posedge clk);
		speed <= 768; en <= 0; r3 <= 1; r4 <= 1; sig3 <= 1; sig4 <= 1;		  repeat (2000) @(posedge clk);		
		speed <= 768; en <= 0; r3 <= 0; r4 <= 0; sig3 <= 1; sig4 <= 1;		  repeat (2000) @(posedge clk);		
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		speed <= 896; en <= 1; r3 <= 1; r1 <= 1; sig2 <= 1; sig4 <= 1;		  repeat (2000) @(posedge clk);
		speed <= 896; en <= 0; r3 <= 1; r1 <= 1; sig2 <= 1; sig4 <= 1;		  repeat (2000) @(posedge clk);		
		speed <= 896; en <= 0; r3 <= 0; r1 <= 0; sig2 <= 1; sig4 <= 1;		  repeat (2000) @(posedge clk);	
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		reset <= 1; 		  @(posedge clk);
		reset <= 0;         @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		$stop; // End the simulation.
	end
	
endmodule