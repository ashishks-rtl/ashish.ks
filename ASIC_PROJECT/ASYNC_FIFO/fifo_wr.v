module fifo_wr #(
    parameter P_SIZE=4
)
(
    input w_clk,
    input w_rstn,

    input w_inc,
    input [P_SIZE-1:0] sync_rd_ptr,

    output [P_SIZE-2:0] w_addr,
    output reg [P_SIZE-1:0] gray_w_ptr,
    output full
);

reg [P_SIZE-1:0] w_ptr;
wire [P_SIZE-1:0] comb_gray_w_ptr;

assign comb_gray_w_ptr = w_ptr ^ (w_ptr >> 1);

always@(posedge w_clk or negedge w_rstn) begin
      if(!w_rstn)
          begin
                 w_ptr <= {P_SIZE{1'b0}};
          end
       else if(w_inc && !full)
           begin
                 w_ptr <= w_ptr + 1'b1;
           end

    end


    assign w_addr = w_ptr[P_SIZE-2:0];

    always@(posedge w_clk or negedge w_rstn) begin
                 if(!w_rstn)
                       begin
                            gray_w_ptr <= {P_SIZE{1'b0}};
                       end
                  else begin
                       gray_w_ptr <= comb_gray_w_ptr;
                       end        
                    end

    assign full =   ((sync_rd_ptr[P_SIZE-1]       != comb_gray_w_ptr[P_SIZE-1]) &&
                    (sync_rd_ptr[P_SIZE-2]        != comb_gray_w_ptr[P_SIZE-2]) &&
                    (sync_rd_ptr[P_SIZE-3:0]      == comb_gray_w_ptr[P_SIZE-3:0]));


endmodule