--------------- hw1 ---------------
-- Project Name: hw1
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
	SIGNAL target_code_S : std_logic_vector(1 DOWNTO 0) := "00";
	SIGNAL left_free_S : std_logic := '0';
	SIGNAL right_free_S : std_logic := '0';
	SIGNAL can_sort_S : std_logic := '0';
	SIGNAL go_left_S : std_logic := '0';
	SIGNAL go_right_S : std_logic := '0';
	SIGNAL go_reject_S : std_logic := '0';
BEGIN
	DUT: path_selector
	PORT MAP(
		target_code => target_code_S,
		left_free => left_free_S,
		right_free => right_free_S,
		can_sort => can_sort_S,
		go_left => go_left_S,
		go_right => go_right_S,
		go_reject => go_reject_S
	);
	target_code_S <= "00", "01" AFTER 50ns, "10" AFTER 100ns, "11" AFTER 150ns, "LL" AFTER 200ns;
	left_free_S <= '0', '1' AFTER 25ns, '0' AFTER 50ns;
	right_free_S <= '0', '1' AFTER 75ns, '0' AFTER 100ns, '1' AFTER 125ns;
END behavior;