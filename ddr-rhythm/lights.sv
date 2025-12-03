module lights (clk, reset, w, out);
	input logic clk, reset;
	input logic [1:0] w;
	output logic [2:0] out;
	
	// State variables
	enum { outer, right, left, middle } ps, ns;
	
	// Next State logic
always_comb begin
    // Default assignment for ns
    ns = outer; // Default to a known state
    case (ps)
        outer: ns = middle;  
        right: begin
            case (w)
                2'b00: ns = outer;
                2'b01: ns = middle;
                2'b10: ns = left;
                default: ns = right;  // Maintain state if w doesn't match
            endcase
        end
        left: begin
            case (w)
                2'b00: ns = outer;
                2'b01: ns = right;
                2'b10: ns = middle;
                default: ns = left;  // Maintain state if w doesn't match
            endcase
        end
        middle: begin
            case (w)
                2'b00: ns = outer;
                2'b01: ns = left;
                2'b10: ns = right;
                default: ns = middle;  // Maintain state if w doesn't match
            endcase
        end
        default: ns = outer; // Handle unspecified current states
    endcase
end

	// Output logic - could also be another always_comb block.
	always_comb begin
		case (ps)
			outer: out = 3'b101;
			right: out = 3'b001;
			left: out = 3'b100;
			middle: out = 3'b010;
		endcase
	end

	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= outer;
		else
			ps <= ns;
	end
endmodule

module lights_testbench();
	logic clk, reset;
	logic [1:0] w;
	logic [2:0] out;

	lights dut (clk, reset, w, out);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
								  @(posedge clk);
		reset <= 1; 		  @(posedge clk); // Always reset FSMs at start
		reset <= 0; w[0] <= 0; w[1] <= 0; @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		w[0] <= 1; w[1] <= 0; @(posedge clk);
		w[0] <= 0; w[1] <= 1; @(posedge clk);
		w[0] <= 1; w[1] <= 1; @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
								  @(posedge clk);
		w[0] <= 0; w[1] <= 0; @(posedge clk);
								  @(posedge clk);
		$stop; // End the simulation.
	end
endmodule