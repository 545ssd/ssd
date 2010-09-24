
`timescale 1ns / 1ns
module nand_controller_tester();

   wire DONE;
   wire DATA_DONE;
   wire DATA_READY;
   wire RB;
   wire [7:0] status;
   wire [7:0] DATA_OUT;
   reg [7:0] DATA_IN;
   // buffer
   reg [8191:0] in0;
   reg [8191:0] in1;
   reg [8191:0] in2;
   reg [8191:0] in3;
   reg [1743:0] in4;
   reg [34511:0] in;
   reg [34511:0] temp;
   reg [34511:0] out;
   reg [34511:0] data;
   reg [7:0] mem1 [4313:0];
   reg [7:0] mem2 [4313:0];
   reg [7:0] mem3 [4313:0];
   reg [7:0] result [4313:0];
   integer fd,status_int,count;
   reg [31:0] ADDR;  //byte addressable (2 (1) dies with 2 (1) planes with 2048 (11) blocks with 64 (6) pages with 4314 (13) bytes)
   reg [2:0] CMD;   //43?  commands
   reg DATA_LOADED;
   reg CMD_LOADED; //not sure if we need this one
   reg [12:0] LEN;
   reg clk;  //100MHz
   reg reset;

`include "controller_parameters.v"

   // nand signals
   wire n_ce1_l,n_ce2_l,n_rb1_l,n_rb2_l,n_re_l,n_we_l,n_ale,n_cle;
   wire ce1_l,ce2_l,rb1_l,rb2_l,re_l,we_l,ale,cle;
   wire [7:0] io;
   wire [7:0] n_io;

   integer i;

   nand_controller_top controller0( DONE, DATA_DONE,DATA_READY, 
RB, status, DATA_OUT, DATA_IN, ADDR, CMD, DATA_LOADED, CMD_LOADED,LEN, clk, reset,
      n_ce1_l,n_ce2_l,n_ale,n_cle,n_re_l,n_we_l,n_io,n_rb1_l,n_rb2_l);

   // instantiate the nand chip
   nand_model mt29(.Dq_Io(io),.Cle(cle),.Ale(ale),.Ce_n(ce1_l),.Ce2_n(ce2_l),
      .Clk_We_n(we_l),.Wr_Re_n(re_l),.Wp_n(1'b1),.Rb_n(rb1_l),.Rb2_n(rb2_l));
   cpld cp(.n_ce_l(n_ce1_l),.n_ce2_l(n_ce2_l),.n_rb_l(n_rb1_l),.n_rb2_l(n_rb2_l)
	,.n_ale(n_ale),.n_cle(n_cle),.n_re_l(n_re_l),.n_we_l(n_we_l)
	,.n_io(n_io),.dir(n_re_l),.ce_l(ce1_l),.ce2_l(ce2_l),.rb_l(rb1_l),
	.rb2_l(rb2_l),.ale(ale),.cle(cle),.re_l(re_l),.we_l(we_l),.io(io));
  always
      #10 clk = !clk;

   initial begin
      $display ("\nStart Initializing");
      ADDR = 32'b0;
      CMD = 6'b0;
      DATA_LOADED = 0;
      CMD_LOADED = 0;

      clk = 0;
      for(i = 0; i<20; i = i+1) begin
         @(posedge clk);
      end

      reset = 0;
      @(posedge clk);
      reset = 1;
      @(posedge clk);
      reset = 0;
      @(posedge DONE);

      $display ("Finished Initializing \n");
      @(posedge clk);
      // First command to both chips must be RESET
      // Reset chip 1
      $display ("TEST Reset1: Starting at time %t, done=%b",$time,DONE);
      ADDR = 32'h0;
      CMD = `RESET_CMD;
      CMD_LOADED = 1'b1;
      @(posedge clk);
    //  $display("time now =%t",$time);
      CMD_LOADED = 1'b0;
      @(posedge DONE);
      $display ("Finish Reset1 at time %t\n",$time);
      @(posedge clk);
      // Reset chip 2
      $display ("TEST Reset2: Starting at time %t, done=%b",$time,DONE);
      ADDR = 32'hFFFFFFFF;
      CMD = `RESET_CMD;
      CMD_LOADED = 1'b1;
      @(posedge clk);
      CMD_LOADED = 1'b0;
      @(posedge DONE);
      @(posedge clk);
      $display ("Finish Reset2 at time %t\n",$time);

      $display ("TEST Read Status: at time %t, start read_status",$time);
      CMD = `READ_STATUS_CMD;
      CMD_LOADED = 1'b1;
      @(posedge clk);
      CMD_LOADED = 1'b0;
      @(posedge DONE);
      @(posedge clk);
      $display ("Finish Read Status at time %t, result=%b\n", $time, status);

      getdata(0);
      getdata(1);
      getdata(2);	
      program_page(32'b0,2'd0,13'd4314);
      read_page(32'b0,2'd0,13'd4314);
      block_erase(32'b0);
      // meta data		
      read_page(32'h00001000,2'd2,13'd218);
      program_page(32'h00001000,2'd1,13'd1);
      read_page(32'h00001000,2'd1,13'd1);
      program_page(32'h00000000,2'd1,13'd4096);
      read_page(32'h00000000,2'd1,13'h4096);
      program_page(32'h00001003,2'd1,13'd2);
      read_page(32'h00001003,2'd1,13'd2);
      program_page(32'h80000000,2'd1,13'd4096);
      read_page(32'h80000000,2'd1,13'd4096);
      program_page(32'h80001000,2'b0,13'd26);
      read_page(32'h80001000,2'd0,13'd26);
      block_erase(32'h80000000);
      program_page(32'h00082000,2'd1,13'd4314);
      program_page(32'h8c082000,2'd0,13'd4314);
      program_page(32'h00084000,2'd1,13'd4314);
      program_page(32'h8c084000,2'd0,13'd4314);
      program_page(32'h00086000,2'd1,13'd4314);
      program_page(32'h8c086000,2'd0,13'd4314);
      read_page(32'h00082000,2'd1,13'd4314);
      read_page(32'h00084000,2'd1,13'd4314);
      read_page(32'h00086000,2'd1,13'd4314);
      read_page(32'h8c082000,2'd0,13'd4314);
      read_page(32'h8c084000,2'd0,13'd4314);
      read_page(32'h8c086000,2'd0,13'd4314);
      program_page(32'h0c000000,2'd0,13'd898);
      program_page(32'h1f000000,2'd0,13'd3087);
      program_page(32'h4e000000,2'd1,13'd1054);
      read_page(32'h0c000000,2'd0,13'd898);
      read_page(32'h1f000000,2'd0,13'd3087);
      read_page(32'h4e000000,2'd1,13'd1054); 
      $finish;
   end


   // task to dig out data from input files
   // a specifies input files
   // 0= deadbeef test
   task getdata;
   input [1:0]a;
   begin
      in0=0;
      in1=0;
      in2=0;
      in3=0;
      in4=0;
      if(a==0) begin
         fd=$fopen("input1.txt","r");
      end else begin
         fd=$fopen("input2.txt","r");
      end
      status_int=$fscanf(fd,"%h\n",in0); 
      status_int=$fscanf(fd,"%h\n",in1); 
      status_int=$fscanf(fd,"%h\n",in2); 
      status_int=$fscanf(fd,"%h\n",in3); 
      status_int=$fscanf(fd,"%h\n",in4); 
      $fclose(fd);
      data={in0,in1,in2,in3,in4};
      for(i=0;i<4314;i=i+1) begin
	if(a==0) begin
  		mem1[i]= data[34511: 34504];
	//	$display("mem[i]=%h,i=%d",mem1[i],i);
	end else if (a==1) begin 
  		mem2[i]= data[34511: 34504];
	//	$display("mem[i]=%h,i=%d",mem2[i],i);
	end else if (a==2) begin
		mem3[i]= 8'hff;
	//	$display("mem[i]=%h,i=%d",mem3[i],i);
	end else begin
	end
        data = data << 8;
 	// $display("data=%h",data[34511:34504]);
      end 
   end
   endtask

   task program_page;
   input [31:0] addr;
   input [1:0] a;	
   input [12:0] len;
   begin
      $display ("TEST Program Page at time %t",$time);
      CMD = `PROGRAM_PAGE_CMD;
      CMD_LOADED = 1'b1;
      ADDR = addr;
      LEN = len;	
      @(posedge clk);
      CMD_LOADED = 1'b0;

      for(i = 0; i < len; i = i+1) begin 
	 if(a==0) begin
         	DATA_IN= mem1[i+addr[12:0]];
	//	$display(" case 0: byte %d din=%h",i,DATA_IN);
	 end else if (a==1) begin
         	DATA_IN= mem2[i+addr[12:0]];
	//	$display(" case 1: byte %d din=%h",i,DATA_IN);
	 end else if (a==2) begin
         	DATA_IN= mem3[i];
	 end else begin
	 end
         DATA_LOADED = 1'b1;
         @(posedge clk);
         DATA_LOADED = 1'b0;
         @(posedge DATA_DONE);
         @(posedge clk);
      end

      @(posedge DONE);
      $display ("Finish Program Page at time %t, result=%b\n", $time,status); 
      @(posedge clk);
   end
   endtask


   task read_page;
   input [31:0]addr;
   input [1:0]a;
   input [12:0] len; 	
   begin
      $display("TEST READ_PAGE at time %t",$time);
      temp=0;
      count=0;
      CMD=`READ_PAGE_CMD;
      CMD_LOADED=1'b1;
      ADDR=addr;
      LEN=len;	
      @(posedge clk);
      CMD_LOADED = 1'b0;

      for(i=0;i<len;i=i+1) begin
//	$display("waiting for byte %d",i);
	@(posedge DATA_READY);
	result[i]=DATA_OUT;
	
      end	
      @(posedge DONE);
      case(a) 
      	2'd0: begin
		for(i=0;i<len;i=i+1) begin
		//	$display("byte %d,result=%h,expect=%h",i,result[i],mem1[i+addr[12:0]]);
			if(result[i]!=mem1[i+addr[12:0]]) begin
			$display("byte %d,result=%h,expect=%h",i,result[i],mem1[i+addr[12:0]]);
			end
		end
	end
	2'd1: begin
		for(i=0;i<len;i=i+1) begin
		//	$display("byte %d,result=%h,expect=%h",i,result[i],mem2[i+addr[12:0]]);
			if(result[i]!=mem2[i+addr[12:0]]) begin
			$display("byte %d,result=%h,expect=%h",i,result[i],mem2[i+addr[12:0]]);
			end
		end
	end
	2'd2: begin
		for(i=0;i<len;i=i+1) begin
		//	$display("byte %d,result=%h,expect=%h",i,result[i],mem3[i]);
			if(result[i]!=mem3[i+addr[12:0]]) begin
			$display("byte %d,result=%h,expect=%h",i,result[i],mem3[i+addr[12:0]]);
			end
		end
	end
	2'd3: begin
	end
      endcase			
      @(posedge clk);
   end
   endtask 

   task block_erase;
   input [31:0]addr;
   begin
      $display ("TEST Block Erase: at time %t, start read_status",$time);
      CMD = `BLOCK_ERASE_CMD;
      CMD_LOADED = 1'b1;
      ADDR = addr;
      @(posedge clk);
      CMD_LOADED = 1'b0;

      @(posedge DONE);
      @(posedge clk);
      $display ("Finish Block Erase at time %t, result=%b\n", $time,status);

   end
   endtask
endmodule
