--------------------- HW1 -----------------------
-- Project Name: Sorting_Sys
-- File Name: output_driver
-- Author: Tomer Rotman
-- Ver: 1.0.0
-- Created Date: 02/05/2026
-------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY output_driver IS
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
END output_driver;

ARCHITECTURE behavior OF output_driver IS
	SIGNAL input  : std_logic_vector(3 DOWNTO 0);
	SIGNAL output : std_logic_vector (3 DOWNTO 0);

	BEGIN
		input <= enable_sort & go_left & go_right & go_reject; -- Concatante input into a 4-bit vector
		
		WITH input SELECT
			output <= "1100" when "1100",
						 "1010" when "1010",
						 "1001" when "1001",
						 "0000" when others; -- Disable driver for all other combinations
						 
		conveyor_on  <= output(3);
		divert_left  <= output(2);
		divert_right <= output(1);
		reject_ack   <= output(0);

END behavior;