`include "nand_controller_parameters.v"


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
    
                  io_T = `IO_IN;
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
                  ce2_l = 0;
                  we_l = 0;
                  io_O = 8'hFF;
                  io_T = `IO_OUT;
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
                  io_O = 8'hFF;
                  io_T = `IO_OUT;
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
                  
                  io_T = `IO_IN;
                  re_l = 1;
                  //wp_l = 1;
                  //nand_pwr = 1;
             
               /*TRANSITIONS*/
               if(fsm_timer == 0)begin
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
               if(fsm_timer == 0)begin
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
               if(fsm_timer == 0)begin
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
                  
             
             //WRITE SOMETHING BASED ON LAST IO READ
                  io_O = (last_io_read*2);
                  io_T = `IO_OUT;
                  re_l = 1;
                           //wp_l = 1;
                  //nand_pwr = 1;
             
               /*TRANSITIONS*/
               if(fsm_timer == 0)begin
                   fsm_nextstate = `S6_TESTIO1;
               end else begin
                   fsm_nextstate = `S8_TESTIO3;
               end
    
             end /*S8_TESTIO3*/ 
             
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
    	       ce2_l = 0;
    	       we_l = 0;
    
    	       io_O = 8'h90;
    	       io_T = `IO_OUT;
    	       re_l = 1;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID2;
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
    	       ce2_l = 0;
    	       we_l = 1;
    
    	       io_O = 8'h90;
    	       io_T = `IO_OUT;
    	       re_l = 1;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID3;
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
    	       ce2_l = 0;
    	       we_l = 1;
    
    	       io_T = `IO_IN;
    	       re_l = 1;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID4;
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
    	       ce2_l = 0;
    	       we_l = 0;
    
    	       io_O = 8'h00;
    	       io_T = `IO_OUT;
    	       re_l = 1;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID5;
    	  end /*STATE_READ_ID4*/              
             
       	 `STATE_READ_ID5: begin
    
    	    /*ENTRY ACTIONS (only first time)*/
    	    if(fsm_laststate != fsm_currstate) begin
    		/*SET TIMER*/
    		fsm_timer_setval = `FSM_TIMER_60NS;
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
    	       ce2_l = 0;
    	       we_l = 1;
    
    	       io_O = 8'h00;
    	       io_T = `IO_OUT;
    	       re_l = 1;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    if(fsm_timer == 0) begin
             fsm_nextstate = `STATE_READ_ID6;
           end else begin
             fsm_nextstate = `STATE_READ_ID5;
           end
          end
          /*STATE_READ_ID5*/                     
             
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
    	       ce2_l = 0;
    	       we_l = 1;
    
    	       io_T = `IO_IN;
    	       re_l = 1;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID7;
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
    	       ce2_l = 0;
    	       we_l = 1;
    
    	       io_T = `IO_IN;
    	       re_l = 0;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID8;
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
    	       ce2_l = 0;
    	       we_l = 1;
    
    	       io_T = `IO_IN;
    	       //BYTE_0 <= io_I;
    	       re_l = 1;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID9;
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
    	       ce2_l = 0;
    	       we_l = 1;
    
    	       io_T = `IO_IN;
    	       
    	       re_l = 0;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID10;
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
    	       ce2_l = 0;
    	       we_l = 1;
    
    	       io_T = `IO_IN;
    	       //BYTE_1 <= io_I;
    	       re_l = 1;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID11;
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
    	       ce2_l = 0;
    	       we_l = 1;
    
    	       io_T = `IO_IN;
    
    	       re_l = 0;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID12;
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
    	       ce2_l = 0;
    	       we_l = 1;
    
    	       io_T = `IO_IN;
    	       //BYTE_2 <= io_I;
    	       re_l = 1;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID13;
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
    	       ce2_l = 0;
    	       we_l = 1;
    
    	       io_T = `IO_IN;
    	       
    	       re_l = 0;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID14;
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
    	       ce2_l = 0;
    	       we_l = 1;
    
    	       io_T = `IO_IN;
    	       //BYTE3 <= io_I;
    	       re_l = 1;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID15;
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
    	       ce2_l = 0;
    	       we_l = 1;
    
    	       io_T = `IO_IN;
    
    	       re_l = 0;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    		fsm_nextstate = `STATE_READ_ID16;
    	    end /*STATE_READ_ID15*/
             
        	 `STATE_READ_ID16: begin
    
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
    
    	       io_T = `IO_IN;
    		//BYTE4 <= io_I;
    	       re_l = 1;
    	     //wp_l = 1;
    	     //nand_pwr = 1;
    
    	    /*TRANSITIONS*/
    	    	//don't use the timer since no delay needed
    	    	/*TODO: SHOULD RETURN TO CONTROL HANDLER*/
    		fsm_nextstate = `STATE_READ_ID16;
    	    end /*STATE_READ_ID16*/
             
             default: begin
              fsm_nextstate = 8'hb5;// DEBUG
         end
      endcase
  end
  
  endmodule
  
  //
