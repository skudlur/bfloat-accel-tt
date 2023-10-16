// Testbench for bfloat-adder.sv
// ===================================
// Inputs: [15:0] a, [15:0] b, res, clk
// Outputs: [15:0] out


// Program block 
program test_bfloat;

   // Parameters
   parameter NUM_TESTS = 100;

   // Signals
   reg [15:0] input1;
   reg [15:0] input2;

   wire [15:0] out;

   // Coverage
   covergroup bf16adder_coverage;
      // Coverpoints for 16-bit a and b inputs
      coverpoint input1 {
	 bins in_bin = { [0:65535] };
      }
      coverpoint input2 {
	 bins in_bin = { [0:65535] };
      }

      // Coverpoints for 16-bit output
      coverpoint out {
	 bins out_bin = { [0:65535] };
      }

      // Cross coverage for inputs
      cross input_cross = {
	 input1,
	 input2,
	 out
      };
   endgroup // bf16adder_coverage

   // covergroup instance
   bf16adder_coverage bf16_adder_cov;
 
   // Design under test instance
   bf16adder dut (.a(input1),
		  .b(input2),
		  .sum(out));

   // Testbench
   initial begin
      // Initialize input signals
      input1 = 16'h0000;
      input2 = 16'h0000;

      // Coverage reset
      bf16_adder_cov.reset();

      // Generation of tests
      repeat (NUM_TESTS) begin
	 input1 = $random;
	 input2 = $random;
	 $display("Test: input1 = %p, input2 = %p", input1, input2);
	 #10;
      end

      $finish;
   end // initial begin

   final begin
      bf16_adder_cov.write();
   end

endprogram // test_bfloat
