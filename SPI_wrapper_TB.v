module SPI_wrapper_TB;
reg	clk_tb;
reg	rst_tb;
reg	MOSI_tb;
reg	SS_n_tb;
wire	MISO_tb;

reg	[9:0]	master_comm;
localparam T = 20;

always
begin
#(T/2) clk_tb = ~clk_tb;
end

SPI_wrapper DUT(
.clk(clk_tb),
.rst(rst_tb),
.MOSI(MOSI_tb),
.SS_n(SS_n_tb),
.MISO(MISO_tb)
);


integer i;

initial
begin
clk_tb =1'b0;
rst_tb=1'b1;
MOSI_tb=1'b0;
SS_n_tb=1'b1;

$readmemh ("RAM.txt",DUT.RAM.RAM);
#T rst_tb =1'b0;
#T rst_tb = 1'b1; SS_n_tb =1'b0;
#T MOSI_tb = 1'b0; //sending write command (sending the address)
#T master_comm =10'b0011011001;

for (i=0; i< 10 ;i=i+1)
begin
MOSI_tb = master_comm [9-i];
#T;
end

SS_n_tb =1'b1;
#T
SS_n_tb =1'b0;
#T MOSI_tb = 1'b0; //sending write command (Sending Data)
#T master_comm =10'b0100110010;

for (i=0; i< 10 ;i=i+1)
begin
MOSI_tb = master_comm [9-i];
#T;
end

SS_n_tb =1'b1;
#T
SS_n_tb =1'b0;
#T MOSI_tb = 1'b1; //sending read command (Sending address)
#T master_comm =10'b1000110010;

for (i=0; i< 10 ;i=i+1)
begin
MOSI_tb = master_comm [9-i];
#T;
end

SS_n_tb =1'b1;
#T
SS_n_tb =1'b0;
#T MOSI_tb = 1'b1; //sending read command (waiting for data)
#T master_comm =10'b1100010010;

for (i=0; i< 10 ;i=i+1)
begin
MOSI_tb = master_comm [9-i];
#T;
end

#(8*T) SS_n_tb =1'b1;
#(5*T) $stop;
end







endmodule
