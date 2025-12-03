module normalLight (clk, reset, L, R, NL, NR, lightOn, softReset);
    input logic clk, reset, softReset;
    input logic L, R, NL, NR;
    output logic lightOn;
    
	 enum logic { off, on } ps, ns;

    always_ff @(posedge clk) begin
        if (reset || softReset)
            ps <= off;
        else
            ps <= ns;
    end

    always_comb begin
        case (ps)
            on: begin
                if (L & R) begin
                    ns = on;
                end else if (L) begin
                    ns = off;
                end else if (R) begin
                    ns = off;
                end else begin
                    ns = on;
                end
            end
            off: begin
                if (L & R) begin
                    ns = off;
                end else if (L & NR) begin
                    ns = on;
                end else if (R & NL) begin
                    ns = on;
                end else begin
                    ns = off;
                end
            end

            default: ns = off;
        endcase
    end
    assign lightOn = (ps == on);
endmodule

module normalLight_testbench();
   logic clk, reset;
   logic L, R, NL, NR;
   logic lightOn;

	normalLight dut (clk, reset, L, R, NL, NR, lightOn);

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
		L <= 1;             @(posedge clk);
								  @(posedge clk);
		NL <= 1; R <= 1;    @(posedge clk);
		L <= 1; R <= 1;     @(posedge clk);
		L <= 0; R <= 0;     @(posedge clk);
								  @(posedge clk);		
		R <= 1;			     @(posedge clk);
		NR <= 1; L <= 1;	  @(posedge clk);
		                    @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		R <= 1;             @(posedge clk);
		NR <= 1; R <= 1;	  @(posedge clk);
		reset <= 1; 		  @(posedge clk);
		reset <= 0;         @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		L <= 1;             @(posedge clk);
		NL <= 1; L <= 1;	  @(posedge clk);
								  @(posedge clk);	
								  @(posedge clk);	
		$stop; // End the simulation.
	end
endmodule