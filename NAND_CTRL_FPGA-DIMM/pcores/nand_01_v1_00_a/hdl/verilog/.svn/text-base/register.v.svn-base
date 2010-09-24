module register (C, CLR, CE, D, Q);
parameter width = 1;

input C, CLR, CE;
input	[width-1:0] D;
output	[width-1:0] Q;
reg		[width-1:0] tmp;


	always @(posedge C)
		begin
			if (CLR)
				tmp <= 0;
			else
				if (CE)
					tmp <= D;
				else
					tmp <= tmp;
		end
	assign Q = tmp;

endmodule
