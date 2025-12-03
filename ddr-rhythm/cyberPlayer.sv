module lfsr (clk, reset, out);
    input logic clk, reset;
	 output logic [9:0] out;

	 logic d;
	 assign d = ~(out[0] ^ out[3]);
	 
    always_ff @(posedge clk) begin
        if (reset)
				out <= 0;
        else		
            out <= {d, out[8:0]};
    end
endmodule