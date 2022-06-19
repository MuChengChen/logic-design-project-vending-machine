module final(number,sel,clk,sel_type,if_sell, out_type, charge,seven_all,seven_char);
input [7:0]number;
input [1:0]sel;
input clk;
input [2:0]sel_type;
output  if_sell;
output  [2:0]out_type;
output  [7:0]charge;
output  [20:0]seven_all;
output  [20:0]seven_char;
reg [7:0]out_number=8'b0;


reg [20:0]seven_all=21'b0;
reg [20:0]seven_char=21'b0;
reg if_sell= 0;
reg [2:0]out_type=3'b0;
reg [7:0]charge=8'b0;

wire [20:0]seven_all_temp;
wire [20:0]seven_char_temp;
wire if_sell_temp;
wire [2:0]out_type_temp;
wire [7:0]charge_temp;
wire [7:0] out_number_temp;

calculate ca(number,sel,clk,out_number_temp);
bin_to_seven bi1(out_number_temp, seven_all_temp);
sell se(out_number_temp ,sel, sel_type, clk,  if_sell_temp, out_type_temp, charge_temp);    
bin_to_seven bi2(charge_temp, seven_char_temp);

always@(number)begin
out_number = out_number_temp;
end

always@(seven_all_temp or seven_char_temp or if_sell_temp or out_type_temp or charge_temp)begin
seven_all= seven_all_temp ;
seven_char=seven_char_temp;
if_sell=if_sell_temp;
out_type= out_type_temp;
charge = charge_temp;
end


endmodule

module calculate(number,sel,clk,out_number);
input [7:0]number;
input [1:0]sel;
input clk;
reg [7:0]num_reg=8'b0;
reg [1:0]sel_precycle;
//reg [7:0]num_reg2=8'b0;
output reg [7:0]out_number=8'b0;
always@( posedge clk or number )
	if(sel==2'b00)//when sel=0,add number
		begin
		   num_reg=num_reg+number;
		   out_number=num_reg;
		   sel_precycle<=sel;
		end
	else if(sel==2'b01)//when sel=1,num_reg reset to 0
		begin   
		   num_reg=8'b0;
		   if(sel_precycle==2'b11)
			out_number=8'b0;
		   sel_precycle<=sel;
		end
	else if(sel==2'b10)//when sel=2,subtract number
		begin
		   num_reg=num_reg-number;
		   out_number=num_reg;
      		   sel_precycle<=sel;
		end
	else if(sel==2'b11)//when sel=3,num_reg reset to 0 and output the number which has already count before
		begin
		   num_reg=8'b0;
		   if(sel_precycle==2'b11)
			out_number=8'b0;
             	   sel_precycle<=sel;
		end
endmodule 

module sell( out_number ,sel_in, sel_type, clk,  if_sell, out_type, charge);
input [7:0] out_number; //all scores or money
input clk;
input [1:0] sel_in;  // select  type of input(= sel in  calculate module)
input [2:0] sel_type;  // select which product you want to buy
output if_sell;        // if buy sucesslly
output [2:0] out_type; // what kind of product you buy succelly
output [7:0] charge;   // how much charge


reg if_sell;
reg [2:0] out_type;
reg [7:0] charge;
reg [7:0] need = 8'b0; // mow much you need to pay
reg [7:0] pre_out_number;


always@(sel_type)begin

case(sel_type)

    3'b001: need = 8'b1101110; // need 110
    3'b010: need = 8'b10010110; // need 150
    3'b011: need = 8'b10111110; // need 190
    3'b100: need = 8'b11100110; // need 230
    3'b101: need = 8'b11110011; // need 243
    3'b110: need = 8'b11110; // need 30
    default : need = 8'b0; 


endcase
end

always@( posedge clk or out_number )begin
   
    if(sel_in == 2'b01 )begin
        if_sell = 0;
        out_type= 3'b0;
        charge = out_number;
    end
    else if(sel_in == 2'b10 )begin
	if_sell = 0;
        out_type= 3'b0;
        charge = pre_out_number-out_number;
	pre_out_number<=out_number;
    end
    else if(sel_in==2'b11) begin
        if(out_number >= need)begin
            if_sell = 1;
            out_type= sel_type;
            charge = out_number - need;
        end
        else begin
            if_sell = 0;
            out_type= 3'b0;
            charge = out_number ;      
        end 
    end  
    else begin
	if_sell = 0;
        out_type= 3'b0;
        charge = 8'b0 ;
	pre_out_number<=out_number;
    end
    
end
  
endmodule







module bin_to_seven(bin, seven);
input [7:0] bin;
output [20:0] seven;

wire [11:0] bcd;
wire [6:0] s_hun;
wire [6:0] s_ten;
wire [6:0] s_one;
reg [20:0] seven;


bi_to_bcd  bi1(.in(bin), .out(bcd) );

 seven_seg_display   s1(bcd[11:8], s_hun);
 seven_seg_display   s2(bcd[7:4], s_ten);
 seven_seg_display   s3(bcd[3:0], s_one);


always @(*) begin
seven = {s_hun, s_ten, s_one};
// seven[20 - : 7] = s_hun;
 //seven[13 - : 7] = s_ten;
 //seven[6 - : 7] = s_one;

end

endmodule

module bi_to_bcd(in, out); //8bit binery number to BCD

input [7:0] in;
output [11:0] out; //11:8 hundreds 7:4 tens 3:0 ones

reg [11:0] out;
//initialize out
initial out = 12'b0;


integer i;
integer j;

always@(in) begin
    out = 12'b0;

    for(i = 7; i>= 0; i = i-1)begin


       for (j = 3; j>= 1; j = j-1)begin
            if(out[j*4-1 -: 4] > 4'b0100)begin //if every number >4 , number =number+ 3
                out[j*4-1 -: 4] = out[j*4-1 -: 4] + 4'b0011;
                //out = out + ( 12'b000000000011 << (j*4-4) ); 
            end    
       end     
        out = out << 1;
        out[0] = in[i];    

    end  

end


endmodule



    




module seven_seg_display(n, out);
input  [3:0] n; //input number
output [6:0] out; //out 6:0 represent abcdefg(each one is one of the led )

reg [6:0] out; 

always@(n) begin

    case(n)
        4'b0000: out = 7'b1111110; //0
        4'b0001: out =7'b0110000; //1 
        4'b0010: out =7'b1101101; //2
        4'b0011: out =7'b1111001; //3
        4'b0100: out =7'b0110011; //4
        4'b0101: out =7'b1011011; //5
        4'b0110: out =7'b1011111; //6
        4'b0111: out =7'b1110000; //7
        4'b1000: out =7'b1111111; //8
        4'b1001: out =7'b1110011; //9
endcase
end
endmodule 
