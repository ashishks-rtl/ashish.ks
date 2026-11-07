module fifo_rd #(
    parameter P_SIZE = 4
)

(
  input r_clk,
  input r_rstn,
  input r_inc,

  input [P_SIZE-1:0] sync_wr_ptr,

  output [P_SIZE-2:0] r_addr,

  output empty,
  output reg [P_SIZE-1:0] gray_r_ptr 

);

reg [P_SIZE-1:0] r_ptr;
wire [P_SIZE-1:0] comb_gray_r_ptr;

assign comb_gray_r_ptr = r_ptr ^ (r_ptr >> 1);

assign r_addr = r_ptr[P_SIZE-2:0];

assign empty = (sync_wr_ptr[P_SIZE-1:0] == comb_gray_r_ptr[P_SIZE-1:0]);

always@(posedge r_clk or negedge r_rstn) begin
    if(!r_rstn)
        begin
            r_ptr <= {P_SIZE{1'b0}};
        end
    else if(r_inc && !empty)
        begin
            r_ptr <= (r_ptr + 1'b1);
        end

end


always@(posedge r_clk or negedge r_rstn) begin
    if(!r_rstn) 
        begin
            gray_r_ptr <= {P_SIZE{1'b0}};
        end
    else begin
            gray_r_ptr <= comb_gray_r_ptr;
        end
end

endmodule