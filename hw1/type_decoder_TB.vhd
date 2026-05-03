--------------------- HW1 ---------------------
-- Project Name: hw1
-- File Name: type_decoder_TB.vhd
-- Author: Daniel Feldman
-- Ver: 0.0.1
-- Created Date: 29/04/2026
-----------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY type_decoder_TB IS
END type_decoder_TB;

ARCHITECTURE behavior of type_decoder_TB IS
	COMPONENT type_decoder
		PORT(
			item_type : IN std_logic_vector(1 DOWNTO 0);
			target_code : OUT std_logic_vector(1 DOWNTO 0);
			valid_item : OUT std_logic
		);
	END COMPONENT;
	SIGNAL S_item_type : std_logic_vector(1 DOWNTO 0) := "00";
	SIGNAL S_target_code : std_logic_vector(1 DOWNTO 0) := "00";
	SIGNAL S_valid_item : std_logic := '0';
BEGIN
	DUT: type_decoder
	PORT MAP(
		item_type => S_item_type,
		target_code => S_target_code,
		valid_item => S_valid_item
	);
	S_item_type <= "00", "01" AFTER 50ns, "10" AFTER 100ns, "11" AFTER 150ns, ('L','L') after 200ns, ('W','W') after 250ns;
END behavior;