`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////
//                       Connect 4 RAM memory                    ////
//        Based on array_R_RAM.v from the Merge Array Lab.       //// 
//////////////////////////////////////////////////////////////////

module c4_array_RAM(clk,write_EN,input_data,read_addr_vga, read_addr_sm, write_addr_sm,
					sm_output,vga_output,p1_four_row,p2_four_row, tie_game);

 input clk;
 input write_EN;
 input [1:0] input_data;
 input [5:0] read_addr_vga, read_addr_sm, write_addr_sm;
 
 output [1:0] vga_output, sm_output;
 output p1_four_row;
 output p2_four_row;
 output tie_game;
 
 reg [1:0] c4_array[0:41]; // Array to store the board

 always @ (posedge clk)
	 begin  : c4_array_RAM_logic
		if (write_EN)
			begin
				c4_array[write_addr_sm] <= input_data;
			end
	 end
 
 assign sm_output = c4_array[read_addr_sm];
 assign vga_output = c4_array[read_addr_vga];
 
 //Check if there are no more possible moves (tie condition) 
 assign tie_game = (c4_array[5] > 0 && c4_array[11] > 0 && c4_array[17] > 0 && c4_array[23] > 0 && c4_array[29] > 0 && c4_array[35] > 0 && c4_array[41] > 0);
 
 //Check if P1 wins
 assign p1_four_row= (((c4_array[0] == 1) && (c4_array[1] == 1) && (c4_array[2] == 1) && (c4_array[3] == 1)) || //start of Vertical | & Player 1
						((c4_array[1] == 1) && (c4_array[2] == 1) && (c4_array[3] == 1) && (c4_array[4] == 1)) ||
						((c4_array[2] == 1) && (c4_array[3] == 1) && (c4_array[4] == 1) && (c4_array[5] == 1)) ||
						((c4_array[6] == 1) && (c4_array[7] == 1) && (c4_array[8] == 1) && (c4_array[9] == 1)) ||
						((c4_array[7] == 1) && (c4_array[8] == 1) && (c4_array[9] == 1) && (c4_array[10] == 1))||
						((c4_array[8] == 1) && (c4_array[9] == 1) && (c4_array[10] == 1) && (c4_array[11] == 1)) ||
						((c4_array[12] == 1) && (c4_array[13] == 1) && (c4_array[14] == 1) && (c4_array[15] == 1)) ||
						((c4_array[13] == 1) && (c4_array[14] == 1) && (c4_array[15] == 1) && (c4_array[16] == 1)) ||
						((c4_array[14] == 1) && (c4_array[15] == 1) && (c4_array[16] == 1) && (c4_array[17] == 1)) ||
						((c4_array[18] == 1) && (c4_array[19] == 1) && (c4_array[20] == 1) && (c4_array[21] == 1)) ||
						((c4_array[19] == 1) && (c4_array[20] == 1) && (c4_array[21] == 1) && (c4_array[22] == 1)) ||
						((c4_array[20] == 1) && (c4_array[21] == 1) && (c4_array[22] == 1) && (c4_array[23] == 1)) ||
						((c4_array[24] == 1) && (c4_array[25] == 1) && (c4_array[26] == 1) && (c4_array[27] == 1)) ||
						((c4_array[25] == 1) && (c4_array[26] == 1) && (c4_array[27] == 1) && (c4_array[28] == 1)) ||
						((c4_array[26] == 1) && (c4_array[27] == 1) && (c4_array[28] == 1) && (c4_array[29] == 1)) ||
						((c4_array[30] == 1) && (c4_array[31] == 1) && (c4_array[32] == 1) && (c4_array[33] == 1)) ||
						((c4_array[31] == 1) && (c4_array[32] == 1) && (c4_array[33] == 1) && (c4_array[34] == 1)) ||
						((c4_array[32] == 1) && (c4_array[33] == 1) && (c4_array[34] == 1) && (c4_array[35] == 1)) ||
						((c4_array[36] == 1) && (c4_array[37] == 1) && (c4_array[38] == 1) && (c4_array[39] == 1)) ||
						((c4_array[37] == 1) && (c4_array[38] == 1) && (c4_array[39] == 1) && (c4_array[40] == 1)) ||
						((c4_array[38] == 1) && (c4_array[39] == 1) && (c4_array[40] == 1) && (c4_array[41] == 1)) || //End of Vertical |
						((c4_array[0] == 1) && (c4_array[6] == 1) && (c4_array[12] == 1) && (c4_array[18] == 1)) || //start of Horizontal -
						((c4_array[6] == 1) && (c4_array[12] == 1) && (c4_array[18] == 1) && (c4_array[24] == 1)) ||
						((c4_array[12] == 1) && (c4_array[18] == 1) && (c4_array[24] == 1) && (c4_array[30] == 1)) ||
						((c4_array[18] == 1) && (c4_array[24] == 1) && (c4_array[30] == 1) && (c4_array[36] == 1)) ||
						((c4_array[1] == 1) && (c4_array[7] == 1) && (c4_array[13] == 1) && (c4_array[19] == 1))||
						((c4_array[7] == 1) && (c4_array[13] == 1) && (c4_array[19] == 1) && (c4_array[25] == 1)) ||
						((c4_array[13] == 1) && (c4_array[19] == 1) && (c4_array[25] == 1) && (c4_array[31] == 1)) ||
						((c4_array[19] == 1) && (c4_array[25] == 1) && (c4_array[31] == 1) && (c4_array[37] == 1)) ||
						((c4_array[2] == 1) && (c4_array[8] == 1) && (c4_array[14] == 1) && (c4_array[20] == 1)) ||
						((c4_array[8] == 1) && (c4_array[14] == 1) && (c4_array[20] == 1) && (c4_array[26] == 1)) ||
						((c4_array[14] == 1) && (c4_array[20] == 1) && (c4_array[26] == 1) && (c4_array[32] == 1)) ||
						((c4_array[20] == 1) && (c4_array[26] == 1) && (c4_array[32] == 1) && (c4_array[38] == 1)) ||
						((c4_array[3] == 1) && (c4_array[9] == 1) && (c4_array[15] == 1) && (c4_array[21] == 1)) ||
						((c4_array[9] == 1) && (c4_array[15] == 1) && (c4_array[21] == 1) && (c4_array[27] == 1)) ||
						((c4_array[15] == 1) && (c4_array[21] == 1) && (c4_array[27] == 1) && (c4_array[33] == 1)) ||
						((c4_array[21] == 1) && (c4_array[27] == 1) && (c4_array[33] == 1) && (c4_array[39] == 1)) ||
						((c4_array[4] == 1) && (c4_array[10] == 1) && (c4_array[16] == 1) && (c4_array[22] == 1)) ||
						((c4_array[10] == 1) && (c4_array[16] == 1) && (c4_array[22] == 1) && (c4_array[28] == 1)) ||
						((c4_array[16] == 1) && (c4_array[22] == 1) && (c4_array[28] == 1) && (c4_array[34] == 1)) ||
						((c4_array[22] == 1) && (c4_array[28] == 1) && (c4_array[34] == 1) && (c4_array[40] == 1)) ||
						((c4_array[5] == 1) && (c4_array[11] == 1) && (c4_array[17] == 1) && (c4_array[23] == 1)) ||
						((c4_array[11] == 1) && (c4_array[17] == 1) && (c4_array[23] == 1) && (c4_array[29] == 1)) ||
						((c4_array[17] == 1) && (c4_array[23] == 1) && (c4_array[29] == 1) && (c4_array[35] == 1)) ||						
						((c4_array[23] == 1) && (c4_array[29] == 1) && (c4_array[35] == 1) && (c4_array[41] == 1)) || //End of Horizontal -
						((c4_array[2] == 1) && (c4_array[9] == 1) && (c4_array[16] == 1) && (c4_array[23] == 1)) || //start of Upward Diagonal /
						((c4_array[1] == 1) && (c4_array[8] == 1) && (c4_array[15] == 1) && (c4_array[22] == 1)) ||
						((c4_array[8] == 1) && (c4_array[15] == 1) && (c4_array[22] == 1) && (c4_array[29] == 1)) ||
						((c4_array[0] == 1) && (c4_array[7] == 1) && (c4_array[14] == 1) && (c4_array[21] == 1)) ||
						((c4_array[7] == 1) && (c4_array[14] == 1) && (c4_array[21] == 1) && (c4_array[28] == 1))||
						((c4_array[14] == 1) && (c4_array[21] == 1) && (c4_array[28] == 1) && (c4_array[35] == 1)) ||
						((c4_array[6] == 1) && (c4_array[13] == 1) && (c4_array[20] == 1) && (c4_array[27] == 1)) ||
						((c4_array[13] == 1) && (c4_array[20] == 1) && (c4_array[27] == 1) && (c4_array[34] == 1)) ||
						((c4_array[20] == 1) && (c4_array[27] == 1) && (c4_array[34] == 1) && (c4_array[41] == 1)) ||
						((c4_array[12] == 1) && (c4_array[19] == 1) && (c4_array[26] == 1) && (c4_array[33] == 1)) ||
						((c4_array[19] == 1) && (c4_array[26] == 1) && (c4_array[33] == 1) && (c4_array[40] == 1)) ||
						((c4_array[18] == 1) && (c4_array[25] == 1) && (c4_array[32] == 1) && (c4_array[39] == 1)) || //End of Upward Diagonal /
						((c4_array[3] == 1) && (c4_array[8] == 1) && (c4_array[13] == 1) && (c4_array[18] == 1)) || //start of Downward Diagonal \
						((c4_array[4] == 1) && (c4_array[9] == 1) && (c4_array[14] == 1) && (c4_array[19] == 1)) ||
						((c4_array[9] == 1) && (c4_array[14] == 1) && (c4_array[19] == 1) && (c4_array[24] == 1)) ||
						((c4_array[5] == 1) && (c4_array[10] == 1) && (c4_array[15] == 1) && (c4_array[20] == 1)) ||
						((c4_array[10] == 1) && (c4_array[15] == 1) && (c4_array[20] == 1) && (c4_array[25] == 1)) ||
						((c4_array[15] == 1) && (c4_array[20] == 1) && (c4_array[25] == 1) && (c4_array[30] == 1)) ||
						((c4_array[11] == 1) && (c4_array[16] == 1) && (c4_array[21] == 1) && (c4_array[26] == 1)) ||
						((c4_array[16] == 1) && (c4_array[21] == 1) && (c4_array[26] == 1) && (c4_array[31] == 1)) ||
						((c4_array[21] == 1) && (c4_array[26] == 1) && (c4_array[31] == 1) && (c4_array[36] == 1)) ||
						((c4_array[17] == 1) && (c4_array[22] == 1) && (c4_array[27] == 1) && (c4_array[32] == 1)) ||
						((c4_array[22] == 1) && (c4_array[27] == 1) && (c4_array[32] == 1) && (c4_array[37] == 1)) ||						
						((c4_array[23] == 1) && (c4_array[28] == 1) && (c4_array[33] == 1) && (c4_array[38] == 1))); //End of Downward Diagonal \ & Player 1
 
 //Check if P2 wins 
 assign p2_four_row = (((c4_array[0] == 2) && (c4_array[1] == 2) && (c4_array[2] == 2) && (c4_array[3] == 2)) || //start of Vertical | & Player 2
						((c4_array[1] == 2) && (c4_array[2] == 2) && (c4_array[3] == 2) && (c4_array[4] == 2)) ||
						((c4_array[2] == 2) && (c4_array[3] == 2) && (c4_array[4] == 2) && (c4_array[5] == 2)) ||
						((c4_array[6] == 2) && (c4_array[7] == 2) && (c4_array[8] == 2) && (c4_array[9] == 2)) ||
						((c4_array[7] == 2) && (c4_array[8] == 2) && (c4_array[9] == 2) && (c4_array[10] == 2))||
						((c4_array[8] == 2) && (c4_array[9] == 2) && (c4_array[10] == 2) && (c4_array[11] == 2)) ||
						((c4_array[12] == 2) && (c4_array[13] == 2) && (c4_array[14] == 2) && (c4_array[15] == 2)) ||
						((c4_array[13] == 2) && (c4_array[14] == 2) && (c4_array[15] == 2) && (c4_array[16] == 2)) ||
						((c4_array[14] == 2) && (c4_array[15] == 2) && (c4_array[16] == 2) && (c4_array[17] == 2)) ||
						((c4_array[18] == 2) && (c4_array[19] == 2) && (c4_array[20] == 2) && (c4_array[21] == 2)) ||
						((c4_array[19] == 2) && (c4_array[20] == 2) && (c4_array[21] == 2) && (c4_array[22] == 2)) ||
						((c4_array[20] == 2) && (c4_array[21] == 2) && (c4_array[22] == 2) && (c4_array[23] == 2)) ||
						((c4_array[24] == 2) && (c4_array[25] == 2) && (c4_array[26] == 2) && (c4_array[27] == 2)) ||
						((c4_array[25] == 2) && (c4_array[26] == 2) && (c4_array[27] == 2) && (c4_array[28] == 2)) ||
						((c4_array[26] == 2) && (c4_array[27] == 2) && (c4_array[28] == 2) && (c4_array[29] == 2)) ||
						((c4_array[30] == 2) && (c4_array[31] == 2) && (c4_array[32] == 2) && (c4_array[33] == 2)) ||
						((c4_array[31] == 2) && (c4_array[32] == 2) && (c4_array[33] == 2) && (c4_array[34] == 2)) ||
						((c4_array[32] == 2) && (c4_array[33] == 2) && (c4_array[34] == 2) && (c4_array[35] == 2)) ||
						((c4_array[36] == 2) && (c4_array[37] == 2) && (c4_array[38] == 2) && (c4_array[39] == 2)) ||
						((c4_array[37] == 2) && (c4_array[38] == 2) && (c4_array[39] == 2) && (c4_array[40] == 2)) ||
						((c4_array[38] == 2) && (c4_array[39] == 2) && (c4_array[40] == 2) && (c4_array[41] == 2)) || //End of Vertical |
						((c4_array[0] == 2) && (c4_array[6] == 2) && (c4_array[12] == 2) && (c4_array[18] == 2)) || //start of Horizontal -
						((c4_array[6] == 2) && (c4_array[12] == 2) && (c4_array[18] == 2) && (c4_array[24] == 2)) ||
						((c4_array[12] == 2) && (c4_array[18] == 2) && (c4_array[24] == 2) && (c4_array[30] == 2)) ||
						((c4_array[18] == 2) && (c4_array[24] == 2) && (c4_array[30] == 2) && (c4_array[36] == 2)) ||
						((c4_array[1] == 2) && (c4_array[7] == 2) && (c4_array[13] == 2) && (c4_array[19] == 2))||
						((c4_array[7] == 2) && (c4_array[13] == 2) && (c4_array[19] == 2) && (c4_array[25] == 2)) ||
						((c4_array[13] == 2) && (c4_array[19] == 2) && (c4_array[25] == 2) && (c4_array[31] == 2)) ||
						((c4_array[19] == 2) && (c4_array[25] == 2) && (c4_array[31] == 2) && (c4_array[37] == 2)) ||
						((c4_array[2] == 2) && (c4_array[8] == 2) && (c4_array[14] == 2) && (c4_array[20] == 2)) ||
						((c4_array[8] == 2) && (c4_array[14] == 2) && (c4_array[20] == 2) && (c4_array[26] == 2)) ||
						((c4_array[14] == 2) && (c4_array[20] == 2) && (c4_array[26] == 2) && (c4_array[32] == 2)) ||
						((c4_array[20] == 2) && (c4_array[26] == 2) && (c4_array[32] == 2) && (c4_array[38] == 2)) ||
						((c4_array[3] == 2) && (c4_array[9] == 2) && (c4_array[15] == 2) && (c4_array[21] == 2)) ||
						((c4_array[9] == 2) && (c4_array[15] == 2) && (c4_array[21] == 2) && (c4_array[27] == 2)) ||
						((c4_array[15] == 2) && (c4_array[21] == 2) && (c4_array[27] == 2) && (c4_array[33] == 2)) ||
						((c4_array[21] == 2) && (c4_array[27] == 2) && (c4_array[33] == 2) && (c4_array[39] == 2)) ||
						((c4_array[4] == 2) && (c4_array[10] == 2) && (c4_array[16] == 2) && (c4_array[22] == 2)) ||
						((c4_array[10] == 2) && (c4_array[16] == 2) && (c4_array[22] == 2) && (c4_array[28] == 2)) ||
						((c4_array[16] == 2) && (c4_array[22] == 2) && (c4_array[28] == 2) && (c4_array[34] == 2)) ||
						((c4_array[22] == 2) && (c4_array[28] == 2) && (c4_array[34] == 2) && (c4_array[40] == 2)) ||
						((c4_array[5] == 2) && (c4_array[11] == 2) && (c4_array[17] == 2) && (c4_array[23] == 2)) ||
						((c4_array[11] == 2) && (c4_array[17] == 2) && (c4_array[23] == 2) && (c4_array[29] == 2)) ||
						((c4_array[17] == 2) && (c4_array[23] == 2) && (c4_array[29] == 2) && (c4_array[35] == 2)) ||						
						((c4_array[23] == 2) && (c4_array[29] == 2) && (c4_array[35] == 2) && (c4_array[41] == 2)) || //End of Horizontal -
						((c4_array[2] == 2) && (c4_array[9] == 2) && (c4_array[16] == 2) && (c4_array[23] == 2)) || //start of Upward Diagonal /
						((c4_array[1] == 2) && (c4_array[8] == 2) && (c4_array[15] == 2) && (c4_array[22] == 2)) ||
						((c4_array[8] == 2) && (c4_array[15] == 2) && (c4_array[22] == 2) && (c4_array[29] == 2)) ||
						((c4_array[0] == 2) && (c4_array[7] == 2) && (c4_array[14] == 2) && (c4_array[21] == 2)) ||
						((c4_array[7] == 2) && (c4_array[14] == 2) && (c4_array[21] == 2) && (c4_array[28] == 2))||
						((c4_array[14] == 2) && (c4_array[21] == 2) && (c4_array[28] == 2) && (c4_array[35] == 2)) ||
						((c4_array[6] == 2) && (c4_array[13] == 2) && (c4_array[20] == 2) && (c4_array[27] == 2)) ||
						((c4_array[13] == 2) && (c4_array[20] == 2) && (c4_array[27] == 2) && (c4_array[34] == 2)) ||
						((c4_array[20] == 2) && (c4_array[27] == 2) && (c4_array[34] == 2) && (c4_array[41] == 2)) ||
						((c4_array[12] == 2) && (c4_array[19] == 2) && (c4_array[26] == 2) && (c4_array[33] == 2)) ||
						((c4_array[19] == 2) && (c4_array[26] == 2) && (c4_array[33] == 2) && (c4_array[40] == 2)) ||
						((c4_array[18] == 2) && (c4_array[25] == 2) && (c4_array[32] == 2) && (c4_array[39] == 2)) || //End of Upward Diagonal /
						((c4_array[3] == 2) && (c4_array[8] == 2) && (c4_array[13] == 2) && (c4_array[18] == 2)) || //start of Downward Diagonal \
						((c4_array[4] == 2) && (c4_array[9] == 2) && (c4_array[14] == 2) && (c4_array[19] == 2)) ||
						((c4_array[9] == 2) && (c4_array[14] == 2) && (c4_array[19] == 2) && (c4_array[24] == 2)) ||
						((c4_array[5] == 2) && (c4_array[10] == 2) && (c4_array[15] == 2) && (c4_array[20] == 2)) ||
						((c4_array[10] == 2) && (c4_array[15] == 2) && (c4_array[20] == 2) && (c4_array[25] == 2)) ||
						((c4_array[15] == 2) && (c4_array[20] == 2) && (c4_array[25] == 2) && (c4_array[30] == 2)) ||
						((c4_array[11] == 2) && (c4_array[16] == 2) && (c4_array[21] == 2) && (c4_array[26] == 2)) ||
						((c4_array[16] == 2) && (c4_array[21] == 2) && (c4_array[26] == 2) && (c4_array[31] == 2)) ||
						((c4_array[21] == 2) && (c4_array[26] == 2) && (c4_array[31] == 2) && (c4_array[36] == 2)) ||
						((c4_array[17] == 2) && (c4_array[22] == 2) && (c4_array[27] == 2) && (c4_array[32] == 2)) ||
						((c4_array[22] == 2) && (c4_array[27] == 2) && (c4_array[32] == 2) && (c4_array[37] == 2)) ||						
						((c4_array[23] == 2) && (c4_array[28] == 2) && (c4_array[33] == 2) && (c4_array[38] == 2))); //End of Downward Diagonal \ & Player 2
 
endmodule
