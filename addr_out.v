module addr_out
#(
parameter MARGIN = 6,
parameter INITIAL= 5
)
(
    CLR     ,
    STB_CLK_2M,
    CS      ,
    LOAD    ,
    ADDR    ,
    load_cnt
);

input           CLR;
input           STB_CLK_2M;
input           CS;
input           LOAD;
output   reg    ADDR;
input    [3:0]  load_cnt;

// reg      [12:0] data;
reg      [14:0] data;


always @(negedge STB_CLK_2M or posedge CLR ) begin
    if(CLR) begin
        data <= INITIAL;        
    end
    else begin
        if (LOAD) begin
            data <= data + MARGIN;
        end
        else begin
            data <= data;
        end
    end
end

// always@(posedge STB_CLK_2M or posedge CLR)begin
//     if(CLR) begin
//         ADDR <=0;
//     end
//     else begin
//         case(load_cnt)
//             4'b0000 : ADDR <= data[11];
//             4'b0001 : ADDR <= data[10];
//             4'b0010 : ADDR <= data[9];
//             4'b0011 : ADDR <= data[8];
//             4'b0100 : ADDR <= data[7];
//             4'b0101 : ADDR <= data[6];
//             4'b0110 : ADDR <= data[5];
//             4'b0111 : ADDR <= data[4];
//             4'b1000 : ADDR <= data[3];
//             4'b1001 : ADDR <= data[2];
//             4'b1010 : ADDR <= data[1];
//             4'b1011 : ADDR <= data[0];
//             default : ADDR <= 0;
//         endcase
//     end
// end

always@(posedge STB_CLK_2M or posedge CLR)begin
    if(CLR) begin
        ADDR <=0;
    end
    else begin
        case(load_cnt)
            4'b0000 : ADDR <= data[13];
            4'b0001 : ADDR <= data[12];
            4'b0010 : ADDR <= data[11];
            4'b0011 : ADDR <= data[10];
            4'b0100 : ADDR <= data[9];
            4'b0101 : ADDR <= data[8];
            4'b0110 : ADDR <= data[7];
            4'b0111 : ADDR <= data[6];
            4'b1000 : ADDR <= data[5];
            4'b1001 : ADDR <= data[4];
            4'b1010 : ADDR <= data[3];
            4'b1011 : ADDR <= data[2];
            4'b1100 : ADDR <= data[1];
            4'b1101 : ADDR <= data[0];

            default : ADDR <= 0;
        endcase
    end
end


endmodule

