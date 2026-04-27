--------------------- Title ---------------------
-- Project Name: hw1
-- File Name: item_presence_logic
-- Author: Daniel Feldman
-- Ver: 0.0.1
-- Created Date: 27/04/2026
-------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY item_presence_logic IS
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
END item_presence_logic;

ARCHITECTURE behavior OF item_presence_logic IS
	BEGIN
		PROCESS(clk, rst)
			VARIABLE ir_cnt, weight_cnt: integer RANGE 0 TO K := 0;
			VARIABLE ir_clean_tmp, weight_clean_tmp : std_logic;
			BEGIN
			-- Check Reset
			IF rst = '1' THEN
				ir_cnt := 0;
				weight_cnt := 0;
				ir_clean <= '0';
				weight_clean <= '0';
				item_present <= '0';
				ir_clean_tmp := '0';
				weight_clean_tmp := '0';
			-- Clock rising edge
			ELSIF clk'EVENT AND clk='1' THEN
				-- IR Sensor
				IF ir_sensor = '1' THEN
					IF ir_cnt < K THEN
						ir_cnt := ir_cnt + 1;
					ELSE
						ir_clean_tmp := '1';
					END IF;	
				ELSE
					ir_cnt := 0;
					ir_clean_tmp := '0';
				END IF;
				
				-- Weight Sensor
				IF weight_sensor = '1' THEN
					IF weight_cnt < K THEN
						weight_cnt := weight_cnt + 1;
					ELSE
						weight_clean_tmp := '1';
					END IF;
				ELSE
					weight_cnt := 0;
					weight_clean_tmp := '0';
				END IF;
				
				-- Both Sensors
				ir_clean <= ir_clean_tmp;
				weight_clean <= weight_clean_tmp;
				item_present <= ir_clean_tmp AND weight_clean_tmp;
			END IF;
		END PROCESS;
END behavior;