// Datapath Module
module bit_counter_datapath (
    input  logic        clk,
    input  logic        reset,
    input  logic [9:0]  data_in,     // 8-bit input from switches
    input  logic        load_a,      // Control signal to load A
	 input  logic        res_eq_zero, // Status signal result == 0
    input  logic        shift_a,     // Control signal to shift A
    input  logic        inc_result,  // Control signal to increment result
    output logic        a_eq_zero,   // Status signal A == 0
    output logic        a_lsb,       // Status signal for A[0]
    output logic [3:0]  result       // Count result
);

    // Internal registers
    logic [9:0] A;  // Register to store input value
    
    // Register A logic
    always_ff @(posedge clk) begin
        if (reset)
            A <= 10'b0;
        else if (load_a)
            A <= data_in;
        else if (shift_a)
            A <= A >> 1;  // Right shift A
    end
    
    // Result counter logic
    always_ff @(posedge clk) begin
        if (reset)
            result <= 4'b0;
        else if (res_eq_zero)
            result <= 4'b0;
        else if (inc_result)
            result <= result + 1'b1;
    end
    
    // Status signals
    assign a_eq_zero = (A == 10'b0);  // A == 0 status
    assign a_lsb = A[0];              // LSB of A
    
endmodule