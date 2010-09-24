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
`define FSM_TIMER_100US 4999
`define FSM_TIMER_1MS 49999



//FSM States/////////////////////////////////
`define S_INVALID 0
`define S1_PWRUP1 10
`define S2_PWRUP2 11
`define S3_RESET1 12
`define S4_RESET2 13
`define S5_RESET3 14

//IO BUS DIRECTION//////////////////////////
`define IO_OUT 0
`define IO_IN 1