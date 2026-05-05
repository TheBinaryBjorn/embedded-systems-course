--------------- hw1 ---------------
-- Project Name: hw1
-- File Name: path_selector.vhd
-- Author: Daniel Feldman
-- Ver: 0.0.1
-- Created Date: 03/05/2026
------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY path_selector IS
	PORT(
		target_code : IN std_logic_vector(1 DOWNTO 0);
		left_free : IN std_logic;
		right_free : IN std_logic;
		can_sort : OUT std_logic;
		go_left : OUT std_logic;
		go_right : OUT std_logic;
		go_reject : OUT std_logic
	);
END path_selector;

ARCHITECTURE behavior of path_selector IS
BEGIN
	PROCESS(target_code, left_free, right_free)
	BEGIN
		-- Check left: 00
		IF target_code = "00" THEN
			go_left <= '1';
			go_right <= '0';
			go_reject <= '0';
			IF left_free = '1' THEN
				can_sort <= '1';
			ELSE
				can_sort <= '0';
			END IF;
		
		-- Check Right: 01
		ELSIF target_code = "01" THEN
			go_left <= '0';
			go_right <= '1';
			go_reject <= '0';
			IF right_free = '1' THEN
				can_sort <= '1';
			ELSE
				can_sort <= '0';
			END IF;
		
		-- Check reject: 10 and others
		ELSE
			go_left <= '0';
			go_right <= '0';
			go_reject <= '1';
			can_sort <= '1';	
		END IF;
	END PROCESS;
END behavior;