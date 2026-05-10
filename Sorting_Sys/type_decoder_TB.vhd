--------------------- HW1 ---------------------
-- Project Name: Sorting_Sys
-- File Name: type_decoder_TB.vhd
-- Author: Daniel Feldman
-- Ver: 0.0.1
-- Created Date: 29/04/2026
-----------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY type_decoder_TB IS
END type_decoder_TB;

ARCHITECTURE behavior of type_decoder_TB IS
	COMPONENT type_decoder
		PORT(
			item_type : IN std_logic_vector(1 DOWNTO 0);
			target_code : OUT std_logic_vector(1 DOWNTO 0);
			valid_item : OUT std_logic
		);
	END COMPONENT;
	SIGNAL S_item_type : std_logic_vector(1 DOWNTO 0) := "00";
	SIGNAL S_target_code : std_logic_vector(1 DOWNTO 0) := "00";
	SIGNAL S_valid_item : std_logic := '0';
BEGIN
	DUT: type_decoder
	PORT MAP(
		item_type => S_item_type,
		target_code => S_target_code,
		valid_item => S_valid_item
	);

	PROCESS
	BEGIN
		-- target_code: LEFT = 00, RIGHT = 01, FAIL = 10
		
		-- TC1: S_item_type = "00"
		-- Expected: S_target_code = "00", S_valid_item = '1'
		S_item_type <= "00";
		WAIT FOR 10 ns;
		
		ASSERT (S_target_code = "00" AND S_valid_item = '1')
		REPORT "TC1 Failed: Expected: S_target_code = 00, S_valid_item = 1"
		SEVERITY ERROR;
		
		-- TC2: S_item_type = "01"
		-- Expected: S_target_code = "01", S_valid_item = '1'
		S_item_type <= "01";
		WAIT FOR 10 ns;
		
		ASSERT (S_target_code = "01" AND S_valid_item = '1')
		REPORT "TC2 Failed: Expected: S_target_code = 01, S_valid_item = '1'"
		SEVERITY ERROR;
		
		-- TC3: S_item_type = "10"
		-- Expected: S_target_code = "01", S_valid_item = '1'
		S_item_type <= "10";
		WAIT FOR 10 ns;
		
		ASSERT (S_target_code = "01" AND S_valid_item = '1')
		REPORT "TC3 Failed: Expected: S_target_code = 01, S_valid_item = '1'"
		SEVERITY ERROR;
		
		-- TC4: S_item_type = "11"
		-- Expected: S_target_code = "10", S_valid_item = '0'
		S_item_type <= "11";
		WAIT FOR 10 ns;
		
		ASSERT (S_target_code = "10" AND S_valid_item = '0')
		REPORT "TC4 Failed: Expected: S_target_code = 10, S_valid_item = '0'"
		SEVERITY ERROR;
		
		-- TC5: S_item_type = "XX"
		-- Expected: S_target_code = "10", S_valid_item = '0'
		S_item_type <= "XX";
		WAIT FOR 10 ns;
		
		ASSERT (S_target_code = "10" AND S_valid_item = '0')
		REPORT "TC5 Failed: Expected: S_target_code = 10, S_valid_item = '0'"
		SEVERITY ERROR;
		
		REPORT "Test Simulation Complete, check console above for any ERROR messages."
		SEVERITY NOTE;
		WAIT;
	END PROCESS;
END behavior;