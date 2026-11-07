module Async_fifo_tb;
   
parameter D_SIZE = 8;
parameter A_SIZE = 4;
parameter P_SIZE = 5;
parameter F_DEPTH = 9;
parameter BURST_LEN = 9;
parameter Write_Clk_Period = 10;   //10 
parameter Read_Clk_Period = 20;    // 40 


reg i_w_clk;
reg i_w_rstn;
reg i_w_inc;
reg i_r_clk;
reg i_r_rstn;
reg i_r_inc;
reg  [D_SIZE-1:0] i_w_data;
wire [D_SIZE-1:0] o_r_data;
wire o_full;
wire o_empty;

reg [D_SIZE-1:0] Burst_Words [BURST_LEN-1:0];

integer WR_WORD;
integer RD_WORD;

initial 
begin
    $dumpfile("Async_fifo_tb.vcd");
    $dumpvars(0, Async_fifo_tb);

    $readmemh("../stimulus.txt", Burst_Words);

    $monitor("WRITE DATA is %h",i_w_data);

    initialize();

    wr_reset();

    for(WR_WORD=0; WR_WORD<BURST_LEN; WR_WORD=WR_WORD+1) 
    begin
        WR_FIFO_DATA(Burst_Words[WR_WORD]);
    end
end

initial
begin
      $monitor ("READ DATA is %h",o_r_data);
      rd_reset();
      wait(!o_empty);

      for(RD_WORD=0; RD_WORD<BURST_LEN; RD_WORD=RD_WORD+1) 
      begin
          RD_FIFO_DATA();
      end 
      #(Read_Clk_Period*10);
      $stop;  
end

task initialize;
   begin
        i_w_clk = 1'b0;
        i_w_rstn = 1'b0;
        i_w_inc = 1'b0;
        i_r_clk = 1'b0;
        i_r_rstn = 1'b0;
        i_r_inc = 1'b0;
        i_w_data = {D_SIZE{1'b0}};
   end

endtask

task rd_reset;
begin
    #(Read_Clk_Period/2);
    i_r_rstn = 1'b0;
    #(Read_Clk_Period/2);
    i_r_rstn = 1'b1;
end
endtask


task wr_reset;
begin   
    #(Write_Clk_Period/2);
    i_w_rstn = 1'b0;
    #(Write_Clk_Period/2);
    i_w_rstn = 1'b1;
    #(Write_Clk_Period/2);
end
endtask



task WR_FIFO_DATA(input [D_SIZE-1:0] i_data);
begin   
    i_w_data = i_data;
    i_w_inc = 1'b1;
    #(Write_Clk_Period);
    i_w_inc = 1'b0;
end     
endtask

task RD_FIFO_DATA;
begin
    i_r_inc = 1'b1;
    #(Read_Clk_Period);
    i_r_inc = 1'b0;
end     
endtask

always #(Write_Clk_Period/2) i_w_clk = ~i_w_clk;
always #(Read_Clk_Period/2) i_r_clk = ~i_r_clk;

Async_fifo #(
    .D_SIZE(D_SIZE),
    .A_SIZE(A_SIZE),
    .P_SIZE(P_SIZE),
    .F_DEPTH(F_DEPTH)
) u_async_fifo (
    .i_w_clk(i_w_clk),
    .i_w_rstn(i_w_rstn),
    .i_w_inc(i_w_inc),
    .i_w_data(i_w_data),

    .i_r_clk(i_r_clk),
    .i_r_rstn(i_r_rstn),
    .i_r_inc(i_r_inc),

    .o_r_data(o_r_data),

    .o_full(o_full),
    .o_empty(o_empty)
);






endmodule