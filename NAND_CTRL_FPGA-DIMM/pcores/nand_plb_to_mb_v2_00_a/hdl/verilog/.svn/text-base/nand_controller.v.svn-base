`timescale 1ns / 1ns
`default_nettype none
//`include "controller_parameters.v"
`include "nand_controller_parameters.v"


/* OPEN ISSUES

   - had to slow FSM clock from 100 to 50 MHz, so the timing constants are off, but it still works
*/

/*
CHANGE LOG:
5/5/2010 redesign for communication with PLB
3/27/2010 first implementation of new nand_controller design (wconstab)
*/


(* fsm_style = "bram" *)
module nand_controller ( clk, reset, 
			nand_cmd_reg, status_reg, debug_reg, clear_cmd_reg, nand_data_buf,
			ce1_l,ce2_l,ale,cle,re_l,we_l,
			io_I,io_O,io_T,
			rb1_l,rb2_l );
 
 
   input [31:0] nand_cmd_reg;
   output reg [31:0] status_reg;
   output [31:0] debug_reg;
   output reg [31:0] nand_data_buf;
   output reg clear_cmd_reg;  // can clear the nand_cmd_reg with 1
   


   input clk; 
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
   
  /*Debug Signals*/
  assign debug_reg[31:24] = fsm_nextstate,
  	 debug_reg[23:16] = fsm_currstate,
  	 debug_reg[15:8] = fsm_laststate,
  	 debug_reg[7:0] = fsm_timer[7:0];
 
   
  
   
  /*FSM*/
  /*Sequential Logic*/
  always @ (posedge clk or posedge reset)
  begin
      if(reset) begin
         fsm_laststate <= `S_INVALID;
         fsm_currstate <= `STATE_WAIT_FOR_CMD;
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
/*WAIT_FOR_CMD****************************************************/
/*****************************************************************/  

	 `STATE_WAIT_FOR_CMD: begin
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
	             
	               /*STATE OUPUTS*/
	               cle = 0;
	               ale = 0;
	               ce1_l = 1;
	               ce2_l = 1;
	               we_l = 1;
	               io_T = `IO_IN;
	               re_l = 1;
	               //wp_l = 1;
	               
	               clear_cmd_reg = 0;
	               status_reg = `NAND_CMD_DONE;
	          
	            /*TRANSITIONS*/
	            if(nand_cmd_reg == `STATE_RESET1)begin
	                /*T1*/
	                fsm_nextstate = `STATE_RESET1;
	            end else if (nand_cmd_reg == `STATE_READ_ID1)begin
	                /*T2*/
	                fsm_nextstate = `STATE_READ_ID1;
	            end else begin
	            	/*T3*/
	            	fsm_nextstate = `STATE_WAIT_FOR_CMD;
	            end
           end
	          
/*****************************************************************/
/*STATE_RESET*****************************************************/
/*****************************************************************/
         `STATE_RESET1: begin
           
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
            
              /*STATE OUTPUTS*/
              cle = 1;
              ale = 0;
              ce1_l = 0;
              ce2_l = 1;
              we_l = 0;
              io_O = 8'hFF;
              io_T = `IO_OUT;
              re_l = 1;
              //wp_l = 1;
	     
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;
	          
         
           /*TRANSITIONS*/
           if(fsm_timer == 0 && fsm_laststate == fsm_currstate)begin
               /*T6*/
               fsm_nextstate = `STATE_RESET2;
           end else begin
               /*T5*/
               fsm_nextstate = `STATE_RESET1;
           end
         
         end /*STATE_RESET1*/
         `STATE_RESET2: begin
           
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
            
              /*STATE OUTPUTS*/
              cle = 1;
              ale = 0;
              ce1_l = 0;
              ce2_l = 1;
              we_l = 1;
              io_O = 8'hFF;
              io_T = `IO_OUT;
              re_l = 1;
              //wp_l = 1;
              clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0 && fsm_laststate == fsm_currstate)begin
               /*T8*/
               fsm_nextstate = `STATE_RESET3;
           end else begin
               /*T7*/
               fsm_nextstate = `STATE_RESET2;
           end
         
         end /*STATE_RESET2*/
         
         `STATE_RESET3: begin
           
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
            
              /*STATE OUTPUTS*/
              cle = 0;
              ale = 0;
              ce1_l = 1;
              ce2_l = 1;
              we_l = 1;
              io_T = `IO_IN;
              re_l = 1;
              //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;
         
           /*TRANSITIONS*/
           if(fsm_timer == 0 && fsm_laststate == fsm_currstate)begin
               /*T10*/
               fsm_nextstate = `STATE_WAIT_FOR_CMD;
           end else begin
               /*T9*/
               fsm_nextstate = `STATE_RESET3;
           end
        
         end /*STATE_RESET3*/


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

	       /*STATE OUTPUTS*/
	       cle = 1;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 0;

	       io_O = 8'hEE;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	     clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 1;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_O = 8'hEE;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 1;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;
          io_O = 8'h80;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 1;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 0;

	       io_O = 8'h80;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 1;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_O = 8'h80;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;
          io_O = 8'h55;
	       io_T = `IO_IN;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       re_l = 0;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       nand_data_buf[7:0] <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       
	       re_l = 0;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       nand_data_buf[15:8] <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;

	       re_l = 0;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       nand_data_buf[23:16] <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       
	       re_l = 0;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       nand_data_buf[31:24] <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;

	       re_l = 0;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
		//BYTE4 <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
	    	/*TODO: SHOULD RETURN TO CONTROL HANDLER*/
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_WAIT_FOR_CMD;
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

	       /*STATE OUTPUTS*/
	       cle = 1;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 0;

	       io_O = 8'h90;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 1;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_O = 8'h90;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 1;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;
          io_O = 8'h20;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 1;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 0;

	       io_O = 8'h20;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 1;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_O = 8'h20;
	       io_T = `IO_OUT;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_O = 8'h55;
	       io_T = `IO_IN;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;
          io_O = 8'h55;
	       io_T = `IO_IN;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       re_l = 0;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       //BYTE_0 <= io_I;
	       nand_data_buf[7:0] <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       
	       re_l = 0;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	        //BYTE1<= io_I;
	        nand_data_buf[15:8] <= io_I; 
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;

	       re_l = 0;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       //BYTE_2 <= io_I;
	       nand_data_buf[23:16] <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       
	       re_l = 0;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
	       //BYTE3 <= io_I;
	       nand_data_buf[31:24] <= io_I;
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;

	       re_l = 0;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

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

	       /*STATE OUTPUTS*/
	       cle = 0;
	       ale = 0;
	       ce1_l = 0;
	       ce2_l = 1;
	       we_l = 1;

	       io_T = `IO_IN;
		//BYTE4 <= io_I;
		
	       re_l = 1;
	     //wp_l = 1;
	      clear_cmd_reg = 1;
	      status_reg = `NAND_BUSY;

	    /*TRANSITIONS*/
	    	//don't use the timer since no delay needed
	    	/*TODO: SHOULD RETURN TO CONTROL HANDLER*/
		if(fsm_timer == 0 && fsm_laststate == fsm_currstate) begin
		    fsm_nextstate = `STATE_WAIT_FOR_CMD;
		end else begin
		    fsm_nextstate = `STATE_READ_ID16;
      end
	  end /*STATE_READ_ID16*/
         
         
         
    endcase
   end
  
  endmodule
  
