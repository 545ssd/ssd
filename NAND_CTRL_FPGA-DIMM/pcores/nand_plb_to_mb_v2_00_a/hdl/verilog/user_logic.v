//----------------------------------------------------------------------------
// user_logic.vhd - module
//----------------------------------------------------------------------------
//
// ***************************************************************************
// ** Copyright (c) 1995-2009 Xilinx, Inc.  All rights reserved.            **
// **                                                                       **
// ** Xilinx, Inc.                                                          **
// ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
// ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
// ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
// ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
// ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
// ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
// ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
// ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
// ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
// ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
// ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
// ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
// ** FOR A PARTICULAR PURPOSE.                                             **
// **                                                                       **
// ***************************************************************************
//
//----------------------------------------------------------------------------
// Filename:          user_logic.vhd
// Version:           2.00.a
// Description:       User logic module.
// Date:              Wed May 05 15:07:59 2010 (by Create and Import Peripheral Wizard)
// Verilog Standard:  Verilog-2001
//----------------------------------------------------------------------------
// Naming Conventions:
//   active low signals:                    "*_n"
//   clock signals:                         "clk", "clk_div#", "clk_#x"
//   reset signals:                         "rst", "rst_n"
//   generics:                              "C_*"
//   user defined types:                    "*_TYPE"
//   state machine next state:              "*_ns"
//   state machine current state:           "*_cs"
//   combinatorial signals:                 "*_com"
//   pipelined or register delay signals:   "*_d#"
//   counter signals:                       "*cnt*"
//   clock enable signals:                  "*_ce"
//   internal version of output port:       "*_i"
//   device pins:                           "*_pin"
//   ports:                                 "- Names begin with Uppercase"
//   processes:                             "*_PROCESS"
//   component instantiations:              "<ENTITY_>I_<#|FUNC>"
//----------------------------------------------------------------------------
`include "nand_controller.v"

module user_logic
(
  // -- ADD USER PORTS BELOW THIS LINE ---------------
  	
      nand_fsm_clk,
      
      //NAND1
      nand_01_re_L,
      nand_01_we_L,
      nand_01_ale,
      nand_01_cle,
      nand_01_ce1_L,
      nand_01_ce2_L,
      
      nand_01_rb1_L,
      nand_01_rb2_L,
      
      nand_01_io_I,
      nand_01_io_O,
      nand_01_io_T,
      nand_01_iodir,
      
      //NAND2
      nand_02_re_L,
      nand_02_we_L,
      nand_02_ale,
      nand_02_cle,
      nand_02_ce1_L,
      nand_02_ce2_L,
     
      nand_02_rb1_L,
      nand_02_rb2_L,
          
      nand_02_io_I,
      nand_02_io_O,
      nand_02_io_T,
      nand_02_iodir,
      
      //NAND3
      nand_03_re_L,
      nand_03_we_L,
      nand_03_ale,
      nand_03_cle,
      nand_03_ce1_L,
      nand_03_ce2_L,
     
      nand_03_rb1_L,
      nand_03_rb2_L,
          
      nand_03_io_I,
      nand_03_io_O,
      nand_03_io_T,
      nand_03_iodir,
  
      //NAND4
      nand_04_re_L,
      nand_04_we_L,
      nand_04_ale,
      nand_04_cle,
      nand_04_ce1_L,
      nand_04_ce2_L,
      
      nand_04_rb1_L,
      nand_04_rb2_L,
          
      nand_04_io_I,
      nand_04_io_O,
      nand_04_io_T,
      nand_04_iodir,
  // -- ADD USER PORTS ABOVE THIS LINE ---------------

  // -- DO NOT EDIT BELOW THIS LINE ------------------
  // -- Bus protocol ports, do not add to or delete 
  Bus2IP_Clk,                     // Bus to IP clock
  Bus2IP_Reset,                   // Bus to IP reset
  Bus2IP_Data,                    // Bus to IP data bus
  Bus2IP_BE,                      // Bus to IP byte enables
  Bus2IP_RdCE,                    // Bus to IP read chip enable
  Bus2IP_WrCE,                    // Bus to IP write chip enable
  IP2Bus_Data,                    // IP to Bus data bus
  IP2Bus_RdAck,                   // IP to Bus read transfer acknowledgement
  IP2Bus_WrAck,                   // IP to Bus write transfer acknowledgement
  IP2Bus_Error                    // IP to Bus error response
  // -- DO NOT EDIT ABOVE THIS LINE ------------------
); // user_logic

// -- ADD USER PARAMETERS BELOW THIS LINE ------------
// --USER parameters added here 
// -- ADD USER PARAMETERS ABOVE THIS LINE ------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol parameters, do not add to or delete
parameter C_SLV_DWIDTH                   = 32;
parameter C_NUM_REG                      = 40;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

// -- ADD USER PORTS BELOW THIS LINE -----------------
    input nand_fsm_clk;

    //NAND1
    output nand_01_re_L;
    output nand_01_we_L;
    output nand_01_ale;
    output nand_01_cle;
    output nand_01_ce1_L;
    output nand_01_ce2_L;
    
    input  nand_01_rb1_L;
    input  nand_01_rb2_L;
    
    input  [7:0] nand_01_io_I;
    output [7:0] nand_01_io_O;
    output nand_01_io_T;
    output nand_01_iodir;
    
    //NAND2
    output nand_02_re_L;
    output nand_02_we_L;
    output nand_02_ale;
    output nand_02_cle;
    output nand_02_ce1_L;
    output nand_02_ce2_L;
    
    input  nand_02_rb1_L;
    input  nand_02_rb2_L;
    
    input  [7:0] nand_02_io_I;
    output [7:0] nand_02_io_O;
    output nand_02_io_T;
    output nand_02_iodir;
    
    //NAND3
    output nand_03_re_L;
    output nand_03_we_L;
    output nand_03_ale;
    output nand_03_cle;
    output nand_03_ce1_L;
    output nand_03_ce2_L;
    
    input  nand_03_rb1_L;
    input  nand_03_rb2_L;
    
    input  [7:0] nand_03_io_I;
    output [7:0] nand_03_io_O;
    output nand_03_io_T;
    output nand_03_iodir;

    //NAND4
    output nand_04_re_L;
    output nand_04_we_L;
    output nand_04_ale;
    output nand_04_cle;
    output nand_04_ce1_L;
    output nand_04_ce2_L;
    
    input  nand_04_rb1_L;
    input  nand_04_rb2_L;
    
    input  [0:7] nand_04_io_I;
    output [0:7] nand_04_io_O;
    output nand_04_io_T;
    output nand_04_iodir;
// -- ADD USER PORTS ABOVE THIS LINE -----------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol ports, do not add to or delete
input                                     Bus2IP_Clk;
input                                     Bus2IP_Reset;
input      [0 : C_SLV_DWIDTH-1]           Bus2IP_Data;
input      [0 : C_SLV_DWIDTH/8-1]         Bus2IP_BE;
input      [0 : C_NUM_REG-1]              Bus2IP_RdCE;
input      [0 : C_NUM_REG-1]              Bus2IP_WrCE;
output     [0 : C_SLV_DWIDTH-1]           IP2Bus_Data;
output                                    IP2Bus_RdAck;
output                                    IP2Bus_WrAck;
output                                    IP2Bus_Error;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------

  // --USER nets declarations added here, as needed for user logic
   wire [31:0] sys_ctrl_reg,  nand1_cmd_reg, nand2_cmd_reg, nand3_cmd_reg, nand4_cmd_reg;
   wire [31:0] debug_reg;
   wire [31:0] nand1_status_reg, nand2_status_reg, nand3_status_reg, nand4_status_reg;
   wire [31:0] nand1_data_buf, nand2_data_buf, nand3_data_buf, nand4_data_buf;
   wire sys_reset;
   wire nand1_clear_cmd_reg, nand2_clear_cmd_reg, nand3_clear_cmd_reg, nand4_clear_cmd_reg;
   
  // Nets for user logic slave model s/w accessible register example
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg0;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg1;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg2;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg3;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg4;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg5;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg6;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg7;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg8;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg9;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg10;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg11;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg12;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg13;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg14;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg15;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg16;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg17;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg18;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg19;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg20;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg21;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg22;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg23;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg24;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg25;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg26;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg27;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg28;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg29;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg30;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg31;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg32;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg33;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg34;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg35;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg36;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg37;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg38;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg39;
  wire       [0 : 39]                       slv_reg_write_sel;
  wire       [0 : 39]                       slv_reg_read_sel;
  reg        [0 : C_SLV_DWIDTH-1]           slv_ip2bus_data;
  wire                                      slv_read_ack;
  wire                                      slv_write_ack;
  integer                                   byte_index, bit_index;

  // --USER logic implementation added here

	assign 
		nand_01_iodir = nand_01_io_T,
		nand_02_iodir = nand_02_io_T,
		nand_03_iodir = nand_03_io_T,
		nand_04_iodir = nand_04_io_T;
		
	assign  
		sys_ctrl_reg = slv_reg0,   	//MB writes this, but we can clear it
		sys_reset = sys_ctrl_reg[31],
		
		nand1_cmd_reg = slv_reg2,	//MB writes these
		nand2_cmd_reg = slv_reg6,
		nand3_cmd_reg = slv_reg10,
		nand4_cmd_reg = slv_reg14;
      		
      
  nand_controller nandctrl1( .clk(nand_fsm_clk), .reset(sys_reset),
				   .nand_cmd_reg(nand1_cmd_reg), .status_reg(nand1_status_reg), 
				   .debug_reg(), .clear_cmd_reg(nand1_clear_cmd_reg), .nand_data_buf(nand1_data_buf),
				   .re_l(nand_01_re_L), .we_l(nand_01_we_L), 
				   .ale(nand_01_ale), .cle(nand_01_cle),
				   .ce1_l(nand_01_ce1_L), .ce2_l(nand_01_ce2_L), 
				   .io_I(nand_01_io_I), .io_O(nand_01_io_O), .io_T(nand_01_io_T), 
				   .rb1_l(nand_01_rb1_L), .rb2_l(nand_01_rb2_L));
				   
	nand_controller nandctrl2( .clk(nand_fsm_clk), .reset(sys_reset),
				   .nand_cmd_reg(nand2_cmd_reg), .status_reg(nand2_status_reg), 
				   .debug_reg(), .clear_cmd_reg(nand2_clear_cmd_reg), .nand_data_buf(nand2_data_buf),
				   .re_l(nand_02_re_L), .we_l(nand_02_we_L), 
				   .ale(nand_02_ale), .cle(nand_02_cle),
				   .ce1_l(nand_02_ce1_L), .ce2_l(nand_02_ce2_L), 
				   .io_I(nand_02_io_I), .io_O(nand_02_io_O), .io_T(nand_02_io_T), 
				   .rb1_l(nand_02_rb1_L), .rb2_l(nand_02_rb2_L));

	nand_controller nandctrl3( .clk(nand_fsm_clk), .reset(sys_reset),
				   .nand_cmd_reg(nand3_cmd_reg), .status_reg(nand3_status_reg), 
				   .debug_reg(), .clear_cmd_reg(nand3_clear_cmd_reg), .nand_data_buf(nand3_data_buf),
				   .re_l(nand_03_re_L), .we_l(nand_03_we_L), 
				   .ale(nand_03_ale), .cle(nand_03_cle),
				   .ce1_l(nand_03_ce1_L), .ce2_l(nand_03_ce2_L), 
				   .io_I(nand_03_io_I), .io_O(nand_03_io_O), .io_T(nand_03_io_T), 
				   .rb1_l(nand_03_rb1_L), .rb2_l(nand_03_rb2_L));

	nand_controller nandctrl4( .clk(nand_fsm_clk), .reset(sys_reset),
				   .nand_cmd_reg(nand4_cmd_reg), .status_reg(nand4_status_reg), 
				   .debug_reg(), .clear_cmd_reg(nand4_clear_cmd_reg), .nand_data_buf(nand4_data_buf),
				   .re_l(nand_04_re_L), .we_l(nand_04_we_L), 
				   .ale(nand_04_ale), .cle(nand_04_cle),
				   .ce1_l(nand_04_ce1_L), .ce2_l(nand_04_ce2_L), 
				   .io_I(nand_04_io_I), .io_O(nand_04_io_O), .io_T(nand_04_io_T), 
				   .rb1_l(nand_04_rb1_L), .rb2_l(nand_04_rb2_L));				   
				   

	//mux to allow nandctrl to reset the slave reg

  // ------------------------------------------------------
  // Example code to read/write user logic slave model s/w accessible registers
  // 
  // Note:
  // The example code presented here is to show you one way of reading/writing
  // software accessible registers implemented in the user logic slave model.
  // Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  // to one software accessible register by the top level template. For example,
  // if you have four 32 bit software accessible registers in the user logic,
  // you are basically operating on the following memory mapped registers:
  // 
  //    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  //                     "1000"   C_BASEADDR + 0x0
  //                     "0100"   C_BASEADDR + 0x4
  //                     "0010"   C_BASEADDR + 0x8
  //                     "0001"   C_BASEADDR + 0xC
  // 
  // ------------------------------------------------------

  assign
    slv_reg_write_sel = Bus2IP_WrCE[0:39],
    slv_reg_read_sel  = Bus2IP_RdCE[0:39],
    slv_write_ack     = Bus2IP_WrCE[0] || Bus2IP_WrCE[1] || Bus2IP_WrCE[2] || Bus2IP_WrCE[3] || Bus2IP_WrCE[4] || Bus2IP_WrCE[5] || Bus2IP_WrCE[6] || Bus2IP_WrCE[7] || Bus2IP_WrCE[8] || Bus2IP_WrCE[9] || Bus2IP_WrCE[10] || Bus2IP_WrCE[11] || Bus2IP_WrCE[12] || Bus2IP_WrCE[13] || Bus2IP_WrCE[14] || Bus2IP_WrCE[15] || Bus2IP_WrCE[16] || Bus2IP_WrCE[17] || Bus2IP_WrCE[18] || Bus2IP_WrCE[19] || Bus2IP_WrCE[20] || Bus2IP_WrCE[21] || Bus2IP_WrCE[22] || Bus2IP_WrCE[23] || Bus2IP_WrCE[24] || Bus2IP_WrCE[25] || Bus2IP_WrCE[26] || Bus2IP_WrCE[27] || Bus2IP_WrCE[28] || Bus2IP_WrCE[29] || Bus2IP_WrCE[30] || Bus2IP_WrCE[31] || Bus2IP_WrCE[32] || Bus2IP_WrCE[33] || Bus2IP_WrCE[34] || Bus2IP_WrCE[35] || Bus2IP_WrCE[36] || Bus2IP_WrCE[37] || Bus2IP_WrCE[38] || Bus2IP_WrCE[39],
    slv_read_ack      = Bus2IP_RdCE[0] || Bus2IP_RdCE[1] || Bus2IP_RdCE[2] || Bus2IP_RdCE[3] || Bus2IP_RdCE[4] || Bus2IP_RdCE[5] || Bus2IP_RdCE[6] || Bus2IP_RdCE[7] || Bus2IP_RdCE[8] || Bus2IP_RdCE[9] || Bus2IP_RdCE[10] || Bus2IP_RdCE[11] || Bus2IP_RdCE[12] || Bus2IP_RdCE[13] || Bus2IP_RdCE[14] || Bus2IP_RdCE[15] || Bus2IP_RdCE[16] || Bus2IP_RdCE[17] || Bus2IP_RdCE[18] || Bus2IP_RdCE[19] || Bus2IP_RdCE[20] || Bus2IP_RdCE[21] || Bus2IP_RdCE[22] || Bus2IP_RdCE[23] || Bus2IP_RdCE[24] || Bus2IP_RdCE[25] || Bus2IP_RdCE[26] || Bus2IP_RdCE[27] || Bus2IP_RdCE[28] || Bus2IP_RdCE[29] || Bus2IP_RdCE[30] || Bus2IP_RdCE[31] || Bus2IP_RdCE[32] || Bus2IP_RdCE[33] || Bus2IP_RdCE[34] || Bus2IP_RdCE[35] || Bus2IP_RdCE[36] || Bus2IP_RdCE[37] || Bus2IP_RdCE[38] || Bus2IP_RdCE[39];

  // implement slave model register(s)
  always @( posedge Bus2IP_Clk )
    begin: SLAVE_REG_WRITE_PROC

      if ( Bus2IP_Reset == 1 )
        begin
          slv_reg0 <= 0;
          slv_reg1 <= 0;
          slv_reg2 <= 0;
          slv_reg3 <= 0;
          slv_reg4 <= 0;
          slv_reg5 <= 0;
          slv_reg6 <= 0;
          slv_reg7 <= 0;
          slv_reg8 <= 0;
          slv_reg9 <= 0;
          slv_reg10 <= 0;
          slv_reg11 <= 0;
          slv_reg12 <= 0;
          slv_reg13 <= 0;
          slv_reg14 <= 0;
          slv_reg15 <= 0;
          slv_reg16 <= 0;
          slv_reg17 <= 0;
          slv_reg18 <= 0;
          slv_reg19 <= 0;
          slv_reg20 <= 0;
          slv_reg21 <= 0;
          slv_reg22 <= 0;
          slv_reg23 <= 0;
          slv_reg24 <= 0;
          slv_reg25 <= 0;
          slv_reg26 <= 0;
          slv_reg27 <= 0;
          slv_reg28 <= 0;
          slv_reg29 <= 0;
          slv_reg30 <= 0;
          slv_reg31 <= 0;
          slv_reg32 <= 0;
          slv_reg33 <= 0;
          slv_reg34 <= 0;
          slv_reg35 <= 0;
          slv_reg36 <= 0;
          slv_reg37 <= 0;
          slv_reg38 <= 0;
          slv_reg39 <= 0;
        end
      else
      

	/*NAND1*/
	 slv_reg1 <= nand1_status_reg;
	 if(slv_reg_write_sel == 40'b0010000000000000000000000000000000000000 ||
	    nand1_clear_cmd_reg == 1)begin
	 	slv_reg2 <= nand1_clear_cmd_reg? 32'b0:Bus2IP_Data;
	    end
	 slv_reg3 <= nand1_data_buf;
	 

	/*NAND2*/
      	 slv_reg5 <= nand2_status_reg;
      	 if(slv_reg_write_sel == 40'b0000001000000000000000000000000000000000 ||
      	    nand2_clear_cmd_reg == 1)begin
      	 	slv_reg6 <= nand2_clear_cmd_reg? 32'b0:Bus2IP_Data;
      	    end
	 slv_reg7 <= nand3_data_buf;
	 
	/*NAND3*/
	 slv_reg9 <= nand3_status_reg;
	 if(slv_reg_write_sel == 40'b0000000000100000000000000000000000000000 ||
	    nand3_clear_cmd_reg == 1)begin
		slv_reg10 <= nand3_clear_cmd_reg? 32'b0:Bus2IP_Data;
	    end
	 slv_reg11 <= nand3_data_buf;
	 
	/*NAND4*/
	 slv_reg13 <= nand4_status_reg;
	 if(slv_reg_write_sel == 40'b0000000000000010000000000000000000000000 ||
	    nand4_clear_cmd_reg == 1)begin
		slv_reg14 <= nand4_clear_cmd_reg? 32'b0:Bus2IP_Data;
	    end
	 slv_reg15 <= nand4_data_buf;
	 
	 
        case ( slv_reg_write_sel )
          40'b1000000000000000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg0[bit_index] <= Bus2IP_Data[bit_index];
                  
          /* moved regs 1,2,3 above , NAND1 writes to these*/ 
           
          40'b0000100000000000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg4[bit_index] <= Bus2IP_Data[bit_index];
         
         /* moved regs 5,6,7 above , NAND2 writes to these*/ 
         
          40'b0000000010000000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg8[bit_index] <= Bus2IP_Data[bit_index];
          
          /* moved regs 9,10,11 above, NAND3 writes to these*/
          
          40'b0000000000001000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg12[bit_index] <= Bus2IP_Data[bit_index];
                  
          /* moved regs 13,14,15 above, NAND4 writes to these*/
          
          40'b0000000000000000100000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg16[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000010000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg17[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000001000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg18[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000100000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg19[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000010000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg20[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000001000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg21[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000100000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg22[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000010000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg23[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000001000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg24[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000100000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg25[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000010000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg26[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000001000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg27[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000000100000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg28[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000000010000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg29[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000000001000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg30[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000000000100000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg31[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000000000010000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg32[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000000000001000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg33[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000000000000100000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg34[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000000000000010000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg35[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000000000000001000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg36[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000000000000000100 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg37[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000000000000000010 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg38[bit_index] <= Bus2IP_Data[bit_index];
          40'b0000000000000000000000000000000000000001 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg39[bit_index] <= Bus2IP_Data[bit_index];
          default : ;
        endcase

    end // SLAVE_REG_WRITE_PROC

  // implement slave model register read mux
  always @( slv_reg_read_sel or slv_reg0 or slv_reg1 or slv_reg2 or slv_reg3 or slv_reg4 or slv_reg5 or slv_reg6 or slv_reg7 or slv_reg8 or slv_reg9 or slv_reg10 or slv_reg11 or slv_reg12 or slv_reg13 or slv_reg14 or slv_reg15 or slv_reg16 or slv_reg17 or slv_reg18 or slv_reg19 or slv_reg20 or slv_reg21 or slv_reg22 or slv_reg23 or slv_reg24 or slv_reg25 or slv_reg26 or slv_reg27 or slv_reg28 or slv_reg29 or slv_reg30 or slv_reg31 or slv_reg32 or slv_reg33 or slv_reg34 or slv_reg35 or slv_reg36 or slv_reg37 or slv_reg38 or slv_reg39 )
    begin: SLAVE_REG_READ_PROC

      case ( slv_reg_read_sel )
        40'b1000000000000000000000000000000000000000 : slv_ip2bus_data <= slv_reg0;
        40'b0100000000000000000000000000000000000000 : slv_ip2bus_data <= slv_reg1;
        40'b0010000000000000000000000000000000000000 : slv_ip2bus_data <= slv_reg2;
        40'b0001000000000000000000000000000000000000 : slv_ip2bus_data <= slv_reg3;
        40'b0000100000000000000000000000000000000000 : slv_ip2bus_data <= slv_reg4;
        40'b0000010000000000000000000000000000000000 : slv_ip2bus_data <= slv_reg5;
        40'b0000001000000000000000000000000000000000 : slv_ip2bus_data <= slv_reg6;
        40'b0000000100000000000000000000000000000000 : slv_ip2bus_data <= slv_reg7;
        40'b0000000010000000000000000000000000000000 : slv_ip2bus_data <= slv_reg8;
        40'b0000000001000000000000000000000000000000 : slv_ip2bus_data <= slv_reg9;
        40'b0000000000100000000000000000000000000000 : slv_ip2bus_data <= slv_reg10;
        40'b0000000000010000000000000000000000000000 : slv_ip2bus_data <= slv_reg11;
        40'b0000000000001000000000000000000000000000 : slv_ip2bus_data <= slv_reg12;
        40'b0000000000000100000000000000000000000000 : slv_ip2bus_data <= slv_reg13;
        40'b0000000000000010000000000000000000000000 : slv_ip2bus_data <= slv_reg14;
        40'b0000000000000001000000000000000000000000 : slv_ip2bus_data <= slv_reg15;
        40'b0000000000000000100000000000000000000000 : slv_ip2bus_data <= slv_reg16;
        40'b0000000000000000010000000000000000000000 : slv_ip2bus_data <= slv_reg17;
        40'b0000000000000000001000000000000000000000 : slv_ip2bus_data <= slv_reg18;
        40'b0000000000000000000100000000000000000000 : slv_ip2bus_data <= slv_reg19;
        40'b0000000000000000000010000000000000000000 : slv_ip2bus_data <= slv_reg20;
        40'b0000000000000000000001000000000000000000 : slv_ip2bus_data <= slv_reg21;
        40'b0000000000000000000000100000000000000000 : slv_ip2bus_data <= slv_reg22;
        40'b0000000000000000000000010000000000000000 : slv_ip2bus_data <= slv_reg23;
        40'b0000000000000000000000001000000000000000 : slv_ip2bus_data <= slv_reg24;
        40'b0000000000000000000000000100000000000000 : slv_ip2bus_data <= slv_reg25;
        40'b0000000000000000000000000010000000000000 : slv_ip2bus_data <= slv_reg26;
        40'b0000000000000000000000000001000000000000 : slv_ip2bus_data <= slv_reg27;
        40'b0000000000000000000000000000100000000000 : slv_ip2bus_data <= slv_reg28;
        40'b0000000000000000000000000000010000000000 : slv_ip2bus_data <= slv_reg29;
        40'b0000000000000000000000000000001000000000 : slv_ip2bus_data <= slv_reg30;
        40'b0000000000000000000000000000000100000000 : slv_ip2bus_data <= slv_reg31;
        40'b0000000000000000000000000000000010000000 : slv_ip2bus_data <= slv_reg32;
        40'b0000000000000000000000000000000001000000 : slv_ip2bus_data <= slv_reg33;
        40'b0000000000000000000000000000000000100000 : slv_ip2bus_data <= slv_reg34;
        40'b0000000000000000000000000000000000010000 : slv_ip2bus_data <= slv_reg35;
        40'b0000000000000000000000000000000000001000 : slv_ip2bus_data <= slv_reg36;
        40'b0000000000000000000000000000000000000100 : slv_ip2bus_data <= slv_reg37;
        40'b0000000000000000000000000000000000000010 : slv_ip2bus_data <= slv_reg38;
        40'b0000000000000000000000000000000000000001 : slv_ip2bus_data <= slv_reg39;
        default : slv_ip2bus_data <= 0;
      endcase

    end // SLAVE_REG_READ_PROC

  // ------------------------------------------------------------
  // Example code to drive IP to Bus signals
  // ------------------------------------------------------------

  assign IP2Bus_Data    = slv_ip2bus_data;
  assign IP2Bus_WrAck   = slv_write_ack;
  assign IP2Bus_RdAck   = slv_read_ack;
  assign IP2Bus_Error   = 0;

endmodule
