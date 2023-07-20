 module Switches(
    input wire clk_i,
    input wire rst_i,
    input wire [11:0] addr,
    input wire [23:0] data_sw,
    output reg [31:0] rdata
    );
    always @ (posedge clk_i or posedge rst_i) begin
        if(rst_i) 
            rdata<=0;
        else if(addr==12'h070) 
            rdata<={{8{data_sw[23]}},data_sw};
        else 
            rdata<=rdata;
    end
endmodule