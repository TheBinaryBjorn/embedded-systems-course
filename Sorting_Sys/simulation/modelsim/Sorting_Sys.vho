-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"

-- DATE "05/06/2026 16:04:42"

-- 
-- Device: Altera 5CGXFC7C7F23C8 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	item_counter IS
    PORT (
	clk : IN std_logic;
	rst : IN std_logic;
	count_en : IN std_logic;
	item_count : OUT std_logic_vector(3 DOWNTO 0)
	);
END item_counter;

-- Design Ports Information
-- item_count[0]	=>  Location: PIN_L17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- item_count[1]	=>  Location: PIN_K17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- item_count[2]	=>  Location: PIN_M21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- item_count[3]	=>  Location: PIN_L19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- rst	=>  Location: PIN_N21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- count_en	=>  Location: PIN_M20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_M16,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF item_counter IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_rst : std_logic;
SIGNAL ww_count_en : std_logic;
SIGNAL ww_item_count : std_logic_vector(3 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputCLKENA0_outclk\ : std_logic;
SIGNAL \rst~input_o\ : std_logic;
SIGNAL \count_en~input_o\ : std_logic;
SIGNAL \cnt[1]~1_combout\ : std_logic;
SIGNAL \cnt[3]~3_combout\ : std_logic;
SIGNAL \cnt[2]~2_combout\ : std_logic;
SIGNAL \cnt[0]~0_combout\ : std_logic;
SIGNAL cnt : std_logic_vector(3 DOWNTO 0);
SIGNAL ALT_INV_cnt : std_logic_vector(3 DOWNTO 0);
SIGNAL \ALT_INV_count_en~input_o\ : std_logic;
SIGNAL \ALT_INV_rst~input_o\ : std_logic;

BEGIN

ww_clk <= clk;
ww_rst <= rst;
ww_count_en <= count_en;
item_count <= ww_item_count;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
ALT_INV_cnt(0) <= NOT cnt(0);
ALT_INV_cnt(1) <= NOT cnt(1);
ALT_INV_cnt(2) <= NOT cnt(2);
ALT_INV_cnt(3) <= NOT cnt(3);
\ALT_INV_count_en~input_o\ <= NOT \count_en~input_o\;
\ALT_INV_rst~input_o\ <= NOT \rst~input_o\;

-- Location: IOOBUF_X89_Y37_N22
\item_count[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => cnt(0),
	devoe => ww_devoe,
	o => ww_item_count(0));

-- Location: IOOBUF_X89_Y37_N5
\item_count[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => cnt(1),
	devoe => ww_devoe,
	o => ww_item_count(1));

-- Location: IOOBUF_X89_Y37_N56
\item_count[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => cnt(2),
	devoe => ww_devoe,
	o => ww_item_count(2));

-- Location: IOOBUF_X89_Y38_N5
\item_count[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => cnt(3),
	devoe => ww_devoe,
	o => ww_item_count(3));

-- Location: IOIBUF_X89_Y35_N61
\clk~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: CLKCTRL_G10
\clk~inputCLKENA0\ : cyclonev_clkena
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	disable_mode => "low",
	ena_register_mode => "always enabled",
	ena_register_power_up => "high",
	test_syn => "high")
-- pragma translate_on
PORT MAP (
	inclk => \clk~input_o\,
	outclk => \clk~inputCLKENA0_outclk\);

-- Location: IOIBUF_X89_Y35_N95
\rst~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_rst,
	o => \rst~input_o\);

-- Location: IOIBUF_X89_Y37_N38
\count_en~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_count_en,
	o => \count_en~input_o\);

-- Location: LABCELL_X88_Y37_N48
\cnt[1]~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \cnt[1]~1_combout\ = ( cnt(1) & ( cnt(0) & ( (!\rst~input_o\ & ((!\count_en~input_o\) # ((cnt(2) & cnt(3))))) ) ) ) # ( !cnt(1) & ( cnt(0) & ( (!\rst~input_o\ & \count_en~input_o\) ) ) ) # ( cnt(1) & ( !cnt(0) & ( !\rst~input_o\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000101010101010101000100010001000101000100010001010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_rst~input_o\,
	datab => \ALT_INV_count_en~input_o\,
	datac => ALT_INV_cnt(2),
	datad => ALT_INV_cnt(3),
	datae => ALT_INV_cnt(1),
	dataf => ALT_INV_cnt(0),
	combout => \cnt[1]~1_combout\);

-- Location: FF_X88_Y37_N50
\cnt[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \cnt[1]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => cnt(1));

-- Location: LABCELL_X88_Y37_N6
\cnt[3]~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \cnt[3]~3_combout\ = ( cnt(3) & ( cnt(1) & ( !\rst~input_o\ ) ) ) # ( !cnt(3) & ( cnt(1) & ( (cnt(2) & (\count_en~input_o\ & (cnt(0) & !\rst~input_o\))) ) ) ) # ( cnt(3) & ( !cnt(1) & ( !\rst~input_o\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111110000000000000001000000001111111100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => ALT_INV_cnt(2),
	datab => \ALT_INV_count_en~input_o\,
	datac => ALT_INV_cnt(0),
	datad => \ALT_INV_rst~input_o\,
	datae => ALT_INV_cnt(3),
	dataf => ALT_INV_cnt(1),
	combout => \cnt[3]~3_combout\);

-- Location: FF_X88_Y37_N8
\cnt[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \cnt[3]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => cnt(3));

-- Location: LABCELL_X88_Y37_N54
\cnt[2]~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \cnt[2]~2_combout\ = ( cnt(2) & ( cnt(1) & ( (!\rst~input_o\ & ((!\count_en~input_o\) # ((!cnt(0)) # (cnt(3))))) ) ) ) # ( !cnt(2) & ( cnt(1) & ( (!\rst~input_o\ & (\count_en~input_o\ & cnt(0))) ) ) ) # ( cnt(2) & ( !cnt(1) & ( !\rst~input_o\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000101010101010101000000010000000101010100010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_rst~input_o\,
	datab => \ALT_INV_count_en~input_o\,
	datac => ALT_INV_cnt(0),
	datad => ALT_INV_cnt(3),
	datae => ALT_INV_cnt(2),
	dataf => ALT_INV_cnt(1),
	combout => \cnt[2]~2_combout\);

-- Location: FF_X88_Y37_N56
\cnt[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \cnt[2]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => cnt(2));

-- Location: LABCELL_X88_Y37_N24
\cnt[0]~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \cnt[0]~0_combout\ = ( cnt(0) & ( cnt(1) & ( (!\rst~input_o\ & ((!\count_en~input_o\) # ((cnt(2) & cnt(3))))) ) ) ) # ( !cnt(0) & ( cnt(1) & ( (!\rst~input_o\ & \count_en~input_o\) ) ) ) # ( cnt(0) & ( !cnt(1) & ( (!\rst~input_o\ & !\count_en~input_o\) ) 
-- ) ) # ( !cnt(0) & ( !cnt(1) & ( (!\rst~input_o\ & \count_en~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010001000100010100010001000100000100010001000101000100010001010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_rst~input_o\,
	datab => \ALT_INV_count_en~input_o\,
	datac => ALT_INV_cnt(2),
	datad => ALT_INV_cnt(3),
	datae => ALT_INV_cnt(0),
	dataf => ALT_INV_cnt(1),
	combout => \cnt[0]~0_combout\);

-- Location: FF_X88_Y37_N26
\cnt[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \cnt[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => cnt(0));

-- Location: LABCELL_X36_Y68_N3
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


