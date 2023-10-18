module FPCMP(a,b,out);

input logic [15:0]a,b;
output logic [1:0]out; 

// 00 - equal
// 01 - a < b
// 10 - a > b
// 11 - none

logic sign_a,sign_b,E_eq,E_ls,E_gr,M_ls,M_gr,M_eq;
logic [7:0]exp_a,exp_b;
logic [6:0]mant_a,mant_b;

always@(*)
begin

sign_a = a[15];
sign_b = b[15];

exp_a = a[14:7];
exp_b = b[14:7];

mant_a = a[6:0];
mant_b = b[6:0];

E_ls = (exp_a < exp_b) ? 1'b1 : 0;
E_gr = (exp_a > exp_b) ? 1'b1 : 0;
E_eq = (exp_a == exp_b)? 1'b1 : 0;

M_ls = (mant_a < mant_b) ? 1'b1 : 0;
M_gr = (mant_a > mant_b) ? 1'b1 : 0;
M_eq = (mant_a == mant_b)? 1'b1 : 0;

//comparator logic

if((a[15] == 1'b1) &&  (b[15] == 0)) out = 2'b01; //a < b
else if ((a[15] == 0) && b[15] == 1'b1) out = 2'b10; //a > b
else if (a[15] == b[15])
	begin
		if(E_ls) out = 2'b01; //exp_a < exp_b
		else if (E_gr) out = 2'b10; //exp_a > exp_b
		else if(E_eq)
			begin
				if(M_ls) out = 2'b01; //mant_a < mant_b
				else if(M_gr) out = 2'b10; //mant_a >mant_b
				else if(M_eq) out = 2'b00;
			end
	end

else out = 2'b11;	
	
end
endmodule