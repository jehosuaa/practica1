//julian hpta

module securitybox_controller_JJ(
	input logic Clk,
	input logic Reset,
	input logic [3:0] Key,
	input logic PressedKey, DoorSw,
	output logic OpenDoor,
	output logic OpenDoorLed, ClosedDoorLed,
	output logic WrongPWLed);
	
	
	typedef enum logic [3:0] {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10} State;
	
	reg [3:0] tblock;
	State currentState, nextState;
	
	always_ff @(posedge reset, posedge clk) begin
	
		if(reset)
			currentState <= S9;
		else
			currentState <= nextState;
	
	end
	
	always_comb begin
	
	
	
		case(currentState)
			
			S0:		
				if(PressedKey) begin
						
					if(key == 4'b1001) nextState <= S1;	
					else nextState <= S6; end
						
				else 	nextState <= S0;
			
			S1: 
				if(PressedKey && (DoorSw==0)) begin  //necesito doorsw?
						
					if(key == 4'b0101) nextState <= S2;			
					else nextState <= S7; end
					
				else nextState <= S1;
			
			S2: 
				if(PressedKey && (DoorSw==0)) begin
						
					if(key == 4'b0010) nextState <= S3;
					else nextState <= S8; end
						
				else nextState <= S2;
			
			S3: 
				if(PressedKey && (DoorSw==0)) begin
						
					if(key == 4'b0000) nextState <= S4;						
					else nextState <= S5; end
		
				else nextState <= S3;
			
			S4:
				nextState <= S10;
				
			S6: 
				if(PressedKey && (DoorSw==0)) nextState <= S7;
				else nextState <= S6;
			
			S7: 
				if(PressedKey && (DoorSw==0)) nextState <= S8;
				else nextState <= S7;
			
			S8: 
				if(PressedKey && (DoorSw==0)) nextState <= S5;
				else nextState <= S8;
			
			S5:
			   if (tblock < 10) nextState <= S5;
				else nextState <= S0;
				
//			S9:
//			   if(PressedKey) begin
//						
//					if(key == 4'b1001) nextState <= S1;
//					else nextState <= S6;
//				end
//						
//				else nextState <= S0;
				
//			S10:
//			   if (DoorSw) nextState <= S0;
//				else nextState <= S10;
				
		
			default:
				nextState <= S0;
				
		endcase
	end
	
	always_comb begin
	
		case(currentState)
			S0: begin
				OpenDoorLed = 1'b0;
				CloseDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end	
			S1: begin
				OpenDoorLed = 1'b0;
				CloseDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end	
			S2: begin
				OpenDoorLed = 1'b0;
				CloseDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end	
			S3: begin
				OpenDoorLed = 1'b0;
				CloseDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end	
			S4: begin
				OpenDoorLed = 1'b1;
				CloseDoorLed = 1'b0;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b1;
			end	
			S5: begin
				OpenDoorLed = 1'b0;
				CloseDoorLed = 1'b0;
				WrongPWLed = 1'b1;
				OpenDoor = 1'b0;
			end	
			S6: begin
				OpenDoorLed = 1'b0;
				CloseDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end
			S7: begin
				OpenDoorLed = 1'b0;
				CloseDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end
			S8: begin
				OpenDoorLed = 1'b0;
				CloseDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end
//			S9: begin
//				OpenDoorLed = 1'b1;
//				CloseDoorLed = 1'b0;
//				WrongPWLed = 1'b0;
//				OpenDoor = 1'b0;
//			end
			S10: begin
				OpenDoorLed = 1'b1;
				CloseDoorLed = 1'b0;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end
			default: begin
				OpenDoorLed = 1'b0;
				CloseDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end
		
	endcase
	end
	
	always_ff @(posedge clk  ) begin
		if(reset )
			tblock <=0 ;
		else
			if(currentState==S5)
				tblock <= tblock + 1;
			else tblock <=0 ;
	
	end
endmodule