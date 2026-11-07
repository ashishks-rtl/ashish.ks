module fifo_mem #(
    parameter A_SIZE = 3,
    parameter D_SIZE = 8,
    parameter F_DEPTH = 8
) 
(
    input w_clk,
    input w_rstn,

    input w_full,
    input w_inc,
    input [A_SIZE-1:0] w_addr,
    input [A_SIZE-1:0] r_addr,

    input  [D_SIZE-1:0] w_data,
    output [D_SIZE-1:0] r_data
    
    );


    reg [D_SIZE-1:0] FIFO_MEM [F_DEPTH-1:0];

    reg [F_DEPTH-1:0] i;

    always@(posedge w_clk or negedge w_rstn) begin
       if(!w_rstn)
            begin
                 for(i=0; i<F_DEPTH; i=i+1) begin
                    FIFO_MEM[i] <= {F_DEPTH{1'b0}};
                 end
            end
        else if(!w_full && w_inc)
             begin
                   FIFO_MEM[w_addr] <= w_data;
             end
end


assign r_data = FIFO_MEM[r_addr];

endmodule