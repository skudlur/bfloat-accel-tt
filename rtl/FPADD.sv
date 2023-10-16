module bfloat16adder(a,b,sum);

input logic [15:0]a,b;
output logic [15:0]sum;

logic guard,round_bit,sticky_bit,round,LSB_add;
logic [15:0]local_a,local_b,temp;
logic [7:0]exp_a,exp_b,exp_sum;
logic [6:0]mant_a,mant_b,mant_sum;
logic [15:0]local_mant_a,local_mant_b,local_mant_sum,normalised_sum; //used  to store shifted mantissa values for addition
logic [8:0]compressed_sum;
logic [7:0]shift;



always@(*)
begin
	
	local_a = a;
	local_b = b;
			
	if(a[14:7] < b[14:7])
		begin
			temp = local_a;
			local_a = local_b;
			local_b = temp;
		end 							//this ensures that the input with larger exponent will always reside in a
				
	exp_a = local_a[14:7];
	exp_b = local_b[14:7];
	mant_a = local_a[6:0];
	mant_b = local_b[6:0];
		
	shift = exp_a - exp_b;
		
	local_mant_a = {2'b01,mant_a,7'b0};
	local_mant_b = {2'b01,mant_b,7'b0};
	
	local_mant_b = local_mant_b >> shift;
	
	local_mant_sum = local_mant_a + local_mant_b;
	
	normalised_sum[13:0] = local_mant_sum[15] ? local_mant_sum[14:1] : local_mant_sum[13:0];
	exp_sum = local_mant_sum[15] ? (exp_a + 1'b1) : (exp_a) ;
	normalised_sum[15:14] = {2'b01};
		
	guard = normalised_sum[7];
	round_bit = normalised_sum[6];
	sticky_bit = (| normalised_sum[5:0]);
		
	LSB_add = (round_bit & (sticky_bit | guard)) ? 1'b1 : 0;
		
	compressed_sum <= normalised_sum[15:7] + LSB_add;
		
	mant_sum = compressed_sum[8] ? compressed_sum[7:1] : compressed_sum[6:0];
	exp_sum = compressed_sum[8] ? (exp_sum + 1'b1) : exp_sum;
	
end
	assign sum[15] = local_a[15];
	assign sum[14:7] = exp_sum + 8'd127;
	assign sum[6:0] = mant_sum;
endmodule
