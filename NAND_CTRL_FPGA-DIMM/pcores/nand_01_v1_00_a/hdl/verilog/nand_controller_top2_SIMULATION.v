//`include "controller_parameters.v"

/*Timer Values calculated on spreadsheet accessible here:
https://spreadsheets.google.com/ccc?key=0AuPgSeOMSrjzdHVCSmVDUl9kcE5vUXA0ckJ1MGZwY3c&hl=en
*/

`define FSM_TIMER_20NS 0
`define FSM_TIMER_100US 4999
`define FSM_TIMER_1MS 49999



//FSM States/////////////////////////////////
`define S_INVALID 0
`define S1_PWRUP1 10
`define S2_PWRUP2 11
`define S3_RESET1 12
`define S4_RESET2 13
`define S5_RESET3 14


/*TOP MODULE*/
module top ();

wire clk, reset;
wire [7:0] curr_fsm, fsm_nextstate;
wire [31:0] fsm_timer_out, fsm_timer_setval;
wire fsm_timer_set;

nand_controller_top n1(clk, reset, curr_fsm, fsm_nextstate, fsm_timer_out, fsm_timer_setval, fsm_timer_set);
testbench tb(clk, reset, curr_fsm, fsm_nextstate, fsm_timer_out, fsm_timer_setval, fsm_timer_set);

endmodule /*END TOP MODULE*/


/*MODULE TESTBENCH*/
module testbench(clk, reset,curr_fsm, fsm_nextstate_in, fsm_timer_in, fsm_timer_setval_in, fsm_timer_set_in);

output reg clk;
output reg reset;
input [7:0] curr_fsm, fsm_nextstate_in;
input [31:0] fsm_timer_in, fsm_timer_setval_in;
input fsm_timer_set_in;


initial begin
 $monitor("clk=%b, curr_state=%d, next_state=%d, fsm_timer=%d, fsm_timer_setval=%d, fsm_timer_set=%b\n",
  clk, curr_fsm, fsm_nextstate_in, fsm_timer_in, fsm_timer_setval_in, fsm_timer_set_in);
 clk = 0;
 #5 reset=1;
 #5 reset=0;
 #1000;
end
   

 // Clock generator
 always begin
    #5  clk = ~clk; // Toggle clock every 5 ticks
 end

endmodule /*TESTBENCH*/


/*MODULE NAND_CONTROLLER_TOP*/
module nand_controller_top (clk, reset, fsm_currstate_out, fsm_nextstate_out, fsm_timer_out, fsm_timer_setval_out, fsm_timer_set_out);

    input clk;
    input reset;
    output [7:0] fsm_currstate_out, fsm_nextstate_out;
    output [31:0] fsm_timer_out, fsm_timer_setval_out;
    output fsm_timer_set_out;
    
       /*FSM Stuff*/
   reg [7:0] fsm_laststate, fsm_currstate, fsm_nextstate;
   reg [31:0] fsm_timer, fsm_timer_setval;
   reg fsm_timer_set;

   assign fsm_currstate_out = fsm_currstate;
   assign fsm_nextstate_out = fsm_nextstate;
   assign fsm_timer_out = fsm_timer;
   assign fsm_timer_set_out = fsm_timer_set;
   assign fsm_timer_setval_out = fsm_timer_setval;

/*FSM*/
  /*Sequential Logic*/
  always @ (posedge clk or posedge reset)
  begin
      if(reset) begin
         fsm_laststate <= `S_INVALID;
         fsm_currstate <= `S1_PWRUP1;
        // fsm_nextstate <= `S1_PWRUP1;
         
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
             /* cle = 0;
              ale = 0;
              ce1_l = 1;
              ce2_l = 1;
              we_l = 1;
              io = 8'h00;
              re_l = 1;*/
              //wp_l = 1;
              //nand_pwr = 0;
         
           /*TRANSITIONS*/
          // if(fsm_timer == 0)begin
               /*T2*/
               fsm_nextstate = `S2_PWRUP2;
         //  end else begin
               /*T1*/
         //      fsm_nextstate = `S1_PWRUP1;
         //  end
         
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
              /*cle = 0;
              ale = 0;
              ce1_l = 1;
              ce2_l = 1;
              we_l = 1;
              io = 8'h00;
              re_l = 1;*/
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
             /* cle = 1;
              ale = 0;
              ce1_l = 0;
              ce2_l = 0;
              we_l = 0;
              io = 8'hFF;
              re_l = 1;*/
              //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
           //if(fsm_timer == 0)begin
               /*T6*/
               fsm_nextstate = `S4_RESET2;
          // end else begin
               /*T5*/
           //    fsm_nextstate = `S3_RESET1;
          // end
         
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
              /*cle = 1;
              ale = 0;
              ce1_l = 0;
              ce2_l = 0;
              we_l = 1;
              io = 8'hFF;
              re_l = 1;*/
              //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
          // if(fsm_timer == 0)begin
               /*T8*/
               fsm_nextstate = `S5_RESET3;
          // end else begin
               /*T7*/
           //    fsm_nextstate = `S4_RESET2;
          // end
         
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
             /* cle = 0;
              ale = 0;
              ce1_l = 0;
              ce2_l = 0;
              we_l = 1;
              io = 8'h00;
              re_l = 1;*/
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
