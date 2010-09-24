#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/mm.h>
#include <linux/pci.h>
#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/syscalls.h>

#include <linux/time.h>
#include <linux/unistd.h>
#include <linux/fcntl.h>
#include <linux/file.h>

#include <linux/string.h>


#include <linux/mtd/wmxssd_pcie.h> //exposes the pcie write / read and init functions
#include <linux/mtd/ssd_pci.h> // gets access to XUPv5 
#include <linux/mtd/ioctrl.h> // used by Eric Chung's code

#define	XC_MMAP_LENGTH		8192
#define	XC_DEVNAME 		"/dev/xupv5"
#define PROT_READ 1
#define PROT_WRITE 2
#define MAP_PRIVATE 1
#define MAP_FAILED ((void*)-1)


// Measurements
#define MAX_TLP_SIZE  		32
#define MAX_TLP_COUNT 		64
#define TIMEOUT 1000000 

// SSD Header Test defines
#define SSD_HEADER_READ 0xBABE5  //NAND_READ_PAGE_CMD
#define SSD_HEADER_WRITE 0xBABE3 //NAND_PROGRAM_PAGE_CMD
#define NAND_BLOCK_ERASE_CMD 0xBABE2 //NAND_BLOCK_ERASE_CMD


#define TESTBUFSIZE 8192
unsigned char knownvalue_buffer[TESTBUFSIZE]; // for test
unsigned char test_buffer[TESTBUFSIZE]; // for test
char temp_buf[TESTBUFSIZE];

//MY SSD_HEADER
struct ssd_header {
   unsigned int lba;
   unsigned int command;
   unsigned int size;
   unsigned int dummy;
};


volatile unsigned int  *_dma_addr_ptr;
volatile unsigned int   _dma_addr;
static   unsigned char *_bar0 = NULL;
//unused //static   int            _pcie_fd = -1;

static   unsigned long long __fifowcnt__ = 0;
static   unsigned long long __fiforcnt__ = 0;

static unsigned int
read_ctrl(int ctrl)
{
   volatile unsigned char *ptr;
   
   if(!_bar0) {
      printk("Must initialize bar0 first\n");
      //exit(-1);
      return -1;
   }
   ptr = (_bar0 + ctrl);
   //volatile unsigned int *val  = (unsigned int *)(ptr);
   //return *val;
   return readl(ptr);
}

static void
write_ctrl(int ctrl, unsigned int nval)
{
   volatile unsigned char *ptr;
   if(!_bar0) {
      printk("Must initialize bar0 first\n");
      //exit(-1);
      return;
   }
   
   ptr = (_bar0 + ctrl);
   //volatile unsigned int *val = (unsigned int *)(ptr);
   //*val = nval;
 //  printk("about to write %x to %x(%x)\n", nval, (unsigned int)ptr, virt_to_phys(ptr));
   writel(nval, ptr);
   //printk("done write\n");
}

static void
initiator_reset(void)
{
   // Perform a reset of the Initiator device by setting the low bit of the Device
   // Control Register (DCR) high.
   write_ctrl(DCR_OFFSET, 0x1);
   
   // Clears a reset of the Initiator device by setting the low bit of the Device
   // Control Register (DCR) low, then setting it low again.
   write_ctrl(DCR_OFFSET, 0x0);
   
}

static void
read_dma_addr(unsigned int addr)
{
   // Writes the target address on the host for a DMA transfer to the Write DMA TLP Address Register.
   write_ctrl(READ_ADDR_OFFSET, addr & 0xFFFFFFFC);
}


static void
write_dma_addr(unsigned int addr)
{
   // Writes the target address on the host for a DMA transfer to the Write DMA TLP Address Register.
   write_ctrl(WRITE_ADDR_OFFSET, addr & 0xFFFFFFFC);
}

static void
write_dma_size(unsigned int size)
{
   // Sets the size in bytes of each TLP by writing the value to the Write DMA TLP Size Register.
   unsigned int regValue;
   
   if(size > MAX_TLP_SIZE) {
      printk("ERROR, cannot have TLP larger than %u\n", MAX_TLP_SIZE);
      return ;
   }
   
   // Set the new Write TLP size.
   regValue = read_ctrl(WRITE_SIZE_OFFSET); // Read the entire register to preserve the upper bits
   regValue &= 0xFFFFF000; // Clear the lower 12 bits for the new size value
   regValue |= (size & 0xFFF); // Set the new size
   write_ctrl(WRITE_SIZE_OFFSET, regValue);
}

static void
write_dma_count(unsigned int count)
{
   unsigned int regvalue;
   if(count > MAX_TLP_COUNT) {
      printk("ERROR, cannot have TLP larger than %u\n", MAX_TLP_COUNT);
      return ;
   }
   
   // Sets the number of TLPs to transfer by writing the value to the Write DMA TLP Count Register.
   regvalue = read_ctrl(WRITE_COUNT_OFFSET);// read the entire register to preserve the upper bits
   regvalue &= 0xffff0000;// clear the lower 16 bits for the new count value
   regvalue |= (count & 0xffff);// set the new count
   write_ctrl(WRITE_COUNT_OFFSET, regvalue);
}

static void
read_dma_size(unsigned int size)
{
   // Sets the size in bytes of each TLP by writing the value to the Write DMA TLP Size Register.
   unsigned int regValue;
   
   if(size > MAX_TLP_SIZE) {
      printk("ERROR, cannot have TLP larger than %u\n", MAX_TLP_SIZE);
      return ;
   }
   // Set the new Write TLP size.
   regValue = read_ctrl(READ_SIZE_OFFSET); // Read the entire register to preserve the upper bits
   regValue &= 0xFFFFF000; // Clear the lower 12 bits for the new size value
   regValue |= (size & 0xFFF); // Set the new size
   write_ctrl(READ_SIZE_OFFSET, regValue);
}

static void
read_dma_count(unsigned int count)
{
   unsigned int regvalue;
   if(count > MAX_TLP_COUNT) {
      printk("ERROR, cannot have TLP larger than %u\n", MAX_TLP_COUNT);
      return ;
   }
   
   // Sets the number of TLPs to transfer by writing the value to the Write DMA TLP Count Register.
   regvalue = read_ctrl(READ_COUNT_OFFSET);// read the entire register to preserve the upper bits
   regvalue &= 0xffff0000;// clear the lower 16 bits for the new count value
   regvalue |= (count & 0xffff);// set the new count
   write_ctrl(READ_COUNT_OFFSET, regvalue);
}

static void
setup_write_dma(unsigned int tlp_size, unsigned int tlp_count)
{
   write_dma_size(tlp_size);
   write_dma_count(tlp_count);
}

static void
setup_read_dma(unsigned int tlp_size, unsigned int tlp_count)
{
   read_dma_size(tlp_size);
   read_dma_count(tlp_count);
}

static void
write_dma_start(void)
{
   unsigned int regValue;
   initiator_reset(); // always must happen first before starting a DMA transfer
   
   // Initiate any DMA transfers that have been set up in the Read/Write registers.
   regValue = read_ctrl(DCSR_OFFSET); // Read the entire register to preserve bits
   regValue |= 0x1;
   write_ctrl(DCSR_OFFSET, regValue);
   
}

#if 0
static void
atomic_dma_write(unsigned int tlp_size, unsigned int tlp_count)
{
   write_ctrl(ATOMIC_WRITE_OFFSET, (tlp_size & 0xffff) | ((tlp_size << 16)&0xffff0000));
   }
   
   static void
   atomic_dma_read(unsigned int tlp_size, unsigned int tlp_count)
   {
      write_ctrl(ATOMIC_READ_OFFSET, (tlp_size & 0xffff) | ((tlp_size << 16)&0xffff0000));
   }
   #endif
   
   
   static int 
   write_dma_done(void)
   {
      return 0x1 & (read_ctrl(DCSR_OFFSET) >> 8);
   }
   
   static int
   read_dma_done(void)
   {
      return 0x1 & (read_ctrl(DCSR_OFFSET) >> 24);
   }
   
   static void
   read_dma_start(void)
   {
      unsigned int regValue;
      initiator_reset(); // always must happen first before starting a DMA transfer
      
      // Initiate any DMA transfers that have been set up in the Read/Write registers.
      regValue = read_ctrl(DCSR_OFFSET);// Read the entire register to preserve bits
      regValue |= 0x10000  ;
   //   printk("regvalue %x\n", regValue);
      write_ctrl(DCSR_OFFSET, regValue);
      /*
      regValue = 0;
      regValue = read_ctrl(DCSR_OFFSET);// Read the entire register to preserve bits
      printk(" new regvalue %x\n", regValue);
      */
   }
   
   #if 0
   static unsigned int rev_end(int in)
   {
      return ((in & 0xff000000) >> 24)| 
      ((in & 0x00ff0000) >> 8) |
      ((in & 0x0000ff00) << 8) |
      ((in & 0x000000ff) << 24);
   }
   #endif
   
   static void
   setup_dma_params(int size, int *nsize, int *tlp_sz, int *tlp_cnt)
   {
      *nsize = size; 
      //assert(size <= 8192); // anything larger unsupported
      if(size > 8192)
         printk("SIZE > 8192 -- FAIL!!!!\n");
      
      if((*nsize%8) != 0) {
         *nsize += (8-(*nsize%8)); // next largest modulo-of-8 size
      }
      //assert((*nsize%8)==0);
      if((*nsize%8) != 0)
         printk("(*nsize%%8) != 0 -- FAIL!!!!\n");
      
      if((*nsize/4) <= MAX_TLP_SIZE) {
         *tlp_sz = *nsize/4;
         *tlp_cnt = 1;
      }
      else {
         //assert((*nsize/4)%MAX_TLP_SIZE == 0);
         if((*nsize/4)%MAX_TLP_SIZE != 0)
            printk("(*nsize/4)%%MAX_TLP_SIZE != 0 -- FAIL!!!!  %d\n", *nsize);
         
         *tlp_sz = MAX_TLP_SIZE;
         *tlp_cnt = (*nsize/4/MAX_TLP_SIZE);
      }
   }

/*writes to our FPGA-Ramdisk from buf, size bytes, to address lba*/
int wmxssd_pcie_write(char *buf, int size, unsigned int *lba)
{
   //char data[8192];
   struct ssd_header headerh;
   struct ssd_header *header = &headerh;
   
   //for testing
   //char income[0x1000];
   //int i;
   
   int pci_size;
   /*
   pci_size = size;
   
   // if(pci_size % 8)
   //    pci_size += (8 - size % 8);
   // if(pci_size % 8)
   //    printk("Will is Retarted \r\n");
   
   //size*/
   /*if((size%8) != 0) {
   pci_size += (8-(size%8)); // next largest modulo-of-8 size
}

if((size/4) <= MAX_TLP_SIZE){
}
else {
   pci_size += (128-(size%128));
}*/
   
   //this will only work so long as it is under 0x2000
   if(size>0x2000)
      printk("WHAT???!  ERROR - size %d\n", size);
   else if(size>0x1000)
   {
      wmxssd_pcie_write(buf, 0x1000, lba);
      wmxssd_pcie_write(buf+0x1000, size-0x1000, (unsigned int *)((char *)lba+0x1000));
   }
   else
   {
      
      pci_size = 0x1000;
      //create the command header
      header->lba = htonl((int)lba);
      header->command = htonl(SSD_HEADER_WRITE);
      header->size = htonl(size);
      //printk("--sending write command: %d bytes to addr %x, firstword = %x\n", ntohl(header->size), ntohl(header->lba), *((unsigned int *) buf));
      
      //send the write command to the PCIE device
      pcie_write((char *)header, sizeof(struct ssd_header));
      //send the DATA to the PCIE device
      //use the same hack as on the firmware side - ensure 8-byte alligned
      if(size>8192)
         printk("ERROR - size %d\n", size);
      memcpy(temp_buf, buf, size);
      //for(i=0; i<size; i++) temp_buf[i] = buf[i];
      
      pcie_write(temp_buf, pci_size );
      
      
      // for testing    ---------------------------------
      /*header->lba = htonl(lba);
      header->command = htonl(SSD_HEADER_READ);
      header->size = htonl(size);
      printk("--sending read command: %d bytes to addr %x\n", ntohl(header->size), ntohl(header->lba));
      
      //send the write command to the PCIE device
      pcie_write((char *)header, sizeof(struct ssd_header));
      //send the DATA to the PCIE device
      //use the same hack as on the firmware side - ensure 8-byte alligned
      
      pcie_read(income, pci_size );
      for(i=0; i<size; i=i+4){
         if(*((int *)(income+i)) != *((int *)(buf+i)))
         printk("income[0x%x]: 0x%x --- buf[0x%x]: 0x%x \n", i, *((int *)(income+i)), i, *((int *)(buf+i)));
         }*/
      //--------------------------------------------- 
   }
   
   return 0;
   
}

int wmxssd_pcie_read(char *buf, int size, unsigned int *lba)
{
   struct ssd_header headerh;
   struct ssd_header *header = &headerh;
   int pci_size;
   
   /*
   pci_size = size;
   int i;
   //create the command header
   
   // pci_size = size;
   // if(pci_size % 8)
   //    pci_size += (8 - size %8);
   // if(pci_size % 8)
   //   printk("Will is Retarted \r\n");
   
   //size
   */
   /*if((size%8) != 0) {
   pci_size += (8-(size%8)); // next largest modulo-of-8 size
}

if((size/4) <= MAX_TLP_SIZE){
}
else {
   pci_size += (128-(size%128));
}*/
   if(size>0x2000)
      printk("WHAT???!  ERROR - size %d\n", size);
   else if(size>0x1000)
   {
      wmxssd_pcie_read(buf, 0x1000, lba);
      wmxssd_pcie_read(buf+0x1000, size-0x1000, (unsigned int *)((char *)lba+0x1000));
   }
   else
   {
      pci_size = 0x1000;
      
      header->lba = htonl((int)lba);
      header->command = htonl(SSD_HEADER_READ);
      header->size = htonl(size);
      //printk("--sending read command: %d bytes to addr %x\n", ntohl(header->size), ntohl(header->lba));
      
      //send the read command to the PCIE device
      pcie_write((char *)header, sizeof(struct ssd_header));
      //read the response(data) back
      
      
      pcie_read(temp_buf, pci_size);
      memcpy(buf, temp_buf, size);
      //for(i=0; i<size; i++) buf[i] = temp_buf[i];
      //memcpy( buf, (void *)(((unsigned int )bram_disk | (unsigned int )header->lba)),  header->size);
   }
   
   return 0;
}

int wmxssd_pcie_erase(int size, unsigned int *lba)
{
   struct ssd_header headerh;
   struct ssd_header *header = &headerh;
   
   //create the command header
   header->lba = htonl((int)lba);
   header->command = htonl(NAND_BLOCK_ERASE_CMD);
   header->size = htonl(size);
   //printk("--sending erase command:  addr %x\n", ntohl(header->lba));
   
   //send the erase command to the PCIE device
   pcie_write((char *)header, sizeof(struct ssd_header));
   
   
   return 0;
}


int
pcie_write(char *buf, int size)
{
   volatile char *tmp = (char *)_dma_addr_ptr;
   int i, tlp_sz, tlp_cnt, nsize;
   unsigned long long watchdog=0;
   
   for(i=0; i < size; i++) {
      tmp[i] = buf[i]; // todo: is memcpy safe here?
   }
   
   setup_dma_params(size, &nsize, &tlp_sz, &tlp_cnt);
   setup_read_dma(tlp_sz, tlp_cnt);
   read_dma_start(); // move data from main memory to FPGA
   
   ++__fifowcnt__; // increment local write count
   
   while(__fifowcnt__ != read_ctrl(RX_CNT_OFFSET)) { // spin-wait until FPGA consumes entire DMA payload 
      if(++watchdog > TIMEOUT) {
         printk("timeout\n");
         return 0;
      }
   }
   
   return size;
}


int
pcie_read(char *buf, int size)
{
   unsigned long long watchdog=0;
   volatile char *tmp = (char *)_dma_addr_ptr;
   int i, tlp_sz, tlp_cnt, nsize;
   //unsigned long long watchdog=0;
   
   ++__fiforcnt__; // increment local read count
   
   //printk("waiting.... me:%llx it:%x\n", __fiforcnt__, read_ctrl(TX_CNT_OFFSET));
   while(__fiforcnt__ != read_ctrl(TX_CNT_OFFSET)) {
      //printk("waiting.... me:%llx it:%x\n", __fiforcnt__, read_ctrl(TX_CNT_OFFSET));
      if(++watchdog > TIMEOUT) {
         printk("fiforcnt timeout\n");
         return 0;
      }
   }
   //printk("done waiting.... me:%llx it:%x\n", __fiforcnt__, read_ctrl(TX_CNT_OFFSET));
   
   setup_dma_params(size, &nsize, &tlp_sz, &tlp_cnt);
   setup_write_dma(tlp_sz, tlp_cnt);
   write_dma_start(); // move data from FPGA to main memory
   
 //  printk("waiting for write_dma_done()\n");
   watchdog = 0;
   while(!write_dma_done()) {
      if(++watchdog > TIMEOUT) {
         printk("write dma done timeout\n");
         return 0;
      }
   }
  // printk("write_dma_done()\n");
   
   for(i=0; i < size; i++)
      buf[i] = tmp[i];
   
   return size;
}

//return 0 if pass, 1 if fail
int 
wmxssd_pcie_read_with_verify(char *buf, int size, unsigned int *lba, char *check)
{
   int j;
   
   wmxssd_pcie_read(buf, size, lba);
   
   //verify accuracy of that 4K read
   for(j=0; j<size; j++)
   {
      if(check[j] != buf[j]){
         printk("WMXSSD-READ-TEST:j=%d exp:0x%x%x%x%x act:0x%x%x%x%x --------FAIL\n", j, check[j-3], check[j-2], check[j-1],check[j], buf[j-3], buf[j-2], buf[j-1], buf[j]);
         return 1;
      }
   }
   
   return 0;
}

void test_pcie_ramdisk(void)
{

   unsigned char * ramdisk_writeaddr, tempaddr;
   unsigned int writesize;
   int i;
   int failed = 0;
   int overall_failed = 0;
   int numTestBlocks = 16;
   
   //for varied size test.
   int sizes_to_use[] = {1,2,3,4,5,6,7,8,15,16,31,32,63,64,111,128};
   int num_sizes = 16;
   
//TEST 4k sequential writes
   //write sequential 4K non-overlapping regions, then read them all back and verify
   //write to each byte, so the value at a given location in knownval_buf = its byte number
   for (i=0; i<TESTBUFSIZE; i++)
   {
      //Set each memory address's value equal to the address itself, makes for easy checking
      knownvalue_buffer[i] = i;
   }

   writesize = 0x1000;
   ramdisk_writeaddr = 0x0;

   
   for (i=0; i<numTestBlocks; i++) 
   {
      printk("WMXSSD-TEST:4Kseqblk -- about to write a 4K block. iter:%d\n", i);
      //write 4K to the current address,
      wmxssd_pcie_write((char *)knownvalue_buffer, writesize, (unsigned int *)ramdisk_writeaddr);

      //increment the address -- caste to char * to do byte arithmetic
      ramdisk_writeaddr =  ramdisk_writeaddr + writesize;
   }

   ramdisk_writeaddr = 0x0;
   for (i = 0; i<numTestBlocks; i++)
   {
      printk("WMXSSD-TEST:4Kseqblk -- beginning iter:%d\n", i); 
      //4K back from the current address
      
      ////here
      if( wmxssd_pcie_read_with_verify(test_buffer, writesize, (unsigned int *)ramdisk_writeaddr, knownvalue_buffer) ) {
         failed = 1;
      }

      //increment the address
      ramdisk_writeaddr =  ramdisk_writeaddr + writesize;
      printk("WMXSSD-TEST:4Kseqblk -- verified write at iteration %d\n",i);
   }

   if(failed){
      printk("WMXSSD-TEST:4Kseqblk --FAILED\n\n");
      overall_failed++;
   }
   else
      printk("WMXSSD-TEST:4Kseqblk --PASSED\n\n");

// TEST ERASE -----------------
   //send erase commands to all the same blocks I wrote above.  Then read all those blocks back and verify 
   failed = 0;
   for (i=0; i<TESTBUFSIZE; i++)
   {
      knownvalue_buffer[i] = 0xFF;
   }
   
   ramdisk_writeaddr = 0x0;
   for (i = 0; i<numTestBlocks; i++)
   {
      wmxssd_pcie_erase(writesize, (unsigned int *)ramdisk_writeaddr);
      
      //increment the address
      ramdisk_writeaddr =  ramdisk_writeaddr + writesize;
   }
   
   ramdisk_writeaddr = 0x0;
   for (i = 0; i<numTestBlocks; i++)
   {
      printk("WMXSSD-TEST:4Kseqblkerase -- beginning iter:%d\n", i); 
      //4K back from the current address
      
      ////here
      if( wmxssd_pcie_read_with_verify(test_buffer, writesize, (unsigned int *)ramdisk_writeaddr, knownvalue_buffer) )
      {
         failed = 1;
      }
 
      
      //increment the address
      ramdisk_writeaddr =  ramdisk_writeaddr + writesize;
      printk("WMXSSD-TEST:4Kseqblkerase -- verified write at iteration %d\n",i);
   }
   if(failed) {
      printk("WMXSSD-TEST:4Kseqblkerase --FAILED\n\n");
      overall_failed++;
   }
   else
      printk("WMXSSD-TEST:4Kseqblkerase --PASSED\n\n");
   
   
   //TEST alligned write, varying sized read
   
   failed = 0;
   
   for (i=0; i<TESTBUFSIZE; i++)
   {
      //Set each memory address's value equal to the address itself, makes for easy checking
      knownvalue_buffer[i] = i;
   }
   
   //writes
   ramdisk_writeaddr = 0;
   //write once, one large chunk of known values
      wmxssd_pcie_write(knownvalue_buffer, 1024, (unsigned int*)ramdisk_writeaddr);

      for(i = 0; i<num_sizes; i++)
      {
         if( wmxssd_pcie_read_with_verify(test_buffer, i, (unsigned char *)ramdisk_writeaddr + i, (unsigned char *)knownvalue_buffer + i) )
         {
            printk("WMXSSD-TEST:4Kvarysize --FAILED in size:%d\n", sizes_to_use[i]);
            failed = 1;
         }       
      }
   
   if(failed) {
      printk("WMXSSD-TEST:4Kallilgnedwritevariedread --FAILED\n\n");
      overall_failed++;
   }
   else
      printk("WMXSSD-TEST:4Kallilgnedwritevariedread --PASSED\n\n");
   
   
   
   
   /*
   //TEST varied write, alligned read
   
   failed = 0;
   
   for (i=0; i<TESTBUFSIZE; i++)
   {
      //Set each memory address's value equal to the address itself, makes for easy checking
      knownvalue_buffer[i] = i;
   }
   
   //writes
   ramdisk_writeaddr = 0;
   //write once, one large chunk of known values
 //  wmxssd_pcie_write(knownvalue_buffer, 1024, (unsigned int*)ramdisk_writeaddr);
   tempaddr = knownvalue_buffer;
   for(i = 1; i<num_sizes; i++)
   {  
    
    wmxssd_pcie_write(tempaddr, i, (unsigned char*)ramdisk_writeaddr);
    tempaddr += i;
    ramdisk_writeaddr += i;
    
   }
   ramdisk_writeaddr = 0;
   if( wmxssd_pcie_read_with_verify(test_buffer, 16, (unsigned char *)ramdisk_writeaddr, (unsigned char *)knownvalue_buffer) )
    {
         printk("WMXSSD-TEST:4Kvarysize --FAILED in size:%d\n", sizes_to_use[i]);
         failed = 1;
    }    
   
   
   if(failed) {
      printk("WMXSSD-TEST:4kvariedwriteAllignedread --FAILED\n\n");
      overall_failed++;
   }
   else
      printk("WMXSSD-TEST:4kvariedwriteAllignedread  --PASSED\n\n");
   */
   
   
   
   
//TEST varying sized writes   
      failed = 0;

      for (i=0; i<TESTBUFSIZE; i++)
      {
         //Set each memory address's value equal to the address itself, makes for easy checking
         knownvalue_buffer[i] = i;
      }
      
      //writes
      ramdisk_writeaddr = 0;
      for(i = 0; i<num_sizes; i++)
      {
         wmxssd_pcie_write(knownvalue_buffer, sizes_to_use[i], (unsigned int*)ramdisk_writeaddr);
         ramdisk_writeaddr += sizes_to_use[i];
      }
      
    
      //reads 
      ramdisk_writeaddr = 0;
      for(i = 0; i<num_sizes; i++)
      {
         if( wmxssd_pcie_read_with_verify(test_buffer, sizes_to_use[i], (unsigned int *)ramdisk_writeaddr, knownvalue_buffer) )
         {
            printk("WMXSSD-TEST:4Kvarysize --FAILED in size:%d\n", sizes_to_use[i]);
            failed = 1;
         }

         ramdisk_writeaddr += sizes_to_use[i];
      }

      if(failed) {
         printk("WMXSSD-TEST:4Kvarysize --FAILED\n\n");
         overall_failed++;
      }
      else
         printk("WMXSSD-TEST:4Kvarysize --PASSED\n\n");
      
//TEST overlapping writes
      failed = 0;

      

      if(overall_failed) 
         printk("WMXSSD-TEST:OVERALL --FAILED %d\n\n", overall_failed);
      else
         printk("WMXSSD-TEST:OVERALL --PASSED\n\n");
}

static void
sync_pcie(void)
{
   //char data[8192];
   char syncbyte = 0x69;

   printk("Performing 1 byte DMA sync - sent 0x%x\n",syncbyte);

   //((void **)data)[0] = (void *)htonl(0xdeadbeef);

   //sync write
   pcie_write(&syncbyte,1);
   printk("Sync done\n");
}

int
open_pcie(void)
{
   /*
   * Base address 0 for the PCI express endpoint device on the FPGA
   */ 
   
   _bar0 = sc_vbar0;
   
   /*
   * The virtual address of kernel memory allocated for the 8kB DMA buffer
   */ 
   
   _dma_addr_ptr = (unsigned int *)dma_buf;
   /*
   * <begin_hack>The first 4 bytes of the 8kB DMA buffer contains the physical address of the DMA buffer.
   * We grab the physical address to initialize the PCI express endpoint block on the FPGA. </end_hack>
   */
   
   _dma_addr = virt_to_phys(dma_buf);
   if(1) printk("DMA physical address: 0x%x\n", _dma_addr);
   
   /*
   * Initialize DMA base registers 
   */
   
   read_dma_addr(_dma_addr);
   write_dma_addr(_dma_addr);
   
   /*
   * Read current state of TX/RX counters from FPGA
   * These are used to synchronize between PC/FPGA
   */ 
   
   __fifowcnt__ = read_ctrl(RX_CNT_OFFSET);
   __fiforcnt__ = read_ctrl(TX_CNT_OFFSET);
   
   return 0;
}


void
close_pcie(void)
{
   printk("close_pcie called\n");
}



int ssd_init(void) {
   printk("SSD_DEVICE: ssd_init()\n");

   //sets up PCIe comm in ssd_pci.c, shared via global in hdr
   xupv5_module_init();

      
   if(open_pcie() < 0) {
      printk("Error, unable to open PCI express\n");
      return -1;
   }
   //just sends a byte over PCIe to get the connection to work
   sync_pcie();

   //Run a test
     test_pcie_ramdisk();

   return 0;
}

void ssd_cleanup(void) {
   printk("SSD_DEVICE: ssd_cleanup()\n");
   close_pcie();
   xupv5_module_cleanup();
}

//module_init(ssd_init);
//module_exit(ssd_cleanup);
