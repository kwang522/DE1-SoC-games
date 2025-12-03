module comparator (A, B, out);
	 input logic [9:0] A, B;
    output logic out;

	 always_comb begin
		if (A > B)
		  out = 1'b1;
		else
        out = 1'b0;
	 end
endmodule
