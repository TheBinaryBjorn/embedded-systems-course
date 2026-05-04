--------------------- HW1 -----------------------
-- Project Name: Sorting_Sys
-- File Name: item_counter
-- Author: Tomer Rotman
-- Ver: 1.0.0
-- Created Date: 02/05/2026
-------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

ENTITY item_counter IS
	GENERIC(N : integer := 4);
	PORT(
		  clk		 	 : IN std_logic;
		  rst		 	 : IN std_logic;
		  count_en 	 : IN std_logic;
		  item_count : OUT std_logic_vector(N-1 DOWNTO 0)
	);
END item_counter;

ARCHITECTURE behavior OF item_counter IS
	SIGNAL cnt : std_logic_vector(N-1 DOWNTO 0) := (OTHERS => '0'); -- Holds count value

	BEGIN

	PROCESS(clk)
		BEGIN
			IF (clk'EVENT and clk = '1') THEN
				IF rst = '1' THEN -- Clear counter to zero on reset
					cnt <= (OTHERS => '0');
				ELSIF count_en = '1' THEN -- When count is enabled
					IF cnt = (2**N - 1) THEN -- Clear counter when reached its maximum value
						cnt <= (OTHERS => '0');
					ELSE
						cnt <= cnt + 1; -- Standard increment
					END IF;
				END IF;
			END IF;
	END PROCESS;
	item_count <= cnt;
	
END behavior;