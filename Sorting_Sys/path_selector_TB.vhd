--------------- HW1 ---------------
-- Project Name: Sorting_Sys
-- File Name: path_selector_TB.vhd
-- Author: Daniel Feldman
-- Ver: 0.0.1
-- Created Date: 03/05/2026
------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY path_selector_TB IS
END path_selector_TB;

ARCHITECTURE behavior of path_selector_TB IS
	COMPONENT path_selector
		PORT(
			target_code : IN std_logic_vector(1 DOWNTO 0);
			left_free : IN std_logic;
			right_free : IN std_logic;
			can_sort : OUT std_logic;
			go_left : OUT std_logic;
			go_right : OUT std_logic;
			go_reject : OUT std_logic
		);
	END COMPONENT;
	
	SIGNAL S_target_code : std_logic_vector(1 DOWNTO 0) := "00";
	SIGNAL S_left_free : std_logic := '0';
	SIGNAL S_right_free : std_logic := '0';
	SIGNAL S_can_sort : std_logic;
	SIGNAL S_go_left : std_logic;
	SIGNAL S_go_right : std_logic;
	SIGNAL S_go_reject : std_logic;
	
BEGIN
	DUT: path_selector
	PORT MAP(
		target_code => S_target_code,
		left_free => S_left_free,
		right_free => S_right_free,
		can_sort => S_can_sort,
		go_left => S_go_left,
		go_right => S_go_right,
		go_reject => S_go_reject
	);
	-- target_code: LEFT = 00, RIGHT = 01, FAIL = 10 and others
	PROCESS
	BEGIN
		-- LEFT: Target Code - 00
		
		-- TC1: target_code = "00", left_free = '0', right_free = '0'
		-- Expected: can_sort = '0', go_left = '1', go_right = '0', go_reject = '0'
		S_target_code <= "00";
		S_left_free <= '0';
		S_right_free <= '0';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '0' AND S_go_left = '1' AND S_go_right = '0' AND S_go_reject = '0')
		REPORT "TC1 Failed: Expected: can_sort = '0', go_left = '1', go_right = '0', go_reject = '0'"
		SEVERITY ERROR;
		
		-- TC2: target_code = "00", left_free = '1', right_free = '0'
		-- Expected: can_sort = '1', go_left = '1', go_right = '0', go_reject = '0'
		S_target_code <= "00";
		S_left_free <= '1';
		S_right_free <= '0';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '1' AND S_go_right = '0' AND S_go_reject = '0')
		REPORT "TC2 Failed: Expected: can_sort = '1', go_left = '1', go_right = '0', go_reject = '0'"
		SEVERITY ERROR;
		
		-- TC3: target_code = "00", left_free = '0', right_free = '1'
		-- Expected: can_sort = '0', go_left = '1', go_right = '0', go_reject = '0'
		S_target_code <= "00";
		S_left_free <= '0';
		S_right_free <= '1';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '0' AND S_go_left = '1' AND S_go_right = '0' AND S_go_reject = '0')
		REPORT "TC3 Failed: Expected: can_sort = '0', go_left = '1', go_right = '0', go_reject = '0'"
		SEVERITY ERROR;
		
		-- TC4: target_code = "00", left_free = '1', right_free = '1'
		-- Expected: can_sort = '1', go_left = '1', go_right = '0', go_reject = '0'
		S_target_code <= "00";
		S_left_free <= '1';
		S_right_free <= '1';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '1' AND S_go_right = '0' AND S_go_reject = '0')
		REPORT "TC4 Failed: Expected: can_sort = '1', go_left = '1', go_right = '0', go_reject = '0'"
		SEVERITY ERROR;
		
		
		
		-- RIGHT: Target Code - 01
		
		-- TC5: target_code = "01", left_free = '0', right_free = '0'
		-- Expected: can_sort = '0', go_left = '0', go_right = '1', go_reject = '0'
		S_target_code <= "01";
		S_left_free <= '0';
		S_right_free <= '0';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '0' AND S_go_left = '0' AND S_go_right = '1' AND S_go_reject = '0')
		REPORT "TC5 Failed: Expected: can_sort = '0', go_left = '0', go_right = '1', go_reject = '0'"
		SEVERITY ERROR;
		
		-- TC6: target_code = "01", left_free = '1', right_free = '0'
		-- Expected: can_sort = '0', go_left = '0', go_right = '1', go_reject = '0'
		S_target_code <= "01";
		S_left_free <= '1';
		S_right_free <= '0';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '0' AND S_go_left = '0' AND S_go_right = '1' AND S_go_reject = '0')
		REPORT "TC6 Failed: Expected: can_sort = '0', go_left = '0', go_right = '1', go_reject = '0'"
		SEVERITY ERROR;
		
		-- TC7: target_code = "01", left_free = '0', right_free = '1'
		-- Expected: can_sort = '1', go_left = '0', go_right = '1', go_reject = '0'
		S_target_code <= "01";
		S_left_free <= '0';
		S_right_free <= '1';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '1' AND S_go_reject = '0')
		REPORT "TC7 Failed: Expected: can_sort = '1', go_left = '0', go_right = '1', go_reject = '0'"
		SEVERITY ERROR;
		
		-- TC8: target_code = "01", left_free = '1', right_free = '1'
		-- Expected: can_sort = '1', go_left = '0', go_right = '1', go_reject = '0'
		S_target_code <= "01";
		S_left_free <= '1';
		S_right_free <= '1';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '1' AND S_go_reject = '0')
		REPORT "TC8 Failed: Expected: can_sort = '1', go_left = '0', go_right = '1', go_reject = '0'"
		SEVERITY ERROR;
		
		
		
		-- REJECT: Target Code - 10
		
		-- TC9: target_code = "10", left_free = '0', right_free = '0'
		-- Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'
		S_target_code <= "10";
		S_left_free <= '0';
		S_right_free <= '0';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '0' AND S_go_reject = '1')
		REPORT "TC9 Failed: Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'"
		SEVERITY ERROR;
		
		-- TC10: target_code = "10", left_free = '1', right_free = '0'
		-- Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'
		S_target_code <= "10";
		S_left_free <= '1';
		S_right_free <= '0';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '0' AND S_go_reject = '1')
		REPORT "TC10 Failed: Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'"
		SEVERITY ERROR;
		
		-- TC11: target_code = "10", left_free = '0', right_free = '1'
		-- Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'
		S_target_code <= "10";
		S_left_free <= '0';
		S_right_free <= '1';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '0' AND S_go_reject = '1')
		REPORT "TC11 Failed: Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'"
		SEVERITY ERROR;
		
		-- TC12: target_code = "10", left_free = '1', right_free = '1'
		-- Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'
		S_target_code <= "10";
		S_left_free <= '1';
		S_right_free <= '1';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '0' AND S_go_reject = '1')
		REPORT "TC12 Failed: Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'"
		SEVERITY ERROR;
		

		
		-- REJECT: Target Code - 11
		
		-- TC13: target_code = "11", left_free = '0', right_free = '0'
		-- Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'
		S_target_code <= "11";
		S_left_free <= '0';
		S_right_free <= '0';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '0' AND S_go_reject = '1')
		REPORT "TC13 Failed: Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'"
		SEVERITY ERROR;
		
		-- TC14: target_code = "11", left_free = '1', right_free = '0'
		-- Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'
		S_target_code <= "11";
		S_left_free <= '1';
		S_right_free <= '0';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '0' AND S_go_reject = '1')
		REPORT "TC14 Failed: Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'"
		SEVERITY ERROR;
		
		-- TC15: target_code = "11", left_free = '0', right_free = '1'
		-- Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'
		S_target_code <= "11";
		S_left_free <= '0';
		S_right_free <= '1';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '0' AND S_go_reject = '1')
		REPORT "TC15 Failed: Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'"
		SEVERITY ERROR;
		
		-- TC16: target_code = "11", left_free = '1', right_free = '1'
		-- Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'
		S_target_code <= "11";
		S_left_free <= '1';
		S_right_free <= '1';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '0' AND S_go_reject = '1')
		REPORT "TC16 Failed: Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'"
		SEVERITY ERROR;
		

		
		-- REJECT: Target Code - XX
		
		-- TC17: target_code = "XX", left_free = '0', right_free = '0'
		-- Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'
		S_target_code <= "XX";
		S_left_free <= '0';
		S_right_free <= '0';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '0' AND S_go_reject = '1')
		REPORT "TC17 Failed: Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'"
		SEVERITY ERROR;
		
		-- TC18: target_code = "XX", left_free = '1', right_free = '0'
		-- Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'
		S_target_code <= "XX";
		S_left_free <= '1';
		S_right_free <= '0';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '0' AND S_go_reject = '1')
		REPORT "TC18 Failed: Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'"
		SEVERITY ERROR;
		
		-- TC19: target_code = "XX", left_free = '0', right_free = '1'
		-- Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'
		S_target_code <= "XX";
		S_left_free <= '0';
		S_right_free <= '1';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '0' AND S_go_reject = '1')
		REPORT "TC19 Failed: Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'"
		SEVERITY ERROR;
		
		-- TC20: target_code = "XX", left_free = '1', right_free = '1'
		-- Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'
		S_target_code <= "XX";
		S_left_free <= '1';
		S_right_free <= '1';
		WAIT FOR 10 ns;
		
		ASSERT(S_can_sort = '1' AND S_go_left = '0' AND S_go_right = '0' AND S_go_reject = '1')
		REPORT "TC20 Failed: Expected: can_sort = '1', go_left = '0', go_right = '0', go_reject = '1'"
		SEVERITY ERROR;
		
		REPORT "Test Simulation Complete, check console above for any ERROR messages."
		SEVERITY NOTE;
		WAIT;
	END PROCESS;
END behavior;