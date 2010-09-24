/****************************************************************************************
*
*   Disclaimer   This software code and all associated documentation, comments or other 
*  of Warranty:  information (collectively "Software") is provided "AS IS" without 
*                warranty of any kind. MICRON TECHNOLOGY, INC. ("MTI") EXPRESSLY 
*                DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
*                TO, NONINFRINGEMENT OF THIRD PARTY RIGHTS, AND ANY IMIED WARRANTIES 
*                OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. MTI DOES NOT 
*                WARRANT THAT THE SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE 
*                OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. 
*                FURTHERMORE, MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR 
*                THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS, 
*                ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT OF USE 
*                OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO EVENT SHALL MTI, 
*                ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE LIABLE FOR ANY DIRECT, 
*                INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR SPECIAL DAMAGES (INCLUDING, 
*                WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, 
*                OR LOSS OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE 
*                THE SOFTWARE, EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
*                DAMAGES. Because some jurisdictions prohibit the exclusion or 
*                limitation of liability for consequential or incidental damages, the 
*                above limitation may not apply to you.
*
*                Copyright 2003 Micron Technology, Inc. All rights reserved.
*
****************************************************************************************/
 
`define V33 // no supported parts at 1.8v
`ifdef x8
    parameter tRC_min      =      30;
    parameter tRP_min      =      15;
    parameter tWC_min      =      30;
    parameter tWP_min      =      15;
    parameter tCEA_max     =      23;
    parameter tCLS_min     =      10;
    parameter tCLH_min     =       5;
    parameter tCS_min      =      15;
    parameter tCH_min      =       5;
    parameter tDS_min      =      10;
    parameter tDH_min      =       5;
    parameter tALS_min     =      10;
    parameter tALH_min     =       5;
    parameter tREA_max     =      18;
    parameter tREH_min     =      10;
    parameter tWH_min      =      10;  
`else                          //    Timing Parameters for 3.3Volt x16 and 1.8Volt NAND parts
    parameter tRC_min      =      50;
    parameter tRP_min      =      25;
    parameter tWC_min      =      45;
    parameter tWP_min      =      25;
    parameter tCEA_max     =      45;
    parameter tCLS_min     =      25;
    parameter tCLH_min     =      10;
    parameter tCS_min      =      35;
    parameter tCH_min      =      10;
    parameter tDS_min      =      20;
    parameter tDH_min      =      10;
    parameter tALS_min     =      25;
    parameter tALH_min     =      10;
    parameter tREA_max     =      30;
    parameter tREH_min     =      15;
    parameter tWH_min      =      15;  
`endif 
// program page cache mode has special timing for all configs
    parameter tWC_cache_min      =      45;
    parameter tWP_cache_min      =      25;
    parameter tWH_cache_min      =      15;  
    parameter tCLS_cache_min     =      25;
    parameter tCLH_cache_min     =      10;
    parameter tCS_cache_min      =      35;
    parameter tCH_cache_min      =      10;
    parameter tDS_cache_min      =      20;
    parameter tDH_cache_min      =      10;
    parameter tALS_cache_min     =      25;
    parameter tALH_cache_min     =      10;
	parameter tIR_cache_min      =       0;
    parameter tRC_cache_min      =      50;
    parameter tREH_cache_min     =      15;
    parameter tRP_cache_min      =      25;
    parameter tCEA_cache_max     =      45;
    parameter tREA_cache_max     =      30;

// parameters for all devices
    parameter PAGE_BITS    =       6;  // 2^6=64
    parameter tBERS_min    = 2000000;
    parameter tBERS_max    = 3000000;
    parameter tCBSY_min    =    3000;
    parameter tCBSY_max    =  700000;
    parameter tPROG_typ    =  300000;
    parameter tPROG_max    =  700000;
	parameter NPP		   =	   8;
	parameter tCLR_min     =      10;
	parameter tIR_min      =       0;
	parameter tWW_min      =      30;
	parameter tADL_min     =     100;
	parameter tCHZ_max     =      20;
    parameter tAR_min      =      10;
    parameter tDCBSYR1_min =       0;
    parameter tDCBSYR1_max =    3000;
    parameter tDCBSYR2_min =    3000;
    parameter tDCBSYR2_max =   25000;
    parameter tOH_min      =      15;
    parameter tR_max       =   25000;
    parameter tRHZ_max     =      30;
    parameter tRR_min      =      20;
    parameter tRST_read    =    5000;
    parameter tRST_prog    =   10000;
    parameter tRST_erase   =  500000;
    parameter tRST_powerup =    5000;
	parameter tRST_ready   =    5000;
	parameter tRPRE_max    =   25000;
    parameter tWB_max      =     100;  
    parameter tWHR_min     =      60;  

// unused timing parameters for this device
	parameter tDBSY_min    = 	   0;
	parameter tDBSY_max	   =	   0;
	parameter tLBSY_min	   =       0;
	parameter tLBSY_max	   =       0;
	parameter tRHW_min     =       0;
	parameter tRHOH_min    =       tOH_min;
	parameter tRLOH_min    =       0;
	parameter tOBSY_max    =       0;
	parameter tFEAT		   =       0;
	//programmable drivestrength timing parameters
	parameter tCLHIO_min   =	   0;
	parameter tCLSIO_min   =       0;
	parameter tDHIO_min    =       0;
	parameter tDSIO_min    =       0;
	parameter tREAIO_max   =       0;
	parameter tRPIO_min    =       0;
	parameter tWCIO_min    =       0;
	parameter tWHIO_min    =       0;
	parameter tWHRIO_min   =       0;
	parameter tWPIO_min    =       0;

`ifdef x8
    parameter COL_BITS  =     12;
    parameter DQ_BITS =      8;
`else 
    parameter COL_BITS  =     11; 
    parameter DQ_BITS =     16;
`endif

 parameter NUM_OTP_ROW   =   0;  // Number of OTP pages

`ifdef G2
    parameter ROW_BITS  =     17;
    parameter BLCK_BITS =     11;  // 2^11*Byte=2048 2G
`else `ifdef G4
    parameter ROW_BITS  =     18;
    parameter BLCK_BITS =     12;  // 2^11*Word=4096 for 4G
`else `ifdef G8
    parameter ROW_BITS  =     18;
    parameter BLCK_BITS =     12;  // 2^11*Word=4096 for 4G x 2 die = 8G
`else
	`define G4
	// make G4 default size
	parameter ROW_BITS  =	  18;
	parameter BLCK_BITS =	  12;             
`endif `endif `endif

`ifdef FullMem   // Only do this if you require the full memmory size.
    `ifdef G2
        parameter NUM_ROW   = 131072;  // PagesXBlocks = 64x2048  for 2G
    `else `ifdef G4
        parameter NUM_ROW   = 262144;  // PagesXBlocks = 64x4096  for 4G
    `else `ifdef G8
        parameter NUM_ROW   = 524288;  // PagesXBlocks = 64x4096  for 4G
    `endif `endif `endif
    parameter NUM_PAGE  =    64;
	`ifdef x8
		NUM_COL 		=  2112;
    `else
        NUM_COL         =  1056;
    `endif
`else
    // changed these to smaller values so sim loads and runs faster
    parameter NUM_ROW   =   128;  // PagesXBlocks = 64x16, 16 Blocks for fast sim load
    parameter NUM_PAGE  =    32;
	parameter NUM_COL =  128;
`endif

    parameter NUM_ID_BYTES = 4;
    parameter READ_ID_BYTE0     =  8'h2c;   // Micron Manufacturer ID
	parameter READ_ID_BYTE4 	=  8'b00; //not defined for this part
`ifdef G2
   `ifdef V33     
      `ifdef x8    // 2Gig 3.3V by 8
         parameter READ_ID_BYTE1     =  8'hda;
      `endif
      `ifdef x16   // 2Gig 3.3V by 16
         parameter READ_ID_BYTE1     =  8'hca;
      `endif
   `else
      `ifdef x8    // 2Gig 1.8V by 8
         parameter READ_ID_BYTE1     =  8'haa;
      `endif
      `ifdef x16   // 2Gig 1.8V by 16
         parameter READ_ID_BYTE1     =  8'hba;
      `endif
   `endif
`else `ifdef G4
   `ifdef V33     
      `ifdef x8    // 4Gig 3.3V by 8
         parameter READ_ID_BYTE1     =  8'hdc;
      `endif
      `ifdef x16   // 4Gig 3.3V by 16
         parameter READ_ID_BYTE1     =  8'hcc;
      `endif
   `else
      `ifdef x8    // 4Gig 1.8V by 8
         parameter READ_ID_BYTE1     =  8'hac;
      `endif
      `ifdef x16   // 4Gig 1.8V by 16
         parameter READ_ID_BYTE1     =  8'hbc;
      `endif
   `endif
`else `ifdef G8
   `ifdef V33     
      `ifdef x8    // 8Gig 3.3V by 8
         parameter READ_ID_BYTE1     =  8'hdc;   // this is not intuitive but not a bug, see datasheet note
      `endif
      `ifdef x16   // 4Gig 3.3V by 16
         parameter READ_ID_BYTE1     =  8'hcc;
      `endif
   `else
      `ifdef x8    // 4Gig 1.8V by 8
         parameter READ_ID_BYTE1     =  8'hac;
      `endif
      `ifdef x16   // 4Gig 1.8V by 16
         parameter READ_ID_BYTE1     =  8'hbc;
      `endif
   `endif
`endif `endif `endif
  parameter READ_ID_BYTE2     =  8'h69;   // Dont care
`ifdef x8    
   parameter READ_ID_BYTE3     =  8'h15;
`else `ifdef x16
   parameter READ_ID_BYTE3     =  8'h55;
`endif `endif    


parameter FEATURE_SET = 12'b000000001111;
// FEATURE_SET      unused--\\\\\\\\\\\\--basic NAND commands
//                   unused--\\\\\\\\\\--new commands (page rd cache commands)
//                    unused--\\\\\\\\--read ID2
//			   drive strength--\\\\\\--read unique
//			        block lock--\\\\--OTP commands
//						   ONFI--\\--2plane commands

// Preload Pin
`define PRE 1'b1

`ifdef G2
	parameter NUM_DIE 	=			1;
	parameter NUM_CE 	=			1;
`else `ifdef G4
	parameter NUM_DIE 	=			2;
	parameter NUM_CE 	=			1;
`else `ifdef G8
	parameter NUM_DIE 	=			4;
	parameter NUM_CE 	=			2;
`endif `endif `endif
