// fifo_param.v

module fifo_param #(  parameter WIDTH = 64,      // Number  of bits
                      parameter DEPTH = 4        // Number  of bits
                   )
                 
                 (
                    input  clk,
                    input  rst,

                    input  push,        // push = write     
                    input  pop,         // pop  = read    

                    input  [WIDTH-1:0] data_in, 
                    output [WIDTH-1:0] data_out,

                    output  fifo_empty,
                    output  fifo_full
                 );



reg [DEPTH-1:0] write_address;
reg [DEPTH-1:0] read_address;
reg [DEPTH-1:0] fifo_count;


assign high_val = 1'b1;
assign low_val = 1'b0;



// generate internal write address
always@(posedge clk or posedge rst)

if (rst)
    write_address <= #1 'b0;  // 256 locations
else 
    if (push == 1'b1 && (!fifo_full))                   // if write = 1 and if fifo is NOT full then perform write operation
        write_address <= #1 write_address + 1'b1;
        

// generate internal read address pointer
always@(posedge clk or posedge rst)
if (rst)
    read_address <= #1 'b0; // 256 locations
else
    if (pop == 1'b1 && (!fifo_empty))                   // if read = 1 and if fifo is NOT empty then perform read operation 
        read_address <= #1 read_address +1'b1;


// generate fifo count (increment on push, decrement on pop)
always@(posedge clk or posedge rst)
if (rst)
    fifo_count <= #1 'b0;   // clear counter
else
    if (push== 1'b1 && pop == 1'b0 && (!fifo_full))
        fifo_count <= #1 (fifo_count + 1);              // increment counter if write & fifo NOT full
else
    if (push== 1'b0 && pop == 1'b1 && (!fifo_empty))    // decrement counter if read & fifo NOT empty
        fifo_count <= #1 (fifo_count - 1);

// generate fifo signals
 assign fifo_full  = (fifo_count == {DEPTH{high_val}} )?1'b1:1'b0;   // A mix of parameter with curly braces will help in resolving (the inner curly brace will act as replication operator)
 assign fifo_empty = (fifo_count == {DEPTH{low_val}}  )?1'b1:1'b0;   // A mix of parameter with curly braces will help in resolving (the inner curly brace will act as replication operator)

 
// connect RAM 
mem_param #( WIDTH , DEPTH ) memory2 (.clk(clk), .write(push), .waddr(write_address), .raddr(read_address), .wdata(data_in), .rdata(data_out) );


endmodule