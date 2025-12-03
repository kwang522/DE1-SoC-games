module DE1_SoC_tb;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0] LEDR;
    logic [3:0] KEY;
    logic [9:0] SW;
    
    logic  CLOCK_50;
    logic [7:0] VGA_R;
    logic [7:0] VGA_G;
    logic [7:0] VGA_B;
    logic VGA_BLANK_N;
    logic VGA_CLK;
    logic VGA_HS;
    logic VGA_SYNC_N;
    logic VGA_VS;
    
    DE1_SoC dut (.*);
    
    always #10 CLOCK_50 = ~CLOCK_50;
    
    initial begin
        CLOCK_50 = 0;
        KEY[3] = 0;     // Reset
        repeat(5) @(posedge CLOCK_50);
        KEY[3] = 1;
        
        // First hit
        $display("\nFirst hit:");
        KEY[0] = 0;
        repeat(4) @(posedge CLOCK_50);
        KEY[0] = 1;
        repeat(5) @(posedge CLOCK_50);
        
        // Second hit
        $display("Second hit:");
        KEY[0] = 0;
        repeat(4) @(posedge CLOCK_50);
        KEY[0] = 1;
        repeat(10) @(posedge CLOCK_50);
        
        
        $stop;
    end
endmodule