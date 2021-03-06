library verilog;
use verilog.vl_types.all;
entity nand_model is
    generic(
        tADL_min        : integer := 70;
        tALH_min        : integer := 5;
        tALS_min        : integer := 10;
        tCH_min         : integer := 5;
        tCLH_min        : integer := 5;
        tCLS_min        : integer := 10;
        tCS_min         : integer := 15;
        tDH_min         : integer := 5;
        tDS_min         : integer := 7;
        tWC_min         : integer := 20;
        tWH_min         : integer := 7;
        tWP_min         : integer := 10;
        tWW_min         : integer := 30;
        tAR_min         : integer := 10;
        tCCS_min        : integer := 70;
        tCLR_min        : integer := 10;
        tCOH_min        : integer := 15;
        tIR_min         : integer := 0;
        tOH_min         : integer := 15;
        tRC_min         : integer := 25;
        tREH_min        : integer := 7;
        tRHOH_min       : integer := 15;
        tRHW_min        : integer := 100;
        tRLOH_min       : integer := 5;
        tRP_min         : integer := 10;
        tRR_min         : integer := 20;
        tWHR_min        : integer := 60;
        tEDO_RC         : integer := 30;
        tCEA_max        : integer := 25;
        tCEA_cache_max  : integer := 25;
        tCHZ_max        : integer := 30;
        tCHZ_cache_max  : integer := 30;
        tDCBSYR1_max    : integer := 5000;
        tR_max          : integer := 25000;
        tREA_max        : integer := 16;
        tREA_cache_max  : integer := 16;
        tRHZ_max        : integer := 100;
        tRST_read       : integer := 5000;
        tRST_prog       : integer := 10000;
        tRST_erase      : integer := 500000;
        tRST_powerup    : integer := 1000000;
        tRST_ready      : integer := 5000;
        tWB_max         : integer := 100;
        tVCC_delay      : integer := 10000;
        tRB_PU_max      : integer := 100000;
        tBERS_min       : integer := 700000;
        tBERS_max       : integer := 3000000;
        tCBSY_min       : integer := 20000;
        tCBSY_max       : integer := 700000;
        tDBSY_min       : integer := 500;
        tDBSY_max       : integer := 1000;
        tFEAT           : integer := 1000;
        tPROG_typ       : integer := 250000;
        tPROG_max       : integer := 700000;
        tOBSY_max       : integer := 25000;
        NPP             : integer := 4;
        tCLHIO_min      : integer := 0;
        tCLSIO_min      : integer := 0;
        tDHIO_min       : integer := 0;
        tDSIO_min       : integer := 0;
        tREAIO_max      : integer := 0;
        tRPIO_min       : integer := 0;
        tWCIO_min       : integer := 0;
        tWHIO_min       : integer := 0;
        tWHRIO_min      : integer := 0;
        tWPIO_min       : integer := 0;
        tLBSY_min       : integer := 0;
        tLBSY_max       : integer := 0;
        PAGE_BITS       : integer := 6;
        COL_BITS        : integer := 13;
        COL_CNT_BITS    : integer := 13;
        DQ_BITS         : integer := 8;
        NUM_OTP_ROW     : integer := 10;
        OTP_NPP         : integer := 4;
        NUM_BOOT_BLOCKS : integer := 0;
        BOOT_BLOCK_BITS : integer := 1;
        ROW_BITS        : integer := 18;
        LUN_BITS        : integer := 0;
        BLCK_BITS       : integer := 12;
        NUM_ROW         : integer := 256;
        NUM_PAGE        : integer := 64;
        NUM_COL         : integer := 4314;
        NUM_PLANES      : integer := 2;
        BPC_MAX         : integer := 1;
        BPC             : integer := 1;
        NUM_ID_BYTES    : integer := 5;
        READ_ID_BYTE0   : integer := 44;
        READ_ID_BYTE1   : integer := 211;
        READ_ID_BYTE2   : integer := 144;
        READ_ID_BYTE4   : integer := 100;
        READ_ID_BYTE3   : integer := 46;
        FEATURE_SET     : integer := 639;
        FEATURE_SET2    : integer := 0;
        DRIVESTR_EN     : integer := 1;
        NOONFIRDCACHERANDEN: integer := 0;
        NUM_DIE         : integer := 2;
        NUM_CE          : integer := 2;
        async_only_n    : integer := 0;
        MAX_LUN_PER_TAR : integer := 2
    );
    port(
        Ce2_n           : in     vl_logic;
        Rb2_n           : out    vl_logic;
        Dq_Io           : inout  vl_logic_vector;
        Cle             : in     vl_logic;
        Ale             : in     vl_logic;
        Clk_We_n        : in     vl_logic;
        Wr_Re_n         : in     vl_logic;
        Ce_n            : in     vl_logic;
        Wp_n            : in     vl_logic;
        Rb_n            : out    vl_logic
    );
end nand_model;
