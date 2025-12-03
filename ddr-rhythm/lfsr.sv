module lfsr (clk, reset, out, start, en);
    input logic clk, reset;
	 input logic en;
	 input logic [9:0] start;
	 output logic [9:0] out;

	 logic d;
	 assign d = ~(out[0] ^ out[3]);
	 
    always_ff @(posedge clk) begin
        if (reset) begin
				out <= start;
        end else begin
			   if (en) begin
					 out <= {d, out[9:1]};
				end
		  end	  	
    end
endmodule

module lfsr_testbench();
   logic clk, reset;
	logic en;
	logic [9:0] start;
   logic [9:0] out;

	lfsr dut (clk, reset, out, start, en);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
								  @(posedge clk);							  
		reset <= 1; start<= 0; 		  @(posedge clk);
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
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		reset <= 1; start<= 250; 		  @(posedge clk);
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
		reset <= 1; start<= 500; 		  @(posedge clk);
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
		reset <= 1; start<= 750; 		  @(posedge clk);
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
		$stop; // End the simulation.
	end
endmodule