`timescale 1ns/1ns
module final_tb();
reg [7:0]number;
reg [1:0]sel;
reg clk;
reg [2:0]sel_type;

wire if_sell;
wire [2:0]out_type;
wire [7:0]charge;
wire [20:0]seven_all;
wire [20:0]seven_char;

final test(.number(number),.sel(sel),.clk(clk),.sel_type(sel_type),.if_sell(if_sell), .out_type(out_type), .charge(charge),.seven_all(seven_all),.seven_char(seven_char));

always
#5 clk=~clk;

initial
begin
	clk=1'b1;
	sel_type = 3'b001;
	number = 8'b00010100; sel = 2'b00; #10;//20
	number = 8'b00000000; sel = 2'b01; #10;//0 
	number = 8'b00111100; sel = 2'b00; #10;//60
	number = 8'b01000110; sel = 2'b00; #10;//70
	number = 8'b00000000; sel = 2'b11; #10;//20 
	
	sel_type = 3'b010;
	number = 8'b00000101; sel = 2'b00; #10;//5
	number = 8'b00000101; sel = 2'b10; #10;//5
	number = 8'b00010100; sel = 2'b00; #10;//10
	number = 8'b00000000; sel = 2'b11; #10;//10

	sel_type = 3'b011;
	number = 8'b00010100; sel = 2'b00; #10;//20
	number = 8'b00000000; sel = 2'b01; #10;//0 
	number = 8'b00000000; sel = 2'b01; #10;//0
	number = 8'b11001000; sel = 2'b00; #10;//200
	number = 8'b00000000; sel = 2'b11; #10;//30 

	sel_type = 3'b100;
	number = 8'b00010100; sel = 2'b00; #10;//20
	number = 8'b01010000; sel = 2'b00; #10;//80 
	number = 8'b00111100; sel = 2'b00; #10;//60
	number = 8'b01000110; sel = 2'b00; #10;//70
	number = 8'b00000000; sel = 2'b11; #10;//0 

	sel_type = 3'b101;
	number = 8'b00000000; sel = 2'b01; #10;//0
	number = 8'b01010000; sel = 2'b00; #10;//80 
	number = 8'b00111100; sel = 2'b10; #10;//60
	number = 8'b01000110; sel = 2'b00; #10;//70
	number = 8'b00000000; sel = 2'b11; #10;//90

	sel_type = 3'b110;
	number = 8'b01010000; sel = 2'b00; #10;//80
	number = 8'b00000000; sel = 2'b01; #10;//80 
	number = 8'b00111100; sel = 2'b00; #10;//60
	number = 8'b01000110; sel = 2'b00; #10;//70
	number = 8'b00000000; sel = 2'b11; #10;//100
	$stop;
end

endmodule