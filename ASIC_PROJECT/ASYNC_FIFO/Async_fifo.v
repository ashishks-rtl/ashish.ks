module Async_fifo #(
  parameter D_SIZE = 8,
  parameter A_SIZE = 3,
  parameter P_SIZE = 4,
  parameter F_DEPTH = 8  
)
( 
    input i_w_clk,
    input i_w_rstn,

    input i_w_inc,
    input i_r_clk,
    input i_r_rstn,

    input i_r_inc,
    
    input [D_SIZE-1:0] i_w_data,
    output [D_SIZE-1:0] o_r_data,

    output o_full,
    output o_empty
);

wire [A_SIZE-1:0] w_addr;
wire [A_SIZE-1:0] r_addr;

wire [P_SIZE-1:0] w2r_ptr;
wire [P_SIZE-1:0] r2w_ptr;

wire [P_SIZE-1:0] gray_w_ptr;
wire [P_SIZE-1:0] gray_r_ptr;

fifo_mem #(
    .A_SIZE(A_SIZE),
    .D_SIZE(D_SIZE),
    .F_DEPTH(F_DEPTH)
) u_fifo_mem (
    .w_clk(i_w_clk),
    .w_rstn(i_w_rstn),

    .w_full(o_full),
    .w_inc(i_w_inc),
    .w_addr(w_addr),
    .r_addr(r_addr),

    .w_data(i_w_data),
    .r_data(o_r_data)
);


DF_Sync #(
    .DATA_SIZE(P_SIZE)
) u_w2r_sync (
    .sync_clk(i_r_clk),
    .sync_rstn(i_r_rstn),

    .async_ip(gray_w_ptr),

    .sync_op(w2r_ptr)
);

fifo_wr #(
    .P_SIZE(P_SIZE)
) u_fifo_wr (
    .w_clk(i_w_clk),
    .w_rstn(i_w_rstn),

    .w_inc(i_w_inc),
    .sync_rd_ptr(r2w_ptr),

    .w_addr(w_addr),
    .gray_w_ptr(gray_w_ptr),
    .full(o_full)
);



DF_Sync #(
    .DATA_SIZE(P_SIZE)
) u_r2w_sync (
    .sync_clk(i_w_clk),
    .sync_rstn(i_w_rstn),

    .async_ip(gray_r_ptr),

    .sync_op(r2w_ptr)
);

fifo_rd #(
    .P_SIZE(P_SIZE)
) u_fifo_rd (
    .r_clk(i_r_clk),
    .r_rstn(i_r_rstn),

    .r_inc(i_r_inc),
    .sync_wr_ptr(w2r_ptr),

    .r_addr(r_addr),
    .gray_r_ptr(gray_r_ptr),
    .empty(o_empty)
);


endmodule
