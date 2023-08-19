module SPI_Slave (

input	wire		MOSI,
input	wire		SS_n,
input	wire		clk,
input	wire		rst,
input	wire		tx_valid,
input	wire	[7:0]	tx_data,
output	wire		MISO,
output	reg	[9:0]	rx_data,
output	reg		rx_valid


);

localparam	IDLE=3'b000;
localparam	Write=3'b001;
localparam	CHK_CMD=3'b011;
localparam	Read_Address=3'b010;
localparam	Read_Data=3'b110;

reg	[2:0]	current_state;
reg	[2:0]	next_state;
reg	[3:0]	count;
reg		read_address_done;	
reg	[7:0]	temp;
reg		triggered;
wire		start_count;
always@(posedge clk or negedge rst)
begin
	if(!rst)
	begin
current_state <= IDLE;

	end

	else
	begin
current_state <= next_state;	
	end

end

always@(*)
begin
	case(current_state)
IDLE:
	begin
	if(SS_n)
	begin
	next_state = IDLE;
	end

	else
	begin
	next_state = CHK_CMD;
	end

	end

Write:
	begin
	if(SS_n)
	begin
	next_state = IDLE;
	end
	
	else
	begin
	next_state =Write;
	end
	end
	
CHK_CMD:
	begin
	if(SS_n)
	begin
	next_state = IDLE ;
	end
	else
	begin
	if(!MOSI)
	begin
	next_state =Write;
	end
	
	else
	begin
	if (read_address_done)
	begin
	next_state = Read_Data;
	
	end
	else
	begin
	next_state = Read_Address;
	end

	end
	end
	end

Read_Address:
	begin
	if (SS_n)
	begin
	next_state = IDLE;
	end
	
	else
	begin
	next_state = Read_Address ;
	end

	end	

Read_Data:
	begin
	if (SS_n)
	begin
	next_state = IDLE;
	end
	
	else
	begin
	next_state = Read_Data ;
	end
	end

	default
	begin
	next_state = IDLE;
	end
	
	endcase
end

always @(posedge rx_valid)
begin

if(rx_data[9:8]==2'b10)
begin
read_address_done <= 1'b1;
end

else if (rx_data[9:8] ==2'b11)
begin
read_address_done <= 1'b0;
end

end


always @(posedge tx_valid)
begin
temp <= tx_data;
end


always @(posedge clk)
begin
	if(count== 4'd9)
	begin
	rx_valid <=1'b1;
	end

	else
	begin
	rx_valid <= 1'b0;
	end
end

always@(posedge start_count)begin
        triggered <= 1;
    end

always@(posedge clk , negedge rst)
	begin
if(!rst)
begin
count<=4'b0;
triggered <=1'b0;

end

else if (count == 4'd8)
begin

count <=1'b0;
triggered <=1'b0;

end

else if (triggered)
begin
count<= count + 4'b1 ;
end

end

assign start_count = (current_state == Write || current_state == Read_Data || current_state == Read_Address)? 1 : 0 ; 

always@ (posedge clk or negedge rst)
begin
	if(!rst)
	begin
	rx_data <= 8'b0;
	temp <= 8'b0;
	end
	else
	begin
	rx_data[7:0]<={rx_data[6:0],MOSI};
	temp <= {temp[6:0],1'b0};
	end


end

assign MISO = temp [7];

endmodule
