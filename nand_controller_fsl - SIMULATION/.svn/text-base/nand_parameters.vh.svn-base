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
*                Copyright 2007 Micron Technology, Inc. All rights reserved.
*
****************************************************************************************/
//-------------------------------------------
//   Timing Parameters
//------------------------------------------- 
//setup and hold times
//Command, Data, and Address Input
parameter  tADL_min             =          70; // ALE to data start
parameter  tALH_min             =           5; // ALE hold time
parameter  tALS_min             =          10; // ALE setup time
parameter  tCH_min              =           5; // CE# hold time
parameter  tCLH_min             =           5; // CLE hold time
parameter  tCLS_min             =          10; // CLE setup time
parameter  tCS_min              =          15; // CE# setup time
parameter  tDH_min              =           5; // Data hold time
parameter  tDS_min              =           7; // Data setup time
parameter  tWC_min              =          20; // write cycle time
parameter  tWH_min              =           7; // WE# pulse width HIGH
parameter  tWP_min              =          10; // WE# pulse width
parameter  tWW_min              =          30; // WP# setup time
//Normal Operation
parameter  tAR_min              =          10; // ALE to RE# delay
parameter  tCCS_min             =          70; //Column Change Setup
parameter  tCLR_min             =          10; // CLR to RE# delay
parameter  tCOH_min             =          15; // CE# HIGH to output hold
parameter  tIR_min              =           0; // Output High-Z to RE# LOW
parameter  tOH_min              =          15; // CE# HIGH to output hold
parameter  tRC_min              =          25; // read cycle time
parameter  tREH_min             =          7; // RE# HIGH hold time
parameter  tRHOH_min            =          15; // RE# HIGH to output hold
parameter  tRHW_min             =         100; // RE# HIGH to WE# LOW
parameter  tRLOH_min            =           5; // RE# LOW to output hold
parameter  tRP_min              =          10; // RE# pulse width
parameter  tRR_min              =          20; // Ready to RE# LOW
parameter  tWHR_min             =          60; // WE# HIGH to RE# LOW

//Cache mode ops have special timing
parameter  tALH_cache_min       =    tALH_min; // ALE hold time
parameter  tALS_cache_min       =    tALS_min; // ALE setup time
parameter  tCCS_cache_min       =    tCCS_min; //Column Change Setup
parameter  tCH_cache_min        =     tCH_min; // CE# hold time
parameter  tCLH_cache_min       =    tCLH_min; // CLE hold time
parameter  tCLS_cache_min       =    tCLS_min; // CLE setup time
parameter  tCS_cache_min        =     tCS_min; // CE# setup time
parameter  tDH_cache_min        =     tDH_min; // Data hold time
parameter  tDS_cache_min        =     tDS_min; // Data setup time
parameter  tIR_cache_min        =     tIR_min; // Output High-Z to RE# LOW
parameter  tRC_cache_min        =     tRC_min; // read cycle time
parameter  tREH_cache_min       =    tREH_min; // RE# HIGH hold time
parameter  tRLOH_cache_min      =   tRLOH_min; // RE# LOW to output hold
parameter  tRP_cache_min        =     tRP_min; // RE# pulse width
parameter  tWC_cache_min        =     tWC_min; // write cycle time
parameter  tWH_cache_min        =     tWH_min; // WE# pulse width HIGH
parameter  tWHR_cache_min       =    tWHR_min; // WE# HIGH to RE# LOW
parameter  tWP_cache_min        =     tWP_min; // WE# pulse width
parameter  tWW_cache_min        =     tWW_min; // WP# setup time
//EDO cycle time upper bound
parameter  tEDO_RC              =          30; 
`define EDO

//Delays
parameter  tCEA_max             =          25; // CE# access time
parameter  tCEA_cache_max       =          25; // CE# access time
parameter  tCHZ_max             =          30; // CE# HIGH to output High-Z
parameter  tCHZ_cache_max       =          30; // CE# HIGH to output High-Z
parameter  tDCBSYR1_max         =        5000; // Cache busy in page read cache mode (first 31h) (tRCBSY)
parameter  tR_max               =       25000; // Data transfer from Flash array to data register
parameter  tREA_max             =          16; // RE# access time
parameter  tREA_cache_max       =          16; // RE# access time
parameter  tRHZ_max             =         100; // RE# HIGH to output High-Z
parameter  tRST_read            =        5000; // RESET time issued during READ
parameter  tRST_prog            =       10000; // RESET time issued during PROGRAM
parameter  tRST_erase           =      500000; // RESET time issued during ERASE
parameter  tRST_powerup         =     1000000; // RESET time issued after power-up
parameter  tRST_ready           =        5000; // RESET time issued during idle
parameter  tWB_max              =         100; // WE# HIGH to busy
`ifdef SHORT_RESET
parameter  tVCC_delay           =         100; // VCC valid to R/B# low valid
parameter  tRB_PU_max           =        1000; // R/B# Power up delay.  
`else  // default
parameter  tVCC_delay           =       10000; // VCC valid to R/B# low valid
parameter  tRB_PU_max           =      100000; // R/B# Power up delay.  
`endif

//PROGRAM/ERASE Characteristics
parameter  tBERS_min            =      700000; // BLOCK ERASE operation time
parameter  tBERS_max            =     3000000; // BLOCK ERASE operation time
parameter  tCBSY_min            =       20000; // Busy time for PROGRAM CACHE operation
parameter  tCBSY_max            =      700000; // Busy time for PROGRAM CACHE operation
parameter  tDBSY_min            =         500; // Busy time for TWO-PLANE PROGRAM PAGE operation
parameter  tDBSY_max            =        1000; // Busy time for TWO-PLANE PROGRAM PAGE operation
parameter  tFEAT                =        1000; // Busy time for SET FEATURES and GET FEATURES operations
parameter  tPROG_typ            =      250000; // Busy time for PAGE PROGRAM operation
parameter  tPROG_max            =      700000; // Busy time for PAGE PROGRAM operation
parameter  tOBSY_max            =       25000; // Busy time for OTP DATA PROGRAM if OTP is protected
parameter  NPP                  =           4; // Number of partial page programs
                                // 2*tPROG             -tcmdldtime       -taddrldtime                -dataldtime
parameter  tLPROG_cache_typ     = (2*tPROG_typ) -(tCLS_min +tCLH_min) -(tCS_min +(5*tWC_min) +tDH_min) -(tALS_min) -(tADL_min); // Prog Page Cache Last Page

//--------------------------------------------
//unused timing parameters for this device
//--------------------------------------------
//programmable drivestrength timing parameters
parameter  tCLHIO_min           =           0; // Programmable I/O CLE hold time
parameter  tCLSIO_min           =           0; // Programmable I/O CLE setup time
parameter  tDHIO_min            =           0; // Programmable I/O data hold time
parameter  tDSIO_min            =           0; // Programmable I/O data setup time
parameter  tREAIO_max           =           0; // Programmable I/O RE# access time
parameter  tRPIO_min            =           0; // Programmable I/O RE# pulse width
parameter  tWCIO_min            =           0; // Programmable I/O write cycle time
parameter  tWHIO_min            =           0; // Programmable I/O pulse width high
parameter  tWHRIO_min           =           0; // Programmable I/O WE# high to RE# low
parameter  tWPIO_min            =           0; // Programmable I/O WE# pulse width
parameter  tLBSY_min            =           0; 
parameter  tLBSY_max            =           0; 

//-------------------------------------------
//Memory array configuration parameters
//-------------------------------------------
parameter PAGE_BITS     =       6;  // 2^6=64
parameter COL_BITS      =      13;
parameter COL_CNT_BITS  =      13;  // NUM_COL rounded up
parameter DQ_BITS       =       8;
parameter NUM_OTP_ROW   =      10;  // Number of OTP pages (valid OTP address between 2h and Bh)
parameter OTP_ADDR_MAX  =       NUM_OTP_ROW+2;
parameter OTP_NPP         =    4;  // Number of Partial Programs in OTP
parameter NUM_BOOT_BLOCKS =    0;
parameter BOOT_BLOCK_BITS =    1;

// --------- valid sizes are 8G, 16G, 32G, 64G ---------------
// flash memory array organization
`ifdef CLASSK
    parameter ROW_BITS  =      19; // (64G)
    parameter LUN_BITS  =       1;
`else `ifdef CLASSF
    parameter ROW_BITS  =      19; // (32G)
    parameter LUN_BITS  =       1;
`else `ifdef CLASSG
    parameter ROW_BITS  =      19; // (32G)
    parameter LUN_BITS  =       1;
`else 
    parameter ROW_BITS  =      18; // CLASSA (8G) default, CLASSD (16G), CLASSE (16G)
    parameter LUN_BITS  =       0;
`endif `endif `endif

parameter BLCK_BITS     =      12; 

`ifdef FullMem   // Only do this if you require the full memory size.
    `ifdef CLASSF
        parameter NUM_ROW   = 524288;  // PagesXBlocks = 64x8192 per CE  for (32G)
    `else `ifdef CLASSG
        parameter NUM_ROW   = 524288;  // PagesXBlocks = 64x8192 per CE  for (32G)
    `else `ifdef CLASSK
        parameter NUM_ROW   =1048576;  // PagesXBlocks = 64x8192 per CE  for (64G)
    `else 
        parameter NUM_ROW   = 262144;  // PagesXBlocks = 64x4096  for CLASSA (8G) default, CLASSD (16G), CLASSE (16G)
    `endif `endif `endif
`else
    parameter NUM_ROW       =    256; // smaller value for fast sim load
`endif
parameter NUM_PAGE      =     64;   
parameter NUM_COL       =   4314;
parameter NUM_PLANES    =      2;
parameter NUM_BLCK      =      (1 << BLCK_BITS) -1;  // block limit 

parameter BPC_MAX       = 3'b001;
parameter BPC           = 3'b001;
parameter PAGE_SIZE     =       NUM_COL*BPC_MAX*DQ_BITS;

//-------------------------------------------
//  READ ID values
//-------------------------------------------
parameter NUM_ID_BYTES = 5;
parameter READ_ID_BYTE0         =  8'h2c; // Micron Manufacturer ID
`ifdef CLASSF
     parameter READ_ID_BYTE1    =  8'hd5; // (32G)
     parameter READ_ID_BYTE2    =  8'hd1;
     parameter READ_ID_BYTE4    =  8'h68;
`else `ifdef CLASSG
     parameter READ_ID_BYTE1    =  8'hd5; // (32G)
     parameter READ_ID_BYTE2    =  8'hd1;
     parameter READ_ID_BYTE4    =  8'h68;
`else `ifdef CLASSK
     parameter READ_ID_BYTE1    =  8'hd5; // (64G)
     parameter READ_ID_BYTE2    =  8'hd1;
     parameter READ_ID_BYTE4    =  8'h68;
`else  
    parameter READ_ID_BYTE1     =  8'hd3; // CLASSA (8G), CLASSD (16G), CLASSE (16G)
    parameter READ_ID_BYTE2     =  8'h90;
    parameter READ_ID_BYTE4     =  8'h64;
`endif `endif `endif
parameter READ_ID_BYTE3         =  8'h2E;


//-------------------------------------------
//   Supported features of this device
//-------------------------------------------
parameter FEATURE_SET = 16'b0000001001111111;
//                    used--||||||||||||||||--basic NAND commands
//                     used--||||||||||||||-new commands (page rd cache commands)
//           boot block lock--||||||||||||--read ID2
//                       used--||||||||||--read unique
//                 page unlock--||||||||--OTP commands
//                     ONFI_OTP--||||||--2plane commands
//                      features--||||--ONFI 
//       drive strength(non-ONFI)--||--block lock

parameter FEATURE_SET2 = 16'b0000000000000000;
//                   unused--||||||||||||||||--ECC timing
//                    unused--||||||||||||||--unused
//                     unused--||||||||||||--unused
//                      unused--||||||||||--unused
//                       unused--||||||||--unused
//                        unused--||||||--unused
//                         unused--||||--unused
//                          unused--||--unused


parameter DRIVESTR_EN = 3'h1; // supports feature address 80h only
parameter NOONFIRDCACHERANDEN = 3'h0; // non-onfi read page cache random enable (special case)

//-------------------------------------------
//   Multiple Die Setup
//-------------------------------------------
`ifdef CLASSB
    `define NUM_DIE2
    parameter NUM_DIE   =   2;
    parameter NUM_CE    =   1;  // Number of R/B# is resolved by CLASS in nand_model.v
//    `define T1B1C1D1;  // 1 Target, 1 R/B, Common Cmd (1 cmd bus), Common Data (1 data bus)
    `define DIES2;
`else `ifdef CLASSC
    `define NUM_DIE2
    parameter NUM_DIE   =   2;
    parameter NUM_CE    =   2;
//    `define T2B1C1D1;  // 2 Target, 1 R/B, Common Cmd (1 cmd bus), Common Data (1 data bus)
`else `ifdef CLASSD
    `define NUM_DIE2
    parameter NUM_DIE   =   2;
    parameter NUM_CE    =   2;
//    `define T2B2C1D1;  // 2 Target, 2 R/B, Common Cmd (1 cmd bus), Common Data (1 data bus)
`else `ifdef CLASSE
    `define NUM_DIE2
    parameter NUM_DIE   =   2;
    parameter NUM_CE    =   2;
//    `define T2B2C2D2;  // 2 Target, 2 R/B, Separate Cmd (2 cmd buses), Separate Data (2 data buses)
`else `ifdef CLASSF
    `define NUM_DIE4
    parameter NUM_DIE   =   4;
    parameter NUM_CE    =   2;
    `define DIES4
//    `define T2B2C1D1;  // 2 Target, 2 R/B, Common Cmd (1 cmd bus), Common Data (1 data bus)
`else `ifdef CLASSG
    `define NUM_DIE4
    parameter NUM_DIE   =   4;
    parameter NUM_CE    =   2;
//    `define T2B2C2D2;  // 2 Target, 2 R/B, Separate Cmd (2 cmd buses), Separate Data (2 data buses)
    `define DIES4
`else `ifdef CLASSK
    `define NUM_DIE8
    parameter NUM_DIE   =   8;
    parameter NUM_CE    =   4;
//    `define T4B4C2D2;  // 4 Target, 4 R/B, Separate Cmd (2 cmd buses), Separate Data (2 data buses)
`else `ifdef CLASSM
    parameter NUM_DIE   =   1;
    parameter NUM_CE    =   1;
//    `define T1B1C1D1;  // 1 Target, 1 R/B, Common Cmd (1 cmd bus), Common Data (1 data bus)
`else `ifdef CLASSN
    `define NUM_DIE2
    parameter NUM_DIE   =   2;
    parameter NUM_CE    =   2;
//    `define T2B2C1D1;  // 2 Target, 2 R/B, Common Cmd (1 cmd bus), Common Data (1 data bus)
`else `ifdef CLASSQ
    `define NUM_DIE2
    parameter NUM_DIE   =   2;
    parameter NUM_CE    =   2;
//    `define T2B2C1D1;  // 2 Target, 2 R/B, Common Cmd (1 cmd bus), Common Data (1 data bus)
`else `ifdef CLASSR
    `define NUM_DIE2
    parameter NUM_DIE   =   2;
    parameter NUM_CE    =   2;
//    `define T2B2C2D2;  // 2 Target, 2 R/B, Separate Cmd (2 cmd buses), Separate Data (2 data buses)
`else `ifdef CLASST
    `define NUM_DIE4
    parameter NUM_DIE   =   4;
    parameter NUM_CE    =   2;
//    `define T2B2C1D1;  // 2 Target, 2 R/B, Common Cmd (1 cmd bus), Common Data (1 data bus)
    `define DIES4
`else `ifdef CLASSU
    `define NUM_DIE4
    parameter NUM_DIE   =   4;
    parameter NUM_CE    =   2;
//    `define T2B2C2D2;  // 2 Target, 2 R/B, Separate Cmd (2 cmd buses), Separate Data (2 data buses)
    `define DIES4
`else `ifdef CLASSW
    `define NUM_DIE8
    parameter NUM_DIE   =   8;
    parameter NUM_CE    =   4;
//    `define T4B4C2D2;  // 4 Target, 4 R/B, Separate Cmd (2 cmd buses), Separate Data (2 data buses)
`else  // DEFAULT = CLASSA
    parameter NUM_DIE   =   1;
    parameter NUM_CE    =   1;
//    `define T1B1C1D1;  // 1 Target, 1 R/B, Common Cmd (1 cmd bus), Common Data (1 data bus)
`endif `endif `endif `endif `endif `endif `endif `endif `endif `endif `endif `endif `endif `endif 
parameter async_only_n = 1'b0;

//-------------------------------------------
//   ONFI Setup
//-------------------------------------------
//need to keep this in params file since ever NAND device will have different values
reg [DQ_BITS -1 : 0]        onfi_params_array [NUM_COL-1 : 0]; // packed array
reg [PAGE_SIZE -1 : 0]      onfi_params_array_unpacked;

task setup_params_array;
    integer k;
    reg [PAGE_SIZE -1 : 0]      mask;
    begin
    // Here we set the values of the read-only ONFI parameters.
    // These are defined by the ONFI spec
    // and are the default power-on values for the ONFI FEATURES supported by this device.
    //-------------------------------------
    //Parameter page signature
    onfi_params_array[0] = 8'h4F; // 'O'
    onfi_params_array[1] = 8'h4E; // 'N'
    onfi_params_array[2] = 8'h46; // 'F'
    onfi_params_array[3] = 8'h49; // 'I'
    //ONFI revision number
    onfi_params_array[4] = 8'h02;
    onfi_params_array[5] = 8'h00;
    //Features supported
 `ifdef CLASSK
    onfi_params_array[6] = 8'h1A; // (64G)
    onfi_params_array[7] = 8'h00;
 `else `ifdef CLASSF
    onfi_params_array[6] = 8'h1A; // (32G)
    onfi_params_array[7] = 8'h00;
 `else `ifdef CLASSG
    onfi_params_array[6] = 8'h1A; // (32G)
    onfi_params_array[7] = 8'h00;
 `else 
    onfi_params_array[6] = 8'h18;
    onfi_params_array[7] = 8'h00;
 `endif `endif `endif
    //optional command supported
    onfi_params_array[8] = 8'h1D;
    onfi_params_array[9] = 8'h00;
    //Reserved
    for (k=10; k<=31 ; k=k+1) begin
        onfi_params_array[k] = 8'h00;
    end
    //Manufacturer ID
    onfi_params_array[32] = 8'h4D; //M
    onfi_params_array[33] = 8'h49; //I
    onfi_params_array[34] = 8'h43; //C
    onfi_params_array[35] = 8'h52; //R
    onfi_params_array[36] = 8'h4F; //O
    onfi_params_array[37] = 8'h4E; //N
    onfi_params_array[38] = 8'h20;
    onfi_params_array[39] = 8'h20;
    onfi_params_array[40] = 8'h20;
    onfi_params_array[41] = 8'h20;
    onfi_params_array[42] = 8'h20;
    onfi_params_array[43] = 8'h20;    
    //Device model
    onfi_params_array[44] = 8'h4D; //M
    onfi_params_array[45] = 8'h54; //T
    onfi_params_array[46] = 8'h32; //2
    onfi_params_array[47] = 8'h39; //9
    onfi_params_array[48] = 8'h46; //F
 `ifdef CLASSA
    onfi_params_array[49] = 8'h30; //0  (8G)
    onfi_params_array[50] = 8'h38; //8
 `else `ifdef CLASSD
    onfi_params_array[49] = 8'h31; //1 (16G)
    onfi_params_array[50] = 8'h36; //6
 `else `ifdef CLASSE
    onfi_params_array[49] = 8'h31; //1 (16G)
    onfi_params_array[50] = 8'h36; //6
 `else `ifdef CLASSF
    onfi_params_array[49] = 8'h33; //3 (32G)
    onfi_params_array[50] = 8'h32; //2
 `else `ifdef CLASSG
    onfi_params_array[49] = 8'h33; //3 (32G)
    onfi_params_array[50] = 8'h32; //2
 `else
    onfi_params_array[49] = 8'h36; //6
    onfi_params_array[50] = 8'h34; //4
 `endif `endif `endif `endif `endif
    onfi_params_array[51] = 8'h47; //G
    onfi_params_array[52] = 8'h30; //0
    onfi_params_array[53] = 8'h38; //8
 `ifdef CLASSA
    onfi_params_array[54] = 8'h41; //A (8G)
 `else `ifdef CLASSD
    onfi_params_array[54] = 8'h44; //D (16G)
 `else `ifdef CLASSE
    onfi_params_array[54] = 8'h44; //D (16G)
 `else 
    onfi_params_array[54] = 8'h46; //F
 `endif `endif `endif

    onfi_params_array[55] = 8'h41; //A
    onfi_params_array[56] = 8'h41; //A
    onfi_params_array[57] = 8'h20;
    onfi_params_array[58] = 8'h20;
    onfi_params_array[59] = 8'h20;
    onfi_params_array[60] = 8'h20;
    onfi_params_array[61] = 8'h20;
    onfi_params_array[62] = 8'h20;
    onfi_params_array[63] = 8'h20;

    //manufacturer ID
    onfi_params_array[64] = 8'h2C;
    //Date code
    onfi_params_array[65] = 8'h00; 
    onfi_params_array[66] = 8'h00; 
    //reserved
    for (k=67; k<=79 ; k=k+1) begin
        onfi_params_array[k] = 8'h00;
    end
    //Number of data bytes per page
    onfi_params_array[80] = 8'h00;
    onfi_params_array[81] = 8'h10;
    onfi_params_array[82] = 8'h00;
    onfi_params_array[83] = 8'h00;
    //Number of spare bytes per page        
    onfi_params_array[84] = 8'hDA;
    onfi_params_array[85] = 8'h00;
    //Number of data bytes per partial page
    onfi_params_array[86] = 8'h00;    
    onfi_params_array[87] = 8'h02;    
    onfi_params_array[88] = 8'h00;    
    onfi_params_array[89] = 8'h00;    
    //Number of spare bytes per partial page
    onfi_params_array[90] = 8'h1B;
    onfi_params_array[91] = 8'h00;
    //Number of pages per block
    onfi_params_array[92] = 8'h40;
    onfi_params_array[93] = 8'h00;
    onfi_params_array[94] = 8'h00;
    onfi_params_array[95] = 8'h00;
    //Number of blocks per unit
    onfi_params_array[96] = 8'h00;
    onfi_params_array[97] = 8'h10;
    onfi_params_array[98] = 8'h00;
    onfi_params_array[99] = 8'h00;
    //Number of units
 `ifdef CLASSK
    onfi_params_array[100] = 8'h02; // (64G)
 `else `ifdef CLASSF
    onfi_params_array[100] = 8'h02; //(32G)
 `else `ifdef CLASSG
    onfi_params_array[100] = 8'h02; //(32G)
 `else
    onfi_params_array[100] = 8'h01;
 `endif `endif `endif
    //Number of address cycles
    onfi_params_array[101] = 8'h23;
    //Number of bits per cell
    onfi_params_array[102] = 8'h01;
    //Bad blocks maximum per unit
    onfi_params_array[103] = 8'h50;
    onfi_params_array[104] = 8'h00;
    //Block endurance
    onfi_params_array[105] = 8'h01;
    onfi_params_array[106] = 8'h05;
    //Guaranteed valid blocks at beginning of target
    onfi_params_array[107] = 8'h01;
    //Block endurance for guaranteed valid blocks
    onfi_params_array[108] = 8'h00;
    onfi_params_array[109] = 8'h00;
    //Number of program per page
    onfi_params_array[110] = 8'h04;
    //Partial programming attributes
    onfi_params_array[111] = 8'h00;
    //Number of ECC bits
    onfi_params_array[112] = 8'h01;
    //Number of interleaved address bits
    onfi_params_array[113] = 8'h01;
    //Interleaved operation attributes
    onfi_params_array[114] = 8'h0E;
    //reserved
    for (k=115; k<=127 ; k=k+1) begin
        onfi_params_array[k] = 8'h00;
    end
    //IO pin capacitance
  `ifdef CLASSK
    onfi_params_array[128] = 8'h0A; // (64G)
  `else `ifdef CLASSF
    onfi_params_array[128] = 8'h0A; // (32G)
  `else `ifdef CLASSG
    onfi_params_array[128] = 8'h0A; // (32G)
  `else 
    onfi_params_array[128] = 8'h05;
  `endif `endif `endif
    //Timing mode support
    onfi_params_array[129] = 8'h3F;    
    onfi_params_array[130] = 8'h00;
    //Program cache timing mode support
    onfi_params_array[131] = 8'h3F;    
    onfi_params_array[132] = 8'h00;
    //tPROG max page program time
    onfi_params_array[133] = 8'hBC;
    onfi_params_array[134] = 8'h02;
    //tBERS max block erase time
    onfi_params_array[135] = 8'hB8;
    onfi_params_array[136] = 8'h0B;
    //tR max page read time        
    onfi_params_array[137] = 8'h19;
    onfi_params_array[138] = 8'h00;
    //tCCS min change column setup time (same as tWHR)
    onfi_params_array[139] = 8'h46;
    onfi_params_array[140] = 8'h00;
    //reserved
    for (k=141; k<=163; k=k+1) begin
        onfi_params_array[k] = 8'h00;
    end
    //Vendor-specific revision number    
    onfi_params_array[164] = 8'h01;
    onfi_params_array[165] = 8'h00;
    //vendor-specific
    onfi_params_array[166] = 8'h01;
    onfi_params_array[167] = 8'h01;
    onfi_params_array[168] = 8'h01;
    onfi_params_array[169] = 8'h02;
    onfi_params_array[170] = 8'h04;
    onfi_params_array[171] = 8'h80;
    onfi_params_array[172] = 8'h01;
    onfi_params_array[173] = 8'h81;
    onfi_params_array[174] = 8'h04;
    onfi_params_array[175] = 8'h01;
    onfi_params_array[176] = 8'h02;
    onfi_params_array[177] = 8'h01;
    onfi_params_array[178] = 8'h0A;
    for (k=179; k<=253; k=k+1) begin
        onfi_params_array[k] = 8'h00;
    end
    //Integrity CRC
  `ifdef CLASSK
    onfi_params_array[254] = 8'h41; // (64G)
    onfi_params_array[255] = 8'h5D;
  `else `ifdef CLASSG
    onfi_params_array[254] = 8'hE3; // (32G)
    onfi_params_array[255] = 8'h69;
  `else `ifdef CLASSE
    onfi_params_array[254] = 8'h7D; // (16G)
    onfi_params_array[255] = 8'h7E;
  `else `ifdef CLASSF
    onfi_params_array[254] = 8'h6D; // (32G)
    onfi_params_array[255] = 8'h9B;
  `else `ifdef CLASSD
    onfi_params_array[254] = 8'hF3; // (16G)
    onfi_params_array[255] = 8'h8C;
  `else
    onfi_params_array[254] = 8'hED;
    onfi_params_array[255] = 8'h20;
  `endif `endif `endif `endif `endif

    onfi_params_array_unpacked =0;
    for (k=0; k<=255; k=k+1) begin
        mask = ({8{1'b1}} << (k*8)); // shifting left zero-fills
        //mask clears onfi params array unpacked slice so can or in onfi_params_array[k] byte
        onfi_params_array_unpacked = (onfi_params_array_unpacked & ~mask) | (onfi_params_array[k]<<(k*8)); // unpacking array
    end

    // onfi params array repeats for each 256 bytes upto 1792, than all FFs to 4320.  
    onfi_params_array_unpacked[0511*8:0256*8] = onfi_params_array_unpacked[0255*8:0000];
    onfi_params_array_unpacked[0767*8:0512*8] = onfi_params_array_unpacked[0255*8:0000];
    onfi_params_array_unpacked[1023*8:0768*8] = onfi_params_array_unpacked[0255*8:0000];
    onfi_params_array_unpacked[1279*8:1024*8] = onfi_params_array_unpacked[0255*8:0000];
    onfi_params_array_unpacked[1535*8:1280*8] = onfi_params_array_unpacked[0255*8:0000];
    onfi_params_array_unpacked[1791*8:1536*8] = onfi_params_array_unpacked[0255*8:0000];
    onfi_params_array_unpacked[4319*8:1792*8] = {(4320-1792){8'hFF}}; // ??? related to page_size 
    end
endtask


//-----------------------------------------------------------------
// FUNCTION : check_feat_addr (addr)
// verifies feature address is valid for this part.
//-----------------------------------------------------------------
function check_feat_addr;
input [07:00] id_reg_addr;
input [00:00] nand_mode  ;
begin
    check_feat_addr = 0;
    case (id_reg_addr)
        8'h01, 8'h80, 8'h81 : check_feat_addr = 1;
    endcase
end
endfunction

//----------------------------------------------------------------------
// TASK : init_onfi_params
//Assigns the read-only ONFI parameters (for devices with ONFI support)
//----------------------------------------------------------------------
reg [(4*DQ_BITS)-1 : 0]         onfi_features [0 : 255];
task init_onfi_params;
begin
    //Supported ONFI feature addresses and parameter initialization
    //These are used in the GET FEATURES and SET FEATURES commands
    // Read Features section has read data output assignments. 
    onfi_features[8'h01] = 0;
    onfi_features[8'h80] = 0;
    onfi_features[8'h81] = 0;

    setup_params_array;  // ONFI parameter page
end
endtask

//----------------------------------------------------------------------
// TASK : update_feat_gen
//----------------------------------------------------------------------
task update_feat_gen;
input gen_in; 
begin

end
endtask
