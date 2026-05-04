--------------------- HW1 -----------------------
-- Project Name: Sorting_Sys
-- File Name: item_counter_TB
-- Author: Tomer Rotman
-- Ver: 1.0.0
-- Created Date: 02/05/2026
-------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY item_counter_TB IS
END item_counter_TB;

ARCHITECTURE behavior OF item_counter_TB IS

	CONSTANT N_const : integer := 4;
	COMPONENT item_counter
	GENERIC(N : integer);
	PORT(
		  clk		 	 : IN std_logic;
		  rst		 	 : IN std_logic;
		  count_en 	 : IN std_logic;
		  item_count : OUT std_logic_vector(N-1 DOWNTO 0)
	);
	END COMPONENT;
	
	SIGNAL S_clk 		  : std_logic := '0';
	SIGNAL S_rst 		  : std_logic := '0';
	SIGNAL S_count_en   : std_logic := '0';
	SIGNAL S_item_count : std_logic_vector(N_const-1 DOWNTO 0) := (OTHERS => '0');
	
	BEGIN
		DUT : item_counter
		GENERIC MAP (N => N_const)
		PORT MAP(
					clk 		  => S_clk,
					rst 		  => S_rst,
					count_en   => S_count_en,
					item_count => S_item_count
		);
		
		S_clk <= not S_clk AFTER 10ns; -- 50MHz Infinite Clock
		
		PROCESS -- Scripting test cases sequentially to maintain code readability
			BEGIN
				-- Test Case 1: Count until maximum and check it goes back to 0 --
				S_count_en <= '1';
				FOR i IN 1 TO (2**N_const - 1) LOOP
					WAIT UNTIL (S_clk'EVENT and S_clk = '1');
					WAIT FOR 1ns;
					ASSERT(S_item_count = i)
					REPORT "FAILED [Case 1.1 - Count]: Unexpected value at step " & integer'IMAGE(i) & "."
					SEVERITY ERROR;
				END LOOP;
			
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
				WAIT FOR 1ns;
				ASSERT (S_item_count = 0)
				REPORT "FAILED [Case 1.2 - Reaching Upper Limit] Counter did not return to 0 after reaching maximum."
				SEVERITY ERROR;
				
				-- Test Case 2: Count Disabled --
				WAIT UNTIL (S_clk'EVENT and S_clk = '1'); -- Count to 1
				WAIT UNTIL (S_clk'EVENT and S_clk = '1'); -- Count to 2
				S_count_en <= '0'; -- Disable Count
				WAIT FOR 35ns;
				ASSERT (S_item_count = 2)
				REPORT "FAILED [Case 2 - Disable Count]: Counter continued counting while Enable signal was LOW."
				SEVERITY ERROR;
				
				-- Test Case 3: Synchronous Reset Count --
				WAIT FOR 20ns;
				S_rst <= '1'; -- Trigger Reset while clock is LOW
				WAIT FOR 5ns;
				ASSERT (S_item_count = 2)
				REPORT "FAILED [Case 3.1 - Synchronous Reset]: Counter reset immediately (Asynchronous behavior detected)."
				SEVERITY ERROR;
				
				WAIT FOR 5ns; -- Rising Edge
				ASSERT (S_item_count = 0)
				REPORT "FAILED [Case 3.2 - Counter Reset to 0]: Counter did not reset on rising edge."
				SEVERITY ERROR;
				
				-- Test Case 4: Priority Check (Reset vs. Enable) --
				S_count_en <= '1'; -- Try to count while Reset is HIGH
				WAIT FOR 40ns; -- Wait two clock cycles
				ASSERT (S_item_count) = 0
				REPORT "FAILED [Case 4 - Reset Priority]: Enable signal overrode the Reset signal."
				SEVERITY ERROR;
				
				S_rst <= '0';
				S_count_en <= '0';
				
				REPORT "ALL TEST CASES COMPLETED";
				WAIT; -- Freeze
		END PROCESS;
		
END behavior;