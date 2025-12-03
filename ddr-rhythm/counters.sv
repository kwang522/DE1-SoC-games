module victoryLogic (clk, reset, LEDR1, LEDR9, L, R, HEX0);
    input logic clk, reset;
	 input logic LEDR1, LEDR9, L, R;
    output logic [6:0] HEX0;
	 
	 enum { none, one, two } ps, ns;
    
	 always_comb begin
		  case (ps)
            none: begin
                if (LEDR1 && R) begin
                    ns = one;
						  HEX0 = ~7'b0000110;
                end else if (LEDR9 && L) begin
                    ns = two;
						  HEX0 = ~7'b1011011;
                end else begin
						  ns = none;
						  HEX0 = 7'b1111111;
					 end
            end
            one: begin
						  ns = one;
						  HEX0 = ~7'b0000110;
            end
            two: begin
						  ns = two;
						  HEX0 = ~7'b1011011;
            end
            default: begin
					ns = none;
					HEX0 = 7'b1111111;
				end
        endcase
    end
	 
    always_ff @(posedge clk) begin
        if (reset)
            ps <= none;
        else
            ps <= ns;
    end
endmodule

module victoryLogic_testbench();
   logic clk, reset;
	logic LEDR1, LEDR9, L, R;
   logic [6:0] HEX0;

	victoryLogic dut (clk, reset, LEDR1, LEDR9, L, R, HEX0);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
								  @(posedge clk);							  
		reset <= 1; 		  @(posedge clk);
		reset <= 0;         @(posedge clk);
								  @(posedge clk);
		LEDR1 <= 1; R <= 1; @(posedge clk);
		LEDR1 <= 1; L <= 1; @(posedge clk);
		LEDR1 <= 1; R <= 1; @(posedge clk);
		reset <= 1; 		  @(posedge clk);
		reset <= 0;         @(posedge clk);
								  @(posedge clk);
		LEDR9 <= 1; L <= 1; @(posedge clk);
		LEDR9 <= 1; R <= 1; @(posedge clk);
		LEDR9 <= 1; L <= 1; @(posedge clk);
		reset <= 1; 		  @(posedge clk);
		reset <= 0;         @(posedge clk);
								  @(posedge clk);
		LEDR1 <= 1; L <= 1; @(posedge clk);
								  @(posedge clk);
                          @(posedge clk);
		reset <= 1; 		  @(posedge clk);
		reset <= 0;         @(posedge clk);
								  @(posedge clk);
		LEDR9 <= 1; R <= 1; @(posedge clk);
								  @(posedge clk);	
		reset <= 1; 		  @(posedge clk);
		reset <= 0;         @(posedge clk);
								  @(posedge clk);
		R <= 1;				  @(posedge clk);
		L <= 1;				  @(posedge clk);									  
		$stop; // End the simulation.
	end
endmodule