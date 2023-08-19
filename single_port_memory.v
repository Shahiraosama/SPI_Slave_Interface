module single_port_memory #(parameter MEM_DEPTH =256 , parameter ADDR_SIZE = 8)(

input	wire		clk,
input	wire		rst,
input	wire		rx_valid,
input	wire	[9:0]	din,
output	reg		tx_valid,
output	reg	[7:0] 	dout

);

integer	i;

reg	[ADDR_SIZE-1:0] write_address;
reg	[ADDR_SIZE-1:0] read_address;
reg	[ADDR_SIZE-1:0]	RAM	[0:MEM_DEPTH-1] ;

always@(posedge clk or negedge rst)
begin
	if(!rst)
begin
	for(i=0; i< MEM_DEPTH ; i=i+1)
	
	begin
	RAM[i]<= 'b0;
	end
	tx_valid<=1'b0;
	dout<=8'b0;
end
	else 
begin
	case(din[9:8])
	2'b00:
	begin
	write_address<= din[7:0];
	end

	2'b01:
	begin
	RAM[write_address] <= din[7:0] ;
	end

	2'b10:
	begin
	read_address <= din[7:0];
	tx_valid <= 1'b1;
	end
	
	2'b11:
	begin
	dout<= RAM[read_address];
	tx_valid <=1'b1;
	end

	default:
	begin
	tx_valid<=1'b0;
	dout<=8'b0;
	end
	endcase

end
end
endmodule
