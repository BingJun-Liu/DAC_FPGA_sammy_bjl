module clk_ctrl(
    CLR,
    CLK_250K,
    Done,
    STB_CLK_250K,
    START
);

input            CLR;
input            CLK_250K;
input            Done;
output           STB_CLK_250K;
output           START;

reg       [9:0]  stb_cnt;
reg       [1:0]  EN_syn;
reg              start_reg;
reg              START;

////CLOCK STABLE////
wire      stb_en;
assign    stb_en = (~CLR) & (stb_cnt[9]) & (~Done) ;

always @(posedge CLK_250K or posedge CLR) begin
    if(CLR) begin
        stb_cnt <=0;
    end
    else if( ~stb_cnt[9]) begin
        stb_cnt <= stb_cnt +1'b1;
    end
    else begin
        stb_cnt <= stb_cnt;
    end
end

//// CLOCK GATE ////
assign STB_CLK_250K = (stb_en) ? (CLK_250K & EN_syn[1]) : 1'b0;

always @(negedge CLK_250K or posedge CLR) begin
    if(CLR) begin
        EN_syn[0] <= 0;
        EN_syn[1] <= 0;
        start_reg <= 0;
        START     <= 0;
    end
    else begin
        EN_syn[0] <= 1;
        EN_syn[1] <= EN_syn[0];
        start_reg <= ~CLR;
        START     <= start_reg;
    end
end


endmodule

