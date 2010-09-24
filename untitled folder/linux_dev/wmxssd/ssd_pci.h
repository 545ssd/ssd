#ifndef __SSD_PCI_H
#define __SSD_PCI_H

#define XC_DEBUG(...)					\
	do {						\
		printk("%s(%d): ", __func__, __LINE__);	\
		printk(__VA_ARGS__);			\
		printk("\n");				\
	} while (0)

/*
 * Xilinx's Vendor and Device ID 
 */
//#define	XILINX_VID	0x10ee
//#define	XILINX_DID	0x5050

#define	XILINX_VID	0x10ee
#define	XILINX_DID	0x0007

#include <linux/interrupt.h> // for irqreturn_t

//extern declarations??
extern char *dma_buf;
extern char *sc_vbar0; 
// [END] extern declarations


struct xupv5_sc {
	// Interrupt number
	int irq;

	// Pointer to the BAR0 address.
	void __iomem	*bar0;

	//Address of the BAR0 region.
	unsigned long	 bar0_addr;

	unsigned int	 bar0_len;

	//Device name
	char		 name[16];
};

// function prototypes
unsigned long long get_us(void);
	// pci driver functions
irqreturn_t xupv5_irq_handler(int irq, void *dev_id);
int xupv5_probe(struct pci_dev *dev, const struct pci_device_id *id);
void xupv5_remove(struct pci_dev *dev);
	// pci file ops
int xc_open(struct inode *inode, struct file *file);
int xc_release(struct inode *inode, struct file *file);
int xc_mmap(struct file *file, struct vm_area_struct *vma);
	// module
int xupv5_module_init(void);
void xupv5_module_cleanup(void);

// [END] function prototypes

#endif /* __SSD_PCI_H */
