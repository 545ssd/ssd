/*
Parameters for Nand Controller FSM
Will Constable (wconstab)
April 2010
*/

//FSMTIMER///////////////////////////////////

/*Timer Values calculated on spreadsheet accessible here:
https://spreadsheets.google.com/ccc?key=0AuPgSeOMSrjzdHVCSmVDUl9kcE5vUXA0ckJ1MGZwY3c&hl=en
*/


`define FSM_TIMER_20NS 0
`define FSM_TIMER_100US 9998
`define FSM_TIMER_1US 98
`define FSM_TIMER_1MS 99998

`define FSM_TIMER_60NS 4
`define FSM_TIMER_70NS 5
`define FSM_TIMER_120NS 10
`define FSM_TIMER_10NS_NOTIMER -1



//FSM States/////////////////////////////////
`define S_INVALID 0

`define STATE_WAIT_FOR_CMD 10

`define STATE_RESET1 12
`define STATE_RESET2 13
`define STATE_RESET3 14

`define STATE_READ_ID1 18
`define STATE_READ_ID2 19
`define STATE_READ_ID3 20
`define STATE_READ_ID4 21
`define STATE_READ_ID5 22

/*`define STATE_READ_ID5_1 50  SEE BELOW, keep numbers in order*/
`define STATE_READ_ID6 23
`define STATE_READ_ID7 24
`define STATE_READ_ID8 25
`define STATE_READ_ID9 26
`define STATE_READ_ID10 27
`define STATE_READ_ID11 28
`define STATE_READ_ID12 29
`define STATE_READ_ID13 30
`define STATE_READ_ID14 31
`define STATE_READ_ID15 32
`define STATE_READ_ID16 33

`define STATE_GET_FEATURES1 34
`define STATE_GET_FEATURES2 35
`define STATE_GET_FEATURES3 36
`define STATE_GET_FEATURES4 37
`define STATE_GET_FEATURES5 38
`define STATE_GET_FEATURES6 39
`define STATE_GET_FEATURES7 40 
`define STATE_GET_FEATURES8 41
`define STATE_GET_FEATURES9 42
`define STATE_GET_FEATURES10 43
`define STATE_GET_FEATURES11 44
`define STATE_GET_FEATURES12 45
`define STATE_GET_FEATURES13 46
`define STATE_GET_FEATURES14 47
`define STATE_GET_FEATURES15 48
`define STATE_GET_FEATURES16 49

`define STATE_READ_ID5_1 50

`define STATE_TEST_BYTE_OUT1 60
`define STATE_TEST_BYTE_OUT2 61
`define STATE_TEST_BYTE_OUT3 62
`define STATE_TEST_BYTE_OUT4 63
//IO BUS DIRECTION//////////////////////////
`define IO_OUT 0
`define IO_IN 1

//STATUS_REG
`define NAND_CMD_DONE 1
`define NAND_BUSY 2
`define NAND_DATA_BUF_FULL 4