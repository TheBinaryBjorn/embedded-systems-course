--------------- HW2 ---------------
-- Project Name: Sorting_Sys
-- File Name: automated_sorting_sys_TB.vhd
-- Author: Tomer Rotman
-- Ver: 1.0.0
-- Created Date: 18/05/2026
-----------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY automated_sorting_sys_TB IS
END automated_sorting_sys_TB;

ARCHITECTURE behavior OF automated_sorting_sys_TB IS

	CONSTANT N_const : integer := 4;
	COMPONENT automated_sorting_sys
	GENERIC(N : integer := N_const);
	PORT(
		  clk								 : IN std_logic;
		  rst								 : IN std_logic;
		  ir_sensor, weight_sensor  : IN std_logic;
		  item_type						 : IN std_logic_vector(1 DOWNTO 0);
		  left_free, right_free		 : IN std_logic;
		  ir_clean, weight_clean	 : OUT std_logic;
		  conveyor_on					 : OUT std_logic;
		  divert_left, divert_right : OUT std_logic;
		  reject_ack					 : OUT std_logic;
		  item_count					 : OUT std_logic_vector(N-1 DOWNTO 0)
	);
	END COMPONENT;
	
	SIGNAL S_clk, S_rst 						 : std_logic := '0';
	SIGNAL S_ir_sensor, S_weight_sensor  : std_logic := '0';
	SIGNAL S_left_free, S_right_free 	 : std_logic := '0';
	SIGNAL S_item_type 						 : std_logic_vector(1 DOWNTO 0);
	SIGNAL S_ir_clean, S_weight_clean  	 : std_logic;
   SIGNAL S_conveyor_on                 : std_logic;
   SIGNAL S_divert_left, S_divert_right : std_logic;
   SIGNAL S_reject_ack                  : std_logic;
   SIGNAL S_item_count                  : std_logic_vector(N_const-1 DOWNTO 0);
	
	CONSTANT clk_period : time := 20 ns; -- 50MHz Infinite Clock
	
	-- Conveyor Start Latency: 5 rising edges total
	-- * 3 Rising edges: Filter sensors noise to confirm an item is presence.
	-- * 1 Rising edge : Verify the target destination path is available.
	-- * 1 Rising edge : Send the command to activate the conveyor belt.
	CONSTANT conveyor_start_latency : integer := 5;
	
	BEGIN
		DUT : automated_sorting_sys
		GENERIC MAP (N => N_const)
		PORT MAP(
					clk 		  	  => S_clk,
					rst 		  	  => S_rst,
					ir_sensor  	  => S_ir_sensor,
					weight_sensor => S_weight_sensor,
					left_free	  => S_left_free,
					right_free	  => S_right_free,
					item_type	  => S_item_type,
					ir_clean		  => S_ir_clean,
					weight_clean  => S_weight_clean,
					conveyor_on	  => S_conveyor_on,
					divert_left	  => S_divert_left,
					divert_right  => S_divert_right,
					reject_ack 	  => S_reject_ack,
					item_count    => S_item_count
		);
		
		S_clk <= not S_clk AFTER clk_period/2; 
		
		PROCESS
			BEGIN
			S_left_free <= '1';
			S_right_free <= '1';
			
			-- Test Case 1: Sensors noise while paths are free, making sure they do not start --
			
			-- Noise from weight sensor
			S_ir_sensor <= '0';
			S_weight_sensor <= '1'; 
			S_item_type <= "00";
			FOR i IN 1 to conveyor_start_latency LOOP
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
			END LOOP;
			ASSERT(S_conveyor_on = '0' and S_divert_left = '0')
			REPORT "FAILED [Case 1.1 - Noise from weight sensor]: Conveyor started unexpectedly."
			SEVERITY ERROR;
			
			-- Noise from infra-red sensor
			S_ir_sensor <= '1';
			S_weight_sensor <= '0'; 
			S_item_type <= "00";
			FOR i IN 1 to conveyor_start_latency LOOP
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
			END LOOP;
			ASSERT(S_conveyor_on = '0' and S_divert_left = '0')
			REPORT "FAILED [Case 1.2 - Noise from infra-red sensor]: Conveyor started unexpectedly."
			SEVERITY ERROR;
			
			S_ir_sensor <= '0';
			
			-- Test Case 2: Transferring Items While Paths Free --
			
			WAIT FOR clk_period - 1 ns;
			
			-- Left Path
			S_ir_sensor <= '1';
			S_weight_sensor <= '1';
			FOR i IN 1 to 3 LOOP
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
			END LOOP;
			WAIT FOR 1 ns;
			ASSERT(S_ir_clean = '1' and S_weight_clean = '1')
			REPORT "FAILED [Case 2.1 - Transferring Item to Left Path]: Clean flags not triggered."
			SEVERITY ERROR;
			FOR i IN 1 to 2 LOOP
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
			END LOOP;
			WAIT FOR 1 ns;
			ASSERT(S_conveyor_on = '1' and S_divert_left = '1')
			REPORT "FAILED [Case 2.1 - Transferring Item to Left Path]: Conveyor not on or the path taken was incorrect."
			SEVERITY ERROR;
			S_left_free <= '0';
			S_ir_sensor <= '0';
			S_weight_sensor <= '0';
			WAIT FOR clk_period;
			ASSERT(S_item_count = "0001")
			REPORT "FAILED [Case 2.1 - Transferring Item to Left Path]: Item passed not counted."
			SEVERITY ERROR;
			
			WAIT FOR clk_period - 1 ns;
			
			-- Right Path
			S_item_type <= "01";
			S_ir_sensor <= '1';
			S_weight_sensor <= '1';
			FOR i IN 1 to 3 LOOP
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
			END LOOP;
			WAIT FOR 1 ns;
			ASSERT(S_ir_clean = '1' and S_weight_clean = '1')
			REPORT "FAILED [Case 2.2 - Transferring Item to Right Path]: Clean flags not triggered."
			SEVERITY ERROR;
			FOR i IN 1 to 2 LOOP
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
			END LOOP;
			WAIT FOR 1 ns;
			ASSERT(S_conveyor_on = '1' and S_divert_right = '1')
			REPORT "FAILED [Case 2.2 - Transferring Item to Right Path]: Conveyor not on or the path taken was incorrect."
			SEVERITY ERROR;
			S_right_free <= '0';
			S_ir_sensor <= '0';
			S_weight_sensor <= '0';
			WAIT FOR clk_period;
			ASSERT(S_item_count = "0010")
			REPORT "FAILED [Case 2.2 - Transferring Item to Right Path]: Item passed not counted."
			SEVERITY ERROR;
			
			WAIT FOR clk_period - 1 ns;
			
			S_right_free <= '1';
			S_item_type <= "10";
			S_ir_sensor <= '1';
			S_weight_sensor <= '1';
			FOR i IN 1 to 3 LOOP
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
			END LOOP;
			WAIT FOR 1 ns;
			ASSERT(S_ir_clean = '1' and S_weight_clean = '1')
			REPORT "FAILED [Case 2.3 - Transferring Item to Right Path]: Clean flags not triggered."
			SEVERITY ERROR;
			FOR i IN 1 to 2 LOOP
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
			END LOOP;
			WAIT FOR 1 ns;
			ASSERT(S_conveyor_on = '1' and S_divert_right = '1')
			REPORT "FAILED [Case 2.3 - Transferring Item to Right Path]: Conveyor not on or the path taken was incorrect."
			SEVERITY ERROR;
			S_right_free <= '0';
			S_ir_sensor <= '0';
			S_weight_sensor <= '0';
			WAIT FOR clk_period;
			ASSERT(S_item_count = "0011")
			REPORT "FAILED [Case 2.3 - Transferring Item to Right Path]: Item passed not counted."
			SEVERITY ERROR;
			
			WAIT FOR clk_period - 1 ns;
			
			-- Reject
			S_item_type <= "11";
			S_ir_sensor <= '1';
			S_weight_sensor <= '1';
			FOR i IN 1 to 3 LOOP
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
			END LOOP;
			WAIT FOR 1 ns;
			ASSERT(S_ir_clean = '1' and S_weight_clean = '1')
			REPORT "FAILED [Case 2.4 - Rejecting Item]: Clean flags not triggered."
			SEVERITY ERROR;
			FOR i IN 1 to 2 LOOP
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
			END LOOP;
			WAIT FOR 1 ns;
			ASSERT(S_conveyor_on = '1' and S_reject_ack = '1')
			REPORT "FAILED [Case 2.4 - Rejecting Item]: Conveyor not on or the path taken was incorrect."
			SEVERITY ERROR;
			S_ir_sensor <= '0';
			S_weight_sensor <= '0';
			WAIT FOR clk_period;
			ASSERT(S_item_count = "0011")
			REPORT "FAILED [Case 2.4 - Rejecting Item]: Item rejected unexpectedly counted as sorted."
			SEVERITY ERROR;
			
			WAIT FOR clk_period - 1 ns;
			
			-- Test Case 3: Transferring Items While Paths Not Free --
			S_item_type <= "00";
			S_ir_sensor <= '1';
			S_weight_sensor <= '1';
			FOR i IN 1 to conveyor_start_latency LOOP
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
			END LOOP;
			WAIT FOR 1 ns;
			ASSERT(S_conveyor_on = '0')
			REPORT "FAILED [Case 3 - Paths Not Free]: Conveyor is unexpectedly on."
			SEVERITY ERROR;
			
			WAIT FOR clk_period;
			ASSERT(S_item_count = "0011")
			REPORT "FAILED [Case 3 - Paths Not Free]: Item not yet sorted, but already counted."
			SEVERITY ERROR;
			
			-- Test Case 4: Reset --
			S_left_free <= '1';
			S_rst <= '1';
			WAIT UNTIL (S_clk'EVENT and S_clk = '1');
			WAIT FOR 1 ns;
			ASSERT(S_ir_clean = '0' and S_weight_clean = '0')
			REPORT "FAILED [Case 4.1 - Reset While Item Present]: Clean flags were not reset."
			SEVERITY ERROR;
			ASSERT(S_item_count = "0000")
			REPORT "FAILED [Case 4.1 - Reset While Item Present]: Items sorted count was not reset."
			SEVERITY ERROR;
			
			WAIT FOR clk_period - 1 ns;
			S_rst <= '0';
			FOR i IN 1 to conveyor_start_latency LOOP
				WAIT UNTIL (S_clk'EVENT and S_clk = '1');
			END LOOP;
			WAIT FOR 1 ns;
			ASSERT(S_conveyor_on = '1')
			REPORT "FAILED [Case 4.2 - State Restart]: Conveyor not on in expected latency."
			SEVERITY ERROR;
			S_left_free <= '0';
			S_ir_sensor <= '0';
			S_weight_sensor <= '0';
			
			WAIT;
		END PROCESS;

END behavior;