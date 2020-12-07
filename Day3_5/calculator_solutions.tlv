\m4_TLV_version 1d: tl-x.org
\SV

   // =========================================
   // Welcome!  Try the tutorials via the menu.
   // =========================================

   // Default Makerchip TL-Verilog Code Template
   
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   $reset = *reset;

   //$out[5:0] = $in1[3:0] + $in2[3:0] + 10;
   //$out1 = $sel ? $in3 : $in2;


   |calc
      // Calculator
      @0
         $val1[31:0] = >>1$out;
         $val2[31:0] = $rand2[3:0];
         $sum[31:0] = $val1[31:0] + $val2[31:0];
         $diff[31:0] = $val1[31:0] - $val2[31:0];
         $mul[31:0] = $val1[31:0] * $val2[31:0];
         $div[31:0] = $val1[31:0] / $val2[31:0];
         
         $out[31:0] = $reset ? 0 : ($op[0] ? $sum[31:0] 
                 : ($op[1] ? $diff[31:0] 
                 : ($op[2] ? $mul[31:0]
                 : $div[31:0]) ) );
   
   
   |pythagoras theorem
      @0
         $a_sq = $a * $a;
         $b_sq = $b * $b;
      @1   
         $sum_a_b = $a_sq + $b_sq;
      @2   
         $c = sqrt($sum_a_b);
   
   /*
   |Fibonacci
      @0
         // Fibioncci
         $num[31:0] = $reset ? 1 : (>>1$num + >>2$num);
   */
   /*
   |Counter
      @0
         //Free running counter
         $cnt[31:0] = $reset ? 1 : (>>1$cnt + 1);
   */
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
   
\SV
   endmodule
