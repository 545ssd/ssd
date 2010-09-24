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
#define MTDRAM_WRITE_SIZE (16)
#define MTDRAM_OOB_SIZE (218)


#ifdef MODULE
module_param(total_size, ulong, 0);
MODULE_PARM_DESC(total_size, "Total device size in KiB");
module_param(erase_size, ulong, 0);
MODULE_PARM_DESC(erase_size, "Device erase block size in KiB");
#endif




// We could store these in the mtd structure, but we only support 1 device..
static struct mtd_info *mtd_info;

static int nand_erase(struct mtd_info *mtd, struct erase_info *instr)
{

   //printk("WMXSSD: nand_erase called\r\n");
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

static int nand_read(struct mtd_info *mtd, loff_t from, size_t len,
		size_t *retlen, u_char *buf)
{
   // printk("WMXSSD: nand_read called\r\n");
   if (from + len > mtd->size)
      return -EINVAL;

   wmxssd_pcie_read(buf, (int)len, (unsigned int *)from);

   *retlen = len;
   return 0;
}

static int nand_read_oob(struct mtd_info *mtd, loff_t from,
          struct mtd_oob_ops *ops)
{
   int ret = -ENOTSUPP;
   ops->retlen = 0;
   ops->retooblen = 0;

   // printk("WMXSSD: nand_read called\r\n");
   if (ops->datbuf && (from + ops->len) > mtd->size)
      return -EINVAL;

   if (!ops->datbuf) //just read oob only
      ret = wmxssd_pcie_read(buf, ops->ooblen, (unsigned int *)((char *)from+ops->ooboffs));
   else //read data and/or oob (not just oob though)
   {
      //TODO:might be missing a bounds check

      //read data
      ret = wmxssd_pcie_read(buf, ops->len, (unsigned int *)from);

      //maybe read oob
      if(ops->mode == MTD_OOB_PLACE)
         ret = ret | wmxssd_pcie_read(buf, ops->ooblen, (unsigned int *)((char *)from+ops->ooboffs));
   }

   ops->retlen = ops->len;
   ops->retooblen = ops->ooblen;

   return ret;
}

static int nand_write(struct mtd_info *mtd, loff_t to, size_t len,
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

static int nand_write_oob(struct mtd_info *mtd, loff_t to,
           struct mtd_oob_ops *ops)
{
   int ret = -ENOTSUPP;
   ops->retlen = 0;
   ops->retooblen = 0;

   // printk("WMXSSD: nand_read called\r\n");
   if (ops->datbuf && (from + ops->len) > mtd->size)
      return -EINVAL;

   if (!ops->datbuf) //just write oob only
      ret = wmxssd_pcie_write(buf, ops->ooblen, (unsigned int *)((char *)to+ops->ooboffs));
   else //write data and/or oob (not just oob though)
   {
      //TODO:might be missing a bounds check

      //write data
      ret = wmxssd_pcie_write(buf, ops->len, (unsigned int *)to);

      //maybe write oob
      if(ops->mode == MTD_OOB_PLACE)
         ret = ret | wmxssd_pcie_write(buf, ops->ooblen, (unsigned int *)((char *)to+ops->ooboffs));
   }

   ops->retlen = ops->len;
   ops->retooblen = ops->ooblen;

   return ret;
}

static int nand_block_isbad(struct mtd_info *mtd, loff_t offs)
{
   /* Check for invalid offset */
   if (offs > mtd->size)
      return -EINVAL;

   //TODO:get block by modding with offset

   //TODO:read bad block bit

   //TODO:return answer
   return 0;
}

static int nand_block_markbad(struct mtd_info *mtd, loff_t ofs)
{
   int ret;

   if ( nand_block_isbad(mtd, ofs) ) {
      /* If it was bad already, return success and do nothing. */
      if (ret > 0)
         return 0;
   }
   else {
      //TODO: write to mark it as bad by writting to oob
   }

   return 0;
}

static int nand_block_isbad(struct mtd_info *mtd, loff_t offs)
{
   /* Check for invalid offset */
   if (offs > mtd->size)
      return -EINVAL;

   //TODO:get block by modding with offset

   //TODO:read bad block bit

   //TODO:return answer
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

static int nand_suspend(struct mtd_info *mtd)
{
   //TODO: do something maybe
}

static void nand_resume(struct mtd_info *mtd)
{
   //TODO: do something maybe
}

static void nand_sync(struct mtd_info *mtd)
{
   //TODO: make a new command that will let you wait for read RB from the nand
//    while(!new_command) {
//       sleep(10);
//    }
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
   mtd->type = MTD_NANDFLASH;
   mtd->flags = MTD_CAP_NANDFLASH;
   mtd->size = size;
   mtd->writesize = MTDRAM_WRITE_SIZE;
   mtd->erasesize = MTDRAM_ERASE_SIZE;
   mtd->oobsize = MTDRAM_OOB_SIZE;
   mtd->priv = mapped_address;
   //mtd->writesize_shift = 5;
   //mtd->writesize_mask = 63;

   mtd->owner = THIS_MODULE;
   mtd->erase = nand_erase;
   mtd->point = NULL;
   mtd->unpoint = NULL;
   mtd->get_unmapped_area = ram_get_unmapped_area;//TODO can we get rid of this?
   mtd->read = nand_read;
   mtd->write = nand_write;

   /* Fill in remaining MTD driver data */
   mtd->read_oob = nand_read_oob;
   mtd->write_oob = nand_write_oob;
   mtd->sync = nand_sync;
   mtd->lock = NULL;
   mtd->unlock = NULL;
   mtd->suspend = nand_suspend;
   mtd->resume = nand_resume;
   mtd->block_isbad = nand_block_isbad;
   mtd->block_markbad = nand_block_markbad;

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
