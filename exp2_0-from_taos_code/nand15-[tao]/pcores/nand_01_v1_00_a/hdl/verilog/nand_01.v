//----------------------------------------------------------------------------
// nand_01 - module
//----------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////
//
//
// Definition of Ports
// FSL_Clk             : Synchronous clock
// FSL_Rst           : System reset, should always come from FSL bus
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

`include "controller_parameters.v"
//`default_type none

//----------------------------------------
// Module Section
//----------------------------------------
(* fsm_style = "bram" *)
module nand_01 
	(
		// ADD USER PORTS BELOW THIS LINE 
		// -- USER ports added here 
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
		FSL_M_Full,
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
		n_re_l, n_we_l, n_ale, n_cle, n_ce1_l, n_ce2_l, n_wp_l, n_io_dir,
		//n_io, n_i, n_o, n_t,
		n_i, n_o,
		n_rb1_l, n_rb2_l, t_rb1_l, t_rb2_l,
		t_i
		// DO NOT EDIT ABOVE THIS LINE ////////////////////
	);



// ADD USER PORTS BELOW THIS LINE 
// -- USER ports added here 
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
output n_re_l, n_we_l, n_ale, n_cle, n_ce1_l, n_ce2_l, n_wp_l, n_io_dir;
//inout [0:7] n_io;
input [0:7] n_i;
output [0:7] n_o; //, n_t;
input n_rb1_l, n_rb2_l;

/* debugging signals */
output t_rb1_l, t_rb2_l;
output [0:7] t_i;


// ADD USER PARAMETERS BELOW THIS LINE 
// --USER parameters added here 
// ADD USER PARAMETERS ABOVE THIS LINE




	// Base states of the FSM
	localparam STATE_1 = 6'h0;
	localparam STATE_2 = 6'h1;
   localparam STATE_3 = 6'h2;
   localparam STATE_4 = 6'h3;

	// FSM control variables
	reg [0:5] curr_state, next_state;
	
	
	
	// Wires for the nand controller
	// to / from NAND chip
	
	wire [0:7] n_i;
	wire n_rb1_l, n_rb2_l;
   
   reg n_re_l, n_we_l, n_ale, n_cle, n_ce1_l, n_wp_l, n_ce2_l, n_o, n_io_dir;

	
	// MAIN FSM ---------------------------------------------------------------------- MAIN FSM //


	always@(posedge FSL_Clk or posedge FSL_Rst)
	begin
		if (FSL_Rst)
		begin
			curr_state		<= STATE_1;
		end
		else
		begin
			//$display("(%t) state %x to state %x now.", $time, curr_state, next_state);
			curr_state <= next_state;
		end
	end

	always@(*)
	begin

		case (curr_state) 
			STATE_1:
				begin
               n_re_l = 0; 
               n_we_l = 0;
               n_ale = 0; 
               n_cle = 0; 
               n_ce1_l = 0; 
               n_wp_l = 0; 
               n_ce2_l = 0;
               n_o = 8'hAA;
               
               next_state <= STATE_2;
				end

			STATE_2:
				begin
               n_re_l = 1; 
               n_we_l = 1;
               n_ale = 1; 
               n_cle = 1; 
               n_ce1_l = 1; 
               n_wp_l = 1; 
               n_ce2_l = 1;
               n_o = 8'h55;
               
               next_state <= STATE_3;
				end
            
         STATE_3:
				begin
               n_re_l = 0; 
               n_we_l = 0;
               n_ale = 0; 
               n_cle = 0; 
               n_ce1_l = 0; 
               n_wp_l = 0; 
               n_ce2_l = 0;
               n_o = 8'h00;
               next_state <= STATE_4;
				end
            
            STATE_4:
				begin
               n_re_l = 1; 
               n_we_l = 1;
               n_ale = 1; 
               n_cle = 1; 
               n_ce1_l = 1; 
               n_wp_l = 1; 
               n_ce2_l = 1;
               n_o = 8'hFF;
               //Stay stuck here.  This way we see 2 transitions, then observe 'steady' values
               next_state <= STATE_1;
				end
      endcase
	
	end
	
endmodule