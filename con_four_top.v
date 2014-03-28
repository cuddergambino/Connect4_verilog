`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////
//                       Connect 4 Top Module                    ////
//           Based on various top modules from EE201 Labs        //// 
//////////////////////////////////////////////////////////////////

module con_four_top(ClkPort, vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b, btnL, btnR, btnC, btnD, btnU, 
	selectXpos, St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar,
	An0, An1, An2, An3, Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	LD0, LD1, LD2, LD3, LD4, LD5);
	input ClkPort, btnL, btnR, btnC, btnD, btnU;
	output St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar;
	output vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b, selectXpos;
	output An0, An1, An2, An3, Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp;
	output LD0, LD1, LD2, LD3, LD4, LD5;
	reg vga_r, vga_g, vga_b;
	
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/*  LOCAL SIGNALS */
	wire	reset, ClkPort, board_clk, clk, button_clk;
	
	wire	Qi, Qp1, Qp2, Qp1sf, Qp2sf, Qp1check, Qp1drop, Qp1land, Qp2check, Qp2drop, Qp2land, Qp1win, Qp2win, Qdraw;
	wire	SCEN_C, SCEN_D, SCEN_L, SCEN_R;
	wire	R, G, B;
	
	wire	write_EN;
	wire [1:0] input_data, sm_output, vga_output;
	wire [5:0] read_addr_vga, read_addr_sm, write_addr_sm;
	
	wire p1_four_row, p2_four_row, tie_game;
	
	reg [6:0] SSD_CATHODES_HEX_2, SSD_CATHODES_HEX_3, SSD_CATHODES_0, SSD_CATHODES_1, SSD_CATHODES_2;
	reg [1:0] display;
	
	assign reset = btnU;

	/////////////////////////////////////  Clock Setup  //////////////////////////////////////
	BUF BUF1 (board_clk, ClkPort);
	
	reg [27:0]	DIV_CLK;
	always @ (posedge board_clk, posedge reset)  
	begin : CLOCK_DIVIDER
      if (reset)
			DIV_CLK <= 0;
      else
			DIV_CLK <= DIV_CLK + 1'b1;
	end	

	assign	flash_clk = DIV_CLK[25];
	assign	clk = DIV_CLK[1];
	assign 	{St_ce_bar, St_rp_bar, Mt_ce_bar, Mt_St_oe_bar, Mt_St_we_bar} = {5'b11111};
	//////////////////////////////////////////////////////////////////////////////////////////
	
	wire inDisplayArea;
	wire [9:0] CounterX;
	wire [9:0] CounterY;
	reg  [9:0] selectXpos;
	
	//Instantiate btnL (Left)
	ee201_debouncer #(.N_dc(26)) UUT_BtnL
		(.CLK(board_clk), .RESET(reset), .PB(btnL), .DPB( ), .SCEN(SCEN_L), .MCEN( ), .CCEN( ));
	
	//Instantiate btnR (Right)
	ee201_debouncer #(.N_dc(26)) UUT_BtnR
		(.CLK(board_clk), .RESET(reset), .PB(btnR), .DPB( ), .SCEN(SCEN_R), .MCEN( ), .CCEN( ));
	
	//Instantiate btnC (Start/Ack)
	ee201_debouncer #(.N_dc(26)) UUT_BtnC
		(.CLK(board_clk), .RESET(reset), .PB(btnC), .DPB( ), .SCEN(SCEN_C), .MCEN( ), .CCEN( ));
	
	//Instantiate btnD (Confirm Move)
	ee201_debouncer #(.N_dc(26)) UUT_BtnD
		(.CLK(board_clk), .RESET(reset), .PB(btnD), .DPB( ), .SCEN(SCEN_D), .MCEN( ), .CCEN( ));
	
	//Instantiate the State Machine
	connect_four UUT_con_four
		(.clk(board_clk), .reset(reset), .start(SCEN_C), .ack(SCEN_C), .Left(SCEN_L), .Right(SCEN_R), .Down(SCEN_D),
		.write_EN(write_EN), .write_pos(write_addr_sm), .write_data(input_data), .read_pos(read_addr_sm), .read_data(sm_output),
		.p1_four_row(p1_four_row), .p2_four_row(p2_four_row), .tie_game(tie_game),
		.Qi(Qi), .Qp1(Qp1), .Qp2(Qp2), .Qp1sf(Qp1sf), .Qp2sf(Qp2sf), .Qp1check(Qp1check), 
		.Qp1drop(Qp1drop), .Qp1land(Qp1land), .Qp2check(Qp2check), .Qp2drop(Qp2drop), 
		.Qp2land(Qp2land), .Qp1win(Qp1win), .Qp2win(Qp2win), .Qdraw(Qdraw));
	
	//Instantiate HVSync Generator module (Pixel Counter)
	hvsync_generator syncgen(.clk(clk), .reset(reset), .vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync),
		 					.inDisplayArea(inDisplayArea), .CounterX(CounterX), .CounterY(CounterY));
	
	//Instantiate VGA module
	vga_mod UUT_vga(.clk(clk), .CounterX(CounterX), .CounterY(CounterY), .vga_r(R), .vga_g(G), .vga_b(B), 
					.inDisplayArea(inDisplayArea), .selectXpos(selectXpos), .slotchecked(vga_output), 
					.slotnumber(read_addr_vga), .Qp1(Qp1), .Qp2(Qp2), .Qp1sf(Qp1sf), .Qp2sf(Qp2sf), 
					.Qp1check(Qp1check), .Qp1drop(Qp1drop), .Qp1land(Qp1land), .Qp2check(Qp2check), 
					.Qp2drop(Qp2drop), .Qp2land(Qp2land), .Qp1win(Qp1win), .Qp2win(Qp2win));  
	
	//Instantiate board memory
	c4_array_RAM UUT_mem(.clk(board_clk), .write_EN(write_EN), .input_data(input_data), .read_addr_sm(read_addr_sm), .write_addr_sm(write_addr_sm),
						.read_addr_vga(read_addr_vga), .sm_output(sm_output), .vga_output(vga_output),
						.p1_four_row(p1_four_row), .p2_four_row(p2_four_row), .tie_game(tie_game));
	
	/////////////////////////////////////////////////////////////////
	///////////////	   Button Movement & Colors starts here		//////////
	/////////////////////////////////////////////////////////////////
	
	always @(posedge board_clk)
		begin
			if(reset || Qp1land || Qp2land)
				selectXpos<=320;
			else if(SCEN_L && ~SCEN_R && selectXpos > 140) //Both SCEN_L and SCEN_R correspond to the pulses for btnL and btnR
				selectXpos<=selectXpos-60;
			else if(SCEN_R && ~SCEN_L && selectXpos < 500)
				selectXpos<=selectXpos+60;	
		end
	
	always @(posedge clk)
		begin
			vga_r <= R;
			vga_g <= G;
			vga_b <= B;
		end
	
	/////////////////////////////////////////////////////////////////
	///////////////	   Button Movement & Colors ends here		//////////
	/////////////////////////////////////////////////////////////////
	
	/////////////////////////////////////////////////////////////////
	//////////////  	  LD control starts here 	 ///////////////////
	/////////////////////////////////////////////////////////////////

	wire LD0, LD1, LD2, LD3, LD4, LD5;
	assign {LD5, LD4, LD3, LD2, LD1, LD0} = {Qi, Qp1, Qp2, Qp1win, Qp2win, Qdraw};
	
	/////////////////////////////////////////////////////////////////
	//////////////  	  LD control ends here 	 	////////////////////
	/////////////////////////////////////////////////////////////////
	
	/////////////////////////////////////////////////////////////////
	//////////////  	  SSD control starts here 	 ///////////////////
	/////////////////////////////////////////////////////////////////
	reg 	[6:0]	SSD;
	wire 	[6:0]	SSD0, SSD1, SSD2, SSD3;
	wire 	[1:0] 	ssdscan_clk;
	
	assign SSD3 = 7'b1111111;
	assign SSD2 = SSD_CATHODES_2;
	assign SSD1 = SSD_CATHODES_1;
	assign SSD0 = SSD_CATHODES_0;
	
	assign ssdscan_clk = DIV_CLK[19:18];	
	assign An0	= !(~(ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 00
	assign An1	= !(~(ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 01
	assign An2	= !( (ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 10
	assign An3	= !( (ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 11
	
	always @ (ssdscan_clk, SSD0, SSD1, SSD2, SSD3)
	begin : SSD_SCAN_OUT
		case (ssdscan_clk) 
			2'b00:	SSD = SSD0;
			2'b01:	SSD = SSD1;
			2'b10:	SSD = SSD2;
			2'b11:	SSD = SSD3;
		endcase 
	end	

	wire [6:0] SSD_CATHODES_blinking;
	
	assign SSD_CATHODES_blinking = SSD | ( {7{flash_clk & (Qp1win | Qp2win | Qdraw)}} ); //blink when someone wins or if there is a draw
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES_blinking, 1'b1};
	
	
	`define QI_NUM		2'b00	
	`define QP1_NUM 	2'b01
	`define QP2_NUM		2'b10
	`define QDRAW_NUM	2'b11
	
	always @ (Qi, Qp1, Qp2, Qp1sf, Qp2sf, Qp1check, Qp1drop, Qp1land, Qp2check, Qp2drop, Qp2land, Qp1win, Qp2win, Qdraw)
	begin : DISPLAY
		(* full_case, parallel_case *)
		case ( {Qdraw, Qp2win, Qp1win, Qp2check, Qp1check, Qp2land, Qp2drop, Qp2sf, Qp2, Qp1land, Qp1drop, Qp1sf, Qp1, Qi} )		
			14'b00000000000001: display = `QI_NUM;
			14'b00000000000010: display = `QP1_NUM;
			14'b00000000000100: display = `QP1_NUM;
			14'b00000000001000: display = `QP1_NUM;	
			14'b00000000010000: display = `QP1_NUM;
			14'b00000000100000: display = `QP2_NUM;
			14'b00000001000000: display = `QP2_NUM;
			14'b00000010000000: display = `QP2_NUM;
			14'b00000100000000: display = `QP2_NUM;
			14'b00001000000000: display = `QP1_NUM;
			14'b00010000000000: display = `QP2_NUM;
			14'b00100000000000: display = `QP1_NUM;
			14'b01000000000000: display = `QP2_NUM;
			14'b10000000000000: display = `QDRAW_NUM;				
		endcase
	end
	
	always @ (display) 
	begin : LETTERS_SSD0
		case (display)		
			2'b00: SSD_CATHODES_0 = 7'b1111111 ; //Nothing 
			2'b01: SSD_CATHODES_0 = 7'b1001111 ; //1
			2'b10: SSD_CATHODES_0 = 7'b0010010 ; //2
			2'b11: SSD_CATHODES_0 = 7'b0110000 ; //E
		endcase
	end
	
	always @ (display) 
	begin : LETTERS_SSD1
		case (display)		
			2'b00: SSD_CATHODES_1 = 7'b1111111 ; //Nothing 
			2'b01: SSD_CATHODES_1 = 7'b0011000 ; //P
			2'b10: SSD_CATHODES_1 = 7'b0011000 ; //P
			2'b11: SSD_CATHODES_1 = 7'b1111001 ; //I
		endcase
	end
	
	always @ (display) 
	begin : LETTERS_SSD2
		case (display)		
			2'b00: SSD_CATHODES_2 = 7'b1111111 ; //Nothing 
			2'b01: SSD_CATHODES_2 = 7'b1111111 ; //Nothing
			2'b10: SSD_CATHODES_2 = 7'b1111111 ; //Nothing
			2'b11: SSD_CATHODES_2 = 7'b1110000 ; //t
		endcase
	end
		
	/////////////////////////////////////////////////////////////////
	//////////////  	  SSD control ends here 	 ///////////////////
	/////////////////////////////////////////////////////////////////
endmodule
