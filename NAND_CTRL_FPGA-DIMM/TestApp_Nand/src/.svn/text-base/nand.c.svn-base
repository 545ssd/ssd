#include <string.h>
//#include <sys/unistd.h>

#include <xparameters.h>		// generated file with every peripheral's address
#include "xio.h"					//printf.. and more?


   /*Defines for Protocol*/
   /*__SYS_CTRL_REG__*/
   #define CTRL_REG_CLEAR_ALL_FLAGS 0x00000000
   #define SYS_RESET 0x80000000
   //#define MB_FINISHED_READ 0x00000001

   /*__NANDX_CMD_REG__*/
   #define NAND_CMD_RESET 12
   #define NAND_CMD_READ_ID 18
   #define NAND_CMD_GET_FEATURES 34

   /*__NANDX_STATUS_REG__

	 [ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ | _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ]
	     Hi 16 bits used for LENGTH    |    LOW 16 Bits used for flags
   */
   //make these numbers each binary values on a certain bit
   #define NAND_CMD_DONE      0x00000001
   #define NAND_BUSY		  0x00000002
   #define NAND_DATA_BUF_FULL 0x00000004

   /* Hardware Registers */
    // Base Addr defined in xparamaters.h

    //offset:
	#define SYS_CTRL_REG 0x0  		// (0)

    #define NAND1_STATUS_REG 0x4  	// (1)
    #define NAND1_CMD_REG 0x8		// (2)
	#define NAND1_DATA_BUF_HEAD 0xC	// (3-4)

	#define NAND2_STATUS_REG 0x14	// (5)
	#define NAND2_CMD_REG 0x18		// (6)
	#define NAND2_DATA_BUF_HEAD 0x1C// (7-8)

    #define NAND3_STATUS_REG 0x24	// (9)
    #define NAND3_CMD_REG 0x28		// (10)
	#define NAND3_DATA_BUF_HEAD 0x2C// (11-12)

    #define NAND4_STATUS_REG 0x34	// (13)
    #define NAND4_CMD_REG 0x38		// (14)
	#define NAND4_DATA_BUF_HEAD 0x3C// (15)

	#define VERBOSE 1
	#define SILENT 0

	#define SUCCESS 0
	#define ERROR_DEV_NO_INIT 1


int hw_reset(int verbose);
int nand_reset(int nand_cmd_reg_offset, int nand_status_reg_offset, int verbose);
int nand_read_id(int nand_cmd_reg_offset, int nand_status_reg_offset, int nand_data_buf_offset, int verbose);

int main(void)
{

	int error;

	 hw_reset(SILENT);

	 if( (error = nand_reset(NAND1_CMD_REG, NAND1_STATUS_REG, SILENT)) != SUCCESS)
	 	xil_printf("NAND1 RESET Failed: error = %d",error);
	 if( (error = nand_reset(NAND2_CMD_REG, NAND2_STATUS_REG, SILENT)) != SUCCESS)
	 	xil_printf("NAND2 RESET Failed: error = %d",error);
	 if( (error = nand_reset(NAND3_CMD_REG, NAND3_STATUS_REG, SILENT)) != SUCCESS)
		xil_printf("NAND3 RESET Failed: error = %d",error);
	 if( (error = nand_reset(NAND4_CMD_REG, NAND4_STATUS_REG, SILENT)) != SUCCESS)
		xil_printf("NAND4 RESET Failed: error = %d",error);


	 nand_read_id(NAND1_CMD_REG, NAND1_STATUS_REG, NAND1_DATA_BUF_HEAD, VERBOSE);

	 nand_read_id(NAND3_CMD_REG, NAND3_STATUS_REG, NAND3_DATA_BUF_HEAD, VERBOSE);


}



int hw_reset(int verbose)
{
	int temp, delay, delay2;

	if(verbose == VERBOSE)
		xil_printf("-----Starting HW Reset------\r\n");


	   /*Toggle HW reset pin*/
	     XIo_Out32( (XPAR_NAND_PLB_TO_MB_0_BASEADDR + SYS_CTRL_REG), SYS_RESET );
		for(delay = 0 ; delay < 10000 ; delay++)
		{/*DELAY LOOP*/
				for(delay2 = 0 ; delay2 < 10000 ; delay2++)
					{temp++;}
		}
		 XIo_Out32( (XPAR_NAND_PLB_TO_MB_0_BASEADDR + SYS_CTRL_REG), CTRL_REG_CLEAR_ALL_FLAGS);
		for(delay = 0 ; delay < 10000 ; delay++)
		{/*DELAY LOOP*/
				for(delay2 = 0 ; delay2 < 10000 ; delay2++)
					{temp++;}
		}
	if(verbose == VERBOSE)
	 	xil_printf("-----Finished HW Reset------\r\n\r\n");


	 	return 0;

}

int nand_reset(int nand_cmd_reg_offset, int nand_status_reg_offset, int verbose)
{
	int readval;

	 if(verbose == VERBOSE)
	 	xil_printf("-----Sending NAND RESET   cmd_reg = %d, status_reg = %d-----\r\n",nand_cmd_reg_offset, nand_status_reg_offset);

	/* Issue RESET command, wait for it to complete*/
	 XIo_Out32( (XPAR_NAND_PLB_TO_MB_0_BASEADDR + nand_cmd_reg_offset), NAND_CMD_RESET);
	 readval = XIo_In32( XPAR_NAND_PLB_TO_MB_0_BASEADDR + nand_status_reg_offset);
	 while(readval == NAND_BUSY )
	 {
		if(verbose == VERBOSE)
			xil_printf("     NAND RESET status = NAND_BUSY (%x)\r\n",readval);

		readval = XIo_In32( XPAR_NAND_PLB_TO_MB_0_BASEADDR + nand_status_reg_offset);

	 }
	 if(verbose == VERBOSE)
	 	xil_printf("-----Finished NAND RESET: status = NAND_CMD_DONE (%x)-----\r\n\r\n",readval);

	if(readval == NAND_CMD_DONE)
		return SUCCESS;

    else
    	return ERROR_DEV_NO_INIT;


}


int nand_read_id(int nand_cmd_reg_offset, int nand_status_reg_offset, int nand_data_buf_offset, int verbose)
{
	int readval;

	/* Issue READ_ID command, store result in temp, acknowledge command */
	if(verbose == VERBOSE)
		 xil_printf("-----Sending NAND READ_ID------\r\n");

	XIo_Out32( (XPAR_NAND_PLB_TO_MB_0_BASEADDR + nand_cmd_reg_offset), NAND_CMD_READ_ID);
	readval = XIo_In32( XPAR_NAND_PLB_TO_MB_0_BASEADDR + nand_status_reg_offset);
	while(readval == NAND_BUSY)
	 {
		if(verbose == VERBOSE)
			xil_printf("     NAND READ_ID: status = NAND_BUSY (%x)\r\n",readval);

		readval = XIo_In32( XPAR_NAND_PLB_TO_MB_0_BASEADDR + nand_status_reg_offset);

	 }
	if(verbose == VERBOSE)
		xil_printf("----- Finished READ_ID; status = NAND_CMD_DONE (%x)\r\n",readval);

	readval = XIo_In32( XPAR_NAND_PLB_TO_MB_0_BASEADDR + nand_data_buf_offset );

	//don't use sys_ctrl_reg for this, need to make a new reg if its necessary...
	//XIo_Out32( (XPAR_NAND_PLB_TO_MB_0_BASEADDR + SYS_CTRL_REG), MB_FINISHED_READ);

	if(verbose == VERBOSE)
		xil_printf("     Read_ID read val: %x\r\n\r\n", readval);

	return readval;
}
