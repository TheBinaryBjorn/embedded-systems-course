--------------------- Title ---------------------
-- Project Name: hw1
-- File Name: test_item_presence_logic
-- Author: Daniel Feldman
-- Ver: 0.0.1
-- Created Date: 27/04/2026
-------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY test_item_presence_logic IS
END test_item_presence_logic;

ARCHITECTURE behavior OF test_item_presence_logic IS
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
	SIGNAL S_ir_clean, S_weight_clean, S_item_present : std_logic;
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
	S_clk <= NOT S_clk AFTER 10ns;
	S_ir_sensor <= '0', '1' after 30ns, '0' after 60ns, '1' after 90ns;
	S_weight_sensor <= '0', '1' after 60ns, '0' after 200ns;
	S_rst <= '1' after 500ns;

END behavior;