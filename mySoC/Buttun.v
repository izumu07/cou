module Button(
    input wire clk_i,
    input wire rst_i,
    input wire [11:0] addr,
    input wire [4:0] btn,
    output reg [31:0] rdata
    );
    always @ (posedge clk_i or posedge rst_i) begin
        if(rst_i) 
            rdata<=0;
        else if(addr==12'h078) 
            rdata<={{27{btn[4]}},btn};
        else
            rdata<=rdata;
    end
endmodule