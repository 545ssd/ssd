/*
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A 
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR 
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION 
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE 
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO 
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO 
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE 
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 */

/*
 * Xilinx EDK 11.3 EDK_LS3.57
 *
 * This file is a sample test application
 *
 * This application is intended to test and/or illustrate some 
 * functionality of your system.  The contents of this file may
 * vary depending on the IP in your system and may use existing
 * IP driver functions.  These drivers will be generated in your
 * XPS project when you run the "Generate Libraries" menu item
 * in XPS.
 *
 * Your XPS project directory is at:
 *    C:\timSSD\nand01\
 */


// Located in: microblaze_0/include/xparameters.h
#include "xparameters.h"

#include "mb_interface.h"

#include "stdio.h"

#include "xutil.h"

#define write_into_fsl(val, id)  putfsl(val, id)
#define read_from_fsl(val, id)  getfsl(val, id)


//====================================================

int main (void) {


   /*
    * Enable and initialize cache
    */
   #if XPAR_MICROBLAZE_0_USE_ICACHE
      microblaze_invalidate_icache();
      microblaze_enable_icache();
   #endif

   #if XPAR_MICROBLAZE_0_USE_DCACHE
      microblaze_invalidate_dcache();
       microblaze_enable_dcache();
   #endif

   print("-- Entering main() --\r\n");

	/* READ PAGE */
	volatile unsigned int c1 = 0x00100004;
	volatile unsigned int c2 = 0x80162145;
	volatile unsigned int tmp, i, j;
		
	read_from_fsl(tmp, 0);
	xil_printf("c1 = %x\r\n", tmp);
	read_from_fsl(tmp, 0);
	xil_printf("c2 = %x\r\n", tmp);
	
	write_into_fsl(c1, 0);
	write_into_fsl(c2, 0);
   tmp = 0;
	
	for (i=0; i<4; i++)
	{
		read_from_fsl(tmp, 0);
		xil_printf("0x%x\r\n", tmp);
	}

	c1 = 0x00100002;
	c2 = 0x00000000;

	/* PROGRAM PAGE */
	write_into_fsl(c1, 0);
	write_into_fsl(c2, 0);
	xil_printf("written into fsl\r\n", tmp);
	
	for (i=0; i<4; i++)
	{
		tmp = 0xdeadb000 | i;
		write_into_fsl(tmp, 0);
      xil_printf("written %d\r\n", i);
	}
	
	read_from_fsl(tmp, 0);
	xil_printf("c1 = %x\r\n", tmp);
	read_from_fsl(tmp, 0);
	xil_printf("c2 = %x\r\n", tmp);
	

	/* READ PAGE */
	c1 = 0x00100004;
	c2 = 0x00000000;
		
	write_into_fsl(c1, 0);
	write_into_fsl(c2, 0);
   tmp = 0;
	
	for (i=0; i<4; i++)
	{
		read_from_fsl(tmp, 0);
		if (tmp != (0xdeadb000 | i))
			xil_printf("expecting %x but received %x\r\n", 0xdeadb000 | i, tmp);
		//if (i % 256 == 0)
			xil_printf("received %x\r\n", tmp);
	}
	if (tmp != 0xdeadb000)
		xil_printf("expecting %x but received %x\r\n", 0xdeadb000 | 1078, tmp);
	read_from_fsl(tmp, 0);
	xil_printf("c1 = %x\r\n", tmp);
	read_from_fsl(tmp, 0);
	xil_printf("c2 = %x\r\n", tmp);
	

   /* 
    * MemoryTest routine will not be run for the memory at 
    * 0x00000000 (dlmb_cntlr)
    * because it is being used to hold a part of this application program
    */

   /*
    * Disable cache and reinitialize it so that other
    * applications can be run with no problems
    */
   #if XPAR_MICROBLAZE_0_USE_DCACHE
      microblaze_disable_dcache();
      microblaze_invalidate_dcache();
   #endif

   #if XPAR_MICROBLAZE_0_USE_ICACHE
      microblaze_disable_icache();
      microblaze_invalidate_icache();
   #endif


   print("-- Exiting main() --\r\n");
   return 0;
}

