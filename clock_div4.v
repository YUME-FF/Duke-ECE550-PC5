module clock_div4(clk, rst, out_clk);
  output reg out_clk;
  input clk;
  input rst;	
	reg [1:0] count;
	always@(posedge clk)
		begin
			if(rst)
				count<=2'b00;
			else
				count<=count+1'b1;
		end
 
	always@(posedge clk)
		begin                                 
			if(rst)                          
				out_clk<=1'b0;
			else if(count==2'b00 || count==2'b10)
				out_clk<=~out_clk;
			else
				out_clk<=out_clk;
		end
endmodule