--------------------- hw1 ---------------------
-- Project Name: hw1
-- File Name: item_presence_logic_TB.vhd
-- Author: Daniel Feldman
-- Ver: 0.0.1
-- Created Date: 27/04/2026
-------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY item_presence_logic_TB IS
END item_presence_logic_TB;

ARCHITECTURE behavior OF item_presence_logic_TB IS
	COMPONENT item_presence_logic
		GENERIC(K: POSITIVE:=3);
		PORT(
			clk : in std_logic;
			rst : in std_logic;
			ir_sensor : in std_logic;
			weight_sensor : in std_logic;
			ir_clean : out std_logic;
			weight_clean : out std_logic;
			item_present : out std_logic
		);
	END COMPONENT;
	SIGNAL S_clk : std_logic := '0';
	SIGNAL S_rst : std_logic := '0';
	SIGNAL S_ir_sensor : std_logic := '0';
	SIGNAL S_weight_sensor : std_logic := '0';
	SIGNAL S_ir_clean : std_logic:= '0';
	SIGNAL S_weight_clean : std_logic := '0';
	SIGNAL S_item_present : std_logic := '0';
	
	CONSTANT clk_period : time := 20ns;
BEGIN
	DUT: item_presence_logic
	GENERIC MAP(K=>3)
	PORT MAP(
		clk => S_clk,
		rst => S_rst,
		ir_sensor => S_ir_sensor,
		weight_sensor => S_weight_sensor,
		ir_clean => S_ir_clean,
		weight_clean => S_weight_clean,
		item_present => S_item_present
	);
	S_clk <= NOT S_clk AFTER clk_period / 2;
	
	PROCESS
	BEGIN
		-- System Reset
		S_rst <= '1';
		S_ir_sensor <= '0';
		S_weight_sensor <= '0';
		WAIT FOR clk_period*2;
		
		S_rst <= '0';
		WAIT FOR clk_period*2;
		
		-- Reset Off
		-- Test Case 1: Both Sensors Off, Reset Off
		S_ir_sensor <= '0';
		S_weight_sensor <= '0';
		S_rst <= '0';
		WAIT FOR clk_period*3;
		
		ASSERT (S_ir_clean = '0' AND S_weight_clean = '0' AND S_item_present = '0')
		REPORT "TC1 Failed: Expected all outputs to be 0."
		SEVERITY ERROR;
		
		-- Test Case 2: IR Sensor On, Weight Sensor Off, Reset Off
		S_ir_sensor <= '1';
		S_weight_sensor <= '0';
		S_rst <= '0';
		
		WAIT FOR clk_period*3;
		
		ASSERT(S_ir_clean = '1' AND S_weight_clean = '0' AND S_item_present = '0')
		REPORT "TC2 Failed: Expected S_ir_clean='1', S_weight_clean = '0', S_item_present = '0'"
		SEVERITY ERROR;
		
		-- Test Case 3: IR Sensor Off, Weight Sensor On, Reset Off
		S_ir_sensor <= '0';
		S_weight_sensor <= '1';
		S_rst <= '0';
		
		WAIT FOR clk_period*3;
		
		ASSERT(S_ir_clean = '0' AND S_weight_clean = '1' AND S_item_present = '0')
		REPORT "TC3 Failed: Expected S_ir_clean='0', S_weight_clean = '1', S_item_present = '0'"
		SEVERITY ERROR;
		
		-- Test Case 4: Both Sensors On, Reset Off
		S_ir_sensor <= '1';
		S_weight_sensor <= '1';
		S_rst <= '0';
		
		WAIT FOR clk_period*3;
		
		ASSERT(S_ir_clean = '1' AND S_weight_clean = '1' AND S_item_present = '1')
		REPORT "TC4 Failed: Expected S_ir_clean='1', S_weight_clean = '1', S_item_present = '1'"
		SEVERITY ERROR;
		
		-- Reset On
		-- Test Case 5: Both Sensors Off, Reset On
		S_ir_sensor <= '0';
		S_weight_sensor <= '0';
		S_rst <= '1';
		WAIT FOR clk_period*3;
		
		ASSERT (S_ir_clean = '0' AND S_weight_clean = '0' AND S_item_present = '0')
		REPORT "TC5 Failed: Expected all outputs to be 0."
		SEVERITY ERROR;
		
		-- Test Case 6: IR Sensor On, Weight Sensor Off, Reset On
		S_ir_sensor <= '1';
		S_weight_sensor <= '0';
		S_rst <= '1';
		
		WAIT FOR clk_period*3;
		
		ASSERT(S_ir_clean = '0' AND S_weight_clean = '0' AND S_item_present = '0')
		REPORT "TC6 Failed: Expected S_ir_clean='0', S_weight_clean = '0', S_item_present = '0'"
		SEVERITY ERROR;
		
		-- Test Case 7: IR Sensor Off, Weight Sensor On, Reset On
		S_ir_sensor <= '0';
		S_weight_sensor <= '1';
		S_rst <= '1';
		
		WAIT FOR clk_period*3;
		
		ASSERT(S_ir_clean = '0' AND S_weight_clean = '0' AND S_item_present = '0')
		REPORT "TC7 Failed: Expected S_ir_clean='0', S_weight_clean = '0', S_item_present = '0'"
		SEVERITY ERROR;
		
		-- Test Case 8: Both Sensors On, Reset On
		S_ir_sensor <= '1';
		S_weight_sensor <= '1';
		S_rst <= '1';
		
		WAIT FOR clk_period*3;
		
		ASSERT(S_ir_clean = '0' AND S_weight_clean = '0' AND S_item_present = '0')
		REPORT "TC8 Failed: Expected S_ir_clean='0', S_weight_clean = '0', S_item_present = '0'"
		SEVERITY ERROR;
		
		REPORT "Test Simulation Complete, check console above for any ERROR messages."
		SEVERITY NOTE;
		WAIT;
		
	END PROCESS;

END behavior;