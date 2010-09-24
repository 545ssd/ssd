
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/mm.h>
#include <linux/pci.h>
#include <linux/cdev.h>
#include <linux/fs.h>

#include <linux/time.h>
#include <linux/unistd.h>


//#include "ssd_pci.h"
#include <linux/mtd/ssd_pci.h>
char *dma_buf = 0;
char *sc_vbar0 = 0; 

/*
 * This is temporary solution until I lock this driver properly
 */
unsigned long		dev_addr = 0;

/*
 * Character device structure.
 */
static struct cdev	xupv5_cdev;
static dev_t		xupv5_dev;


// absolute time from epoch (in microseconds)
unsigned long long
get_us(void)
{
  struct timeval tval;
  do_gettimeofday(&tval);
  return (unsigned long long)(tval.tv_sec*1000000ull)
        +(unsigned long long)(tval.tv_usec);
}

irqreturn_t
xupv5_irq_handler(int irq, void *dev_id)
{
	struct xupv5_sc *sc;

	XC_DEBUG("IRQ Handling called!");
	sc = dev_id;
	if (sc == NULL)
		return (IRQ_NONE);
	XC_DEBUG("Interrupt handled");
	return (IRQ_HANDLED);	
}



int
xupv5_probe(struct pci_dev *dev, const struct pci_device_id *id)
{
	struct xupv5_sc *sc;
	int error;
	char name[16];
	char *c;

	error = pci_enable_device(dev);
	if (error < 0) {
		XC_DEBUG("pci_enable_device returned %d", error);
		return (-ENODEV);
	}

	sc = kzalloc(sizeof(*sc), GFP_KERNEL);
	if (sc == NULL) {
		XC_DEBUG("Not enough memory to allocate sc");
		pci_disable_device(dev);
		return (-ENOMEM);
	}
	memset(sc, 0, sizeof(*sc));
	snprintf(sc->name, sizeof(sc->name), "%s%d", pci_name(dev), 0);

	error = pci_request_regions(dev, name);
	if (error < 0) {
		XC_DEBUG("pci_request_regions returned %d", error);
		pci_disable_device(dev);
		kfree(sc);
		return (-ENODEV);
	}

	/*
	 * WK: No error checking...
	 */
	sc->bar0_len = pci_resource_len(dev, 0);
	XC_DEBUG(" BAR0 length: %d", sc->bar0_len);
	sc->bar0_addr = pci_resource_start(dev, 0);
	XC_DEBUG("BAR0 physical address: %lx", sc->bar0_addr);
	dev_addr = sc->bar0_addr;
	sc->bar0 = ioremap_nocache(sc->bar0_addr, sc->bar0_len);
	sc_vbar0 = sc->bar0;
	XC_DEBUG("   BAR0 virtual address: %p(%x)", sc->bar0, virt_to_phys(sc->bar0));

	error = request_irq(dev->irq, xupv5_irq_handler, IRQF_SHARED, sc->name, sc);
	if (error != 0) {
		XC_DEBUG("Unable to get the interrupt");
		pci_disable_device(dev);
		kfree(sc);
		return -ENOMEM;
	}
	sc->irq = dev->irq;
	XC_DEBUG("Registered interrupt %d\n", sc->irq);

	c = (char *)sc->bar0;

#if 0
	*c |= 1;
	msleep(300);
	*c &= ~1;
	msleep(300);
	*c |= 1;

	c += 4;
	*c = ~(*c);
#endif

	pci_set_drvdata(dev, sc); XC_DEBUG("Probe completed");
	return (0);
}

void
xupv5_remove(struct pci_dev *dev)
{
	struct xupv5_sc *sc;

	XC_DEBUG("Releasing device's resources");
	sc = pci_get_drvdata(dev);
	if (sc == NULL) {
		XC_DEBUG("sc shouldn't be NULL here");
		return;
	}

	if (sc->bar0) {
		XC_DEBUG("Unmapping %p", sc->bar0);
		iounmap(sc->bar0);
	}

	if (sc->irq >= 0) {
		XC_DEBUG("Freeing IRQ: %d", sc->irq);
		free_irq(sc->irq, sc);
	}

	pci_release_regions(dev);
	pci_disable_device(dev);
	
	kfree(sc);
	pci_set_drvdata(dev, NULL);
	XC_DEBUG("Device detached");
}


static struct pci_device_id xupv5_ids[] = {
	{ PCI_DEVICE(XILINX_VID, XILINX_DID) },
	{ 0 },
};
MODULE_DEVICE_TABLE(pci, xupv5_ids);

struct pci_driver xupv5_driver = {
	.name = "xupv5_pcird",
	.id_table = xupv5_ids,
	.probe = xupv5_probe,
	.remove = xupv5_remove,
};

int
xc_open(struct inode *inode, struct file *file)
{

	XC_DEBUG("Called");
	return (0);
}

int
xc_release(struct inode *inode, struct file *file)
{

	XC_DEBUG("Called");
	return (0);
}

int
xc_mmap(struct file *file, struct vm_area_struct *vma)
{
	unsigned long msz;
	int error;
	unsigned int *phys_addr;

	msz = 0;
	error = 0;
	XC_DEBUG("VMA start\t%lx", vma->vm_start);
	XC_DEBUG("VMA end\t%lx", vma->vm_end);
	XC_DEBUG("VMA pgoff\t%lx", vma->vm_pgoff);

	/*
	 * Check if the request from the user's mmap() call
	 * fulfills requirements from of this driver. (we
	 * can only map 8192 bytes)
	 */
	msz = vma->vm_end - vma->vm_start;
	if (msz != 8192) {
		XC_DEBUG("You wanted to mmap() %ld bytes, but only 8192 is"
		    "allowed", msz);
		return (-EINVAL);
	}

	if(vma->vm_pgoff == 0) {
		XC_DEBUG("Offset 0 in mmap, allocating control registers\n"); 
		/*
		 * Protection.
		 */
		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);

		/* Remap-pfn-range will mark the range VM_IO and VM_RESERVED */
		error = remap_pfn_range(vma, vma->vm_start, dev_addr >> PAGE_SHIFT, 8192, /* vma->vm_page_prot */PAGE_SHARED);
		if (error != 0) {
			XC_DEBUG("Couldn't get memory remapped, error = %d", error);
			return -EAGAIN;
		}
	}
	else if(vma->vm_pgoff == 2) {
		XC_DEBUG("Offset 2 in mmap, allocating physical memory\n"); 
		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
		error = remap_pfn_range(vma, vma->vm_start, (long int)(virt_to_phys(dma_buf)) >> PAGE_SHIFT, 8192, /* vma->vm_page_prot */PAGE_SHARED);
		if (error != 0) {
			XC_DEBUG("Couldn't get physical memory remapped, error = %d", error);
			return -EAGAIN;
		}
		
		phys_addr = (unsigned int *)dma_buf;
		*phys_addr = virt_to_phys(dma_buf);
		printk("Phys address of DMA buf: %x\n", (unsigned int)virt_to_phys(dma_buf));
	}
	else {
		XC_DEBUG("Unhandled offset\n");
	}

	return (0);
}

static const struct file_operations xupv5_fops = {
	.owner		= THIS_MODULE,
	.open		= xc_open,
	.release	= xc_release,
	.mmap		= xc_mmap,
};

int
xupv5_module_init(void)
{
	int error;
	int major;

	error = 0;
	major = 0;
	XC_DEBUG("Initialization");
	error = pci_register_driver(&xupv5_driver);
	if (error != 0) {
		XC_DEBUG("pci_module_register returned %d", error);
		return (error);
	}

	error = alloc_chrdev_region(&xupv5_dev, 0, 1, "xupv5");
	if (error != 0) {
		XC_DEBUG("alloc_chrdev_region() returned %d", error);
		return (error);
	}

	cdev_init(&xupv5_cdev, &xupv5_fops);
	error = cdev_add(&xupv5_cdev, xupv5_dev, 1);
	if (error != 0) {
		XC_DEBUG("cdev_add() returned %d", error);
		return (error);
	}


	dma_buf = kmalloc(8192, GFP_KERNEL);

	if(!dma_buf) {
		XC_DEBUG("Unable to kmalloc 8192 Bytes\n");
		return -1;
	}

	return (0);
}

void
xupv5_module_cleanup(void)
{

	XC_DEBUG("destruction");
	pci_unregister_driver(&xupv5_driver);
	unregister_chrdev_region(xupv5_dev, 1); 

	if(dma_buf)
		kfree(dma_buf);
}

/*
module_init(xupv5_module_init);
module_exit(xupv5_module_cleanup);
*/
