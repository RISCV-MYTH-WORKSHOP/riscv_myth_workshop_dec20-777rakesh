\m4_TLV_version 1d: tl-x.org
\SV

   // =========================================
   // Welcome!  Try the tutorials via the menu.
   // =========================================

   // Default Makerchip TL-Verilog Code Template
   
   `include "sqrt32.v"

   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   $reset = *reset;

   // RV_D3SK1_L3_Lab
   //$out[5:0] = $in1[3:0] + $in2[3:0] + 10;
   //$out1 = $sel ? $in3 : $in2;

/*
   // RV_D3SK2_L3_Lab
   |calc
      // Calculator
      @1
         $val1[31:0] = >>2$out;
         $val2[31:0] = $rand2[3:0];
         
         $sum[31:0] = $val1[31:0] + $val2[31:0];
         $diff[31:0] = $val1[31:0] - $val2[31:0];
         $mul[31:0] = $val1[31:0] * $val2[31:0];
         $div[31:0] = $val1[31:0] / $val2[31:0];

         //Free running counter
         $cnt[0:0] = $reset ? 1 : (>>1$cnt + 1);
         
         $valid[0:0] = $cnt[0:0];
         
      ?$valid
      @2
         $out[31:0] = ($reset) ? 0 : ($op[0] ? $sum[31:0] 
                 : ($op[1] ? $diff[31:0] 
                 : ($op[2] ? $mul[31:0]
                 : $div[31:0]) ) );
   */

   /*
   // RV_D3SK3_L3_Lab Error conditions
   |comp
      @1
         $err1[8:0] = $bad_input[8:0] + $illegal_exp[8:0]
         
      @2
         
      @3
         $err2[8:0] = $over_flow[8:0] || $err1[8:0]
      
      @4
         
      @5
         
      @6
         $err3[8:0] = $div_by_zero[8:0] || $err2[8:0]
   */   
   
   // RV_D3SK4_L3_Lab
   |pythagoras theorem
      @1
         $reset = *reset;
      
      ?$valid
         @1
            $a_sq[31:0] = $a[3:0] * $a[3:0];
            $b_sq[31:0] = $b[3:0] * $b[3:0];
         @2   
            $sum_a_b[31:0] = $a_sq[31:0] + $b_sq[31:0];
         @3   
            $c[31:0] = sqrt($sum_a_b[31:0]);
      @4
         $tot_distance[63:0] = 
               $reset ? 0 : (
                  $valid ? (>>1$tot_distance + $c) : $RETAIN  );
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
