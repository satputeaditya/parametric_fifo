//======================================================================
//
// mem_param.v
// -----------
//
// Memory instance. 
//
//======================================================================

  module mem_param #(
                     parameter WIDTH = 1024,
                     parameter DEPTH = 8
                  )
				  
                  (
                    input  				clk,
                    input  				write,

                    input  [DEPTH-1:0] 	waddr, 
                    input  [DEPTH-1:0] 	raddr, 

                    input  [WIDTH-1:0] 	wdata, 
                    output [WIDTH-1:0] 	rdata
                 );  

  //----------------------------------------------------------------
  // Registers declarations.
  //----------------------------------------------------------------
  reg [WIDTH-1:0] mem[0:(2**DEPTH)-1];
  reg [WIDTH-1:0] rdatax;

  //----------------------------------------------------------------
  // Output port signal assignments.
  //----------------------------------------------------------------
  assign rdata = rdatax;

  //----------------------------------------------------------------
  // memory read process 
  //----------------------------------------------------------------
  always @(*) 
	begin : read_process                
		rdatax <=  mem[raddr];
	end  // read_process
  //----------------------------------------------------------------
  // memory write process 
  //----------------------------------------------------------------
  always @(posedge(clk)) 
    begin : write_process
		if(write) 
			mem[waddr]<= wdata;
	end  // write_process

  endmodule // mem_param

//======================================================================
// EOF mem_param.v
//======================================================================
