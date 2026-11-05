module clock_divider (
    input clk_100MHz,
    input rst_n,
    output reg generated_clk_50MHz
);
    

always @(posedge clk_100MHz or negedge rst_n) begin
    if (!rst_n) begin
        generated_clk_50MHz <= 1'b0;
    end else begin
        generated_clk_50MHz <= ~generated_clk_50MHz; // Toggle the clock signal
    end
end

endmodule


