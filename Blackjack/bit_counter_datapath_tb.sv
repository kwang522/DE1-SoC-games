module bit_counter_datapath_tb;

    // DUT I/O signals
    logic clk;
    logic reset;
    logic [9:0] data_in;
    logic load_a;
    logic res_eq_zero;
    logic shift_a;
    logic inc_result;
    logic a_eq_zero;
    logic a_lsb;
    logic [3:0] result;

    // Instantiate DUT
    bit_counter_datapath dut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .load_a(load_a),
        .res_eq_zero(res_eq_zero),
        .shift_a(shift_a),
        .inc_result(inc_result),
        .a_eq_zero(a_eq_zero),
        .a_lsb(a_lsb),
        .result(result)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Stimulus sequence
    initial begin
        $dumpfile("bit_counter_datapath_tb.vcd");
        $dumpvars(0, bit_counter_datapath_tb);

        // Initial state
        reset = 1;
        data_in = 10'b0000010101; // Example: 5 ones -> expected result = 4
        load_a = 0;
        res_eq_zero = 0;
        shift_a = 0;
        inc_result = 0;
        #12;

        // Release reset
        reset = 0;
        #10;

        // Load A
        load_a = 1;
        #10;
        load_a = 0;

        // Loop through bits of A and simulate a controller
        repeat (10) begin
            if (dut.A[0] == 1) begin
                inc_result = 1;
            end else begin
                inc_result = 0;
            end

            shift_a = 1;
            #10;
            shift_a = 0;
            inc_result = 0;
            #10;
        end

        // Optional reset result register again
        res_eq_zero = 1;
        #10;
        res_eq_zero = 0;

        // Done
        $display("Final result = %0d", result);
        $finish;
    end

    // Monitor signals
    initial begin
        $display("Time\tA[9:0]\tLSB\tA==0\tResult");
        forever begin
            @(posedge clk);
            $display("%0t\t%b\t%b\t%b\t%0d",
                $time, dut.A, a_lsb, a_eq_zero, result);
        end
    end

endmodule
