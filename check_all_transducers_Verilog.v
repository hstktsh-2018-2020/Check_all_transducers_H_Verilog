`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:46:41 01/29/2018 
// Design Name: 
// Module Name:    check_all_transducers_Verilog 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module check_all_transducers_Verilog(
	 input CLK,
    output trans1,
    output trans2,
	 output trans3,
	 output trans4,
	 output trans5,
	 output trans6,
	 output trans7,
	 output trans8,
	 output trans9,
	 output trans10,
	 output trans11,
	 output trans12,
	 output trans13,
	 output trans14,
	 output trans15,
	 output trans16,
	 output trans17,
	 output trans18,
	 output trans19,
	 output trans20,
	 output trans21,
	 output trans22,
	 output trans23,
	 output trans24,
	 output trans25,
	 output trans26,
	 output trans27,
	 output trans28,
	 output trans29,
	 output trans30,
	 output trans31,
	 output trans32,
	 output trans33,
	 output trans34,
	 output trans35,
	 output trans36,
	 output trans37,
	 output trans38,
	 output trans39,
	 output trans40,
	 output trans41,
	 output trans42,
	 output trans43,
	 output trans44,
	 output trans45,
	 output trans46,
	 output trans47,
	 output trans48,
	 output trans49
    );

	//define signals
	reg trans1_reg = 1'b0;
	reg trans2_reg = 1'b0;
	reg trans3_reg = 1'b0;
	reg trans4_reg = 1'b0;
	reg trans5_reg = 1'b0;
	reg trans6_reg = 1'b0;
	reg trans7_reg = 1'b0;
	reg trans8_reg = 1'b0;
	reg trans9_reg = 1'b0;
	reg trans10_reg = 1'b0;
	reg trans11_reg = 1'b0;
	reg trans12_reg = 1'b0;
	reg trans13_reg = 1'b0;
	reg trans14_reg = 1'b0;
	reg trans15_reg = 1'b0;
	reg trans16_reg = 1'b0;
	reg trans17_reg = 1'b0;
	reg trans18_reg = 1'b0;
	reg trans19_reg = 1'b0;
	reg trans20_reg = 1'b0;
	reg trans21_reg = 1'b0;
	reg trans22_reg = 1'b0;
	reg trans23_reg = 1'b0;
	reg trans24_reg = 1'b0;
	reg trans25_reg = 1'b0;
	reg trans26_reg = 1'b0;
	reg trans27_reg = 1'b0;
	reg trans28_reg = 1'b0;
	reg trans29_reg = 1'b0;
	reg trans30_reg = 1'b0;
	reg trans31_reg = 1'b0;
	reg trans32_reg = 1'b0;
	reg trans33_reg = 1'b0;
	reg trans34_reg = 1'b0;
	reg trans35_reg = 1'b0;
	reg trans36_reg = 1'b0;
	reg trans37_reg = 1'b0;
	reg trans38_reg = 1'b0;
	reg trans39_reg = 1'b0;
	reg trans40_reg = 1'b0;
	reg trans41_reg = 1'b0;
	reg trans42_reg = 1'b0;
	reg trans43_reg = 1'b0;
	reg trans44_reg = 1'b0;
	reg trans45_reg = 1'b0;
	reg trans46_reg = 1'b0;
	reg trans47_reg = 1'b0;
	reg trans48_reg = 1'b0;
	reg trans49_reg = 1'b0;
	reg [10:0] pwm_base_reg = 11'h000;
	reg [9:0] pwm_duty_reg = 10'h000;
//	reg [9:0] duty_count_stop_reg = 10'd624;
//	reg pwm_out_reg = 1'b1;
	reg [6:0] base_cycle_counter_reg = 7'h00;
	reg [15:0] count_base_reg = 16'h0000;
	
	wire pwmbp;
	wire pwm_out;
	wire countbp;
	wire count_reset;

	//PWM Base Cycle Generate
	/* Calculation
		base count = 50[MHz] / 40 [kHz] = 1250
		0 ~ 1249 -> 1250 count
	*/
	always @(posedge CLK) begin  //CB16RE
		if (pwmbp == 1'b1) begin  //R:pwmbp
			pwm_base_reg <= 11'h000;  //h:hexadecimal, assign 0 to all bits
		end
		else begin
			pwm_base_reg <= pwm_base_reg + 1'b1;  //increment
		end
	end
	
	assign pwmbp = (pwm_base_reg[10:0] == 11'd1249) ? 1'b1 : 1'b0;  //COMP16

	//PWM Duty Ratio Generate
	always @(posedge CLK) begin  //CB16RE
		if (pwmbp == 1'b1) begin  //R:pwmbp
			pwm_duty_reg <= 11'h000;
		end
		else if (pwm_out == 1'b1) begin  //CE:pwm_out
			pwm_duty_reg <= pwm_duty_reg + 1'b1;
		end
	end

	//duty ratio = 50% -> 1250 / 2 = 625
		assign pwm_out = (pwm_duty_reg[9:0] == 10'd624) ? 1'b0 : 1'b1;  //COMP16
		
	
	
	//Count Base Cycle Generate
	/* Calculation
		base count = 40[kHz] / 1 [Hz] = 40*10^3
	*/
	always @(posedge pwmbp) begin  //CB16RE
		if (countbp == 1'b1) begin  //R:countbp
			count_base_reg <= 16'h0000;
		end
		else begin
			count_base_reg <= count_base_reg + 1'b1;
		end
	end
	
	assign countbp = (count_base_reg[15:0] == 16'd39999) ? 1'b1 : 1'b0;  //COMP16

	//base cycle counter generate
	always @(posedge countbp) begin  //CB8RE
		if (count_reset == 1'b1) begin  //R:count_reset
			base_cycle_counter_reg <= 7'h00;
		end
		else begin
			base_cycle_counter_reg <= base_cycle_counter_reg + 1'b1;
		end
	end
	
	assign count_reset = (base_cycle_counter_reg[6:0] == 7'd100) ? 1'b1 : 1'b0;  //COMP8
	
//	assign trans1 = pwm_out;
	
	//To transducers
	
	assign trans1 = (base_cycle_counter_reg[6:0] == 7'd0) ? pwm_out : 1'b0;
	assign trans2 = (base_cycle_counter_reg[6:0] == 7'd2) ? pwm_out : 1'b0;
	assign trans3 = (base_cycle_counter_reg[6:0] == 7'd4) ? pwm_out : 1'b0;
	assign trans4 = (base_cycle_counter_reg[6:0] == 7'd6) ? pwm_out : 1'b0;
	assign trans5 = (base_cycle_counter_reg[6:0] == 7'd8) ? pwm_out : 1'b0;
	assign trans6 = (base_cycle_counter_reg[6:0] == 7'd10) ? pwm_out : 1'b0;
	assign trans7 = (base_cycle_counter_reg[6:0] == 7'd12) ? pwm_out : 1'b0;
	assign trans8 = (base_cycle_counter_reg[6:0] == 7'd14) ? pwm_out : 1'b0;
	assign trans9 = (base_cycle_counter_reg[6:0] == 7'd16) ? pwm_out : 1'b0;
	assign trans10 = (base_cycle_counter_reg[6:0] == 7'd18) ? pwm_out : 1'b0;
	assign trans11 = (base_cycle_counter_reg[6:0] == 7'd20) ? pwm_out : 1'b0;
	assign trans12 = (base_cycle_counter_reg[6:0] == 7'd22) ? pwm_out : 1'b0;
	assign trans13 = (base_cycle_counter_reg[6:0] == 7'd24) ? pwm_out : 1'b0;
	assign trans14 = (base_cycle_counter_reg[6:0] == 7'd26) ? pwm_out : 1'b0;
	assign trans15 = (base_cycle_counter_reg[6:0] == 7'd28) ? pwm_out : 1'b0;
	assign trans16 = (base_cycle_counter_reg[6:0] == 7'd30) ? pwm_out : 1'b0;
	assign trans17 = (base_cycle_counter_reg[6:0] == 7'd32) ? pwm_out : 1'b0;
	assign trans18 = (base_cycle_counter_reg[6:0] == 7'd34) ? pwm_out : 1'b0;
	assign trans19 = (base_cycle_counter_reg[6:0] == 7'd36) ? pwm_out : 1'b0;
	assign trans20 = (base_cycle_counter_reg[6:0] == 7'd38) ? pwm_out : 1'b0;
	assign trans21 = (base_cycle_counter_reg[6:0] == 7'd40) ? pwm_out : 1'b0;
	assign trans22 = (base_cycle_counter_reg[6:0] == 7'd42) ? pwm_out : 1'b0;
	assign trans23 = (base_cycle_counter_reg[6:0] == 7'd44) ? pwm_out : 1'b0;
	assign trans24 = (base_cycle_counter_reg[6:0] == 7'd46) ? pwm_out : 1'b0;
	assign trans25 = (base_cycle_counter_reg[6:0] == 7'd48) ? pwm_out : 1'b0;
	assign trans26 = (base_cycle_counter_reg[6:0] == 7'd50) ? pwm_out : 1'b0;
	assign trans27 = (base_cycle_counter_reg[6:0] == 7'd52) ? pwm_out : 1'b0;
	assign trans28 = (base_cycle_counter_reg[6:0] == 7'd54) ? pwm_out : 1'b0;
	assign trans29 = (base_cycle_counter_reg[6:0] == 7'd56) ? pwm_out : 1'b0;
	assign trans30 = (base_cycle_counter_reg[6:0] == 7'd58) ? pwm_out : 1'b0;
	assign trans31 = (base_cycle_counter_reg[6:0] == 7'd60) ? pwm_out : 1'b0;
	assign trans32 = (base_cycle_counter_reg[6:0] == 7'd62) ? pwm_out : 1'b0;
	assign trans33 = (base_cycle_counter_reg[6:0] == 7'd64) ? pwm_out : 1'b0;
	assign trans34 = (base_cycle_counter_reg[6:0] == 7'd66) ? pwm_out : 1'b0;
	assign trans35 = (base_cycle_counter_reg[6:0] == 7'd68) ? pwm_out : 1'b0;
	assign trans36 = (base_cycle_counter_reg[6:0] == 7'd70) ? pwm_out : 1'b0;
	assign trans37 = (base_cycle_counter_reg[6:0] == 7'd72) ? pwm_out : 1'b0;
	assign trans38 = (base_cycle_counter_reg[6:0] == 7'd74) ? pwm_out : 1'b0;
	assign trans39 = (base_cycle_counter_reg[6:0] == 7'd76) ? pwm_out : 1'b0;
	assign trans40 = (base_cycle_counter_reg[6:0] == 7'd78) ? pwm_out : 1'b0;
	assign trans41 = (base_cycle_counter_reg[6:0] == 7'd80) ? pwm_out : 1'b0;
	assign trans42 = (base_cycle_counter_reg[6:0] == 7'd82) ? pwm_out : 1'b0;
	assign trans43 = (base_cycle_counter_reg[6:0] == 7'd84) ? pwm_out : 1'b0;
	assign trans44 = (base_cycle_counter_reg[6:0] == 7'd86) ? pwm_out : 1'b0;
	assign trans45 = (base_cycle_counter_reg[6:0] == 7'd88) ? pwm_out : 1'b0;
	assign trans46 = (base_cycle_counter_reg[6:0] == 7'd90) ? pwm_out : 1'b0;
	assign trans47 = (base_cycle_counter_reg[6:0] == 7'd92) ? pwm_out : 1'b0;
	assign trans48 = (base_cycle_counter_reg[6:0] == 7'd94) ? pwm_out : 1'b0;
	assign trans49 = (base_cycle_counter_reg[6:0] == 7'd96) ? pwm_out : 1'b0;

	
/*	always @(posedge countbp) begin
		case(base_cycle_counter_reg)
			7'd000: trans1_reg = pwm_out;
			7'd001: trans1_reg = 1'b0;
			7'd002: trans2_reg = pwm_out;
			7'd003: trans2_reg = 1'b0;
			7'd004: trans3_reg = pwm_out;
			7'd005: trans3_reg = 1'b0;
			7'd006: trans4_reg = pwm_out;
			7'd007: trans4_reg = 1'b0;
			7'd008: trans5_reg = pwm_out;
			7'd009: trans5_reg = 1'b0;
			7'd010: trans6_reg = pwm_out;
			7'd011: trans6_reg = 1'b0;
			7'd012: trans7_reg = pwm_out;
			7'd013: trans7_reg = 1'b0;
		endcase
	end*/
	
/*	assign trans1 = trans1_reg;
	assign trans2 = trans2_reg;
	assign trans3 = trans3_reg;
	assign trans4 = trans4_reg;
	assign trans5 = trans5_reg;
	assign trans6 = trans6_reg;
	assign trans7 = trans7_reg;
	assign trans8 = trans8_reg;
	assign trans9 = trans9_reg;
	assign trans10 = trans10_reg;
	assign trans11 = trans11_reg;
	assign trans12 = trans12_reg;
	assign trans13 = trans13_reg;
	assign trans14 = trans14_reg;
	assign trans15 = trans15_reg;
	assign trans16 = trans16_reg;
	assign trans17 = trans17_reg;
	assign trans18 = trans18_reg;
	assign trans19 = trans19_reg;
	assign trans20 = trans20_reg;
	assign trans21 = trans21_reg;
	assign trans22 = trans22_reg;
	assign trans23 = trans23_reg;
	assign trans24 = trans24_reg;
	assign trans25 = trans25_reg;
	assign trans26 = trans26_reg;
	assign trans27 = trans27_reg;
	assign trans28 = trans28_reg;
	assign trans29 = trans29_reg;
	assign trans30 = trans30_reg;
	assign trans31 = trans31_reg;
	assign trans32 = trans32_reg;
	assign trans33 = trans33_reg;
	assign trans34 = trans34_reg;
	assign trans35 = trans35_reg;
	assign trans36 = trans36_reg;
	assign trans37 = trans37_reg;
	assign trans38 = trans38_reg;
	assign trans39 = trans39_reg;
	assign trans40 = trans40_reg;
	assign trans41 = trans41_reg;
	assign trans42 = trans42_reg;
	assign trans43 = trans43_reg;
	assign trans44 = trans44_reg;
	assign trans45 = trans45_reg;
	assign trans46 = trans46_reg;
	assign trans47 = trans47_reg;
	assign trans48 = trans48_reg;
	assign trans49 = trans49_reg;
*/

endmodule
