module CS_LD_ctrl
#(
parameter BIT_CNT_MAX = 4095
)
(
    CLR        ,
    STB_CLK_2M ,
    START      ,
    CS         ,
    LOAD       ,
    Done       ,
    load_cnt
);

input              CLR;
input              STB_CLK_2M;
input              START;
output reg         CS;
output reg         LOAD;
output reg         Done;
output     [3:0]   load_cnt;


reg        [3:0]   load_cnt;
reg        [15:0]  a_14_bit_cnt;
reg        [12:0]  bit_num;
reg        [14:0]  cnt_st;
reg                done_sig;
reg                trig;


//// START SIGNAL ////
always @(posedge STB_CLK_2M or posedge CLR or posedge done_sig) begin
    if (CLR) begin
        cnt_st <= 0;
    end
    else if (done_sig) begin
        cnt_st <= 0;
    end
    else begin
        if(~cnt_st[14]) begin
            cnt_st <= cnt_st + 1;
        end
        else begin
            cnt_st <= cnt_st;
        end
    end
end

//// CS SIGNAL ////
always@(negedge STB_CLK_2M or posedge CLR or posedge trig) begin
    if (CLR) begin
        CS <= 0;
    end
    else if (trig) begin
        CS <= 0;
    end
    else begin
        if(LOAD) begin
            CS <= 0;
        end
        else if (done_sig) begin
            CS <= 0;
        end
        else if(START & ~LOAD) begin
            CS <= 1;
        end
        else begin
            CS <= CS;
        end
    end
end

always@(posedge STB_CLK_2M or posedge CLR) begin
    if (CLR) begin
        load_cnt <=0;
        LOAD     <=0;
    end
    else begin
        if (a_14_bit_cnt == 16383) begin
            load_cnt <= 0;
            LOAD     <= 0;
        end
        // else if (load_cnt == 13) begin
        //     load_cnt <= load_cnt;
        //     LOAD     <= 0;
        // end
        // else if (load_cnt == 12) begin
        //     load_cnt <= load_cnt + 1;
        //     LOAD     <= 1;
        // end
        else if (load_cnt == 15) begin
            load_cnt <= load_cnt;
            LOAD     <= 0;
        end
        else if (load_cnt == 14) begin
            load_cnt <= load_cnt + 1;
            LOAD     <= 1;
        end
        else begin
            load_cnt <= load_cnt + 1;
            LOAD     <= 0;
        end
    end
end

always@(posedge STB_CLK_2M or posedge CLR) begin
    if(CLR) begin
        trig <= 0;
    end
    else begin
        if (a_14_bit_cnt[14]) begin
            trig <= 0;
        end
        // else if(load_cnt == 12) begin
        //     trig <= 1;
        // end
        else if(load_cnt == 14) begin
            trig <= 1;
        end
        else begin
            trig <= trig;
        end
    end
end

//// LOAD SIGNAL ////
always@(posedge STB_CLK_2M or posedge CLR) begin
    if (CLR) begin
        a_14_bit_cnt <= 0;
    end
    else begin
        if(a_14_bit_cnt[14]) begin
            a_14_bit_cnt <= 0;
        end
        else if(trig) begin
            a_14_bit_cnt <= a_14_bit_cnt + 1;
        end
        else begin
            a_14_bit_cnt <= a_14_bit_cnt;
        end
    end
end

always@(negedge STB_CLK_2M or posedge CLR) begin
    if(CLR) begin
        bit_num <= 0;
        done_sig  <= 0;
    end
    else begin
        if(LOAD & (bit_num == BIT_CNT_MAX)) begin
            bit_num <= 0;
            done_sig  <= 1;            
        end
        else if(LOAD) begin
            bit_num <= bit_num + 1;
            done_sig  <= 0;
        end
        else begin
            bit_num <= bit_num;
            done_sig  <= done_sig;
        end
    end
end

always@(posedge STB_CLK_2M or posedge CLR) begin
    if(CLR) begin
        Done <= 0;
    end
    else begin
        Done <= done_sig;
    end
end


endmodule

