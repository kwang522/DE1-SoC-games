module metastability (clk, reset, KEY, KEY_out);
	 input logic clk, reset;
    input logic KEY;
    output logic KEY_out;
	 
    logic KEY_ff1, KEY_ff2;

    always_ff @(posedge clk) begin
        if (reset) begin
            KEY_ff1 <= 1'b0;
            KEY_ff2 <= 1'b0;
        end else begin
            KEY_ff1 <= KEY;     
            KEY_ff2 <= KEY_ff1;
		  end
    end
	 
    assign KEY_out = KEY_ff2;

endmodule

module metastability_testbench();
    logic clk, reset;
    logic KEY;
    logic KEY_out;


	metastability dut (.clk, .reset, .KEY, .KEY_out);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		KEY <= 0;			  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);							  
		reset <= 1; 		  @(posedge clk);
		reset <= 0;         @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		KEY <= 1;           @(posedge clk);
		KEY <= 0;           @(posedge clk);
								  @(posedge clk);
		KEY <= 1;			  @(posedge clk);
		KEY <= 1;			  @(posedge clk);
		KEY <= 0;           @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		KEY <= 0;           @(posedge clk);
								  @(posedge clk);
		KEY <= 1;			  @(posedge clk);
		KEY <= 0;           @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);  
		$stop; // End the simulation.
	end
endmodule