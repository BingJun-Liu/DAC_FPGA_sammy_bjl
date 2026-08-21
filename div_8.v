module div_8 (
    rst,
    clk,
    clk_2
);

input           rst;
input           clk;
output          clk_2;

reg       [8:0] cnt, clk_m;

assign clk_2 = clk_m;


always @(posedge clk or posedge rst) begin
    if(rst) begin
        cnt <=0;
    end
    else if (cnt == 7) begin
        cnt <= 0;
    end
    else begin
        cnt <= cnt + 1;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
        clk_m <=0;
    end
    else if (cnt < 4) begin
        clk_m <= 0;
    end
    else begin
        clk_m <= 1;
    end
end


endmodule

