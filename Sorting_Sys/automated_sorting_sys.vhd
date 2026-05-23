--------------- HW2 ---------------
-- Project Name: Sorting_Sys
-- File Name: automated_sorting_sys.vhd
-- Author: Tomer Rotman
-- Ver: 1.0.0
-- Created Date: 18/05/2026
------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY automated_sorting_sys IS
	GENERIC(N : integer := 4);
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
END automated_sorting_sys;

ARCHITECTURE structure OF automated_sorting_sys IS
	
	COMPONENT sorting_control
	PORT(
		  clk 			: IN std_logic;
		  rst 			: IN std_logic;
		  item_present : IN std_logic;
		  valid_item 	: IN std_logic;
		  can_sort 		: IN std_logic;
		  enable_sort 	: OUT std_logic;
		  count_en 		: OUT std_logic
	);
	END COMPONENT;
	
	COMPONENT type_decoder
	PORT(
		  item_type	  : IN std_logic_vector(1 DOWNTO 0);
		  target_code : OUT std_logic_vector(1 DOWNTO 0);
		  valid_item  : OUT std_logic
	);
	END COMPONENT;
	
	COMPONENT path_selector
	PORT(
		  target_code						 : IN std_logic_vector(1 DOWNTO 0);
		  left_free, right_free 		 : IN std_logic;
		  can_sort							 : OUT std_logic;
		  go_left, go_right, go_reject : OUT std_logic
	);
	END COMPONENT;
	
	COMPONENT item_presence_logic
	PORT(
		  clk 							: IN std_logic;
		  rst 							: IN std_logic;
		  ir_sensor, weight_sensor : IN std_logic;
		  ir_clean, weight_clean	: OUT std_logic;
		  item_present 				: OUT std_logic
	);
	END COMPONENT;
	
	COMPONENT output_driver
	PORT(
		  enable_sort						 : IN std_logic;
		  go_left, go_right, go_reject : IN std_logic;
		  conveyor_on						 : OUT std_logic;
		  divert_left, divert_right	 : OUT std_logic;
		  reject_ack						 : OUT std_logic
	);
	END COMPONENT;
	
	COMPONENT item_counter
	GENERIC(N : integer);
	PORT(
		  clk		 	 : IN std_logic;
		  rst		 	 : IN std_logic;
		  count_en 	 : IN std_logic;
		  item_count : OUT std_logic_vector(N-1 DOWNTO 0)
	);
	END COMPONENT;
	
	-- type_decoder signals
	SIGNAL s_target_code : std_logic_vector(1 DOWNTO 0);
	SIGNAL s_valid_item	: std_logic;
	
	-- path_selector signals
	SIGNAL s_can_sort, s_go_left, s_go_right, s_go_reject : std_logic;
	
	-- sorting_control signals
	SIGNAL s_count_en, s_enable_sort : std_logic;
	
	-- item_presence signals
	SIGNAL s_item_present : std_logic;
	
	BEGIN
		
		u_type_decoder : type_decoder PORT MAP(
															item_type 	=> item_type,
															target_code => s_target_code,
															valid_item 	=> s_valid_item
												);
		
		u_path_selector : path_selector PORT MAP(
															  left_free   => left_free,
															  right_free  => right_free,
															  target_code => s_target_code,
															  can_sort    => s_can_sort,
															  go_left     => s_go_left,
															  go_right    => s_go_right,
															  go_reject   => s_go_reject
												  );
		
		u_sorting_control : sorting_control PORT MAP(
																	can_sort     => s_can_sort,
																	clk          => clk,
																	item_present => s_item_present,
																	rst          => rst,
																	valid_item   => s_valid_item,
																	count_en 	 => s_count_en,
																	enable_sort  => s_enable_sort
														);
		
		u_item_presence : item_presence_logic PORT MAP(
																	  clk 			 => clk,
																	  ir_sensor 	 => ir_sensor,
																	  rst				 => rst,
																	  weight_sensor => weight_sensor,
																	  ir_clean 		 => ir_clean,
																	  item_present  => s_item_present,
																	  weight_clean  => weight_clean
												  );
		
		u_output_driver : output_driver PORT MAP(
															  enable_sort  => s_enable_sort,
															  go_left 	   => s_go_left,
															  go_reject    => s_go_reject,
															  go_right 	   => s_go_right,
															  conveyor_on  => conveyor_on,
															  divert_left  => divert_left,
															  divert_right => divert_right,
															  reject_ack 	=> reject_ack
												  );
												  
		u_item_counter : item_counter GENERIC MAP(N => N)
												PORT MAP(
															clk 		  => clk,
															count_en   => s_count_en,
															rst 		  => rst,
															item_count => item_count
												);
												
END structure;