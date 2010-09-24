`timescale 1ns / 1ns
//`default_type none

(* fsm_style = "bram" *)
module nand_controller_top ( DONE, DATA_DONE, DATA_READY, RB, status, DATA_OUT, current_fsm_state, DATA_IN, ADDR, CMD, DATA_LOADED, CMD_LOADED,LEN, clk, reset,
   ce1_l,ce2_l,ale,cle,re_l,we_l,i,o,rb1_l,rb2_l );
   output DONE;
   output DATA_DONE;
   output DATA_READY;
   output RB; //note: high enable
   output reg [7:0] status;
   output reg [7:0] DATA_OUT;
	output [6:0] current_fsm_state;
   input [7:0] DATA_IN;
   input [31:0] ADDR;  //byte addressable (2 (1) dies with 2 (1) planes with 2048 (11) blocks with 64 (6) pages with 4314 (13) bytes)
   input [2:0] CMD;   //43?  commands will be [5:0] with all commands
   input DATA_LOADED;
   input CMD_LOADED;
   input [12:0] LEN;
   input clk;  //100MHz
   input reset;

`include "controller_parameters.v"
   // nand interface
   output reg re_l, we_l;
   output reg ale, cle;
   output ce1_l, ce2_l;
   input  [7:0] i; 
   output [7:0] o;
   input rb1_l, rb2_l;

   reg ce_l;
   wire cs;

   reg [6:0] current_fsm_state, next_fsm_state;
    //synthesis attribute signal_encoding of current_fsm_state is "user" 
   reg [6:0] addr_latch_return=7'b0; 
   //synthesis attribute signal_encoding of addr_latch_return is "user" 
   reg [12:0] dataCycleCount;
   wire dataCycleCount_reset0;
   reg re_l_goingHigh; //signifies re_l is going low to high next state.  must be set to avoid timing issues.
   reg [3:0] tRHWCount; //need to wait 100ns when RE goes high before WE goes low
   reg [13:0] initStateCount; //need to wait 11000 clock cycles
   reg [7:0] write_data;
   wire [7:0] buffered_read_data;
   wire new_cmd;
   reg [12:0] length;	
   reg new_data;
   reg buffered_new_cmd, buffered_new_cmd2;
   reg buffered_new_data;
   wire [2:0] load_addr_latch_return;
   wire read_now, load_status;
   wire initStateCount_inc, dataCycleCount_dec;

   // bidirectional_signal_splitter splitter( .out( buffered_read_data ), .bidir( io ), .in( write_data ), .sel( re_l ), .clk( clk ));
initial begin
//  $monitor("i=%h,o=%h,t=%d",i,o,dir);	
end
   assign o=write_data;
   assign buffered_read_data=i;	
   //assign dir=re_l;	
 //  always @ (posedge DATA_LOADED) begin
  //    $display("DISPLAYING: At time %t,new_data=%b,data_loaded=%b,buf_data=%b,state=%d,dataCycleCount=%d", $time, new_data,  DATA_LOADED, buffered_new_data, current_fsm_state,dataCycleCount);
//   end

   assign cs = ADDR[31]; //chip select: cs is 0 if we are using CE#, and 1 if we are using CE2# (same for other wires)

   or(ce1_l, cs, ce_l);
   or(ce2_l, ~cs, ce_l);

   //nand(RB, rb1_l, rb2_l);
	assign RB=cs? (~rb2_l): (~rb1_l);
   // effectively @(posedge CMD_LOADED), but synthesizable
   and(new_cmd, ~buffered_new_cmd2, CMD_LOADED);

   always @ (posedge clk or posedge reset) begin
      if(reset) begin
         new_data <= 1'b0;
      end else if(~buffered_new_data && DATA_LOADED) begin
         new_data <= 1'b1;
      end else if(DATA_DONE) begin
         new_data <= 1'b0;
      end
   end

   always @ (posedge clk or posedge reset) begin
      if(reset) begin
         status <= 8'b0;
      end else if(load_status) begin
         status <= buffered_read_data;
      end
   end

   always @ (posedge clk or posedge reset) begin
      if(reset) begin
         tRHWCount <= 4'd0;
      end else if(re_l_goingHigh) begin
         tRHWCount <= 4'd11;
    //     $monitor("at time=%t, re_l_goingHigh=%b, io=%b, status=%b, buffered_read_data=%b", $time,    re_l_goingHigh, io, status, buffered_read_data);
   //      $display("DISPLAYING at time=%t, re_l_goingHigh=%b, io=%b, status=%b, buffered_read_data=%b", $time, re_l_goingHigh, io, status, buffered_read_data);
      end else if(tRHWCount != 4'd0) begin
         tRHWCount <= tRHWCount - 4'd1;
      end
   end

   always @ (posedge clk or posedge reset) begin
      if(reset) begin
         DATA_OUT <= 8'b0;
      end else if(read_now) begin
	 DATA_OUT <= buffered_read_data;	
      end
   end

   // sequential logic block, where all things happening on clock edge should reside
   // Note: 1:only non blocking assign should be used
   //       2:always hava a reset case
   always @ (posedge clk or posedge reset) begin
      if (reset) begin
         current_fsm_state <= `INIT_STATE0;
         initStateCount <= 1; //this could be a higher number (like (max number)-11000 or something)
         dataCycleCount <= 0;
         buffered_new_data <= 1'b0;
         buffered_new_cmd <= 1'b0;
         buffered_new_cmd2 <= 1'b0;

      end else begin
         current_fsm_state <= next_fsm_state;
         initStateCount <= initStateCount_inc ? (initStateCount+1) : initStateCount;
         if(dataCycleCount_reset0) begin
            dataCycleCount <= length;
         end else if (dataCycleCount_dec) begin
            dataCycleCount <= dataCycleCount-1;
         end
         buffered_new_data <= DATA_LOADED;
         buffered_new_cmd <= CMD_LOADED;
         buffered_new_cmd2 <= buffered_new_cmd;
     end
   end

   assign load_addr_latch_return =  {(current_fsm_state==`PROGRAM_PAGE_ADDR_LATCH_STATE0), (current_fsm_state==`ERASE_BLOCK_ADDR_LATCH_STATE0), (current_fsm_state==`READ_PAGE_ADDR_LATCH_STATE0)};
   always @ (posedge clk or posedge reset) begin
      if(reset) begin
         addr_latch_return <= 7'h0;
      end else    
        if(load_addr_latch_return != 3'b0) begin
            if(load_addr_latch_return[2]) begin
               addr_latch_return <= `PROGRAM_PAGE_ADDR_LATCH_STATE1;
            end else if(load_addr_latch_return[1]) begin
               addr_latch_return <= `ERASE_BLOCK_CMD_LATCH_STATE3;
            end else if(load_addr_latch_return[0]) begin
               addr_latch_return <= `READ_PAGE_CMD_LATCH_STATE3;
            end else begin
               addr_latch_return <= 7'hx;
            end
      	end
   end
	always @ (posedge clk or posedge reset) begin
		if(reset) begin
			length=4314;
		end else begin
			if(current_fsm_state == `START_STATE1) begin
				length=LEN;
			end
		end
	end
   // assign len= (current_fsm_state == `START_STATE1) ? LEN: len;	
   assign DONE = (current_fsm_state==`START_STATE0);
   assign DATA_DONE = (current_fsm_state==`INPUT_DATA_LATCH_STATE1);
   assign DATA_READY = (current_fsm_state==`OUTPUT_DATA_LATCH_STATE11);
   assign read_now = (current_fsm_state==`DATA_ACCESS_STATE1);
   assign load_status = (current_fsm_state==`READ_STATUS_STATE4);
   assign initStateCount_inc = (current_fsm_state==`INIT_STATE1);
   assign dataCycleCount_dec = (current_fsm_state==`DATA_ACCESS_STATE1) || (current_fsm_state==`INPUT_DATA_LATCH_STATE1);
   assign dataCycleCount_reset0 = (current_fsm_state==`READ_PAGE_OUTPUT_DATA_LATCH_STATE0) || (current_fsm_state==`PROGRAM_PAGE_INPUT_DATA_LATCH_STATE0);

//    combinational next state and output logic
//    to avoid inferred latches, the following should be assigned to in all states
//    most signals that change are marked with a //#
//    nand:
//       ale
//       ce_l
//       cle
//       re_l
//       we_l
//       write_data
//    internals:
//       re_l_goingHigh
//    states:
//       next_fsm_state
//    if the signals did not change, simply use the setting from the previous state
//    note :1. use blocking assign(=) only
//          2. try to avoid recursive statements, like a=a+1
   always @ * begin
      case(current_fsm_state)
         `INIT_STATE0: begin
            ale = 1'b0;
            ce_l = 1'b1;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            //write_data = 8'h00;
            write_data = 8'hcc;
            re_l_goingHigh = 1'b1; //#

            next_fsm_state = `INIT_STATE1;
         end
         `INIT_STATE1: begin
            ale = 1'b0;
            ce_l = 1'b1;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            //write_data = 8'h00;
            write_data = 8'hc1;
            re_l_goingHigh = 1'b0;
            //initStateCount_inc =1;

            next_fsm_state = (initStateCount==0)? `START_STATE0: `INIT_STATE1;
         end
         `START_STATE0: begin
            //should set everything to correct state here, similar to reset
            ale = 1'b0; //#
            ce_l = 1'b1; //#
            cle = 1'b0; //#
            re_l = 1'b1; //#
            we_l = 1'b1; //#
            //write_data = 8'h00; //#
            write_data=8'hc2;
            re_l_goingHigh = 1'b0; //#

     //       $display("at time %t, new_cmd=%b", $time, new_cmd);
            next_fsm_state = new_cmd ? `START_STATE1 : `START_STATE0;
         end
         `START_STATE1: begin
     //      $display ("new CMD at time=%t, CMD=%d", $time, CMD);
            case(CMD)
               `READ_STATUS_CMD: begin
                  ale = 1'b0;
                  ce_l = 1'b0; //#
                  cle = 1'b1; //#
                  re_l = 1'b1;
                  we_l = ~(tRHWCount==0); //#
                  write_data = 8'h70; //#

                  re_l_goingHigh = 1'b0;

                  next_fsm_state = (tRHWCount==0) ? `READ_STATUS_CMD_STATE0 : `START_STATE1;
               end
               `PROGRAM_PAGE_CMD: begin
                  ale = 1'b0;
                  ce_l = 1'b0; //#
                  cle = 1'b1; //#
                  re_l = 1'b1;
                  we_l = ~(tRHWCount==0); //#
                  write_data = 8'h80; //#

                  re_l_goingHigh = 1'b0;

                  next_fsm_state = (tRHWCount==0) ? `PROGRAM_PAGE_CMD_LATCH_STATE0 : `START_STATE1;
               end
                `BLOCK_ERASE_CMD: begin
                  ale = 1'b0;
                  ce_l = 1'b0; //#
                  cle = 1'b1; //#
                  re_l = 1'b1;
                  we_l = ~(tRHWCount==0); //#
                  write_data = 8'h60; //#

                  re_l_goingHigh = 1'b0;

                  next_fsm_state = (tRHWCount==0) ? `ERASE_BLOCK_CMD_LATCH_STATE0 : `START_STATE1;
               end
               `RESET_CMD: begin
                  //$display ("RESET_CMD at time=%t",$time);
                  ale = 1'b0;
                  ce_l = 1'b0; //#
                  cle = 1'b1; //#
                  re_l = 1'b1;
                  we_l = ~(tRHWCount==0); //#
                  //write_data = 8'hFF; //#
                  write_data = 8'hAA;
                  re_l_goingHigh = 1'b0;

                  next_fsm_state = (tRHWCount==0) ? `RESET_STATE0 : `START_STATE1;
               end

              `READ_PAGE_CMD: begin
                  ale = 1'b0;
                  ce_l = 1'b0; //#
                  cle = 1'b1; //#
                  re_l = 1'b1;
                  we_l = ~(tRHWCount==0); //#
                  write_data = 8'h00; //#

                  re_l_goingHigh = 1'b0;

                  next_fsm_state = (tRHWCount==0) ? `READ_PAGE_CMD_LATCH_STATE0 : `START_STATE1;
               end
               default: begin
                  //$display("NEVERRRRRRRRRRRRRRR");
                  ale = 1'b0;
                  ce_l = 1'b1;
                  cle = 1'b0;
                  re_l = 1'b1;
                  we_l = 1'b1;
                  write_data = 8'h00;

                  re_l_goingHigh = 1'b0;

                  next_fsm_state = `START_STATE0;
               end
            endcase
         end

//////////////////RESET///////////////////////
         `RESET_STATE0: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b0;
            //write_data = 8'hFF;
            write_data = 8'hA0;
            re_l_goingHigh = 1'b0;

            next_fsm_state = `RESET_STATE1;
         end
         `RESET_STATE1: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b1; //#
           // write_data = 8'hFF;
            write_data = 8'hA1;
            re_l_goingHigh = 1'b0;

            next_fsm_state = `RESET_STATE2;
         end
         // wait for RB to go high
         `RESET_STATE2: begin
            ale = 1'b0;
            ce_l = 1'b1; //#
            cle = 1'b0; //#
            re_l = 1'b1;
            we_l = 1'b1;
            //write_data = 8'hFF;
            write_data = 8'hA2;
            re_l_goingHigh = 1'b0;

            next_fsm_state = (RB? `RESET_STATE3:`RESET_STATE2);
         end
         // wait for RB to go low
         `RESET_STATE3: begin
            ale = 1'b0;
            ce_l = 1'b1;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            //write_data = 8'hFF;
            write_data = 8'hA3;
            re_l_goingHigh = 1'b0;

            next_fsm_state = (RB?`RESET_STATE3: `START_STATE0);
         end

//////////////////READ STATUS///////////////////////
         `READ_STATUS_CMD_STATE0: begin
//             $display("READ_STATUS_CMD_STATE0 at %t\n", $time);
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b0;
            write_data = 8'h70;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_CMD_STATE1;
         end
         `READ_STATUS_CMD_STATE1: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b1; //#
            write_data = 8'h70;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_CMD_STATE2;
         end
         `READ_STATUS_CMD_STATE2: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0; //#
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'h70;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_STATE_WAIT0;
         end
         `READ_STATUS_STATE_WAIT0: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b0;
            we_l = 1'b1;
            write_data = 8'hx; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_STATE_WAIT1;
         end
         `READ_STATUS_STATE_WAIT1: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b0;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_STATE_WAIT2;
         end
         `READ_STATUS_STATE_WAIT2: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b0;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_STATE_WAIT3;
         end
         `READ_STATUS_STATE_WAIT3: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b0;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_STATE1;
         end
         `READ_STATUS_STATE1: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b0; //#
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_STATE2;
         end
         `READ_STATUS_STATE2: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b0;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_STATE2a;
         end
			`READ_STATUS_STATE2a: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b0;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_STATE2b;
         end
			`READ_STATUS_STATE2b: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b0;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_STATE2c;
         end
			`READ_STATUS_STATE2c: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b0;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_STATE3;
         end
         `READ_STATUS_STATE3: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b0;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b1; //#
            //load_status = 1'b1;

            next_fsm_state = `READ_STATUS_STATE4;
         end
         `READ_STATUS_STATE4: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0; //#

            next_fsm_state = `START_STATE0;
         end

//////////////////PROGRAM PAGE///////////////////////
         `PROGRAM_PAGE_CMD_LATCH_STATE0: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b0;
            write_data = 8'h80;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `PROGRAM_PAGE_CMD_LATCH_STATE1;
         end
         `PROGRAM_PAGE_CMD_LATCH_STATE1: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b1; //#
            write_data = 8'h80;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `PROGRAM_PAGE_CMD_LATCH_STATE2;
         end
         `PROGRAM_PAGE_CMD_LATCH_STATE2: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0; //#
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'h80;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `PROGRAM_PAGE_ADDR_LATCH_STATE0;
         end
         `PROGRAM_PAGE_ADDR_LATCH_STATE0: begin
            //$display ("`PROGRAM_PAGE_ADDR_LATCH_STATE0 at time=%t",$time);
            ale = 1'b1; //#
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b0; //#
            write_data = ADDR[7:0]; //#

            re_l_goingHigh = 1'b0;

            //addr_latch_return = `PROGRAM_PAGE_ADDR_LATCH_STATE1;
            next_fsm_state = `ADDR_LATCH_STATE1;
         end
         `PROGRAM_PAGE_ADDR_LATCH_STATE1: begin
            ale = 1'b1;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'bx; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = `PROGRAM_PAGE_ADDR_LATCH_STATE2;
         end
         `PROGRAM_PAGE_ADDR_LATCH_STATE2: begin
            ale = 1'b1;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'bx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `PROGRAM_PAGE_INPUT_DATA_LATCH_STATE0;
         end
         `PROGRAM_PAGE_INPUT_DATA_LATCH_STATE0: begin
            //$display ("`PROGRAM_PAGE_INPUT_DATA_LATCH_STATE0 at time=%t",$time);
            ale = 1'b1;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'bx;

            re_l_goingHigh = 1'b0;
            //dataCycleCount_reset0 = 1'b1; <---dataCycleCount = 1078;

            //input_data_latch_return = `PROGRAM_PAGE_INPUT_DATA_LATCH_STATE1;
            next_fsm_state = `INPUT_DATA_LATCH_STATE0;
         end
         `PROGRAM_PAGE_CMD_LATCH_STATE3: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1; //#
            re_l = 1'b1;
            we_l = 1'b0; //#
            write_data = 8'h10; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = `PROGRAM_PAGE_CMD_LATCH_STATE4;
         end
         `PROGRAM_PAGE_CMD_LATCH_STATE4: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b1; //#
            write_data = 8'h10;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `PROGRAM_PAGE_CMD_LATCH_STATE5;
         end
         `PROGRAM_PAGE_CMD_LATCH_STATE5: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0; //#
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'h10;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `PROGRAM_PAGE_BUSY_STATE0;
         end
         `PROGRAM_PAGE_BUSY_STATE0: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'bx; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = RB ? `PROGRAM_PAGE_BUSY_STATE1 : `PROGRAM_PAGE_BUSY_STATE0;
         end
         `PROGRAM_PAGE_BUSY_STATE1: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'bx; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = RB ? `PROGRAM_PAGE_BUSY_STATE1 : `PROGRAM_PAGE_CMD_LATCH_STATE6;
         end
         `PROGRAM_PAGE_CMD_LATCH_STATE6: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1; //#
            re_l = 1'b1;
            we_l = 1'b0; //#
            write_data = 8'h70; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_CMD_STATE0;
         end

//////////////////ERASE BLOCK///////////////////////
         `ERASE_BLOCK_CMD_LATCH_STATE0: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b0;
            write_data = 8'h60;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ERASE_BLOCK_CMD_LATCH_STATE1;
         end
         `ERASE_BLOCK_CMD_LATCH_STATE1: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b1; //#
            write_data = 8'h60;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ERASE_BLOCK_CMD_LATCH_STATE2;
         end
         `ERASE_BLOCK_CMD_LATCH_STATE2: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0; //#
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'h60;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ERASE_BLOCK_ADDR_LATCH_STATE0;
         end
         `ERASE_BLOCK_ADDR_LATCH_STATE0: begin
            ale = 1'b1; //#
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b0; //#
            write_data = ADDR[20:13]; //#

            re_l_goingHigh = 1'b0;

            //addr_latch_return = `ERASE_BLOCK_CMD_LATCH_STATE3;
            next_fsm_state = `ADDR_LATCH_STATE5;
         end
         `ERASE_BLOCK_CMD_LATCH_STATE3: begin
            ale = 1'b0; //#
            ce_l = 1'b0;
            cle = 1'b1; //#
            re_l = 1'b1;
            we_l = 1'b0; //#
            write_data = 8'hD0; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ERASE_BLOCK_CMD_LATCH_STATE4;
         end
         `ERASE_BLOCK_CMD_LATCH_STATE4: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b1; //#
            write_data = 8'hD0;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ERASE_BLOCK_CMD_LATCH_STATE5;
         end
         `ERASE_BLOCK_CMD_LATCH_STATE5: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0; //#
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'hD0;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ERASE_BLOCK_BUSY_STATE0;
         end
         `ERASE_BLOCK_BUSY_STATE0: begin
        //  $display ("RB=%b %b %b,`ERASE_BLOCK_BUSY_STATE0 at time=%t",RB,rb1_l,rb2_l,$time);
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            //wait for RB to go high
            next_fsm_state = RB ? `ERASE_BLOCK_BUSY_STATE1 : `ERASE_BLOCK_BUSY_STATE0;
         end
         `ERASE_BLOCK_BUSY_STATE1: begin
     //       $display ("`ERASE_BLOCK_BUSY_STATE1 at time=%t",$time);
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            //wait for RB to go low
            next_fsm_state = RB ? `ERASE_BLOCK_BUSY_STATE1 : `ERASE_BLOCK_CMD_LATCH_STATE6;
         end
         `ERASE_BLOCK_CMD_LATCH_STATE6: begin
            //$display ("`ERASE_BLOCK_CMD_LATCH_STATE2 at time=%t",$time);
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1; //#
            re_l = 1'b1;
            we_l = 1'b0; //#
            write_data = 8'h70; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_STATUS_CMD_STATE0;
         end

///////////////////READ PAGE CYCLES/////////////////////////
         `READ_PAGE_CMD_LATCH_STATE0: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b0;
            write_data = 8'h00;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_PAGE_CMD_LATCH_STATE1;
         end
         `READ_PAGE_CMD_LATCH_STATE1: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b1; //#
            write_data = 8'h00;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_PAGE_CMD_LATCH_STATE2;
         end
         `READ_PAGE_CMD_LATCH_STATE2: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0; //#
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'h00;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_PAGE_ADDR_LATCH_STATE0;
         end
         `READ_PAGE_ADDR_LATCH_STATE0: begin
            ale = 1'b1; //#
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b0; //#
            write_data = ADDR[7:0]; //#

            re_l_goingHigh = 1'b0;

            //addr_latch_return = `READ_PAGE_CMD_LATCH_STATE3;
            next_fsm_state = `ADDR_LATCH_STATE1;
         end
         `READ_PAGE_CMD_LATCH_STATE3: begin
            ale = 1'b0; //#
            ce_l = 1'b0;
            cle = 1'b1; //#
            re_l = 1'b1;
            we_l = 1'b0; //#
            write_data = 8'h30; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_PAGE_CMD_LATCH_STATE4;
         end
         `READ_PAGE_CMD_LATCH_STATE4: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b1; //#
            write_data = 8'h30;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_PAGE_CMD_LATCH_STATE5;
         end
         `READ_PAGE_CMD_LATCH_STATE5: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0; //#
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'h30;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_PAGE_WAIT_STATE0;
         end
         `READ_PAGE_WAIT_STATE0: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'hx; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = (RB ? `READ_PAGE_WAIT_STATE1 : `READ_PAGE_WAIT_STATE0);
         end
         `READ_PAGE_WAIT_STATE1: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = (RB ? `READ_PAGE_WAIT_STATE1 : `READ_PAGE_WAIT_STATE2);
         end
         `READ_PAGE_WAIT_STATE2: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_PAGE_WAIT_STATE3;
         end
         `READ_PAGE_WAIT_STATE3: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_PAGE_WAIT_STATE4;
         end
         `READ_PAGE_WAIT_STATE4: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `READ_PAGE_OUTPUT_DATA_LATCH_STATE0;
         end
         `READ_PAGE_OUTPUT_DATA_LATCH_STATE0: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;
            //dataCycleCount_reset0 = 1'b1;

            //output_data_latch_return = `READ_PAGE_OUTPUT_DATA_LATCH_STATE1;
            next_fsm_state = `OUTPUT_DATA_LATCH_STATE0;
         end

//////////////////OUTPUT DATA LATCH Cycle///////////////////////
         `OUTPUT_DATA_LATCH_STATE0: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `OUTPUT_DATA_LATCH_STATE1;
         end
         `OUTPUT_DATA_LATCH_STATE1: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b0; //#
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;
            //read_data_sel = 4'b1000; //#
            //load_data_access_return = 4'b1000;

            next_fsm_state = `DATA_ACCESS_STATE0;
         end
         `OUTPUT_DATA_LATCH_STATE11: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1; //#
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0; //#

            //$display("DATA_OUT=%h, dataCycleCount=%d", DATA_OUT, dataCycleCount);
            next_fsm_state = (dataCycleCount==0) ? `START_STATE0 : `OUTPUT_DATA_LATCH_STATE0;
         end

//////////////////DATA ACCESS Cycles//////////////////
         `DATA_ACCESS_STATE0: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b0;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `DATA_ACCESS_STATE1;
         end
         `DATA_ACCESS_STATE1: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b0;
            we_l = 1'b1;
            write_data = 8'hx;

            re_l_goingHigh = 1'b1; //#
            //read_now = 1'b1;

            next_fsm_state = `OUTPUT_DATA_LATCH_STATE11;
         end

//////////////////CMD LATCH Cycle///////////////////////
//          `CMD_LATCH_STATE0: begin
//             next_fsm_state = `CMD_LATCH_STATE1;
//          end
/*
         `CMD_LATCH_STATE1: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b1;
            re_l = 1'b1;
            we_l = 1'b1; //#
            //write_data = 8'h70;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `CMD_LATCH_STATE2;
         end
         `CMD_LATCH_STATE2: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0; //#
            re_l = 1'b1;
            we_l = 1'b1;
            //write_data = 8'h70;

            re_l_goingHigh = 1'b0;

            next_fsm_state = goto_fsm_state;
         end
*/

//////////////////ADDRESS LATCH Cycle///////////////////////
/*
         `ADDR_LATCH_STATE0: begin
            ale =1'b1;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l =1'b1;
            we_l = 1'b0;
            write_data = ADDR[7:0];
         //   $display ("PROGRAM_PAGE_ADDR_LATCH_STATE0 at time=%t",$time);

            next_fsm_state = `ADDR_LATCH_STATE1;
         end
*/
         `ADDR_LATCH_STATE1: begin
            ale = 1'b1;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1; //#
            write_data = ADDR[7:0]; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ADDR_LATCH_STATE2;
         end
         `ADDR_LATCH_STATE2: begin
            ale = 1'b1;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b0; //#
            write_data = {3'b0, ADDR[12:8]}; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ADDR_LATCH_STATE3;
         end
         `ADDR_LATCH_STATE3: begin
            ale = 1'b1;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1; //#
            write_data = {3'b0, ADDR[12:8]};

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ADDR_LATCH_STATE4;
         end
         `ADDR_LATCH_STATE4: begin
            ale = 1'b1;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b0; //#
            write_data = ADDR[20:13]; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ADDR_LATCH_STATE5;
         end
         `ADDR_LATCH_STATE5: begin
            ale = 1'b1;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1; //#
            write_data = ADDR[20:13];

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ADDR_LATCH_STATE6;
         end
         `ADDR_LATCH_STATE6: begin
            ale = 1'b1;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b0; //#
            write_data = ADDR[28:21]; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ADDR_LATCH_STATE7;
         end
         `ADDR_LATCH_STATE7: begin
            ale = 1'b1;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1; //#
            write_data = ADDR[28:21];

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ADDR_LATCH_STATE8;
         end
         `ADDR_LATCH_STATE8: begin
            ale = 1'b1;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b0; //#
            write_data = {6'b0, ADDR[30:29]}; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = `ADDR_LATCH_STATE9;
         end
         `ADDR_LATCH_STATE9: begin
            ale = 1'b1;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1; //#
            write_data = {6'b0, ADDR[30:29]};

            re_l_goingHigh = 1'b0;

            next_fsm_state = addr_latch_return;
         end

//////////////////INPUT DATA LATCH Cycle///////////////////////
         `INPUT_DATA_LATCH_STATE0: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b0;
            write_data = DATA_IN; //#

            re_l_goingHigh = 1'b0;

            next_fsm_state = new_data ? `INPUT_DATA_LATCH_STATE1 : `INPUT_DATA_LATCH_STATE0;
         end
         `INPUT_DATA_LATCH_STATE1: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = DATA_IN;

            re_l_goingHigh = 1'b0;

            next_fsm_state = `INPUT_DATA_LATCH_STATE8;
         end
         `INPUT_DATA_LATCH_STATE8: begin
            ale = 1'b0;
            ce_l = 1'b0;
            cle = 1'b0;
            re_l = 1'b1;
            we_l = 1'b1;
            write_data = DATA_IN;

            re_l_goingHigh = 1'b0;

            next_fsm_state = (dataCycleCount==0) ? `PROGRAM_PAGE_CMD_LATCH_STATE3 : `INPUT_DATA_LATCH_STATE0;
         end

         default: begin
            //$display("nEVERRRRRRRRRRRRRRRyyyy");

            ce_l = 1'b1;
            re_l = 1'b1;
            we_l = 1'b1;
            ale = 1'b0;
            cle = 1'b0;
            write_data = 8'h00;
            
            re_l_goingHigh = 1'b0;
            next_fsm_state = `START_STATE0;
         end

      endcase
   end

endmodule
