// mem_param.v

module mem_param #(
                     parameter WIDTH = 1024,
                     parameter DEPTH = 8
                  )
                 (
                    input  clk,
                    input  write,

                    input  [DEPTH-1:0] waddr, 
                    input  [DEPTH-1:0] raddr, 

                    input  [WIDTH-1:0] wdata, 
                    output [WIDTH-1:0] rdata
                 );


reg [WIDTH-1:0] mem[0:(2**DEPTH)-1];
reg [WIDTH-1:0] rdatax;

assign rdata = rdatax;

always @(*) begin               // READ 
  rdatax <=  mem[raddr];
end

always @(posedge(clk)) begin    // WRITE
  if(write) begin
    mem[waddr]<= wdata;
  end
end

endmodule