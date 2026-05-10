--------------- HW2 ---------------
-- Project Name: Sorting_Sys
-- File Name: sorting_control.vhd
-- Author: Daniel Feldman
-- Ver: 1.0.0
-- Created Date: 10/05/2026
------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY sorting_control IS
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		item_present : IN std_logic;
		valid_item : IN std_logic;
		can_sort : IN std_logic;
		enable_sort : OUT std_logic;
		count_en : OUT std_logic
	);
END sorting_control;

ARCHITECTURE behavior of sorting_control IS
	TYPE state IS (IDLE, CHECK, SORT, WAIT_CLEAR);
	SIGNAL cur_state, next_state : state;
BEGIN
	COMB: PROCESS(cur_state, item_present, can_sort, valid_item)
	BEGIN
		enable_sort <= '0';
		count_en <= '0';
		next_state <= cur_state; 

		CASE cur_state IS
			WHEN IDLE => 
				IF (item_present = '1') THEN
					next_state <= CHECK;
				END IF;
								
			WHEN CHECK => 
				IF (item_present = '0') THEN
					next_state <= IDLE;
				ELSIF (can_sort = '1') THEN
					next_state <= SORT;
				END IF;
									
			WHEN SORT => 
				enable_sort <= '1';
				count_en <= valid_item;
				next_state <= WAIT_CLEAR;
								
			WHEN WAIT_CLEAR => 
				IF (item_present = '0') THEN
					next_state <= IDLE;
				END IF;
									
			WHEN OTHERS => 
				next_state <= IDLE;
		END CASE;
	END PROCESS;
	
	SYNC: PROCESS(clk, rst)
	BEGIN
		IF (rst = '1') THEN
			cur_state <= IDLE;
		ELSIF rising_edge(clk) THEN
			cur_state <= next_state;
		END IF;
	END PROCESS;
END behavior;