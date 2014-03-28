`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////
//                  Connect 4 State Machine module               ////
//////////////////////////////////////////////////////////////////

module connect_four(start, ack, clk, reset, Down, Left, Right, read_data, p1_four_row, p2_four_row,
		Qi, Qp1, Qp2, Qp1sf, Qp2sf, Qp1check, Qp1drop, Qp1land, Qp2check, Qp2drop, Qp2land, Qp1win, Qp2win, Qdraw,
		Qi, Qp1, Qp2, Qp1sf, Qp2sf, Qp1check, Qp1drop, Qp1land, Qp2check, Qp2drop, Qp2land,
		write_pos, read_pos, write_data, write_EN, tie_game);
	
	input start, ack, clk, reset, Down, Left, Right, read_data, p1_four_row, p2_four_row, tie_game;
	output Qi, Qp1, Qp2, Qp1sf, Qp2sf, Qp1check, Qp1drop, Qp1land, Qp2check, Qp2drop, Qp2land, Qp1win, Qp2win, Qdraw;
	output write_pos, read_pos, write_data, write_EN;
	
	reg [13:0] state;
	reg [1:0] write_data;
	reg [5:0] read_pos, write_pos;
	reg write_EN;
	reg [2:0] select_col;
	reg [5:0] Turn_Count;
	reg [31:0] timer;

	wire [1:0] read_data;
	
	localparam
		INITIAL		= 14'b00000000000001,
		P1TURN 		= 14'b00000000000010,
		P1SLOTFIND 	= 14'b00000000000100,
		P1DROP 		= 14'b00000000001000,
		P1LAND		= 14'b00000000010000,
		P2TURN 		= 14'b00000000100000,
		P2SLOTFIND 	= 14'b00000001000000,
		P2DROP		= 14'b00000010000000,
		P2LAND		= 14'b00000100000000,
		P1CHECK		= 14'b00001000000000,
		P2CHECK		= 14'b00010000000000,
		P1WIN 		= 14'b00100000000000,
		P2WIN 		= 14'b01000000000000,
		DRAW 		= 14'b10000000000000;
	
	assign {Qdraw, Qp2win, Qp1win, Qp2check, Qp1check, Qp2land, Qp2drop, Qp2sf, Qp2, Qp1land, Qp1drop, Qp1sf, Qp1, Qi} = state;
	
	//`define SINGLE_DROP_TIME 50000000 
	//50 MHz
	
	`define SINGLE_DROP_TIME 30000000 
	//30 MHz 

		
always @(posedge clk, posedge reset)
begin: C4_CU_N_DPU
	if (reset)
		begin
			state <= INITIAL;
			write_EN <= 0;
			write_pos <= 42;
		end
	else
		begin
			case (state)
				INITIAL:
				begin
				
				// NSL
					if (start && write_pos == 0)
					begin
						write_EN <= 0;
						select_col <= 3;
						read_pos <= 23;
						state <= P1TURN;
					end
						
				// RTL
					
					if(write_pos > 0)
						write_pos <= write_pos - 1;
					
					write_EN <= 1;						
					write_data <= 2'b00;
						
				end
					
				P1TURN:
				begin	
				
					//NSL
					if(Down & read_data == 0)	//check if valid move
						begin
							write_pos <= read_pos;
							state <= P1SLOTFIND;
						end
				
					//RTL
					if (Left && (select_col > 0))
						begin
							select_col <= select_col - 1;
							read_pos <= read_pos - 6;
						end
					else if (Right && (select_col < 6))
						begin
							select_col <= select_col + 1;
							read_pos <= read_pos + 6;
						end;
				end
				
				P1SLOTFIND:
				begin
				
					//NSL 				
					if(read_data != 0)
						begin
						read_pos <= read_pos + 1;
						timer <= 1;
						state <= P1DROP;
						end
					else if(read_pos == select_col * 6)
						begin
						timer <= 1;
						state <= P1DROP;
						end
				
						
					//RTL				
					if(read_data == 0 && read_pos != select_col*6)
					begin
						read_pos <= read_pos - 1;
					end
				end
				
				P1DROP:
				begin
				
					//NSL
					if(write_pos == read_pos)
						begin
						state <= P1LAND;
						end
						
					// RTL
					if(timer == 0)
						begin
							write_EN <= 0;
							write_pos <= write_pos - 1;
							
							timer <= timer + 1;
						end
						
					else if(timer == 1)
						begin
							write_EN <= 1;
							write_data <= 2'b01;
							timer <= timer + 1;
						end
						
					else if(timer == `SINGLE_DROP_TIME)
						begin
							write_EN <= 1;
							write_data <= 2'b00;
							timer <= 0;
						end
						
					else
						begin
						timer <= timer + 1;
						end
				end
				
				P1LAND:
				begin
				
					//NSL
					state <= P1CHECK;
					select_col <= 3;
					read_pos <= 23;
					
					//RTL
					write_EN <= 0;
					Turn_Count <= Turn_Count + 1;
				end

				P2TURN:
				begin	
				
					//NSL
					if(Down & read_data == 0)	//check if valid move
						begin
							write_pos <= read_pos;
							state <= P2SLOTFIND;
						end
				
				
					//RTL
					if (Left && (select_col > 0))
						begin
							select_col <= select_col - 1;
							read_pos <= read_pos - 6;
						end
					else if (Right && (select_col < 6))
						begin
							select_col <= select_col + 1;
							read_pos <= read_pos + 6;
						end;
				end
				
				P2SLOTFIND:
				begin
				
					//NSL 				
					if(read_data != 0)
						begin
						read_pos <= read_pos + 1;
						timer <= 1;
						state <= P2DROP;
						end
					else if(read_pos == select_col * 6)
						begin
						timer <= 1;
						state <= P2DROP;
						end

					//RTL
					if(read_data == 0 && read_pos != select_col*6)
					begin
						read_pos <= read_pos - 1;
					end
				end
				
				P2DROP:
				begin
				
					//NSL
					if(write_pos == read_pos)
						begin
						state <= P2LAND;
						end
						
					// RTL
					if(timer == 0)
						begin
							write_EN <= 0;
							write_pos <= write_pos - 1;
							timer <= timer + 1;
						end
						
					else if(timer == 1)
						begin
							write_EN <= 1;
							write_data <= 2'b10;
							timer <= timer + 1;
						end
						
					else if(timer == `SINGLE_DROP_TIME)
						begin
							write_EN <= 1;
							write_data <= 2'b00;
							
							timer <= 0;
						end
						
					else
						begin
						timer <= timer + 1;
						end
				end
				
				P2LAND:
				begin
				
					//NSL
					state <= P2CHECK;
					select_col <= 3;
					read_pos <= 23;
					
					//RTL
					write_EN <= 0;
					Turn_Count <= Turn_Count + 1;
				end		

				P1CHECK: //69 ways to win Connect 4
				begin
					if (p1_four_row)
							state <= P1WIN;
					else
							state <= P2TURN;
				end
							
				P2CHECK: //69 ways to win Connect 4
				begin
					if (p2_four_row)
							state <= P2WIN;
					else if(tie_game)
							state <= DRAW;
					else
							state <= P1TURN;
				end
				
				P1WIN:
				begin
					if (ack)
					begin
						state <= INITIAL;
						write_EN <= 0;
						write_pos <= 42;
						timer <= 0;
					end
				end
					
				P2WIN:
				begin
					if (ack)
					begin
						state <= INITIAL;
						write_EN <= 0;
						write_pos <= 42;
					end
				end
				
				DRAW:
				begin
					if (ack)
					begin
						state <= INITIAL;
						write_EN <= 0;
						write_pos <= 42;
					end
				end
			endcase
		end
end

endmodule		
			
