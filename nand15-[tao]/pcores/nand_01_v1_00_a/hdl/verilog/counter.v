module counter (C, CLR, CE, CE4, Q);
parameter width = 1;

input C, CLR, CE, CE4;
output	[width-1:0] Q;
reg			[width-1:0] tmp;


	always @(posedge C)
		begin
			if (CLR)
				tmp <= 0;
			else
				if (CE)
					tmp <= tmp + 1;
				else if (CE4)
					tmp <= tmp + 4;
		end
	assign Q = tmp;

endmodule
