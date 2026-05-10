--------------------- HW1 -----------------------
-- Project Name: Sorting_Sys
-- File Name: item_counter_TB
-- Author: Tomer Rotman
-- Ver: 2.0.0
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
				-- Test Case 1: Count until maximum and check it stays at maximum --
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
				ASSERT (S_item_count = 2**N_const - 1)
				REPORT "FAILED [Case 1.2 - Reaching Upper Limit] Counter does not stay at maximum value."
				SEVERITY ERROR;
				
				-- Test Case 2: Synchronous Reset Count --
				WAIT FOR 10ns;
				S_rst <= '1'; -- Trigger Reset while clock is LOW
				S_count_en <= '0';
				WAIT FOR 5ns;
				ASSERT (S_item_count = 2**N_const - 1)
				REPORT "FAILED [Case 2.1 - Synchronous Reset]: Asynchronous Reset behavior detected."
				SEVERITY ERROR;
				
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
				WAIT FOR 1ns;
				ASSERT (S_item_count = 0)
				REPORT "FAILED [Case 2.2 - Counter Reset to 0]: Counter did not reset on rising edge."
				SEVERITY ERROR;
				
				-- Test Case 3: Priority Check (Reset vs. Enable) --
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
				WAIT FOR 10ns;
				S_count_en <= '1'; -- Try to count while Reset is HIGH
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
				WAIT UNTIL (S_clk'EVENT and S_clk = '1'); -- Wait two rising edges
				WAIT FOR 1ns;
				ASSERT (S_item_count = 0)
				REPORT "FAILED [Case 3 - Reset Priority]: Enable signal overrode the Reset signal."
				SEVERITY ERROR;
				
				-- Test Case 4: Count Disabled --
				WAIT FOR 10ns;
				S_rst <= '0';
				WAIT UNTIL (S_clk'EVENT and S_clk = '1'); -- Count to 1
				WAIT UNTIL (S_clk'EVENT and S_clk = '1'); -- Count to 2
				WAIT FOR 10ns;
				S_count_en <= '0'; -- Disable Count
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
				WAIT FOR 1ns;
				ASSERT (S_item_count = 2)
				REPORT "FAILED [Case 4 - Disable Count]: Counter continued counting while Enable signal was LOW."
				SEVERITY ERROR;
				
				REPORT "ALL TEST CASES COMPLETED";
				WAIT; -- Freeze
		END PROCESS;
		
END behavior;