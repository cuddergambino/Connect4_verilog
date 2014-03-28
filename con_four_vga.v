`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////
//                       VGA Display Module                      ////
//                 Based on vga_demo.v by Da Cheng               //// 
//////////////////////////////////////////////////////////////////

module vga_mod(clk, CounterX, CounterY, vga_r, vga_g, vga_b, inDisplayArea, selectXpos, slotchecked, slotnumber, 
			Qp1, Qp1check, Qp1drop, Qp1sf, Qp1land, Qp1win, Qp2, Qp2check, Qp2drop, Qp2sf, Qp2land, Qp2win);

input clk, Qp1, Qp1check, Qp1drop, Qp1sf, Qp1land, Qp1win, Qp2, Qp2check, Qp2drop, Qp2sf, Qp2land, Qp2win;
input CounterX, CounterY, slotchecked, inDisplayArea, selectXpos;
output vga_r, vga_g, vga_b, slotnumber;

wire [9:0] CounterX, CounterY, selectXpos;
wire [1:0] slotchecked;
wire inDisplayArea;
wire  [5:0] slotnumber;

/* Local Signals */
reg [2:0] rownum, colnum;
reg [2:0] vga; 
/*///////////////*/

// Color definitions
	`define red 3'b100
	`define	green 3'b010
	`define yellow 3'b110
	`define black 3'b000


// Gap center definitions (holes in board)
	`define boardTLCx 110
	`define boardTLCy 80	
	`define boardWidth 420	
	`define boardHeight 360
	
	`define Gx0 140		
	`define Gx1 200		
	`define Gx2 260
	`define Gx3 320
	`define Gx4 380
	`define Gx5 440
	`define Gx6 500
	
	`define Gy5 110		
	`define Gy4 170		
	`define Gy3 230
	`define Gy2 290
	`define Gy1 350
	`define Gy0 410
	
	`define SPieceyC `Gy5 - 55
	
	`define Gx_Gy15 (((`Gx0 - 3 <= CounterX) && (CounterX <= `Gx0 + 3)) || \
            ((`Gx1 - 3 <= CounterX) && (CounterX <= `Gx1 + 3)) || \
            ((`Gx2 - 3 <= CounterX) && (CounterX <= `Gx2 + 3)) || \
            ((`Gx3 - 3 <= CounterX) && (CounterX <= `Gx3 + 3)) || \
            ((`Gx4 - 3 <= CounterX) && (CounterX <= `Gx4 + 3)) || \
            ((`Gx5 - 3 <= CounterX) && (CounterX <= `Gx5 + 3)) || \
            ((`Gx6 - 3 <= CounterX) && (CounterX <= `Gx6 + 3)))
				
	`define Gx_Gy14 ((`Gx0 - 6 <= CounterX && CounterX <= `Gx0 + 6) || 	\
            (`Gx1 - 6 <= CounterX && CounterX <= `Gx1 + 6) ||				\
            (`Gx2 - 6 <= CounterX && CounterX <= `Gx2 + 6) ||				\
            (`Gx3 - 6 <= CounterX && CounterX <= `Gx3 + 6) ||				\
            (`Gx4 - 6 <= CounterX && CounterX <= `Gx4 + 6) ||				\
            (`Gx5 - 6 <= CounterX && CounterX <= `Gx5 + 6) ||				\
            (`Gx6 - 6 <= CounterX && CounterX <= `Gx6 + 6) )
				
	`define Gx_Gy13 ((`Gx0 - 8 <= CounterX && CounterX <= `Gx0 + 8) || 	\
            (`Gx1 - 8 <= CounterX && CounterX <= `Gx1 + 8) ||				\
            (`Gx2 - 8 <= CounterX && CounterX <= `Gx2 + 8) ||				\
            (`Gx3 - 8 <= CounterX && CounterX <= `Gx3 + 8) ||				\
            (`Gx4 - 8 <= CounterX && CounterX <= `Gx4 + 8) ||				\
            (`Gx5 - 8 <= CounterX && CounterX <= `Gx5 + 8) ||				\
            (`Gx6 - 8 <= CounterX && CounterX <= `Gx6 + 8) )
			
	`define Gx_Gy12 (														\
			(`Gx0 - 9 <= CounterX && CounterX <= `Gx0 + 9) || 				\
            (`Gx1 - 9 <= CounterX && CounterX <= `Gx1 + 9) ||				\
            (`Gx2 - 9 <= CounterX && CounterX <= `Gx2 + 9) ||				\
            (`Gx3 - 9 <= CounterX && CounterX <= `Gx3 + 9) ||				\
            (`Gx4 - 9 <= CounterX && CounterX <= `Gx4 + 9) ||				\
            (`Gx5 - 9 <= CounterX && CounterX <= `Gx5 + 9) ||				\
            (`Gx6 - 9 <= CounterX && CounterX <= `Gx6 + 9) )
			
	`define Gx_Gy11 (														\
			(`Gx0 - 10 <= CounterX && CounterX <= `Gx0 + 10) || 			\
            (`Gx1 - 10 <= CounterX && CounterX <= `Gx1 + 10) ||				\
            (`Gx2 - 10 <= CounterX && CounterX <= `Gx2 + 10) ||				\
            (`Gx3 - 10 <= CounterX && CounterX <= `Gx3 + 10) ||				\
            (`Gx4 - 10 <= CounterX && CounterX <= `Gx4 + 10) ||				\
            (`Gx5 - 10 <= CounterX && CounterX <= `Gx5 + 10) ||				\
            (`Gx6 - 10 <= CounterX && CounterX <= `Gx6 + 10) )
			
	`define Gx_Gy10 (														\
			(`Gx0 - 11 <= CounterX && CounterX <= `Gx0 + 11) || 			\
            (`Gx1 - 11 <= CounterX && CounterX <= `Gx1 + 11) ||				\
            (`Gx2 - 11 <= CounterX && CounterX <= `Gx2 + 11) ||				\
            (`Gx3 - 11 <= CounterX && CounterX <= `Gx3 + 11) ||				\
            (`Gx4 - 11 <= CounterX && CounterX <= `Gx4 + 11) ||				\
            (`Gx5 - 11 <= CounterX && CounterX <= `Gx5 + 11) ||				\
            (`Gx6 - 11 <= CounterX && CounterX <= `Gx6 + 11) )
			
	`define Gx_Gy9 (														\
			(`Gx0 - 12 <= CounterX && CounterX <= `Gx0 + 12) || 			\
            (`Gx1 - 12 <= CounterX && CounterX <= `Gx1 + 12) ||				\
            (`Gx2 - 12 <= CounterX && CounterX <= `Gx2 + 12) ||				\
            (`Gx3 - 12 <= CounterX && CounterX <= `Gx3 + 12) ||				\
            (`Gx4 - 12 <= CounterX && CounterX <= `Gx4 + 12) ||				\
            (`Gx5 - 12 <= CounterX && CounterX <= `Gx5 + 12) ||				\
            (`Gx6 - 12 <= CounterX && CounterX <= `Gx6 + 12) )
			
	`define Gx_Gy8 (														\
			(`Gx0 - 13 <= CounterX && CounterX <= `Gx0 + 13) || 			\
            (`Gx1 - 13 <= CounterX && CounterX <= `Gx1 + 13) ||				\
            (`Gx2 - 13 <= CounterX && CounterX <= `Gx2 + 13) ||				\
            (`Gx3 - 13 <= CounterX && CounterX <= `Gx3 + 13) ||				\
            (`Gx4 - 13 <= CounterX && CounterX <= `Gx4 + 13) ||				\
            (`Gx5 - 13 <= CounterX && CounterX <= `Gx5 + 13) ||				\
            (`Gx6 - 13 <= CounterX && CounterX <= `Gx6 + 13) )
			
	`define Gx_Gy6 (														\
			(`Gx0 - 14 <= CounterX && CounterX <= `Gx0 + 14) || 			\
            (`Gx1 - 14 <= CounterX && CounterX <= `Gx1 + 14) ||				\
            (`Gx2 - 14 <= CounterX && CounterX <= `Gx2 + 14) ||				\
            (`Gx3 - 14 <= CounterX && CounterX <= `Gx3 + 14) ||				\
            (`Gx4 - 14 <= CounterX && CounterX <= `Gx4 + 14) ||				\
            (`Gx5 - 14 <= CounterX && CounterX <= `Gx5 + 14) ||				\
            (`Gx6 - 14 <= CounterX && CounterX <= `Gx6 + 14) )
			
	`define Gx_Gy3 (														\
			(`Gx0 - 15 <= CounterX && CounterX <= `Gx0 + 15) || 			\
            (`Gx1 - 15 <= CounterX && CounterX <= `Gx1 + 15) ||				\
            (`Gx2 - 15 <= CounterX && CounterX <= `Gx2 + 15) ||				\
            (`Gx3 - 15 <= CounterX && CounterX <= `Gx3 + 15) ||				\
            (`Gx4 - 15 <= CounterX && CounterX <= `Gx4 + 15) ||				\
            (`Gx5 - 15 <= CounterX && CounterX <= `Gx5 + 15) ||				\
            (`Gx6 - 15 <= CounterX && CounterX <= `Gx6 + 15) )


	assign {vga_r, vga_g, vga_b} = vga;
	assign slotnumber = 6*colnum + rownum;
			
	always @(posedge clk)
		begin
		if(`Gy0 - 16 <= CounterY && CounterY <= `Gy0 + 14) // 6 possible rows
			rownum <= 0;
		else if(`Gy1 - 16 <= CounterY && CounterY <= `Gy1 + 14)
			rownum <= 1;
		else if(`Gy2 - 16 <= CounterY && CounterY <= `Gy2 + 14)
			rownum <= 2;
		else if(`Gy3 - 16 <= CounterY && CounterY <= `Gy3 + 14)
			rownum <= 3;
		else if(`Gy4 - 16 <= CounterY && CounterY <= `Gy4 + 14)
			rownum <= 4;
		else if(`Gy5 - 16 <= CounterY && CounterY <= `Gy5 + 14)
			rownum <= 5;
			
		if(`Gx0 - 16 <= CounterX && CounterX <= `Gx0 + 14) // 7 possible columns
			colnum <= 0;
		else if(`Gx1 - 16 <= CounterX && CounterX <= `Gx1 + 14)
			colnum <= 1;
		else if(`Gx2 - 16 <= CounterX && CounterX <= `Gx2 + 14)
			colnum <= 2;
		else if(`Gx3 - 16 <= CounterX && CounterX <= `Gx3 + 14)
			colnum <= 3;
		else if(`Gx4 - 16 <= CounterX && CounterX <= `Gx4 + 14)
			colnum <= 4;
		else if(`Gx5 - 16 <= CounterX && CounterX <= `Gx5 + 14)
			colnum <= 5;
		else if(`Gx6 - 16 <= CounterX && CounterX <= `Gx6 + 14)
			colnum <= 6;
					
				
		if (   
			   ( (`Gy0 - 15 <= CounterY && CounterY <= `Gy0 + 15) && `Gx_Gy15)
			|| ( (`Gy0 - 14 <= CounterY && CounterY <= `Gy0 + 14) && `Gx_Gy14)
			|| ( (`Gy0 - 13 <= CounterY && CounterY <= `Gy0 + 13) && `Gx_Gy13)
			|| ( (`Gy0 - 12 <= CounterY && CounterY <= `Gy0 + 12) && `Gx_Gy12)
			|| ( (`Gy0 - 11 <= CounterY && CounterY <= `Gy0 + 11) && `Gx_Gy11)
			|| ( (`Gy0 - 10 <= CounterY && CounterY <= `Gy0 + 10) && `Gx_Gy10)
			|| ( (`Gy0 - 9  <= CounterY && CounterY <= `Gy0 + 9) && `Gx_Gy9)
			|| ( (`Gy0 - 8  <= CounterY && CounterY <= `Gy0 + 8) && `Gx_Gy8)
			|| ( (`Gy0 - 6  <= CounterY && CounterY <= `Gy0 + 6) && `Gx_Gy6)
			|| ( (`Gy0 - 3  <= CounterY && CounterY <= `Gy0 + 3) && `Gx_Gy3)
			||
			   ( (`Gy1 - 15 <= CounterY && CounterY <= `Gy1 + 15) && `Gx_Gy15)
			|| ( (`Gy1 - 14 <= CounterY && CounterY <= `Gy1 + 14) && `Gx_Gy14)
			|| ( (`Gy1 - 13 <= CounterY && CounterY <= `Gy1 + 13) && `Gx_Gy13)
			|| ( (`Gy1 - 12 <= CounterY && CounterY <= `Gy1 + 12) && `Gx_Gy12)
			|| ( (`Gy1 - 11 <= CounterY && CounterY <= `Gy1 + 11) && `Gx_Gy11)
			|| ( (`Gy1 - 10 <= CounterY && CounterY <= `Gy1 + 10) && `Gx_Gy10)
			|| ( (`Gy1 - 9  <= CounterY && CounterY <= `Gy1 + 9) && `Gx_Gy9)
			|| ( (`Gy1 - 8  <= CounterY && CounterY <= `Gy1 + 8) && `Gx_Gy8)
			|| ( (`Gy1 - 6  <= CounterY && CounterY <= `Gy1 + 6) && `Gx_Gy6)
			|| ( (`Gy1 - 3  <= CounterY && CounterY <= `Gy1 + 3) && `Gx_Gy3)
			||
			   ( (`Gy2 - 15 <= CounterY && CounterY <= `Gy2 + 15) && `Gx_Gy15)
			|| ( (`Gy2 - 14 <= CounterY && CounterY <= `Gy2 + 14) && `Gx_Gy14)
			|| ( (`Gy2 - 13 <= CounterY && CounterY <= `Gy2 + 13) && `Gx_Gy13)
			|| ( (`Gy2 - 12 <= CounterY && CounterY <= `Gy2 + 12) && `Gx_Gy12)
			|| ( (`Gy2 - 11 <= CounterY && CounterY <= `Gy2 + 11) && `Gx_Gy11)
			|| ( (`Gy2 - 10 <= CounterY && CounterY <= `Gy2 + 10) && `Gx_Gy10)
			|| ( (`Gy2 - 9  <= CounterY && CounterY <= `Gy2 + 9) && `Gx_Gy9)
			|| ( (`Gy2 - 8  <= CounterY && CounterY <= `Gy2 + 8) && `Gx_Gy8)
			|| ( (`Gy2 - 6  <= CounterY && CounterY <= `Gy2 + 6) && `Gx_Gy6)
			|| ( (`Gy2 - 3  <= CounterY && CounterY <= `Gy2 + 3) && `Gx_Gy3)
			||
			   ( (`Gy3 - 15 <= CounterY && CounterY <= `Gy3 + 15) && `Gx_Gy15)
			|| ( (`Gy3 - 14 <= CounterY && CounterY <= `Gy3 + 14) && `Gx_Gy14)
			|| ( (`Gy3 - 13 <= CounterY && CounterY <= `Gy3 + 13) && `Gx_Gy13)
			|| ( (`Gy3 - 12 <= CounterY && CounterY <= `Gy3 + 12) && `Gx_Gy12)
			|| ( (`Gy3 - 11 <= CounterY && CounterY <= `Gy3 + 11) && `Gx_Gy11)
			|| ( (`Gy3 - 10 <= CounterY && CounterY <= `Gy3 + 10) && `Gx_Gy10)
			|| ( (`Gy3 - 9  <= CounterY && CounterY <= `Gy3 + 9) && `Gx_Gy9)
			|| ( (`Gy3 - 8  <= CounterY && CounterY <= `Gy3 + 8) && `Gx_Gy8)
			|| ( (`Gy3 - 6  <= CounterY && CounterY <= `Gy3 + 6) && `Gx_Gy6)
			|| ( (`Gy3 - 3  <= CounterY && CounterY <= `Gy3 + 3) && `Gx_Gy3)
			||
			   ( (`Gy4 - 15 <= CounterY && CounterY <= `Gy4 + 15) && `Gx_Gy15)
			|| ( (`Gy4 - 14 <= CounterY && CounterY <= `Gy4 + 14) && `Gx_Gy14)
			|| ( (`Gy4 - 13 <= CounterY && CounterY <= `Gy4 + 13) && `Gx_Gy13)
			|| ( (`Gy4 - 12 <= CounterY && CounterY <= `Gy4 + 12) && `Gx_Gy12)
			|| ( (`Gy4 - 11 <= CounterY && CounterY <= `Gy4 + 11) && `Gx_Gy11)
			|| ( (`Gy4 - 10 <= CounterY && CounterY <= `Gy4 + 10) && `Gx_Gy10)
			|| ( (`Gy4 - 9  <= CounterY && CounterY <= `Gy4 + 9) && `Gx_Gy9)
			|| ( (`Gy4 - 8  <= CounterY && CounterY <= `Gy4 + 8) && `Gx_Gy8)
			|| ( (`Gy4 - 6  <= CounterY && CounterY <= `Gy4 + 6) && `Gx_Gy6)
			|| ( (`Gy4 - 3  <= CounterY && CounterY <= `Gy4 + 3) && `Gx_Gy3)
			||
			   ( (`Gy5 - 15 <= CounterY && CounterY <= `Gy5 + 15) && `Gx_Gy15)
			|| ( (`Gy5 - 14 <= CounterY && CounterY <= `Gy5 + 14) && `Gx_Gy14)
			|| ( (`Gy5 - 13 <= CounterY && CounterY <= `Gy5 + 13) && `Gx_Gy13)
			|| ( (`Gy5 - 12 <= CounterY && CounterY <= `Gy5 + 12) && `Gx_Gy12)
			|| ( (`Gy5 - 11 <= CounterY && CounterY <= `Gy5 + 11) && `Gx_Gy11)
			|| ( (`Gy5 - 10 <= CounterY && CounterY <= `Gy5 + 10) && `Gx_Gy10)
			|| ( (`Gy5 - 9  <= CounterY && CounterY <= `Gy5 + 9) && `Gx_Gy9)
			|| ( (`Gy5 - 8  <= CounterY && CounterY <= `Gy5 + 8) && `Gx_Gy8)
			|| ( (`Gy5 - 6  <= CounterY && CounterY <= `Gy5 + 6) && `Gx_Gy6)
			|| ( (`Gy5 - 3  <= CounterY && CounterY <= `Gy5 + 3) && `Gx_Gy3)
			)
			
			begin
				
			 	if(slotchecked == 1) // slotchecked corresponds to vga_output
					begin
						if(inDisplayArea)
							vga <= `red;
					end
				else if(slotchecked == 2)
					begin
						if(inDisplayArea)
							vga <= `green;
					end
				else
					begin
						if(inDisplayArea)
							vga <= `black;
					end				 
			 end
			 
		else if (CounterX >= `boardTLCx && CounterX <= `boardTLCx + `boardWidth &&
				 CounterY >= `boardTLCy && CounterY <= `boardTLCy + `boardHeight )
			 begin
				if(inDisplayArea)
					vga <= `yellow;
			 end
		else if (
						(`SPieceyC - 15 <= CounterY && `SPieceyC + 15 >= CounterY &&
						 selectXpos - 3  <= CounterX && selectXpos + 3  >= CounterX) ||
						(`SPieceyC - 14 <= CounterY && `SPieceyC + 14 >= CounterY &&
						 selectXpos - 6  <= CounterX && selectXpos + 6  >= CounterX) ||
						(`SPieceyC - 13 <= CounterY && `SPieceyC + 13 >= CounterY &&
						 selectXpos - 8  <= CounterX && selectXpos + 8  >= CounterX) ||
						(`SPieceyC - 12 <= CounterY && `SPieceyC + 12 >= CounterY &&
						 selectXpos - 9  <= CounterX && selectXpos + 9  >= CounterX) ||
						(`SPieceyC - 11 <= CounterY && `SPieceyC + 11 >= CounterY &&
						 selectXpos - 10 <= CounterX && selectXpos + 10  >= CounterX) ||
						(`SPieceyC - 10 <= CounterY && `SPieceyC + 10 >= CounterY &&
						 selectXpos - 11 <= CounterX && selectXpos + 11  >= CounterX) ||
						(`SPieceyC - 9  <= CounterY && `SPieceyC + 9  >= CounterY &&
						 selectXpos - 12 <= CounterX && selectXpos + 12 >= CounterX) ||
						(`SPieceyC - 8  <= CounterY && `SPieceyC + 8  >= CounterY &&
						 selectXpos - 13 <= CounterX && selectXpos + 13 >= CounterX) ||
						(`SPieceyC - 6  <= CounterY && `SPieceyC + 6  >= CounterY &&
						 selectXpos - 14 <= CounterX && selectXpos + 14 >= CounterX) ||
						(`SPieceyC - 3  <= CounterY && `SPieceyC + 3  >= CounterY &&
						 selectXpos - 15 <= CounterX && selectXpos + 15 >= CounterX)
					)
			begin
				if(Qp1 | Qp2check | Qp2drop | Qp1sf | Qp2land | Qp1win)
					begin
						if(inDisplayArea)
							vga <= `red;
					end
				else if(Qp2 | Qp1check | Qp1drop | Qp2sf | Qp1land | Qp2win)
					begin
						if(inDisplayArea)
							vga <= `green;
					end
				else
					begin
						if(inDisplayArea)
							vga <= `black;
					end
			end
			
		else
			 begin
				if(inDisplayArea)
					vga <= `black;
			 end
		end

endmodule
		
