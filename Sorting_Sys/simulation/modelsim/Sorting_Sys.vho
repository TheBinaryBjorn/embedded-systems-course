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

-- DATE "05/10/2026 15:15:49"

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

ENTITY 	sorting_control IS
    PORT (
	clk : IN std_logic;
	rst : IN std_logic;
	item_present : IN std_logic;
	valid_item : IN std_logic;
	can_sort : IN std_logic;
	enable_sort : OUT std_logic;
	count_en : OUT std_logic
	);
END sorting_control;

-- Design Ports Information
-- enable_sort	=>  Location: PIN_K22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- count_en	=>  Location: PIN_L17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- valid_item	=>  Location: PIN_N20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- item_present	=>  Location: PIN_M21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- can_sort	=>  Location: PIN_K17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_M16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- rst	=>  Location: PIN_M20,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF sorting_control IS
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
SIGNAL ww_item_present : std_logic;
SIGNAL ww_valid_item : std_logic;
SIGNAL ww_can_sort : std_logic;
SIGNAL ww_enable_sort : std_logic;
SIGNAL ww_count_en : std_logic;
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputCLKENA0_outclk\ : std_logic;
SIGNAL \item_present~input_o\ : std_logic;
SIGNAL \can_sort~input_o\ : std_logic;
SIGNAL \cur_state.WAIT_CLEAR~0_combout\ : std_logic;
SIGNAL \rst~input_o\ : std_logic;
SIGNAL \cur_state.WAIT_CLEAR~q\ : std_logic;
SIGNAL \Selector0~0_combout\ : std_logic;
SIGNAL \cur_state.IDLE~q\ : std_logic;
SIGNAL \Selector1~0_combout\ : std_logic;
SIGNAL \cur_state.CHECK~q\ : std_logic;
SIGNAL \Selector2~0_combout\ : std_logic;
SIGNAL \cur_state.SORT~q\ : std_logic;
SIGNAL \valid_item~input_o\ : std_logic;
SIGNAL \count_en~0_combout\ : std_logic;
SIGNAL \ALT_INV_cur_state.CHECK~q\ : std_logic;
SIGNAL \ALT_INV_cur_state.IDLE~q\ : std_logic;
SIGNAL \ALT_INV_cur_state.SORT~q\ : std_logic;
SIGNAL \ALT_INV_rst~input_o\ : std_logic;
SIGNAL \ALT_INV_can_sort~input_o\ : std_logic;
SIGNAL \ALT_INV_item_present~input_o\ : std_logic;
SIGNAL \ALT_INV_valid_item~input_o\ : std_logic;
SIGNAL \ALT_INV_cur_state.WAIT_CLEAR~q\ : std_logic;

BEGIN

ww_clk <= clk;
ww_rst <= rst;
ww_item_present <= item_present;
ww_valid_item <= valid_item;
ww_can_sort <= can_sort;
enable_sort <= ww_enable_sort;
count_en <= ww_count_en;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_cur_state.CHECK~q\ <= NOT \cur_state.CHECK~q\;
\ALT_INV_cur_state.IDLE~q\ <= NOT \cur_state.IDLE~q\;
\ALT_INV_cur_state.SORT~q\ <= NOT \cur_state.SORT~q\;
\ALT_INV_rst~input_o\ <= NOT \rst~input_o\;
\ALT_INV_can_sort~input_o\ <= NOT \can_sort~input_o\;
\ALT_INV_item_present~input_o\ <= NOT \item_present~input_o\;
\ALT_INV_valid_item~input_o\ <= NOT \valid_item~input_o\;
\ALT_INV_cur_state.WAIT_CLEAR~q\ <= NOT \cur_state.WAIT_CLEAR~q\;

-- Location: IOOBUF_X89_Y38_N56
\enable_sort~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \cur_state.SORT~q\,
	devoe => ww_devoe,
	o => ww_enable_sort);

-- Location: IOOBUF_X89_Y37_N22
\count_en~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \count_en~0_combout\,
	devoe => ww_devoe,
	o => ww_count_en);

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

-- Location: IOIBUF_X89_Y37_N55
\item_present~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_item_present,
	o => \item_present~input_o\);

-- Location: IOIBUF_X89_Y37_N4
\can_sort~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_can_sort,
	o => \can_sort~input_o\);

-- Location: LABCELL_X88_Y37_N36
\cur_state.WAIT_CLEAR~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \cur_state.WAIT_CLEAR~0_combout\ = ( \cur_state.WAIT_CLEAR~q\ & ( \cur_state.IDLE~q\ & ( ((!\item_present~input_o\ & ((\cur_state.CHECK~q\))) # (\item_present~input_o\ & ((!\can_sort~input_o\) # (!\cur_state.CHECK~q\)))) # (\cur_state.SORT~q\) ) ) ) # ( 
-- !\cur_state.WAIT_CLEAR~q\ & ( \cur_state.IDLE~q\ & ( (\cur_state.SORT~q\ & ((!\cur_state.CHECK~q\) # ((\item_present~input_o\ & !\can_sort~input_o\)))) ) ) ) # ( \cur_state.WAIT_CLEAR~q\ & ( !\cur_state.IDLE~q\ & ( ((\cur_state.CHECK~q\ & 
-- ((!\item_present~input_o\) # (\can_sort~input_o\)))) # (\cur_state.SORT~q\) ) ) ) # ( !\cur_state.WAIT_CLEAR~q\ & ( !\cur_state.IDLE~q\ & ( (\cur_state.SORT~q\ & ((!\item_present~input_o\ & ((!\cur_state.CHECK~q\))) # (\item_present~input_o\ & 
-- (\can_sort~input_o\ & \cur_state.CHECK~q\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000101000000001000011111011111100001111000001000101111111101111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_item_present~input_o\,
	datab => \ALT_INV_can_sort~input_o\,
	datac => \ALT_INV_cur_state.SORT~q\,
	datad => \ALT_INV_cur_state.CHECK~q\,
	datae => \ALT_INV_cur_state.WAIT_CLEAR~q\,
	dataf => \ALT_INV_cur_state.IDLE~q\,
	combout => \cur_state.WAIT_CLEAR~0_combout\);

-- Location: IOIBUF_X89_Y37_N38
\rst~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_rst,
	o => \rst~input_o\);

-- Location: FF_X88_Y37_N38
\cur_state.WAIT_CLEAR\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \cur_state.WAIT_CLEAR~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \cur_state.WAIT_CLEAR~q\);

-- Location: LABCELL_X88_Y37_N12
\Selector0~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \Selector0~0_combout\ = ( \cur_state.CHECK~q\ & ( ((!\cur_state.WAIT_CLEAR~q\ & \cur_state.SORT~q\)) # (\item_present~input_o\) ) ) # ( !\cur_state.CHECK~q\ & ( ((!\cur_state.WAIT_CLEAR~q\ & ((\cur_state.IDLE~q\) # (\cur_state.SORT~q\)))) # 
-- (\item_present~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011101110111011001110111011101100111011001110110011101100111011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_cur_state.WAIT_CLEAR~q\,
	datab => \ALT_INV_item_present~input_o\,
	datac => \ALT_INV_cur_state.SORT~q\,
	datad => \ALT_INV_cur_state.IDLE~q\,
	dataf => \ALT_INV_cur_state.CHECK~q\,
	combout => \Selector0~0_combout\);

-- Location: FF_X88_Y37_N14
\cur_state.IDLE\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \Selector0~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \cur_state.IDLE~q\);

-- Location: LABCELL_X88_Y37_N42
\Selector1~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \Selector1~0_combout\ = ( \cur_state.CHECK~q\ & ( !\cur_state.SORT~q\ & ( (\item_present~input_o\ & !\can_sort~input_o\) ) ) ) # ( !\cur_state.CHECK~q\ & ( !\cur_state.SORT~q\ & ( (\item_present~input_o\ & !\cur_state.IDLE~q\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010100000000010001000100010000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_item_present~input_o\,
	datab => \ALT_INV_can_sort~input_o\,
	datad => \ALT_INV_cur_state.IDLE~q\,
	datae => \ALT_INV_cur_state.CHECK~q\,
	dataf => \ALT_INV_cur_state.SORT~q\,
	combout => \Selector1~0_combout\);

-- Location: FF_X88_Y37_N44
\cur_state.CHECK\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \Selector1~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \cur_state.CHECK~q\);

-- Location: LABCELL_X88_Y37_N51
\Selector2~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \Selector2~0_combout\ = ( !\cur_state.SORT~q\ & ( \cur_state.CHECK~q\ & ( (\item_present~input_o\ & \can_sort~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000010101010000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_item_present~input_o\,
	datad => \ALT_INV_can_sort~input_o\,
	datae => \ALT_INV_cur_state.SORT~q\,
	dataf => \ALT_INV_cur_state.CHECK~q\,
	combout => \Selector2~0_combout\);

-- Location: FF_X88_Y37_N53
\cur_state.SORT\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \Selector2~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \cur_state.SORT~q\);

-- Location: IOIBUF_X89_Y35_N78
\valid_item~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_valid_item,
	o => \valid_item~input_o\);

-- Location: LABCELL_X88_Y37_N15
\count_en~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \count_en~0_combout\ = ( \cur_state.SORT~q\ & ( \valid_item~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000001111000011110000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_valid_item~input_o\,
	dataf => \ALT_INV_cur_state.SORT~q\,
	combout => \count_en~0_combout\);

-- Location: LABCELL_X35_Y35_N0
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


