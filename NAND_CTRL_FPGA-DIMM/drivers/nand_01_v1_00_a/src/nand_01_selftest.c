/*****************************************************************************
* Filename:          C:\timSSD\nand13\drivers/nand_01_v1_00_a/src/nand_01_selftest.c
* Version:           1.00.a
* Description:       
* Date:              Thu Dec 03 18:23:46 2009 (by Create and Import Peripheral Wizard)
*****************************************************************************/

#include "xparameters.h"
#include "nand_01.h"

/* IMPORTANT:
*  In order to run this self test, you need to modify the value of following
*  micros according to the slot ID defined in xparameters.h file. 
*/
#define input_slot_id   XPAR_FSL_NAND_01_0_INPUT_SLOT_ID
#define output_slot_id  XPAR_FSL_NAND_01_0_OUTPUT_SLOT_ID

XStatus NAND_01_SelfTest()
{
	 unsigned int input_0[1];     
	 unsigned int output_0[1];     

	 //Initialize your input data over here: 
	 input_0[0] = 12345;     

	 //Call the macro with instance specific slot IDs
	 nand_01(
		 input_slot_id,
		 output_slot_id,
		 input_0,      
		 output_0       
		 );

	 if (output_0[0] != 12345)
		 return XST_FAILURE;
	 if (output_0[0] != 12345)
		 return XST_FAILURE;

	 return XST_SUCCESS;
}
