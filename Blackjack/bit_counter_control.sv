// Controller Module
module bit_counter_control (
    input  logic        clk,
    input  logic        reset,
    input  logic        s,          // Start signal
    input  logic        a_eq_zero,  // Status signal from datapath
    input  logic        a_lsb,      // LSB of A from datapath
	 output logic        res_eq_zero,// Counter result
    output logic        load_a,     // Load A register
    output logic        shift_a,    // Shift A right
    output logic        inc_result, // Increment result
    output logic        done        // Done signal
);

    // State declaration
    enum {S_idle, S_shift, S_done} ps, ns;
 
    
    // State register
    always_ff @(posedge clk) begin
        if (reset)
            ps <= S_idle;
        else
            ps <= ns;
    end
    
    // Next state logic
    always_comb begin
        case (ps)
            S_idle: ns = s ? S_shift : S_idle;
            S_shift: ns = a_eq_zero ? S_done : S_shift;
            S_done: ns = s ? S_done : S_idle;
        endcase
    end
    
    // Output assignments
	 assign inc_result = (ps == S_shift) & ~a_eq_zero & a_lsb;
	 assign load_a = (ps == S_idle) & ~s;
    assign res_eq_zero = (ps == S_idle);
    assign shift_a = (ps == S_shift);
	 assign done = (ps == S_done);
    
endmodule