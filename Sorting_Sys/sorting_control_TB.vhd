--------------- HW2 ---------------
-- Project Name: Sorting_Sys
-- File Name: sorting_control_TB.vhd
-- Author: Daniel Feldman
-- Ver: 1.0.0
-- Created Date: 10/05/2026
------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY sorting_control_TB IS
END sorting_control_TB;

ARCHITECTURE behavior of sorting_control_TB IS
	COMPONENT sorting_control
		PORT(
			clk : IN std_logic;
			rst : IN std_logic;
			item_present : IN std_logic;
			valid_item : IN std_logic;
			can_sort : IN std_logic;
			enable_sort : OUT std_logic;
			count_en : OUT std_logic
		);
	END COMPONENT;
	
	SIGNAL S_clk          : std_logic := '0';
	SIGNAL S_rst          : std_logic := '0';
	SIGNAL S_item_present : std_logic := '0';
	SIGNAL S_valid_item   : std_logic := '0';
	SIGNAL S_can_sort     : std_logic := '0';
	SIGNAL S_enable_sort  : std_logic;
	SIGNAL S_count_en     : std_logic;
	
	constant clk_period : time := 20 ns;
	
BEGIN
	DUT: sorting_control
	PORT MAP(
		clk => S_clk,
		rst => S_rst,
		item_present => S_item_present,
		valid_item => S_valid_item,
		can_sort => S_can_sort,
		enable_sort => S_enable_sort,
		count_en => S_count_en
	);
	
	S_clk <= NOT S_clk AFTER clk_period/2;
	
	PROCESS
	BEGIN
		S_rst <= '1';
		WAIT FOR clk_period*2; 
		S_rst <= '0';
		WAIT FOR clk_period;
		
		---------------------------------------------------------
		-- TC1: Normal path - Valid item and system ready (IDLE->CHECK->SORT->WAIT_CLEAR->IDLE)
		---------------------------------------------------------
		S_item_present <= '1';
		S_valid_item <= '1';
		S_can_sort <= '1';
		
		WAIT UNTIL rising_edge(S_clk);
		WAIT FOR 2 ns;
		
		-- Now in CHECK state. Wait for another clock edge to transition to SORT.
		WAIT UNTIL rising_edge(S_clk);
		WAIT FOR 2 ns;

		ASSERT (S_enable_sort = '1' AND S_count_en = '1') 
		REPORT "TC1 FAILED: Expected both outputs to be 1 in SORT state"
		SEVERITY ERROR;

		-- Automatic transition to WAIT_CLEAR
		WAIT UNTIL rising_edge(S_clk);
		WAIT FOR 2 ns;
		
		ASSERT (S_enable_sort = '0' AND S_count_en = '0') 
		REPORT "TC1 FAILED: Outputs should be 0 in WAIT_CLEAR"
		SEVERITY ERROR;
		
		-- Remove item from conveyor and return to IDLE
		S_item_present <= '0';
		WAIT FOR clk_period * 2;
		
		---------------------------------------------------------
		-- TC2: Invalid item - Sort but do not count
		---------------------------------------------------------
		S_item_present <= '1';
		S_valid_item <= '0'; -- Invalid item!
		S_can_sort <= '1';
		
		WAIT UNTIL rising_edge(S_clk); -- Transitions to CHECK
		WAIT UNTIL rising_edge(S_clk); -- Transitions to SORT
		WAIT FOR 2 ns;
		
		ASSERT (S_enable_sort = '1' AND S_count_en = '0') 
		REPORT "TC2 FAILED: Expected enable_sort=1 but count_en=0 for invalid item"
		SEVERITY ERROR;

		S_item_present <= '0';
		WAIT FOR clk_period * 3;

		---------------------------------------------------------
		-- TC3: Item leaves before sorting (IDLE->CHECK->IDLE)
		---------------------------------------------------------
		S_item_present <= '1';
		S_can_sort <= '0'; -- Sorting system busy, cannot sort
		
		WAIT UNTIL rising_edge(S_clk); -- Transitions to CHECK
		WAIT FOR 2 ns;
		
		S_item_present <= '0'; -- Item removed from conveyor early
		WAIT UNTIL rising_edge(S_clk); -- Returns to IDLE
		WAIT FOR 2 ns;
		
		ASSERT (S_enable_sort = '0') 
		REPORT "TC3 FAILED: System sorted an item that left early"
		SEVERITY ERROR;
		
		WAIT; 
	END PROCESS;
END behavior;