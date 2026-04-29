--------------------- HW1 ---------------------
-- Project Name: hw1
-- File Name: type_decoder
-- Author: Daniel Feldman
-- Ver: 0.0.1
-- Created Date: 29/04/2026
-----------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY type_decoder IS
	PORT(
		item_type : IN std_logic_vector(1 DOWNTO 0);
		target_code : OUT std_logic_vector(1 DOWNTO 0);
		valid_item : OUT std_logic
	);
END type_decoder;
-- target_code: LEFT = 00, RIGHT = 01, FAIL = 10
ARCHITECTURE behavior OF type_decoder IS
BEGIN
	WITH item_type SELECT
		target_code <= "00" WHEN "00", -- LEFT
							"01" WHEN "01", -- RIGHT
							"01" WHEN "10", -- RIGHT
							"10" WHEN OTHERS; -- FAIL
							
	WITH item_type SELECT	
		valid_item <= '1' WHEN "00", -- VALID
						  '1' WHEN "01", -- VALID
						  '1' WHEN "10", -- VALID
						  '0' WHEN OTHERS; -- INVALID
						  
END behavior;