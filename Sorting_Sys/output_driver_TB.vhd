--------------------- HW1 -----------------------
-- Project Name: Sorting_Sys
-- File Name: output_driver_TB
-- Author: Tomer Rotman
-- Ver: 1.0.0
-- Created Date: 02/05/2026
-------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY output_driver_TB IS
END output_driver_TB;

ARCHITECTURE behavior OF output_driver_TB IS
	
	COMPONENT output_driver
	PORT(
		  enable_sort  : IN std_logic;
		  go_left	   : IN std_logic;
		  go_right	   : IN std_logic;
		  go_reject	   : IN std_logic;
		  conveyor_on  : OUT std_logic;
		  divert_left  : OUT std_logic;
		  divert_right : OUT std_logic;
		  reject_ack	: OUT std_logic
	);
	END COMPONENT;
	

	SIGNAL input  : std_logic_vector(3 DOWNTO 0);
	SIGNAL output : std_logic_vector(3 DOWNTO 0);
	
	BEGIN
		DUT : output_driver
		PORT MAP(
					enable_sort  => input(3),
					go_left 		 => input(2),
					go_right		 => input(1),
					go_reject	 => input(0),
					conveyor_on  => output(3),
					divert_left  => output(2),
					divert_right => output(1),
					reject_ack	 => output(0)
		);
		
		PROCESS -- Scripting test cases sequentially to maintain code readability
			BEGIN
				-- Test Case 1: Sort Disabled --
				input <= "0000";
				WAIT FOR 50 ns;
				ASSERT (output = "0000")
				REPORT "FAILED [Case 1.1 - All Low]: Output is not IDLE."
				SEVERITY ERROR;
				
				input <= "0100"; -- Try Left
				WAIT FOR 50 ns;
				ASSERT (output = "0000")
				REPORT "FAILED [Case 1.2 - Left Attempted while Sort Disabled]: Output is not IDLE."
				SEVERITY ERROR;
				
				-- Test Case 2: Sort Enabled, Directions Disabled --
				input <= "1000";
				WAIT FOR 50 ns;
				ASSERT (output = "0000")
				REPORT "FAILED [Case 2 - No Directions are Set]: Output is not IDLE."
				SEVERITY ERROR;
				
				-- Test Case 3: Sort Enabled --
				input <= "1001"; -- Try Reject
				WAIT FOR 50 ns;
				ASSERT (output = "1001")
				REPORT "FAILED [Case 3.1 - Reject]: Expected 1001."
				SEVERITY ERROR;
				
				input <= "1010"; -- Try Right
				WAIT FOR 50 ns;
				ASSERT (output = "1010")
				REPORT "FAILED [Case 3.2 - Right]: Expected 1010."
				SEVERITY ERROR;
				
				
				input <= "1100"; -- Try Left
				WAIT FOR 50 ns;
				ASSERT (output = "1100")
				REPORT "FAILED [Case 3.3 - Left]: Expected 1100."
				SEVERITY ERROR;
				
				-- Test Case 4: Sort Enabled, Two or More Directions Enabled --
				input <= "1011";
				WAIT FOR 50 ns;
				ASSERT (output = "0000")
				REPORT "FAILED [Case 4 - Two or More Directions Enabled]: Output is not IDLE."
				SEVERITY ERROR;
				
				REPORT "ALL TEST CASES COMPLETED"
				SEVERITY NOTE;
				
				WAIT; -- Freeze
		END PROCESS;
			

END behavior;