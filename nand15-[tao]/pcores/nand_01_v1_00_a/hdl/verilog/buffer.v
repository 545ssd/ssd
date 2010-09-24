module buffer (C, we, addr, D, Q);

input C, we;
input		[0:10] addr;
input		[0:31] D;
output	[0:31] Q;

reg			[0:10] laddr;

//synthesis attribute ram_style of mem is block
reg			[0:31] mem [0:2047];

	always @(posedge C)
	begin
		if (we)
			mem[addr] <= D;
		laddr <= addr;
	end
	assign Q = mem[laddr];

endmodule
