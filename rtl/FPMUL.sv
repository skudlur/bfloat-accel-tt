module FPMUL(a,b,prod,exception,overflow,underflow);
input logic [15:0]a,b;
output logic [15:0]prod;
output logic exception,overflow,underflow;

logic [15:0]local_a1,local_b1;
logic [8:0]local_prod_exp;
logic [7:0]local_mant_a,local_mant_b;
logic [6:0]local_mant_prod;
logic [15:0]mant_prod_temp;
logic zero,sign;

always_comb
begin
	
	sign = a[15] ^ b[15];

	local_prod_exp = a[14:7] - 8'd127;
	local_prod_exp = local_prod_exp + b[14:7];	
	
	exception = (&a[14:7]) | (&b[14:7]); //if either of the expo is 255
	
	local_mant_a = {1'b1,a[6:0]};
	local_mant_b = {1'b1,b[6:0]};
	mant_prod_temp = local_mant_a * local_mant_b;
	
	local_mant_prod = mant_prod_temp[15] ? mant_prod_temp[14:8] : mant_prod_temp[13:7];
	local_prod_exp = mant_prod_temp[15] ? local_prod_exp + 1'b1 : local_prod_exp;
	
	zero = exception ? 1'b0 : (local_mant_prod == 7'b0) ? 1'b1 : 1'b0; //check for NaN
	
	overflow = (local_prod_exp[8] & !local_prod_exp[7] & !zero); //255+255-127 = 383 = 10111111 (383 cannot be staored in 8b exp field)
	
	underflow = (local_prod_exp[8] & local_prod_exp[7] & !zero) ? 1'b1 : 1'b0;; //126 = 00111111 (126 is lesser than 127 so underflow)
end

/*
assign prod[14:7] = local_prod_exp[7:0];
assign prod[6:0] = local_mant_prod;
*/
assign prod = exception ? 16'b0 : zero ? {sign,15'b0} : overflow ? {sign,8'hFF,7'b0} : underflow ? {sign,15'b0} : {sign,local_prod_exp[7:0],local_mant_prod};

endmodule
