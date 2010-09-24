`timescale 1ns / 1ns
`default_nettype none
//`include "controller_parameters.v"
`include "nand_controller_parameters.v"

/*
CHANGE LOG:
3/27/2010 first implementation of new nand_controller design (wconstab)
*/

/*
TODO:
 -new names for .._l signals (maybe _L is better, or if possible, #
 -add nand_pwr
 
*/



(* fsm_style = "bram" *)
module nand_controller_top ( DONE, DATA_DONE, DATA_READY, RB, status, DATA_OUT, current_fsm_state, DATA_IN, ADDR, CMD, DATA_LOADED, CMD_LOADED,LEN, clk, reset,
   ce1_l,ce2_l,ale,cle,re_l,we_l,io,rb1_l,rb2_l );
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
   input clk;  //100MHz or 50MHz?
   input reset;

   /*nand interface*/
   output reg re_l, we_l;
   output reg ale, cle;
   output reg ce1_l, ce2_l;
   inout  [7:0] io; /*this requires special control.  see io_dir*/
   input rb1_l, rb2_l;

   //wire cs;

   /*FSM Stuff*/
   reg [7:0] fsm_laststate, fsm_currstate, fsm_nextstate;
   reg [31:0] fsm_timer, fsm_timer_setval;
   reg fsm_timer_set;
   
   
   reg             io_dir;  // direction (`IO_IN (1) or `IO_OUT (0))
   reg     [7:0]   io_writedata;  // output latch for data write

   assign  io = (io_dir) ? 8'bz : io_writedata;
   //assign io = fsm_currstate; //DEBUG; DISCONNECT NAND FIRST
   
  
   
  /*FSM*/
  /*Sequential Logic*/
  always @ (posedge clk or posedge reset)
  begin
      if(reset) begin
         fsm_laststate <= `S_INVALID;
         fsm_currstate <= `S1_PWRUP1;
         fsm_timer = -1;
      end else begin
         fsm_laststate <= fsm_currstate;
         fsm_currstate <= fsm_nextstate;
         
         //Timer values must be updated immediately (=, NOT <=)
         if(fsm_timer_set == 1)begin
            fsm_timer = fsm_timer_setval;
         end else begin
            fsm_timer = fsm_timer - 1;
         end
      end
  
  end
  /*NEXT STATE LOGIC*/ 
  always @ (negedge clk)
  begin
  
      case(fsm_currstate)
         `S1_PWRUP1: begin
           
           /*ENTRY ACTIONS (only first time)*/
           if(fsm_laststate != fsm_currstate) begin
               /*SET TIMER*/
               fsm_timer_setval = `FSM_TIMER_20NS;//0
               fsm_timer_set = 1 ;
           end           
           
           /*DECREMENT TIMER (only subsequent times)*/
           else if(fsm_laststate == fsm_currstate)begin
              fsm_timer_set = 0;
           end
           /*ALWAYS ACTIONS (every time) */
            
              /*STATE OUPTUPS*/
              cle = 0;
              ale = 0;
              ce1_l = 1;
              ce2_l = 1;
              we_l = 1;
              //io_writedata = 8'h00;
              io_dir = `IO_IN;
              re_l = 1;
              //wp_l = 1;
              //nand_pwr = 0;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0)begin
               /*T2*/
               fsm_nextstate = `S2_PWRUP2;
           end else begin
               /*T1*/
               fsm_nextstate = `S1_PWRUP1;
           end
         
         end /*S1_PWRUP1*/
         `S2_PWRUP2: begin
           
           /*ENTRY ACTIONS (only first time)*/
           if(fsm_laststate != fsm_currstate) begin
               /*SET TIMER*/
               fsm_timer_setval = `FSM_TIMER_100US;//4999
               fsm_timer_set = 1;
           end           
           
           /*DECREMENT TIMER (only subsequent times)*/
           else if(fsm_laststate == fsm_currstate)begin
              fsm_timer_set = 0;
           end
           /*ALWAYS ACTIONS (every time) */
            
              /*STATE OUPTUPS*/
              cle = 0;
              ale = 0;
              ce1_l = 1;
              ce2_l = 1;
              we_l = 1;
              //io = 8'h00;
              io_dir = `IO_IN;
              re_l = 1;
              //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0)begin
               /*T4*/
               fsm_nextstate = `S3_RESET1;
           end else begin
               /*T3*/
               fsm_nextstate = `S2_PWRUP2;
           end
         
         end /*S2_PWRUP2*/
         `S3_RESET1: begin
           
           /*ENTRY ACTIONS (only first time)*/
           if(fsm_laststate != fsm_currstate) begin
               /*SET TIMER*/
               fsm_timer_setval = `FSM_TIMER_20NS;
               fsm_timer_set = 1;
           end           
           
           /*DECREMENT TIMER (only subsequent times)*/
           else if(fsm_laststate == fsm_currstate)begin
              fsm_timer_set = 0;
           end
           /*ALWAYS ACTIONS (every time) */
            
              /*STATE OUPTUPS*/
              cle = 1;
              ale = 0;
              ce1_l = 0;
              ce2_l = 0;
              we_l = 0;
              io_writedata = 8'hFF;
              io_dir = `IO_OUT;
              re_l = 1;
              //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0)begin
               /*T6*/
               fsm_nextstate = `S4_RESET2;
           end else begin
               /*T5*/
               fsm_nextstate = `S3_RESET1;
           end
         
         end /*S3_RESET1*/
         `S4_RESET2: begin
           
           /*ENTRY ACTIONS (only first time)*/
           if(fsm_laststate != fsm_currstate) begin
               /*SET TIMER*/
               fsm_timer_setval = `FSM_TIMER_20NS;
               fsm_timer_set = 1;
           end           
           
           /*DECREMENT TIMER (only subsequent times)*/
          else if(fsm_laststate == fsm_currstate)begin
              fsm_timer_set = 0;
          end
           /*ALWAYS ACTIONS (every time) */
            
              /*STATE OUPTUPS*/
              cle = 1;
              ale = 0;
              ce1_l = 0;
              ce2_l = 0;
              we_l = 1;
              io_writedata = 8'hFF;
              io_dir = `IO_OUT;
              re_l = 1;
              //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0)begin
               /*T8*/
               fsm_nextstate = `S5_RESET3;
           end else begin
               /*T7*/
               fsm_nextstate = `S4_RESET2;
           end
         
         end /*S4_RESET2*/
         
         `S5_RESET3: begin
           
           /*ENTRY ACTIONS (only first time)*/
           if(fsm_laststate != fsm_currstate) begin
               /*SET TIMER*/
               fsm_timer_setval = `FSM_TIMER_1MS;
               fsm_timer_set = 1;
           end           
           
           /*DECREMENT TIMER (only subsequent times)*/
           else if(fsm_laststate == fsm_currstate)begin
              fsm_timer_set = 0;
           end
           /*ALWAYS ACTIONS (every time) */
            
              /*STATE OUPTUPS*/
              cle = 0;
              ale = 0;
              ce1_l = 0;
              ce2_l = 0;
              we_l = 1;
              //io = 8'h00;
              io_dir = `IO_IN;
              re_l = 1;
              //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0)begin
               /*T10*/
               fsm_nextstate = `S3_RESET1;
           end else begin
               /*T9*/
               fsm_nextstate = `S5_RESET3;
           end
        
         end /*S5_RESET3*/
         
         default: begin
          fsm_nextstate = 8'hb5;// DEBUG
         end
      endcase
  end
  
  endmodule
  
  //