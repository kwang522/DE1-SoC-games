module lfsr9 (
    input  logic clk,
    input  logic rst,
    output logic [8:0] rnd
);
    // 9-bit maximal LFSR: taps at bits 9 and 5 (polynomial x^9 + x^5 + 1)
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            rnd <= 9'b1; // Any nonzero seed
        else
            rnd <= {rnd[7:0], rnd[8] ^ rnd[4]};
    end
endmodule
