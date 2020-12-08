\m4_TLV_version 1d: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/c1719d5b338896577b79ee76c2f443ca2a76e14f/tlv_lib/risc-v_shell_lib.tlv'])

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV

   // /====================\
   // | Sum 1 to 9 Program |
   // \====================/
   //
   // Program for MYTH Workshop to test RV32I
   // Add 1,2,3,...,9 (in that order).
   //
   // Regs:
   //  r10 (a0): In: 0, Out: final sum
   //  r12 (a2): 10
   //  r13 (a3): 1..10
   //  r14 (a4): Sum
   // 
   // External to function:
   m4_asm(ADD, r10, r0, r0)             // Initialize r10 (a0) to 0.
   // Function:
   m4_asm(ADD, r14, r10, r0)            // Initialize sum register a4 with 0x0
   m4_asm(ADDI, r12, r10, 1010)         // Store count of 10 in register a2.
   m4_asm(ADD, r13, r10, r0)            // Initialize intermediate sum register a3 with 0
   // Loop:
   m4_asm(ADD, r14, r13, r14)           // Incremental addition
   m4_asm(ADDI, r13, r13, 1)            // Increment intermediate register by 1
   m4_asm(BLT, r13, r12, 1111111111000) // If a3 is less than a2, branch to label named <loop>
   m4_asm(ADD, r10, r14, r0)            // Store final result to register a0 so that it can be read by main program
   
   // Optional:
   // m4_asm(JAL, r7, 00000000000000000000) // Done. Jump to itself (infinite loop). (Up to 20-bit signed immediate plus implicit 0 bit (unlike JALR) provides byte address; last immediate bit should also be 0)
   m4_define_hier(['M4_IMEM'], M4_NUM_INSTRS)

   // RV_D4SK2_L1
   m4_define(['M4_IMEM_INDEX_CNT'], 32)
   |cpu
      @0
         $reset = *reset;
         
         $pc[31:0] = >>1$reset ? 0 : (>>1$pc[31:0] + 4);
         
         // RV_D4SK2_L2
      @1
         $imem_rd_en = !$reset;
         
         $imem_rd_addr[M4_IMEM_INDEX_CNT-1:0] = $pc[31:0];
         
         $instr[31:0] = $imem_rd_data[31:0];
         
         // RV_D4SK2_L3
         //Decoder
         //Instruction type decode
         
         $is_i_type = $instr[6:2] ==? 5'b0000x || 
                       $instr[6:2] ==? 5'b001x0 || 
                       $instr[6:2] == 5'b11001;
         
         $is_s_type = $instr[6:2] ==? 5'b0100x;
         
         $is_b_type = $instr[6:2] ==? 5'b11000;
         
         $is_u_type = $instr[6:5] ==? 5'b0x101;
         
         $is_j_type = $instr[6:2] ==? 5'b11011;
         
         $is_r_type = $instr[6:2] ==? 5'b011x0 ||
                       $instr[6:2] ==? 5'b01011 ||
                       $instr[6:2] ==? 5'b10100;
         
         // RV_D4SK2_L4
         //Immediete decode
         
         $imm[31:0] = $is_i_type ? { {21{$instr[31]}} , {$instr[30:20]} } :
                      $is_s_type ? { {21{$instr[31]}} , {$instr[30:25]} , {$instr[11:7]} } :
                      $is_b_type ? { {20{$instr[31]}} , {$instr[7]} , {$instr[30:25]} , {$instr[11:8]} , 1'b0 } :
                      $is_u_type ? { {$instr[31:12]} , 12'b0 } :
                      $is_j_type ? { {12{$instr[31]}} , {$instr[19:12]} , {$instr[20]} , {$instr[30:21]} , 1'b0 } :
                      32'b0;
         
         // RV_D4SK2_L5
         
         $funct7_valid = $is_r_type;
         ?$funct7_valid
            $funct7[6:0] = $instr[31:25];
         
         $rs2_valid = $is_r_type || $is_s_type || $is_b_type;
         ?$rs2_valid
            $rs2[4:0] = $instr[24:20];
         
         $rs1_valid = $is_r_type || $is_i_type || $is_s_type || $is_b_type;
         ?$rs1_valid
            $rs1[4:0] = $instr[19:15];
         
         $funct3_valid = $is_r_type || $is_i_type || $is_s_type || $is_b_type;
         ?$funct3_valid
            $funct3[2:0] = $instr[14:12];
         
         $rd_valid = $is_r_type || $is_i_type || $is_u_type || $is_j_type;
         ?$rd_valid
            $rd[4:0] = $instr[11:7];
         
         $opcode[6:0] = $instr[6:0];
         
         // RV_D4SK2_L6
         // Decoding instructions
         
         $decode_bits[10:0] = { $funct7[5], $funct3, $opcode};
         
         $is_beq = $decode_bits ==? 11'bx_000_1100011;
         
         $is_bne = $decode_bits ==? 11'bx_001_1100011;
         
         $is_blt = $decode_bits ==? 11'bx_100_1100011;
         
         $is_bge = $decode_bits ==? 11'bx_101_1100011;
         
         $is_bltu = $decode_bits ==? 11'bx_110_1100011;
         
         $is_bgeu = $decode_bits ==? 11'bx_111_1100011;
         
         $is_addi = $decode_bits ==? 11'bx_000_0010011;
         
         $is_add = $decode_bits ==? 11'b0_000_0110011;
         
         // RV_D4SK3_L1 Register file
         
         $rf_rd_en1 = $rs1_valid;
         $rf_rd_index1[4:0] = $rs1[4:0];
         
         $rf_rd_en2 = $rs2_valid;
         $rf_rd_index2[4:0] = $rs2[4:0];
         
         $src1_value[31:0] = $rf_rd_data1[31:0];
         $src2_value[31:0] = $rf_rd_data2[31:0];
         
         //ALU
         $result[31:0] = $is_addi ? ($src1_value[31:0] + $imm[31:0]) :
                         $is_add ? ($src1_value[31:0] + $imm[31:0]) :
                         32'b0;
                         
         $rf_wr_en = ($rd == 0) ? 0 : $rd_valid; // If destinatoin register is "Zero" then do not enable write register
         $rf_wr_index[4:0] = $rd; // Register destination
         
         //RV_D4SK3_L6
         
         $taken_br = $is_beq ? ($src1_value == $src2_value) : 
                     $is_bnq ? ($src1_value != $src2_value) : 
                     $is_blt ? (($src1_value < $src2_value) ^ ($src1_value[31] != $src2_value[31])) : 
                     $is_bge ? (($src1_value >= $src2_value) ^ ($src1_value[31] != $src2_value[31])) : 
                     $is_bltu ? ($src1_value < $src2_value) : 
                     $is_bgeu ? ($src1_value >= $src2_value) : 
                     1'b0;
         
         `BOGUS_USE($is_beq $is_bne $is_blt $is_bge $is_bltu $is_bgeu $is_addi $is_add)
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
   
   // Macro instantiations for:
   //  o instruction memory
   //  o register file
   //  o data memory
   //  o CPU visualization
   |cpu
      m4+imem(@1)    // Args: (read stage)
         
      m4+rf(@1, @1)  // Args: (read stage, write stage) - if equal, no register bypass is required
      //m4+dmem(@4)    // Args: (read/write stage)
   
   //m4+cpu_viz(@4)    // For visualisation, argument should be at least equal to the last stage of CPU logic
                       // @4 would work for all labs
\SV
   endmodule
