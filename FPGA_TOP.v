`timescale 1ns/1ps

module FPGA_TOP #(
    parameter BIT_CNT_MAX = 16383,
    parameter MARGIN      = 1,
    parameter INITIAL     = 0
)
(
    CLR          ,
    refclk       ,
    START        ,
    CS           ,
    LOAD         ,
    ADDR         ,
    STB_CLK_250K ,
    clk_250k
);

input         CLR;
input         refclk;

output        START;
output        CS;
output        LOAD;
output        ADDR;
output        STB_CLK_250K;
output        clk_250k;

wire          [3:0] load_cnt;

//=====================================================================
// --> Digital Module
//---------------------------------------------------------------------
// Clock Generator
//=====================================================================
// FPGA CLOCK INPUT
//CLK_2M
//uclk_2
//(
//    .refclk          ( refclk        ),    //  refclk.clk
//    .rst             ( CLR           ),    //  reset.reset
//    .outclk_0        ( CLK_2M        ),    //  outclk0.clk
//    .locked          (               )     //  locked.export
//);

//---------------------------------------------------------------------
// Clock divide
//=====================================================================
div_8
udiv
(
    .rst             ( CLR           ),
    //.clk             ( CLK_2M        ),
    .clk             ( refclk        ),
    .clk_2           ( clk_250k      )
);

//---------------------------------------------------------------------
// Clock control
//=====================================================================
clk_ctrl
u_ctrl
(
    .CLR             ( CLR           ),
    .CLK_250K        ( clk_250k      ),
    .Done            ( Done          ),
    .STB_CLK_250K    ( STB_CLK_250K  ),
    .START           ( START         )
);

//=====================================================================
// --> Digital Module
//---------------------------------------------------------------------
// Control
//=====================================================================
CS_LD_ctrl
#(
.BIT_CNT_MAX ( BIT_CNT_MAX )
)
uCS
(
    .CLR             ( CLR           ),
    .STB_CLK_2M      ( STB_CLK_250K  ),
    .START           ( START         ),
    .CS              ( CS            ),
    .LOAD            ( LOAD          ),
    .Done            ( Done          ),
    .load_cnt        ( load_cnt      )
);

//---------------------------------------------------------------------
// Address Output
//=====================================================================
addr_out 
#(
.MARGIN  ( MARGIN  ),
.INITIAL ( INITIAL )
)
udata_out
(
    .CLR             ( CLR           ),
    .STB_CLK_2M      ( STB_CLK_250K  ),
    .CS              ( CS            ),
    .LOAD            ( LOAD          ),
    .ADDR            ( ADDR          ),
    .load_cnt        ( load_cnt      )
);


endmodule

