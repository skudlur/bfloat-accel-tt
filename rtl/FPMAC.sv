module FPMAC(a,b,out);
input logic[15:0]a,b;
output logic [15:0]out;

logic [15:0]local_a,local_b;
logic [15:0] fprod, fadd;

assign local_a = a;
assign local_b = b;

FPMUL mul(local_a,local_b,fprod);
bfloat16adder add(fprod,out,fadd);

/*
always_comb
begin

local_a = a;
local_b = b;
fprod1 = fprod;

end
*/


assign out = fadd;

endmodule