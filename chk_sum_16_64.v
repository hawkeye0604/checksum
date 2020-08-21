/***************************************************************************************
* Developer    : A V
* Version      : 1.0
* Filename     : chk_sum_16_64.v  
* Date         : 22/8/2020 
* 
* This module calculates 16-bit chekcsum and checksum match for 64-bit incoming data
**************************************************************************************/

module chk_sum_16_64 (reset, clk, enable, data_in, chksum_op,chksum_match);

input  reset,clk,enable;
input  [63:0] data_in;
output [15:0] chksum_op;
output chksum_match;

reg [19:0] data_sum_c;		//variable to hold data with 4 bit carry
reg [3:0]  carry; 				//variable to sotre 4-bit carry stored in above module
reg [19:0] data_sum_ac;	  //variable to store result after adding carry 
reg [15:0] result;

//clocked process to store result in reg
always@(posedge clk)
begin
	if(reset)
		result <= 0;
	else
		begin
			if(enable)
				result <= data_sum_ac;
			else
				result <= 0;
		end
end

assign data_sum_c   = {4'b0,result} + {4'b0,data_in[15:0]} + {4'b0,data_in[31:16]}
																	 + {4'b0,data_in[47:32]} + {4'b0,data_in[63:48]};
assign carry 			  = data_sum_c[19:16];
assign data_sum_ac  = {4'b0,data_sum_c} + {12'b0,carry};

// Output port assignment
assign chksum_op    = result;
assign chksum_match = (result == 'hFFFF)?1:0;

endmodule


