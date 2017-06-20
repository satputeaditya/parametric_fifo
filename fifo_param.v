//======================================================================
//
// fifo_param.v
// -----------
//
// Parametric fifo with instantiated memory
//
//======================================================================

module fifo_param #(  parameter WIDTH = 64,      // Number  of bits
                      parameter DEPTH = 4        // Number  of bits
                   )
                 
                 (
                    input  clk,
                    input  rst,

                    input  push,        		// push = write     
                    input  pop,         		// pop  = read    

                    input  [WIDTH-1:0] data_in, 
                    output [WIDTH-1:0] data_out,

                    output  fifo_empty,
                    output  fifo_full
                 );

  //----------------------------------------------------------------
  // Registers declarations.
  //----------------------------------------------------------------
  reg [DEPTH-1:0] write_address;
  reg [DEPTH-1:0] read_address;
  reg [DEPTH-1:0] fifo_count;

  //----------------------------------------------------------------
  // Output port signal assignments.
  //----------------------------------------------------------------
  assign high_val 	= 1'b1;
  assign low_val 	= 1'b0;
  assign fifo_full  = (fifo_count == {DEPTH{high_val}} )?1'b1:1'b0;   // inner curly braces act as replication operator
  assign fifo_empty = (fifo_count == {DEPTH{low_val}}  )?1'b1:1'b0;   // inner curly braces act as replication operator 

  //----------------------------------------------------------------
  // generate internal write address pointer.
  //----------------------------------------------------------------
  always@(posedge clk or posedge rst)
	begin
		if (rst)
			write_address <= 'b0;
		else 
		if (push == 1'b1 && (!fifo_full))                  	// if write = 1 and if fifo is NOT full then perform write operation
			write_address <= write_address + 1'b1;
    end

  //----------------------------------------------------------------
  // generate internal read address pointer.
  //----------------------------------------------------------------
  always@(posedge clk or posedge rst)
	begin
		if (rst)
			read_address <= 'b0; // 256 locations
		else
			if (pop == 1'b1 && (!fifo_empty))              // if read = 1 and if fifo is NOT empty then perform read operation 
				read_address <= read_address +1'b1;
	end

  //----------------------------------------------------------------
  //generate fifo count (increment on push, decrement on pop)
  //----------------------------------------------------------------
  always@(posedge clk or posedge rst)
	begin
		if (rst)
			fifo_count <= 'b0;   // clear counter
		else
			if (push== 1'b1 && pop == 1'b0 && (!fifo_full))
				fifo_count <= (fifo_count + 1);              		// increment counter if write & fifo NOT full
			else
				if (push== 1'b0 && pop == 1'b1 && (!fifo_empty))    // decrement counter if read & fifo NOT empty
					fifo_count <= (fifo_count - 1);
	end
 
  //----------------------------------------------------------------
  // memory instantiations   
  //----------------------------------------------------------------
  mem_param #( WIDTH , DEPTH ) U1 (.clk(clk), .write(push), .waddr(write_address), .raddr(read_address), .wdata(data_in), .rdata(data_out) );

  endmodule  // fifo_param

//======================================================================
// EOF fifo_param.v
//======================================================================  
