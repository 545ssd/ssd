/*
 * mtdram - a test mtd device
 * Author: Alexander Larsson <alex@cendio.se>
 *
 * Copyright (c) 1999 Alexander Larsson <alex@cendio.se>
 * Copyright (c) 2005 Joern Engel <joern@wh.fh-wedel.de>
 *
 * This code is GPL
 *
 */

#include <linux/module.h>
#include <linux/slab.h>
#include <linux/ioport.h>
#include <linux/vmalloc.h>
#include <linux/init.h>
#include <linux/mtd/compatmac.h>
#include <linux/mtd/mtd.h>
#include <linux/mtd/mtdram.h>

#include <linux/mtd/wmxssd_pcie.h>  // our PCIe device access
#include <linux/mtd/ssd_pci.h> 	//the low level interface to XUPV5 PCIe

//hack to keep compiler happy - default #'s from MTDRAM 
//#define CONFIG_MTDRAM_TOTAL_SIZE 4096
//#define CONFIG_MTDRAM_ERASE_SIZE 128
//#define CONFIG_MTDRAM_WRITE_SIZE 8

static unsigned long total_size = CONFIG_MTDRAM_TOTAL_SIZE;
static unsigned long erase_size = CONFIG_MTDRAM_ERASE_SIZE;
#define MTDRAM_TOTAL_SIZE (32*1024*1024)
#define MTDRAM_ERASE_SIZE (8 * 1024)
#define MTDRAM_WRITE_SIZE (16 )


#ifdef MODULE
module_param(total_size, ulong, 0);
MODULE_PARM_DESC(total_size, "Total device size in KiB");
module_param(erase_size, ulong, 0);
MODULE_PARM_DESC(erase_size, "Device erase block size in KiB");
#endif




// We could store these in the mtd structure, but we only support 1 device..
static struct mtd_info *mtd_info;

static int ram_erase(struct mtd_info *mtd, struct erase_info *instr)
{

//	printk("WMXSSD: ram_erase called\r\n");
	//printk("Erase size = %d\r\n", (int)instr->len);

	if (instr->addr + instr->len > mtd->size)
		return -EINVAL;

	//memset((char *)mtd->priv + instr->addr, 0xff, instr->len);
	
	wmxssd_pcie_erase((int)instr->len, (unsigned int *)instr->addr);
	
	instr->state = MTD_ERASE_DONE;
	mtd_erase_callback(instr);

	return 0;
}


/*
  ram_point - taken from mtdram.c

    returns an address directly to the memory
  obviously wont work over pcie; need to get rid of it
      -Will

*/
/*static int ram_point(struct mtd_info *mtd, loff_t from, size_t len,
		size_t *retlen, void **virt, resource_size_t *phys)
{
	int *killptr = 0x0;

	 printk("WMXSSD: ram_point called\r\n");
	//make this function crash the kernel, just so i'm convinced nobody is calling it
	 *killptr ;


	if (from + len > mtd->size)
		return -EINVAL;

	// can we return a physical address with this driver? 
	if (phys)
		return -EINVAL;

	*virt = mtd->priv + from;
	*retlen = len;
      
	

  
	return 0;
}*/

/*
  ram_unpoint - taken from mtdram.c
  
  it was empty when I got it - so ill leave it alone
    -will
*/
/*static void ram_unpoint(struct mtd_info *mtd, loff_t from, size_t len)
{
}*/

/*
 * Allow NOMMU mmap() to directly map the device (if not NULL)
 * - return the address to which the offset maps
 * - return -ENOSYS to indicate refusal to do the mapping
 */
static unsigned long ram_get_unmapped_area(struct mtd_info *mtd,
					   unsigned long len,
					   unsigned long offset,
					   unsigned long flags)
{
	return (unsigned long) mtd->priv + offset;
}

static int ram_read(struct mtd_info *mtd, loff_t from, size_t len,
		size_t *retlen, u_char *buf)
{
     
  
     // printk("WMXSSD: ram_read called\r\n");

	if (from + len > mtd->size)
		return -EINVAL;

	//memcpy(buf, mtd->priv + from, len);
         wmxssd_pcie_read(buf, (int)len, (unsigned int *)from);

	*retlen = len;
	return 0;
}

static int ram_write(struct mtd_info *mtd, loff_t to, size_t len,
		size_t *retlen, const u_char *buf)
{
	char *dummy_buf = 0x0;
	int dummy_size = 0x0;
  
	//printk("WMXSSD: ram_write called\r\n");
	 


  
	if (to + len > mtd->size)
		return -EINVAL;

	//memcpy((char *)mtd->priv + to, buf, len);
	wmxssd_pcie_write(buf, (int)len, (unsigned int *)to);


	*retlen = len;
	return 0;
}

static void __exit cleanup_mtdram(void)
{
      // close_pcie();
      ssd_cleanup();
	if (mtd_info) {
		del_mtd_device(mtd_info);
		vfree(mtd_info->priv);
		kfree(mtd_info);
	}
}

int mtdram_init_device(struct mtd_info *mtd, void *mapped_address,
		unsigned long size, char *name)
{
	memset(mtd, 0, sizeof(*mtd));

        printk("WMXSSD mtdram_init_device called\r\n");
    
	//open_pcie();
        ssd_init();


	/* Setup the MTD structure */
	mtd->name = name;
	//mtd->type = MTD_NANDFLASH;
	mtd->type = MTD_RAM;
	//mtd->flags = MTD_CAP_RAM; 
	mtd->flags = (MTD_WRITEABLE);
	mtd->size = size;
	mtd->writesize = MTDRAM_WRITE_SIZE;
	mtd->erasesize = MTDRAM_ERASE_SIZE;
	mtd->priv = mapped_address;
	//mtd->writesize_shift = 5;
	//mtd->writesize_mask = 63;

	mtd->owner = THIS_MODULE;
	mtd->erase = ram_erase;
	//mtd->point = ram_point;
	//mtd->unpoint = ram_unpoint;
	mtd->get_unmapped_area = ram_get_unmapped_area;//TODO can we get rid of this?
	mtd->read = ram_read;
	mtd->write = ram_write;

	if (add_mtd_device(mtd)) {
		return -EIO;
	}

	return 0;
}

static int __init init_mtdram(void)
{
	void *addr;
	int err;

	if (!total_size)
		return -EINVAL;

	/* Allocate some memory */
	mtd_info = kmalloc(sizeof(struct mtd_info), GFP_KERNEL);
	if (!mtd_info)
		return -ENOMEM;
   //TODO get rid of this vmalloc
	addr = vmalloc(MTDRAM_TOTAL_SIZE);
	if (!addr) {
		kfree(mtd_info);
		mtd_info = NULL;
		return -ENOMEM;
 	}
	err = mtdram_init_device(mtd_info, addr, MTDRAM_TOTAL_SIZE, "WMXSSD");
	if (err) {
		//vfree(addr);
		kfree(mtd_info);
		mtd_info = NULL;
		return err;
	}

   //TODO - should we put an erase here to make sure all bytes are FF?
	//memset(mtd_info->priv, 0xff, MTDRAM_TOTAL_SIZE);
	return err;
}

module_init(init_mtdram);
module_exit(cleanup_mtdram);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("WMX");
MODULE_DESCRIPTION("WMX SSD linux driver");
