module bit_counter_control_tb;

    // DUT interface signals
    logic clk;
    logic reset;
    logic s;
    logic a_eq_zero;
    logic a_lsb;

    logic res_eq_zero;
    logic load_a;
    logic shift_a;
    logic inc_result;
    logic done;

    // Instantiate DUT
    bit_counter_control dut (
        .clk(clk),
        .reset(reset),
        .s(s),
        .a_eq_zero(a_eq_zero),
        .a_lsb(a_lsb),
        .res_eq_zero(res_eq_zero),
        .load_a(load_a),
        .shift_a(shift_a),
        .inc_result(inc_result),
        .done(done)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Named state decoding (for debugging)
    string state_name;
    always_comb begin
        case (dut.ps)
            0: state_name = "S_idle";
            1: state_name = "S_shift";
            2: state_name = "S_done";
            default: state_name = "UNKNOWN";
        endcase
    end

    // Test scenario
    initial begin
        // Enable VCD for waveform dump
        $dumpfile("bit_counter_control_tb.vcd");
        $dumpvars(0, bit_counter_control_tb);

        // Initialize inputs
        reset = 1;
        s = 0;
        a_eq_zero = 0;
        a_lsb = 0;
        #12;

        // Step 1: release reset
        reset = 0;
        #10;

        // Step 2: Start signal triggers transition to S_shift
        s = 1;
        #10;

        // Step 3: Remain in S_shift for several cycles with various LSBs
        s = 0;
        repeat (3) begin
            a_lsb = 1;
            a_eq_zero = 0;
            #10;
            a_lsb = 0;
            #10;
        end

        // Step 4: Assert a_eq_zero to transition to S_done
        a_eq_zero = 1;
        #10;

        // Step 5: Hold in S_done with start = 1
        s = 1;
        #10;

        // Step 6: Exit done state by deasserting start
        s = 0;
        #10;

        // Optional: return to S_shift with new start
        a_eq_zero = 0;
        a_lsb = 1;
        s = 1;
        #10;

        // Go through another short shift phase
        s = 0;
        a_lsb = 0;
        repeat (2) begin
            #10;
        end
        a_eq_zero = 1;  // trigger done
        #10;

        // End simulation
        $display("Test completed.");
        #10;
        $finish;
    end

    // Output monitoring
    initial begin
        $display("Time\tState\tStart\tA==0\tLSB\tLoad\tShift\tInc\tResZero\tDone");
        forever begin
            @(posedge clk);
            $display("%0t\t%s\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b",
                $time, state_name, s, a_eq_zero, a_lsb,
                load_a, shift_a, inc_result, res_eq_zero, done);
        end
    end

endmodule
