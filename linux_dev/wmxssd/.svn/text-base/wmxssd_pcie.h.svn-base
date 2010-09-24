#ifndef _WMXSSD_PCIE_H
#define _WMXSSD_PCIE_H



int ssd_init(void);

void ssd_cleanup(void);

int pcie_write(char *buf, int size);

int pcie_read(char *buf, int size);

int wmxssd_pcie_write(char *buf, int size, unsigned int *lba);

int wmxssd_pcie_read(char *buf, int size, unsigned int *lba);

int wmxssd_pcie_erase(int size, unsigned int *lba);

#endif //_WMXSSD_PCIE_H