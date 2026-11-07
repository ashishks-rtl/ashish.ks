module DF_Sync #(
    parameter DATA_SIZE = 2
)
(
    input sync_clk,
    input sync_rstn,

    input [DATA_SIZE-1:0] async_ip,

    output reg [DATA_SIZE-1:0] sync_op
);
    
reg [DATA_SIZE-1:0] meta_flop;

always@(posedge sync_clk or negedge sync_rstn) begin
   if(!sync_rstn) begin
        meta_flop <= {DATA_SIZE{1'b0}};
        sync_op <= {DATA_SIZE{1'b0}};
   end
        else begin
        {sync_op,meta_flop} <= {meta_flop,async_ip};
    end
end

endmodule