//----------------------------------------------------------------------------
// nand_01 - module
//----------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////
//
//
// Definition of Ports
// FSL_Clk         : Synchronous clock
// FSL_Rst         : System reset, should always come from FSL bus
// FSL_S_Clk       : Slave asynchronous clock
// FSL_S_Read      : Read signal, requiring next available input to be read
// FSL_S_Data      : Input data
// FSL_S_Control   : Control Bit, indicating the input data are control word
// FSL_S_Exists    : Data Exist Bit, indicating data exist in the input FSL bus
// FSL_M_Clk       : Master asynchronous clock
// FSL_M_Write     : Write signal, enabling writing to output FSL bus
// FSL_M_Data      : Output data
// FSL_M_Control   : Control Bit, indicating the output data are contol word
// FSL_M_Full      : Full Bit, indicating output FSL bus is full
//
////////////////////////////////////////////////////////////////////////////////

//`include "controller_parameters.v"
`default_nettype none

//----------------------------------------
// Module Section
//----------------------------------------
(* fsm_style = "bram" *)
module nand_01 
	(
		// ADD USER PORTS BELOW THIS LINE 
		nand_fsm_clk,
		curr_state,
		ccount_q,
		control_q,
		count_q,
		raddr_q,
		nDone,
		nReset,
		nAddr,
		nCmd,
		nData_Loaded,
		nCmd_Loaded,
		nCsf,
		n_re_l, n_we_l, n_ale, n_cle, n_ce1_l, n_ce2_l, n_wp_l, //n_io_dir,
		n_io_I, n_io_O, n_io_T,
		n_rb1_l, n_rb2_l, t_rb1_l, t_rb2_l,
		t_i,		
      // ADD USER PORTS ABOVE THIS LINE 

		// DO NOT EDIT BELOW THIS LINE ////////////////////
		// Bus protocol ports, do not add or delete. 
		FSL_Clk,
		FSL_Rst,
		FSL_S_Clk,
		FSL_S_Read,
		FSL_S_Data,
		FSL_S_Control,
		FSL_S_Exists,
		FSL_M_Clk,
		FSL_M_Write,
		FSL_M_Data,
		FSL_M_Control,
		FSL_M_Full

		// DO NOT EDIT ABOVE THIS LINE ////////////////////
	);



// ADD USER PORTS BELOW THIS LINE 
input nand_fsm_clk;
output [0:5] curr_state;
output [0:4] ccount_q;
output [0:15] control_q;
output [0:15] count_q;
output [0:12] raddr_q;
output nDone;
output nReset;
output [0:31] nAddr;
output [0:2] nCmd;
output nData_Loaded;
output nCmd_Loaded;
output [0:6] nCsf;

//Wires To/From NAND Chip
output n_re_l, n_we_l, n_ale, n_cle, n_ce1_l, n_ce2_l, n_wp_l;//, n_io_dir;
//inout [0:7] n_io;
input [0:7] n_io_I;
output [0:7] n_io_O; 
output n_io_T;
input n_rb1_l, n_rb2_l;

/* debugging signals */
output t_rb1_l, t_rb2_l;
output [0:7] t_i;
// ADD USER PORTS ABOVE THIS LINE 

input                                     FSL_Clk;
input                                     FSL_Rst;
output                                    FSL_S_Clk;
output                                    FSL_S_Read;
input      [0 : 31]                       FSL_S_Data;
input                                     FSL_S_Control;
input                                     FSL_S_Exists;
output                                    FSL_M_Clk;
output                                    FSL_M_Write;
output reg [0 : 31]                       FSL_M_Data;
output                                    FSL_M_Control;
input                                     FSL_M_Full;



// ADD USER PARAMETERS BELOW THIS LINE 
// --USER parameters added here 
// ADD USER PARAMETERS ABOVE THIS LINE


//----------------------------------------
// Implementation Section
//----------------------------------------
// In this section, we povide an example implementation of MODULE nand_fsl_02
// that does the following:
//
// 1. Read all inputs
// 2. Add each input to the contents of register 'sum' which
//    acts as an accumulator
// 3. After all the inputs have been read, write out the
//    content of 'sum' into the output FSL bus NUMBER_OF_OUTPUT_WORDS times
//
// You will need to modify this example for
// MODULE nand_fsl_02 to implement your coprocessor

	// Base states of the FSM
//	localparam Invalid = 6'h0;
//	localparam Reset = 6'h1;
//	localparam In_Control = 6'h2; // reads in 2 dwords - 1st {size of transfer in bytes, command}, 2nd - addr
//	localparam Out_Control = 6'h3; // sends out 2 dwords
//	localparam Program_Page = 6'h4; // reads in x dwords, according to size
//	localparam Read_Data = 6'h5; // writes x dwords, according to size
//	localparam Block_Erase = 6'h6; // erases block at address (send in full address)
//
//	// Reset states
//	localparam Reset_INIT = 6'h10;
//	localparam Reset_INIT_WAIT = 6'h12;
//	localparam Reset_D0_LD_CMD0 = 6'h13;
//	localparam Reset_D0_LD_CMD1 = 6'h14;
//	localparam Reset_D0_LD_CMD2 = 6'h15;
//	localparam Reset_D0_LD_CMD_WAIT = 6'h16;
//	localparam Reset_D1_LD_CMD0 = 6'h17;
//	localparam Reset_D1_LD_CMD1 = 6'h18;
//	localparam Reset_D1_LD_CMD2 = 6'h19;
//	localparam Reset_D1_LD_CMD_WAIT = 6'h1a;
//	localparam Reset_GET_STATUS_LD_CMD0 = 6'h1b;
//	localparam Reset_GET_STATUS_LD_CMD1 = 6'h1c;
//	localparam Reset_END_WAIT = 6'h1d;
//
//	// Program states
//	localparam Program_Page_LD_CMDADDR0 = 6'h20;
//	localparam Program_Page_LD_CMDADDR1 = 6'h21;
//	localparam Program_Page_LD_DATA0 = 6'h22;
//	localparam Program_Page_LD_DATA1 = 6'h23;
//	localparam Program_Page_LD_DATA_WAIT = 6'h24;
//	localparam Program_Page_END_WAIT = 6'h25;
//
//	// Read states
//	localparam Read_Page_LD_CMDADDR0 = 6'h28;
//	localparam Read_Page_LD_CMDADDR1 = 6'h29;
//	localparam Read_Page_GET_DATA = 6'h2a;
//	localparam Read_Page_END_WAIT = 6'h2b;
//	localparam Read_Page_END_OUTDATA = 6'h2c;
//
//	// Erase states
//	localparam Block_Erase_LD_CMDADDR0 = 6'h30;
//	localparam Block_Erase_LD_CMDADDR1 = 6'h31;
//	localparam Block_Erase_END_WAIT = 6'h32;


	// FSM control variables
//	reg [0:5] curr_state, next_state;
//	wire [0:4] ccount_q;
//	reg ccount_clr, ccount_ce, ccount_ce4;
//	counter #(5) c_ccount( .C(FSL_Clk), .CLR(ccount_clr), .CE(ccount_ce), .CE4(ccount_ce4), .Q(ccount_q) );

	// Storing of control variables
//	wire [0:31] addr_q;
//	reg [0:31] addr_d;
//	reg addr_clr, addr_ce;
//	register #(32) r_addr( .C(FSL_Clk), .CLR(addr_clr), .CE(addr_ce), .D(addr_d), .Q(addr_q) );
//
//	wire [0:15] count_q;
//	reg [0:15] count_d;
//	reg count_clr, count_ce;
//	register #(16) r_count( .C(FSL_Clk), .CLR(count_clr), .CE(count_ce), .D(count_d), .Q(count_q) );

	// bit 15-status, 14-write, bit 13-read, bit 12-erase, bit 11-reset
//	wire [0:15] control_q;
//	reg [0:15] control_d;
//	reg control_clr, control_ce;
//	register #(16) r_control( .C(FSL_Clk), .CLR(control_clr), .CE(control_ce), .D(control_d), .Q(control_q) );

	// Storing of data
//	reg mem_we;
//	reg [0:10] mem_addr;
//	reg [0:31] mem_D;
//	reg [0:23] mem_tmp;
//	wire [0:31] mem_Q;
//	buffer b_mem( .C(FSL_Clk), .we(mem_we), .addr(mem_addr), .D(mem_D), .Q(mem_Q) );

//	wire [0:12] raddr_q;
	//reg raddr_clr, raddr_ce, raddr_ce4;
	//counter #(13) c_raddr( .C(FSL_Clk), .CLR(raddr_clr), .CE(raddr_ce), .CE4(raddr_ce4), .Q(raddr_q) );
	
	// Wires for the nand controller
	// outputs
	wire nDone, nData_Done, nData_Ready, nRB;
	wire [0:7] nStatus;
	wire [0:7] nData_Out;
	// inputs
	reg [0:7] nData_In;
	wire [0:31] nAddr;
	wire [0:12] nLen;
	reg [0:2] nCmd;
	reg nData_Loaded, nCmd_Loaded, nReset;
	// to NAND chip
	wire n_re_l, n_we_l, n_ale, n_cle, n_ce1_l, n_wp_l, n_ce2_l;
	//wire [0:7] n_i, n_o;
   wire [0:7] n_io_I,n_io_O;
   wire n_io_T;
	wire n_rb1_l, n_rb2_l;//, n_io_dir;
	// for synchronization



	// for simulation only
//`ifdef SIMULATION
//	reg [0:5] printed_state;
//`endif


	// instantiate the nand_controller
	nand_controller_top c1( .DONE(nDone), .DATA_DONE(nData_Done), .DATA_READY(nData_Ready), .RB(nRB),
		.status(nStatus), .DATA_OUT(nData_Out), .current_fsm_state(nCsf), .DATA_IN(nData_In), .ADDR(nAddr), .CMD(nCmd),
		.DATA_LOADED(nData_Loaded), .CMD_LOADED(nCmd_Loaded), .LEN(nLen), .clk(nand_fsm_clk),
		.reset(FSL_Rst), .re_l(n_re_l), .we_l(n_we_l), .ale(n_ale), .cle(n_cle), .ce1_l(n_ce1_l),
		.ce2_l(n_ce2_l), .io_I(n_io_I), .io_O(n_io_O), .io_T(n_io_T), .rb1_l(n_rb1_l), .rb2_l(n_rb2_l));

	
//	assign FSL_S_Read  = ((curr_state == Program_Page && raddr_q < count_q) || curr_state == In_Control) ? FSL_S_Exists : 0;
//	assign FSL_M_Write = ((curr_state == Out_Control && ccount_q != 2) || (curr_state == Read_Page_END_OUTDATA && raddr_q < count_q)) ? ~FSL_M_Full : 0;
//	assign FSL_M_Control = 1'b0;	
//	
//	assign FSL_M_Clk = 0;
//	assign FSL_S_Clk = 0;
//	assign n_io_dir = n_re_l;
//	assign n_wp_l = 1;
//
//	assign nAddr = addr_q;
//	assign nLen = count_q;
	
	/* tristate buffer */
	//assign n_t = {~n_re_l,~n_re_l,~n_re_l,~n_re_l,~n_re_l,~n_re_l,~n_re_l,~n_re_l};

	/* DEBUGGING */
//	assign t_rb1_l = n_rb1_l;
//	assign t_rb2_l = n_rb2_l;
//	assign t_i = n_i;
	
	
//`ifdef SIMULATION
//	always@(nStatus)
//		$display("(%t) ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Status %x", $time, nStatus);
//
//	always@(posedge nDone)
//		$display("(%t) ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Done received!", $time);
//
//	always@(posedge FSL_M_Write)
//		$display("(%t) 0x%x ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ FSL_M_Write went high!", $time, FSL_M_Data);
//`endif

	// MAIN FSM ---------------------------------------------------------------------- MAIN FSM //


//	always@(posedge FSL_Clk or posedge FSL_Rst)
//	begin
//		if (FSL_Rst)
//		begin
//`ifdef SIMULATION
//			$display("(%t) FSL RESET",$time);
//`endif
//			curr_state		<= Invalid;
//		end
//		else
//		begin
//			//$display("(%t) state %x to state %x now.", $time, curr_state, next_state);
//			curr_state <= next_state;
//		end
//	end
//
//	always@(*)
//	begin
//		 FSL_M_Data    = 0;
//		next_state		= Invalid;
//		ccount_clr		= 0;
//		ccount_ce			= 0;
//		ccount_ce4		= 0;
//		addr_d				= 0;
//		addr_clr			= 0;
//		addr_ce				= 0;
//		count_d				= 0;
//		count_clr			= 0;
//		count_ce			= 0;
//		control_d			= 0;
//		control_clr		= 0;
//		control_ce		= 0;
//		mem_we				= 0;
//		mem_addr			= 0;
//		mem_D					= 0;
//		raddr_clr			= 0;
//		raddr_ce			= 0;
//		raddr_ce4			= 0;
//		nData_In			= 0;
//		nCmd					= 0;
//		nData_Loaded	= 0;
//		nCmd_Loaded		= 0;
//		nReset				= 0;
//
//		case (curr_state) 
//			Invalid:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Invalid state reached!", $time);
//					printed_state = curr_state;
//`endif
//					next_state = Reset;
//				end
//
//
//			// RESET ---------------------------------------------------------------------- RESET //
//			Reset:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Reset state", $time);
//					printed_state = curr_state;
//`endif
//					ccount_clr = 1;
//					raddr_clr = 1;
//					addr_clr = 1;
//					count_clr = 1;
//					control_clr = 1;
//					next_state = Reset_INIT;
//               //next_state = In_Control;
//				end
//
//			Reset_INIT:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Reset_INIT)
//					begin
//						printed_state = Reset_INIT;
//						$display("(%t) Reset_INIT state", $time);
//					end
//`endif
//
//					next_state = curr_state;
//
//					if (ccount_q == 22)
//					begin
//						nReset = 1;
//						ccount_ce = 1;
//					end
//					else if (ccount_q == 23)
//					begin
//						next_state = Reset_INIT_WAIT;
//						ccount_clr = 1;
//					end
//					else
//						ccount_ce = 1;
//				end
//
//			Reset_INIT_WAIT:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Reset_INIT_WAIT)
//					begin
//						printed_state = Reset_INIT_WAIT;
//						$display("(%t) Reset_INIT_WAIT state", $time);
//					end
//`endif
//
//					next_state = curr_state;
//
//					if (nDone && ccount_q == 0)
//					begin
//`ifdef SIMULATION
//						$display("(%t) Done!", $time);
//`endif
//						ccount_ce = 1;
//					end
//					else if (ccount_q != 0)
//					begin
//						if (ccount_q == 5)
//						begin
//							next_state = Reset_D0_LD_CMD0;
//							ccount_clr = 1;
//						end
//						else
//							ccount_ce = 1;
//					end
//				end
//
//			Reset_D0_LD_CMD0:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Reset_D0_LD_CMD0 state", $time);
//					printed_state = curr_state;
//`endif
//					addr_d = 32'h0;
//					addr_ce = 1;
//					next_state = Reset_D0_LD_CMD1;
//				end
//
//			Reset_D0_LD_CMD1:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Reset_D0_LD_CMD1)
//					begin
//						printed_state = Reset_D0_LD_CMD1;
//						$display("(%t) Reset_D0_LD_CMD1 state", $time);
//					end
//`endif
//
//					nCmd_Loaded = 1;
//					nCmd = `RESET_CMD;
//
//					if (ccount_q == 12)
//					begin
//						next_state = Reset_D0_LD_CMD2;
//						ccount_clr = 1;
//					end
//					else
//					begin
//						next_state = curr_state;
//						ccount_ce = 1;
//					end
//				end
//
//			Reset_D0_LD_CMD2:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Reset_D0_LD_CMD2 state", $time);
//					printed_state = curr_state;
//`endif
//					next_state = Reset_D0_LD_CMD_WAIT;
//				end
//
//
//			Reset_D0_LD_CMD_WAIT:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Reset_D0_LD_CMD_WAIT)
//					begin
//						printed_state = Reset_D0_LD_CMD_WAIT;
//						$display("(%t) Reset_D0_LD_CMD_WAIT state", $time);
//					end
//`endif
//
//					next_state = curr_state;
//
//					if (ccount_q == 2)
//					begin
//						ccount_clr = 1;
//						next_state = Reset_D1_LD_CMD0;
//					end
//					else if (nDone || ccount_q == 1)
//						ccount_ce = 1;
//				end
//
//			Reset_D1_LD_CMD0:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Reset_D1_LD_CMD0 state", $time);
//					printed_state = curr_state;
//`endif
//					addr_d = 32'hffffffff;
//					addr_ce = 1;
//					next_state = Reset_D1_LD_CMD1;
//				end
//
//			Reset_D1_LD_CMD1:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Reset_D1_LD_CMD1)
//					begin
//						printed_state = Reset_D1_LD_CMD1;
//						$display("(%t) Reset_D1_LD_CMD1 state", $time);
//					end
//`endif
//
//					nCmd_Loaded = 1;
//					nCmd = `RESET_CMD;
//
//					if (ccount_q == 12)
//					begin
//						next_state = Reset_D1_LD_CMD2;
//						ccount_clr = 1;
//					end
//					else
//					begin
//						next_state = curr_state;
//						ccount_ce = 1;
//					end
//				end
//
//			Reset_D1_LD_CMD2:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Reset_D1_LD_CMD2 state", $time);
//					printed_state = curr_state;
//`endif
//					next_state = Reset_D1_LD_CMD_WAIT;
//				end
//
//			Reset_D1_LD_CMD_WAIT:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Reset_D1_LD_CMD_WAIT)
//					begin
//						printed_state = Reset_D1_LD_CMD_WAIT;
//						$display("(%t) Reset_D1_LD_CMD_WAIT state", $time);
//					end
//`endif
//
//					next_state = curr_state;
//
//					if (ccount_q == 2)
//					begin
//						ccount_clr = 1;
//						next_state = Reset_GET_STATUS_LD_CMD0;
//					end
//					else if (nDone || ccount_q == 1)
//						ccount_ce = 1;
//				end
//
//			Reset_GET_STATUS_LD_CMD0:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Reset_GET_STATUS_LD_CMD0 state", $time);
//					printed_state = curr_state;
//`endif
//					nCmd_Loaded = 1;
//					nCmd = `READ_STATUS_CMD;
//
//					if (ccount_q == 12)
//					begin
//						next_state = Reset_GET_STATUS_LD_CMD1;
//						ccount_clr = 1;
//					end
//					else
//					begin
//						next_state = curr_state;
//						ccount_ce = 1;
//					end
//				end
//
//			Reset_GET_STATUS_LD_CMD1:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Reset_GET_STATUS_LD_CMD1 state", $time);
//					printed_state = curr_state;
//`endif
//					next_state = Reset_END_WAIT;
//				end
//
//			Reset_END_WAIT:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Reset_END_WAIT)
//					begin
//						printed_state = Reset_END_WAIT;
//						$display("(%t) Reset_END_WAIT state", $time);
//					end
//`endif
//
//					next_state = curr_state;
//
//					if (nDone)
//					begin
//`ifdef SIMULATION
//						$display("(%t) Status: %x", $time, nStatus);
//`endif
//						control_d[0:7] = nStatus;
//						control_d[8:15] = control_q[8:15];
//						control_ce = 1;
//						ccount_clr = 1;
//						next_state = Out_Control;
//					end
//				end
//
//
//			// IN_CONTROL ------------------------------------------------------------ IN_CONTROL //
//			In_Control:
//				begin
//`ifdef SIMULATION
//					if (printed_state != In_Control)
//					begin
//						printed_state = In_Control;
//						$display("(%t) In_Control state", $time);
//					end
//`endif
//
//					next_state = curr_state;
//
//					if (FSL_S_Exists == 1)
//					begin
//`ifdef SIMULATION
//						$display("(%t) FSL_S_Exists, control_count %x - FSL_S_Data %x - control_q = %x", $time, ccount_q, FSL_S_Data, control_q);
//`endif
//						case (ccount_q)
//							0:
//								begin
//									control_d = FSL_S_Data[16:31];
//									count_d = FSL_S_Data[0:15];
//									control_ce = 1;
//									count_ce = 1;
//									ccount_ce = 1;
//								end
//							
//							1:
//								begin
//									addr_d = FSL_S_Data;
//									addr_ce = 1;
//									if (control_q[15])			// return status
//										next_state = Out_Control;
//									else if (control_q[14]) // write data
//										next_state = Program_Page;
//									else if (control_q[13]) // read data
//										next_state = Read_Data;
//									else if (control_q[12]) // erase blocks
//										next_state = Block_Erase;
//									else if (control_q[11]) // reset nand chip + c1 + c2
//										next_state = Reset;
//
//									ccount_clr = 1;
//									raddr_clr = 1;
//								end
//						
//						endcase
//					end
//				end
//			
//
//			// PROGRAM_PAGE -------------------------------------------------------- PROGRAM_PAGE //
//			Program_Page:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Program_Page state %x %x", $time, raddr_q, raddr_q[0:10]);
//					printed_state = curr_state;
//`endif
//
//					next_state = curr_state;
//
//					if (count_q <= raddr_q)
//					begin
//						next_state = Program_Page_LD_CMDADDR0;
//                  //next_state = Out_Control;
//						raddr_clr = 1;
//						ccount_clr = 1;
//					end
//					else if (FSL_S_Exists == 1)
//					begin
//						//mem[raddr_q[0:10]] = FSL_S_Data;
//						mem_we = 1;
//						mem_addr = raddr_q[0:10];
//						mem_D = FSL_S_Data;
//`ifdef SIMULATION
//						$display("(%t) storing 0x%x at mem index %x", $time, FSL_S_Data, raddr_q);
//`endif
//						raddr_ce4 = 1;
//					end
//				end
//
//			Program_Page_LD_CMDADDR0:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Program_Page_LD_CMDADDR0)
//					begin
//						printed_state = Program_Page_LD_CMDADDR0;
//						$display("(%t) Program_Page_LD_CMDADDR0 state", $time);
//					end
//`endif
//
//					nCmd_Loaded = 1;
//					nCmd = `PROGRAM_PAGE_CMD;
//
//					if (ccount_q >= 12)
//					begin
//						ccount_clr = 1;
//						next_state = Program_Page_LD_CMDADDR1;
//					end
//					else
//					begin
//						next_state = curr_state;
//						ccount_ce = 1;
//					end
//				end
//
//			Program_Page_LD_CMDADDR1:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Program_Page_LD_CMDADDR1 state", $time);
//					printed_state = curr_state;
//`endif
//					next_state = Program_Page_LD_DATA0;
//					raddr_clr = 1;
//					ccount_clr = 1;
//				end
//				
//			Program_Page_LD_DATA0:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Program_Page_LD_DATA0 state raddr=%x", $time, raddr_q);
//					printed_state = curr_state;
//`endif
//					mem_addr = raddr_q[0:10];
//					next_state = Program_Page_LD_DATA1;
//				end
//
//			Program_Page_LD_DATA1:
//				begin
//`ifdef SIMULATION1
//					$display("(%t) Program_Page_LD_DATA1 state raddr=%x count=%x", $time, raddr_q, count_q);
//					printed_state = curr_state;
//`endif
//
//					if (raddr_q == count_q)
//						next_state = Program_Page_END_WAIT;
//					else
//					begin
//						next_state = Program_Page_LD_DATA_WAIT;
//						mem_addr = raddr_q[0:10];
//						case (raddr_q[11:12])
//							0:
//								nData_In = mem_Q[0:7];
//
//							1:
//								nData_In = mem_Q[8:15];
//
//							2:
//								nData_In = mem_Q[16:23];
//
//							3:
//								nData_In = mem_Q[24:31];
//
//						endcase
//					end
//
//`ifdef SIMULATION1
//					$display("nData_In = %x", nData_In);
//`endif
//
//					nData_Loaded = 1;
//				end
//
//			Program_Page_LD_DATA_WAIT:
//				begin
//`ifdef SIMULATION1
//					if (printed_state != curr_state)
//					begin
//						printed_state = curr_state;
//						$display("(%t) Program_Page_LD_DATA_WAIT state raddr=%x", $time, raddr_q);
//					end
//`endif
//
//					mem_addr = raddr_q[0:10];
//					case (raddr_q[11:12])
//						0:
//							nData_In = mem_Q[0:7];
//
//						1:
//							nData_In = mem_Q[8:15];
//
//						2:
//							nData_In = mem_Q[16:23];
//
//						3:
//							nData_In = mem_Q[24:31];
//
//					endcase
//
//					next_state = curr_state;
//
//					if (nData_Done)
//					begin
//`ifdef SIMULATION1
//						$display("(%t) Data_Done", $time);
//`endif
//						raddr_ce = 1;
//						if (raddr_q[11:12] == 2'b11)
//							next_state = Program_Page_LD_DATA0;
//						else
//							next_state = Program_Page_LD_DATA1;
//					end
//				end
//
//			Program_Page_END_WAIT:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Program_Page_END_WAIT)
//					begin
//						printed_state = Program_Page_END_WAIT;
//						$display("(%t) Program_Page_END_WAIT state", $time);
//					end
//`endif
//
//					next_state = curr_state;
//
//					if (nDone)
//					begin
//`ifdef SIMULATION
//						$display("(%t) Done! - status %x", $time, nStatus);
//`endif
//						next_state = Out_Control;
//						control_d[0:7] = nStatus;
//						control_d[8:15] = control_q[8:15];
//						control_ce = 1;
//						ccount_clr = 1;
//						raddr_clr = 1;
//					end
//				end
//			
//
//			// READ_DATA -------------------------------------------------------------- READ_DATA //
//			Read_Data:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Read_Data state", $time);
//					printed_state = curr_state;
//`endif
//					next_state = Read_Page_LD_CMDADDR0;
//               ccount_clr = 1;
//				end
//			
//			Read_Page_LD_CMDADDR0:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Read_Page_LD_CMDADDR0)
//					begin
//						printed_state = Read_Page_LD_CMDADDR0;
//						$display("(%t) Read_Page_LD_CMDADDR0", $time);
//					end
//`endif
//
//					nCmd_Loaded = 1;
//					nCmd = `READ_PAGE_CMD;
//
//					if (ccount_q == 12)
//					begin
//						next_state = Read_Page_LD_CMDADDR1;
//						ccount_clr = 1;
//					end
//					else
//					begin
//						next_state = curr_state;
//						ccount_ce = 1;
//					end
//				end
//				
//			Read_Page_LD_CMDADDR1:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Read_Page_LD_CMDADDR1", $time);
//					printed_state = curr_state;
//`endif
//					next_state = Read_Page_GET_DATA;
//				end
//
//			Read_Page_GET_DATA:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Read_Page_GET_DATA)
//					begin
//						printed_state = Read_Page_GET_DATA;
//						$display("(%t) Read_Page_GET_DATA state", $time);
//					end
//`endif
//
//					next_state = curr_state;
//
//					if (raddr_q == count_q)
//					begin
//						raddr_clr = 1;
//						next_state = Read_Page_END_WAIT;
//					end
//					else if (nData_Ready)
//					begin
//`ifdef SIMULATION1
//						$display("(%t) Just read raddr %x, byte %x", $time, raddr_q, nData_Out);
//`endif
//
//						mem_we = 1;
//						mem_addr = raddr_q[0:10];
//						case (raddr_q[11:12])
//							0:
//								begin
//									mem_tmp[0:7] = nData_Out;
//									mem_D[0:7] = nData_Out;
//								end
//
//							1:
//								begin
//									mem_tmp[8:15] = nData_Out;
//									mem_D[0:7] = mem_tmp[0:7];
//									mem_D[8:15] = nData_Out;
//								end
//
//							2:
//								begin
//									mem_tmp[16:23] = nData_Out;
//									mem_D[0:15] = mem_tmp[0:15];
//									mem_D[16:23] = nData_Out;
//								end
//
//							3:
//								begin
//									mem_D[0:23] = mem_tmp;
//									mem_D[24:31] = nData_Out;
//								end
//
//						endcase
//
//						raddr_ce = 1;
//					end
//				end
//
//			Read_Page_END_WAIT:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Read_Page_END_WAIT)
//					begin
//						printed_state = Read_Page_END_WAIT;
//						$display("(%t) Read_Page_END_WAIT state", $time);
//					end
//`endif
//
//					next_state = curr_state;
//
//					if (nDone)
//					begin
//`ifdef SIMULATION
//						$display("(%t) Done!", $time);
//`endif
//						mem_addr = raddr_q[0:10];
//						next_state = Read_Page_END_OUTDATA;
//						control_d = control_q | (control_q << 8);
//						control_ce = 1;
//						raddr_clr = 1;
//					end
//				end
//			
//			Read_Page_END_OUTDATA:
//				begin
//					next_state = curr_state;
//					mem_addr = raddr_q[0:10];
//
//					if (FSL_M_Full == 0)
//					begin
//						if (count_q <= raddr_q)
//						begin
//							next_state = Out_Control;
//							raddr_clr = 1;
//							ccount_clr = 1;
//						end
//						else
//						begin
//`ifdef SIMULATION
//							$display("(%t) Read_Page_END_OUTDATA raddr - %x", $time, raddr_q);
//`endif
//							FSL_M_Data = mem_Q;
//							// need to advance mem_addr by 4 to ensure that the next DWORD
//							// comes out in time to be fed to the FSL_M_Data.
//							mem_addr = raddr_q[0:10] + 4;
//							raddr_ce4 = 1;
//						end
//					end
//				end
//			
//
//			// BLOCK_ERASE ---------------------------------------------------------- BLOCK_ERASE //
//			Block_Erase:
//				begin
//`ifdef SIMULATION
//					$display("(%t) Block_Erase state", $time);
//					printed_state = curr_state;
//`endif
//					next_state = Block_Erase_LD_CMDADDR0;
//					ccount_clr = 1;
//				end
//			
//			Block_Erase_LD_CMDADDR0:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Block_Erase_LD_CMDADDR0)
//					begin
//						printed_state = Block_Erase_LD_CMDADDR0;
//						$display("(%t) Block_Erase_LD_CMDADDR0 state", $time);
//					end
//`endif
//
//					nCmd_Loaded = 1;
//					nCmd = `BLOCK_ERASE_CMD;
//
//					if (ccount_q == 12)
//					begin
//						next_state = Block_Erase_LD_CMDADDR1;
//						ccount_clr = 1;
//					end
//					else
//					begin
//						next_state = curr_state;
//						ccount_ce = 1;
//					end
//				end
//
//			Block_Erase_LD_CMDADDR1:				
//				begin
//`ifdef SIMULATION
//					$display("(%t) Block_Erase_LD_CMDADDR1 state", $time);
//					printed_state = curr_state;
//`endif
//					next_state = Block_Erase_END_WAIT;
//				end
//
//			Block_Erase_END_WAIT:
//				begin
//`ifdef SIMULATION
//					if (printed_state != Block_Erase_END_WAIT)
//					begin
//						printed_state = Block_Erase_END_WAIT;
//						$display("(%t) Block_Erase_END_WAIT state", $time);
//					end
//`endif
//
//					next_state = curr_state;
//
//					if (nDone)
//					begin
//`ifdef SIMULATION
//						$display("(%t) Done! - status %x", $time, nStatus); 	
//`endif
//						next_state = Out_Control;
//						control_d[0:7] = nStatus;
//						control_d[8:15] = control_q[8:15];
//						control_ce = 1;
//						ccount_clr = 1;
//					end
//				end
//
//
//			// OUT_CONTROL ---------------------------------------------------------- OUT_CONTROL //
//			Out_Control:
//				begin
//`ifdef SIMULATION
//					if (printed_state != curr_state)
//					begin
//						$display("(%t) Out_Control state", $time);
//						printed_state = curr_state;
//					end
//`endif
//
//					next_state = curr_state;
//
//					if (FSL_M_Full == 0)
//					begin
//						case (ccount_q)
//							0:
//								begin
//									FSL_M_Data[0:15] = count_q;
//									FSL_M_Data[16:31] = control_q;
//									ccount_ce = 1;
//								end
//
//							1:
//								begin
//									FSL_M_Data = addr_q;
//									control_clr = 1;
//									ccount_ce = 1;
//								end
//
//							2:
//								begin
//									next_state = In_Control;
//									addr_clr = 1;
//									count_clr = 1;
//									control_clr = 1;
//									ccount_clr = 1;
//									raddr_clr = 1;
//								end
//
//						endcase
//					end
//				end
//		
//		endcase
//	end
	
endmodule
