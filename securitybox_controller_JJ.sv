module securitybox_controller_JJ(Clk, Reset, Key, PressedKey, DoorSw, OpenDoor, OpenDoorLed, ClosedDoorLed, WrongPWLed);
	
	input logic Clk;
	input logic Reset;
	input logic [3:0] Key;
	input logic PressedKey, DoorSw;
	output logic OpenDoor;
	output logic OpenDoorLed, ClosedDoorLed;
	output logic WrongPWLed;
	
	localparam logic[3:0] D1=4'b1001,D2=4'b0101,D3=4'b0010,D4=4'b0000;
	localparam logic[3:0] twait=4'b0101;
	typedef enum logic [3:0] {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10} State;
	
	reg [3:0] tblock;
	State currentState, nextState;
	
	always_ff @(posedge Reset, posedge Clk) begin
	
		if(Reset)
			currentState <= S0;
		else
			currentState <= nextState;
	
	end
	
	always_comb begin
	
	
	
		case(currentState)
			
			S0:		
				if(PressedKey) begin
						
					if(Key == D1) nextState <= S1;	
					else nextState <= S6; end
						
				else 	nextState <= S0;
			
			S1: 
				if(PressedKey && (DoorSw==0)) begin  //necesito doorsw?
						
					if(Key == D2) nextState <= S2;			
					else nextState <= S7; end
					
				else nextState <= S1;
			
			S2: 
				if(PressedKey && (DoorSw==0)) begin
						
					if(Key == D3) nextState <= S3;
					else nextState <= S8; end
						
				else nextState <= S2;
			
			S3: 
				if(PressedKey && (DoorSw==0)) begin
						
					if(Key == D4) nextState <= S4;						
					else nextState <= S5; end
		
				else nextState <= S3;
			
			S4:
				if(DoorSw==1) nextState <= S0;
				else nextState <= S10;
				
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
			   if (4 > tblock) nextState <= S5;
				else nextState <= S0;
				
//			S9:
//			   if(PressedKey) begin
//						
//					if(key == 4'b1001) nextState <= S1;
//					else nextState <= S6;
//				end
//						
//				else nextState <= S0;
				
			S10:
			   if (DoorSw) nextState <= S0;
				else nextState <= S10;
				
		
			default:
				nextState <= S0;
				
		endcase
	end
	
	always_comb begin
	
		case(currentState)
			S0: begin
				OpenDoorLed = 1'b0;
				ClosedDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end	
			S1: begin
				OpenDoorLed = 1'b0;
				ClosedDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end	
			S2: begin
				OpenDoorLed = 1'b0;
				ClosedDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end	
			S3: begin
				OpenDoorLed = 1'b0;
				ClosedDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end	
			S4: begin
				OpenDoorLed = 1'b1;
				ClosedDoorLed = 1'b0;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b1;
			end	
			S5: begin
				OpenDoorLed = 1'b0;
				ClosedDoorLed = 1'b0;
				WrongPWLed = 1'b1;
				OpenDoor = 1'b0;
			end	
			S6: begin
				OpenDoorLed = 1'b0;
				ClosedDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end
			S7: begin
				OpenDoorLed = 1'b0;
				ClosedDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end
			S8: begin
				OpenDoorLed = 1'b0;
				ClosedDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end
			S10: begin
				OpenDoorLed = 1'b1;
				ClosedDoorLed = 1'b0;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end
			default: begin
				OpenDoorLed = 1'b0;
				ClosedDoorLed = 1'b1;
				WrongPWLed = 1'b0;
				OpenDoor = 1'b0;
			end
		
	endcase
	end
	
	always_ff @(posedge Clk) begin
		if(Reset )
			tblock <=0 ;
		else
			if(currentState==S5)
				tblock <= tblock + 1;
			else tblock <=0 ;
	
	end
endmodule

module test_bench();

	logic Clk, Reset;
	logic [3:0] Key;
	logic PressedKey, DoorSw, OpenDoor;
	logic OpenDoorLed, ClosedDoorLed, WrongPWLed;
	
	securitybox_controller_JJ aghhhhh(Clk, Reset, Key, PressedKey, DoorSw, OpenDoor, OpenDoorLed, ClosedDoorLed, WrongPWLed);
	
	initial begin 
		Clk = 1;
		DoorSw=0;
		PressedKey=0;
		Key=0000;
		Reset = 1;#2ms;
		Reset = 0;#2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b1001; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0101; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0010; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0000; #2ms;
		DoorSw = 0; #3ms;
		DoorSw = 1; #3ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b1001; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0101; #2ms;
		PressedKey = 0; DoorSw = 0; Key = 4'b1001; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0001; #2ms;
		
		PressedKey = 1; DoorSw = 0; Key = 4'b1001; #8ms;
		
		PressedKey = 1; DoorSw = 0; Key = 4'b1001; #4ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b1000; #10ms;
		
		PressedKey = 1; DoorSw = 0; Key = 4'b1001; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0111; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0010; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0000; #2ms;
		
		PressedKey = 1; DoorSw = 0; Key = 4'b1001; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0101; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0010; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0000; #2ms;
		
		PressedKey = 1; DoorSw = 0; Key = 4'b1001; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0101; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0010; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0000; #2ms;
		
		PressedKey = 1; DoorSw = 0; Key = 4'b1001; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0101; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0010; #2ms;
		PressedKey = 1; DoorSw = 0; Key = 4'b0000; #3ms;
		DoorSw = 1; #3ms;
		
		
		$stop;
	end
	
	always #1ms Clk =  ~Clk;
	
endmodule
