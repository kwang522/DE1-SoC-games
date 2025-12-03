module enable(clk, reset, speed, en);
    input logic clk, reset;
	 input logic [9:0] speed;
	 output logic en;
	 
	 logic [9:0] count;	 
	 
    always_ff @(posedge clk) begin
		  if (reset) begin 
				count <= '0;
				en <= '0;
		  end	else begin 
			  count <= count + 1;
			  if (count == speed) begin
					en <= '1;
					count <= '0;
			  end else begin
					en <= '0;
			  end
		  end
	 end  
endmodule		  

module enable_testbench();
    logic clk, reset;
	 logic [9:0] speed;
	 logic en;
	 
	 
	 enable dut (.clk, .reset, .speed, .en);
	 
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
		speed <= 512; 		  repeat (2000) @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		speed <= 768; 		  repeat (2000) @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		speed <= 896; 	     repeat (2000) @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		speed <= 960; 	     repeat (2000) @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);								  
		speed <= 992; 	     repeat (2000) @(posedge clk);
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