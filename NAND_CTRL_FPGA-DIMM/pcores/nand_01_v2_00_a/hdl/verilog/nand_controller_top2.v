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
   ce1_l,ce2_l,ale,cle,re_l,we_l,io_I,io_O,io_T,rb1_l,rb2_l );
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
   input      [7:0] io_I; /*this _I,_O,_T crap is just how xilinx does inouts.  see $EDK/doc/psf_rm.pdf, chapter 3 INOUT*/
   output reg [7:0] io_O;
   output reg       io_T; /*direction control for inout io bus*/
   input rb1_l, rb2_l;

   //wire cs;

   /*FSM Stuff*/
   reg [7:0] fsm_laststate, fsm_currstate, fsm_nextstate;
   reg [31:0] fsm_timer, fsm_timer_setval;
   reg fsm_timer_set;
   reg [7:0] last_io_read;
   reg [31:0] test_readval_buf;
   
   //reg             io_dir;  // direction (`IO_IN (1) or `IO_OUT (0))
   //reg     [7:0]   io_writedata;  // output latch for data write

   //assign  io = (io_dir) ? 8'bz : io_writedata;
   //assign io = fsm_currstate; //DEBUG; DISCONNECT NAND FIRST
   
  
   
  /*FSM*/
  /*Sequential Logic*/
  always @ (posedge clk or posedge reset)
  begin
      if(reset) begin
         fsm_laststate <= `S_INVALID;
         fsm_currstate <= `S1_PWRUP1;
         //fsm_currstate <= `S1_TESTIO1; //DEBUG
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
      
      
/*****************************************************************/
/*STATE_PWRUP*****************************************************/
/*****************************************************************/
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
              
              io_T= `IO_IN;
              re_l = 1;
              //wp_l = 1;
              //nand_pwr = 0;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0 && fsm_laststate == fsm_currstate)begin
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
             
              io_T = `IO_IN;
              re_l = 1;
              //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0 && fsm_laststate == fsm_currstate)begin
               /*T4*/
               fsm_nextstate = `S3_RESET1;
           end else begin
               /*T3*/
               fsm_nextstate = `S2_PWRUP2;
           end
         
         end /*S2_PWRUP2*/
         
/*****************************************************************/
/*STATE_RESET*****************************************************/
/*****************************************************************/
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
              ce2_l = 1;
              we_l = 0;
              io_O = 8'hFF;
              io_T = `IO_OUT;
              re_l = 1;
              //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0 && fsm_laststate == fsm_currstate)begin
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
              ce2_l = 1;
              we_l = 1;
              io_O = 8'hFF;
              io_T = `IO_OUT;
              re_l = 1;
              //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0 && fsm_laststate == fsm_currstate)begin
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
              ce1_l = 1;
              ce2_l = 1;
              we_l = 1;
              io_T = `IO_IN;
              re_l = 1;
              //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0 && fsm_laststate == fsm_currstate)begin
               /*T10*/
               fsm_nextstate = `STATE_READ_ID1;
           end else begin
               /*T9*/
               fsm_nextstate = `S5_RESET3;
           end
        
         end /*S5_RESET3*/

/*****************************************************************/
/*STATE_TESTIO****************************************************/
/*****************************************************************/
         `S6_TESTIO1: begin
           
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
              cle = 0;
              ale = 0;
              ce1_l = 0;
              ce2_l = 0;
              we_l = 1;
              
              //WRITE KNOWN VALUE
              io_T = `IO_OUT;
              io_O = 8'hAB;
             
              //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0 && fsm_laststate == fsm_currstate)begin
               fsm_nextstate = `S7_TESTIO2;
            end else begin
               fsm_nextstate = `S6_TESTIO1;
            end
         end /*S6_TESTIO1*/
         `S7_TESTIO2: begin
           
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
              cle = 0;
              ale = 0;
              ce1_l = 0;
              ce2_l = 0;
              we_l = 1;
              
              
              //READ IO BUS IN
              last_io_read <= io_I;
              io_T = `IO_IN;
              re_l = 1;

              //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0 && fsm_laststate == fsm_currstate)begin
               fsm_nextstate = `S8_TESTIO3;
           end else begin
               fsm_nextstate = `S7_TESTIO2;
           end

         end /*S7_TESTIO2*/ 
         
         `S8_TESTIO3: begin
           
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
              cle = 0;
              ale = 0;
              ce1_l = 0;
              ce2_l = 0;
              we_l = 1;
              
              
              //READ IO BUS IN
              last_io_read <= io_I;
              io_T = `IO_IN;
              re_l = 1;

              //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0 && fsm_laststate == fsm_currstate)begin
               fsm_nextstate = `S9_TESTIO4;
           end else begin
               fsm_nextstate = `S8_TESTIO3;
           end

         end /*S8_TESTIO3*/ 
         `S9_TESTIO4: begin
           
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
              cle = 0;
              ale = 0;
              ce1_l = 0;
              ce2_l = 0;
              we_l = 1;
              
         
         //WRITE SOMETHING BASED ON LAST IO READ
              io_O = (last_io_read*2);
              io_T = `IO_OUT;
              re_l = 1;
                       //wp_l = 1;
              //nand_pwr = 1;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0 && fsm_laststate == fsm_currstate)begin
               fsm_nextstate = `S6_TESTIO1;
           end else begin
               fsm_nextstate = `S9_TESTIO4;
           end

         end /*S9_TESTIO4*/ 
/*****************************************************************/
/*STATE_GET_FEATURES***************************************************/
/*****************************************************************/

	  `STATE_GET_FEATURES1: begin

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
	       ce2_l = 1;
	       we_l = 0;

	       io_O = 8'hEE;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_GET_FEATURES2;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES1;   
       end
		
      end /*STATE_GET_FEATURES1*/ 
         
	  `STATE_GET_FEATURES2: begin

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
	       ce2_l = 1;
	       we_l = 1;

	       io_O = 8'hEE;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_GET_FEATURES3;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES2;	
      end
      end /*STATE_GET_FEATURES2*/          
 	 
 	 `STATE_GET_FEATURES3: begin

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
	       cle = 0;
	       ale = 1;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;
          io_O = 8'h80;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_GET_FEATURES4;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES3;
      end
     end /*STATE_GET_FEATURES3*/           
         
  	 `STATE_GET_FEATURES4: begin

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
	       cle = 0;
	       ale = 1;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 0;

	       io_O = 8'h80;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
       if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
         fsm_nextstate = `STATE_GET_FEATURES5;
       end else begin
         fsm_nextstate = `STATE_GET_FEATURES4;
       end
	  end /*STATE_GET_FEATURES4*/              
         
   	 `STATE_GET_FEATURES5: begin

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
	       cle = 0;
	       ale = 1;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_O = 8'h80;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
         fsm_nextstate = `STATE_GET_FEATURES6;
       end else begin
         fsm_nextstate = `STATE_GET_FEATURES5;
       end
      end
      /*STATE_GET_FEATURES5*/                     
         
    	 `STATE_GET_FEATURES6: begin

	    /*ENTRY ACTIONS (only first time)*/
	    if(fsm_laststate != fsm_currstate) begin
		/*SET TIMER*/
		fsm_timer_setval = `FSM_TIMER_1US;
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
	       ce2_l = 1;
	       we_l = 1;
          io_O = 8'h55;
	       io_T = `IO_IN;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_GET_FEATURES7;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES6;
      end
	  end /*STATE_GET_FEATURES6*/          
         
    	 `STATE_GET_FEATURES7: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       re_l = 0;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_GET_FEATURES8;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES7;
      end
	  end /*STATE_GET_FEATURES7*/                   
         
    	 `STATE_GET_FEATURES8: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       //BYTE_0 <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_GET_FEATURES9;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES8;
      end
	  end /*STATE_GET_FEATURES8*/      
         
    	 `STATE_GET_FEATURES9: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       
	       re_l = 0;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_GET_FEATURES10;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES9;
      end
	  end /*STATE_GET_FEATURES9*/               

    	 `STATE_GET_FEATURES10: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       //BYTE_1 <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_GET_FEATURES11;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES10;
      end
	  end /*STATE_GET_FEATURES10*/      
         
    	 `STATE_GET_FEATURES11: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;

	       re_l = 0;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_GET_FEATURES12;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES11;
      end 
	  end /*STATE_GET_FEATURES11*/

    	 `STATE_GET_FEATURES12: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       //BYTE_2 <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_GET_FEATURES13;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES12;
      end
	  end /*STATE_GET_FEATURES12*/
         
    	 `STATE_GET_FEATURES13: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       
	       re_l = 0;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_GET_FEATURES14;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES13;
      end
	  end /*STATE_GET_FEATURES13*/
         
    	 `STATE_GET_FEATURES14: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       //BYTE3 <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_GET_FEATURES15;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES14;
      end
	  end /*STATE_GET_FEATURES14*/

    	 `STATE_GET_FEATURES15: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;

	       re_l = 0;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_GET_FEATURES16;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES15;
      end
	  end /*STATE_GET_FEATURES15*/
         
    	 `STATE_GET_FEATURES16: begin

	    /*ENTRY ACTIONS (only first time)*/
	    if(fsm_laststate != fsm_currstate) begin
		/*SET TIMER*/
		fsm_timer_setval = `FSM_TIMER_100US;
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
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
		//BYTE4 <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
	    	/*TODO: SHOULD RETURN TO CONTROL HANDLER*/
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID1;
		end else begin
		    fsm_nextstate = `STATE_GET_FEATURES16;
      end
	  end /*STATE_GET_FEATURES16*/


/*****************************************************************/
/*STATE_READ_ID***************************************************/
/*****************************************************************/

	  `STATE_READ_ID1: begin

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
	       ce2_l = 1;
	       we_l = 0;

	       io_O = 8'h90;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID2;
		end else begin
		    fsm_nextstate = `STATE_READ_ID1;   
       end
		
      end /*STATE_READ_ID1*/ 
         
	  `STATE_READ_ID2: begin

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
	       ce2_l = 1;
	       we_l = 1;

	       io_O = 8'h90;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID3;
		end else begin
		    fsm_nextstate = `STATE_READ_ID2;	
      end
      end /*STATE_READ_ID2*/          
 	 
 	 `STATE_READ_ID3: begin

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
	       cle = 0;
	       ale = 1;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;
          io_O = 8'h20;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID4;
		end else begin
		    fsm_nextstate = `STATE_READ_ID3;
      end
     end /*STATE_READ_ID3*/           
         
  	 `STATE_READ_ID4: begin

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
	       cle = 0;
	       ale = 1;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 0;

	       io_O = 8'h20;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
       if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
         fsm_nextstate = `STATE_READ_ID5;
       end else begin
         fsm_nextstate = `STATE_READ_ID4;
       end
	  end /*STATE_READ_ID4*/              
         
   	 `STATE_READ_ID5: begin

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
	       cle = 0;
	       ale = 1;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_O = 8'h20;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
         fsm_nextstate = `STATE_READ_ID5_1;
       end else begin
         fsm_nextstate = `STATE_READ_ID5;
       end
      end
      /*STATE_READ_ID5*/                     
         
         
         
   	 `STATE_READ_ID5_1: begin

	    /*ENTRY ACTIONS (only first time)*/
	    if(fsm_laststate != fsm_currstate) begin
		/*SET TIMER*/
		fsm_timer_setval = `FSM_TIMER_120NS;
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
	       ce2_l = 1;
	       we_l = 1;

	       io_O = 8'h55;
	       io_T = `IO_IN;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
         fsm_nextstate = `STATE_READ_ID6;
       end else begin
         fsm_nextstate = `STATE_READ_ID5_1;
       end
      end
      /*STATE_READ_ID5_1*/           
      
    	 `STATE_READ_ID6: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;
          io_O = 8'h55;
	       io_T = `IO_IN;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID7;
		end else begin
		    fsm_nextstate = `STATE_READ_ID6;
      end
	  end /*STATE_READ_ID6*/          
         
    	 `STATE_READ_ID7: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       re_l = 0;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID8;
		end else begin
		    fsm_nextstate = `STATE_READ_ID7;
      end
	  end /*STATE_READ_ID7*/                   
         
    	 `STATE_READ_ID8: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       //BYTE_0 <= io_I;
	       test_readval_buf[7:0] <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID9;
		end else begin
		    fsm_nextstate = `STATE_READ_ID8;
      end
	  end /*STATE_READ_ID8*/      
         
    	 `STATE_READ_ID9: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       
	       re_l = 0;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID10;
		end else begin
		    fsm_nextstate = `STATE_READ_ID9;
      end
	  end /*STATE_READ_ID9*/               

    	 `STATE_READ_ID10: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	        //BYTE1<= io_I;
	        test_readval_buf[15:8] <= io_I; 
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID11;
		end else begin
		    fsm_nextstate = `STATE_READ_ID10;
      end
	  end /*STATE_READ_ID10*/      
         
    	 `STATE_READ_ID11: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;

	       re_l = 0;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID12;
		end else begin
		    fsm_nextstate = `STATE_READ_ID11;
      end 
	  end /*STATE_READ_ID11*/

    	 `STATE_READ_ID12: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       //BYTE_2 <= io_I;
	       test_readval_buf[23:16] <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID13;
		end else begin
		    fsm_nextstate = `STATE_READ_ID12;
      end
	  end /*STATE_READ_ID12*/
         
    	 `STATE_READ_ID13: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       
	       re_l = 0;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID14;
		end else begin
		    fsm_nextstate = `STATE_READ_ID13;
      end
	  end /*STATE_READ_ID13*/
         
    	 `STATE_READ_ID14: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       //BYTE3 <= io_I;
	       test_readval_buf[31:24] <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID15;
		end else begin
		    fsm_nextstate = `STATE_READ_ID14;
      end
	  end /*STATE_READ_ID14*/

    	 `STATE_READ_ID15: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;

	       re_l = 0;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID16;
		end else begin
		    fsm_nextstate = `STATE_READ_ID15;
      end
	  end /*STATE_READ_ID15*/
         
    	 `STATE_READ_ID16: begin

	    /*ENTRY ACTIONS (only first time)*/
	    if(fsm_laststate != fsm_currstate) begin
		/*SET TIMER*/
		fsm_timer_setval = `FSM_TIMER_100US;
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
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
		//BYTE4 <= io_I;
		
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
	    	/*TODO: SHOULD RETURN TO CONTROL HANDLER*/
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_TEST_BYTE_OUT1;
		end else begin
		    fsm_nextstate = `STATE_READ_ID16;
      end
	  end /*STATE_READ_ID16*/
         
         
    	 `STATE_TEST_BYTE_OUT1: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 1;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_OUT;
	       io_O = test_readval_buf[7:0];
		
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
	    	/*TODO: SHOULD RETURN TO CONTROL HANDLER*/
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_TEST_BYTE_OUT2;
		end else begin
		    fsm_nextstate = `STATE_TEST_BYTE_OUT1;
      end
	  end /*STATE_TEST_BYTE_OUT1*/         
         
         
    	 `STATE_TEST_BYTE_OUT2: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 1;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_OUT;
	       io_O = test_readval_buf[15:8];
		
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
	    	/*TODO: SHOULD RETURN TO CONTROL HANDLER*/
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_TEST_BYTE_OUT3;
		end else begin
		    fsm_nextstate = `STATE_TEST_BYTE_OUT2;
      end
	  end /*STATE_TEST_BYTE_OUT2*/
    	 `STATE_TEST_BYTE_OUT3: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 1;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_OUT;
	       io_O = test_readval_buf[23:16];
		
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
	    	/*TODO: SHOULD RETURN TO CONTROL HANDLER*/
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_TEST_BYTE_OUT4;
		end else begin
		    fsm_nextstate = `STATE_TEST_BYTE_OUT3;
      end
	  end /*STATE_TEST_BYTE_OUT3*/
    	 `STATE_TEST_BYTE_OUT4: begin

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
	       cle = 0;
	       ale = 0;
	       ce1_l = 1;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_OUT;
	       io_O = test_readval_buf[31:24];
		
	       re_l = 1;
	     //wp_l = 1;
	     //nand_pwr = 1;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
	    	/*TODO: SHOULD RETURN TO CONTROL HANDLER*/
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_READ_ID1;
		end else begin
		    fsm_nextstate = `STATE_TEST_BYTE_OUT4;
      end
	  end /*STATE_TEST_BYTE_OUT4*/  	  
         
         
           
         default: begin
          fsm_nextstate = 8'hb5;// DEBUG
         end
         
         
         
         
    endcase
   end
  
  endmodule
  
  //
