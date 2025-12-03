module lfsr9_tb;

    // Testbench signals
    logic clk;
    logic rst;
    logic [8:0] rnd;

    // Instantiate the LFSR
    lfsr9 dut (
        .clk(clk),
        .rst(rst),
        .rnd(rnd)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        // Apply reset
        rst = 1;
        #10;
        rst = 0;

        // Run LFSR for 50 clock cycles
        repeat (50) begin
            @(posedge clk);
            $display("Time: %0t | LFSR Output: %b (%0d)", $time, rnd, rnd);
        end

        $finish;
    end

    // Optional: detect stuck-at-zero error (LFSR should never go to 0)
    always @(posedge clk) begin
        if (rnd == 9'b0) begin
            $fatal("ERROR: LFSR entered all-zeros state, which should not happen in a maximal-length LFSR.");
        end
    end

endmodule
