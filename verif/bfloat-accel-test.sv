// Testbench for bfloat-adder.sv
// ===================================
// Inputs: [15:0] a, [15:0] b, res, clk
// Outputs: [15:0] out


// Program block 
// Code your testbench here
// or browse Examples
// Testbench for bfloat-adder.sv
// ===================================
// Inputs: [15:0] a, [15:0] b,
// Outputs: [15:0] out


// Program block 
module test_bfloat;

   // Parameters
   parameter NUM_TESTS = 100;

   // Signals
   reg [15:0] input1;
   reg [15:0] input2;

   wire [15:0] out;

   // Coverage
   covergroup bf16adder_coverage;
      option.per_instance = 1;
     
      // Coverpoints for 16-bit a and b inputs
      coverpoint input1 {
        bins neg_in_bin[] = { [-31766:-1] };
        bins zero_in_bin = { 0 };
        bins pos_in_bin[] = { [1:32767] };
      }
      coverpoint input2 {
        bins neg_in_bin[] = { [-31766:-1] };
        bins zero_in_bin = { 0 };
        bins pos_in_bin[] = { [1:32767] };
      }

      // Coverpoints for 16-bit output
      coverpoint out {
        bins neg_out_bin[] = { [-31766:-1] };
        bins zero_out_bin = { 0 };
        bins pos_out_bin[] = { [1:32767] };
      }

      // Cross coverage for inputs
      cross input1, input2;
   endgroup // bf16adder_coverage

   // covergroup instance
   bf16adder_coverage bf16_adder_cov = new();
  
   // Design under test instance
   bfloat16adder dut (.a(input1), .b(input2), .sum(out));

   // Testbench
   initial begin
      $dumpfile("dump.vcd"); 
      $dumpvars;
     
      // Initialize input signals
      input1 = 16'h0000;
      input2 = 16'h0000;

      bf16_adder_cov.sample();
     
      // Generation of tests
      repeat (NUM_TESTS) begin
        $display("[%0t] Test: input1 = %h, input2 = %h, output = %h", $time+1/10, input1, input2, out);
	 	input1 = $random;
	 	input2 = $random;
        #10;
      end
   end // initial begin

   initial begin
     #1000 $display ("Coverage = %0.2f %%", bf16_adder_cov.get_coverage());
     $finish;
   end

endmodule // test_bfloat
