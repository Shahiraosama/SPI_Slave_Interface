module SPI_wrapper (

input	wire	clk,
input	wire	rst,
input	wire	MOSI,
input	wire	SS_n,
output	wire	MISO

);

wire	[9:0]	rx_data;
wire		rx_valid;
wire		tx_valid;
wire	[7:0]	tx_data;


SPI_Slave spi_slave (.clk(clk),.rst(rst),.MOSI(MOSI),.SS_n(SS_n),.tx_valid(tx_valid),.tx_data(tx_data),.MISO(MISO),.rx_data(rx_data),.rx_valid (rx_valid));
single_port_memory RAM (.clk(clk),.rst(rst),.rx_valid(rx_valid),.din(rx_data),.tx_valid(tx_valid),.dout(tx_data));

endmodule
