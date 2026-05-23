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

-- DATE "05/23/2026 10:19:30"

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

ENTITY 	automated_sorting_sys IS
    PORT (
	clk : IN std_logic;
	rst : IN std_logic;
	ir_sensor : IN std_logic;
	weight_sensor : IN std_logic;
	item_type : IN std_logic_vector(1 DOWNTO 0);
	left_free : IN std_logic;
	right_free : IN std_logic;
	ir_clean : BUFFER std_logic;
	weight_clean : BUFFER std_logic;
	conveyor_on : BUFFER std_logic;
	divert_left : BUFFER std_logic;
	divert_right : BUFFER std_logic;
	reject_ack : BUFFER std_logic;
	item_count : BUFFER std_logic_vector(3 DOWNTO 0)
	);
END automated_sorting_sys;

-- Design Ports Information
-- ir_clean	=>  Location: PIN_M18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- weight_clean	=>  Location: PIN_L19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- conveyor_on	=>  Location: PIN_P19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- divert_left	=>  Location: PIN_K22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- divert_right	=>  Location: PIN_N19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- reject_ack	=>  Location: PIN_P17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- item_count[0]	=>  Location: PIN_L22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- item_count[1]	=>  Location: PIN_P18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- item_count[2]	=>  Location: PIN_M22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- item_count[3]	=>  Location: PIN_L18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- item_type[0]	=>  Location: PIN_N16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- item_type[1]	=>  Location: PIN_N21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ir_sensor	=>  Location: PIN_N20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_M16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- rst	=>  Location: PIN_M21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- weight_sensor	=>  Location: PIN_K21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- right_free	=>  Location: PIN_K17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- left_free	=>  Location: PIN_L17,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF automated_sorting_sys IS
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
SIGNAL ww_ir_sensor : std_logic;
SIGNAL ww_weight_sensor : std_logic;
SIGNAL ww_item_type : std_logic_vector(1 DOWNTO 0);
SIGNAL ww_left_free : std_logic;
SIGNAL ww_right_free : std_logic;
SIGNAL ww_ir_clean : std_logic;
SIGNAL ww_weight_clean : std_logic;
SIGNAL ww_conveyor_on : std_logic;
SIGNAL ww_divert_left : std_logic;
SIGNAL ww_divert_right : std_logic;
SIGNAL ww_reject_ack : std_logic;
SIGNAL ww_item_count : std_logic_vector(3 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputCLKENA0_outclk\ : std_logic;
SIGNAL \ir_sensor~input_o\ : std_logic;
SIGNAL \rst~input_o\ : std_logic;
SIGNAL \u_item_presence|ir_clean_tmp~q\ : std_logic;
SIGNAL \u_item_presence|ir_cnt~1_combout\ : std_logic;
SIGNAL \u_item_presence|ir_cnt~0_combout\ : std_logic;
SIGNAL \u_item_presence|ir_clean_tmp~0_combout\ : std_logic;
SIGNAL \u_item_presence|ir_clean~q\ : std_logic;
SIGNAL \weight_sensor~input_o\ : std_logic;
SIGNAL \u_item_presence|weight_cnt~1_combout\ : std_logic;
SIGNAL \u_item_presence|weight_cnt~0_combout\ : std_logic;
SIGNAL \u_item_presence|weight_clean_tmp~q\ : std_logic;
SIGNAL \u_item_presence|weight_clean_tmp~0_combout\ : std_logic;
SIGNAL \u_item_presence|weight_clean~q\ : std_logic;
SIGNAL \left_free~input_o\ : std_logic;
SIGNAL \u_item_presence|item_present~0_combout\ : std_logic;
SIGNAL \u_item_presence|item_present~q\ : std_logic;
SIGNAL \item_type[0]~input_o\ : std_logic;
SIGNAL \item_type[1]~input_o\ : std_logic;
SIGNAL \right_free~input_o\ : std_logic;
SIGNAL \u_sorting_control|Selector1~2_combout\ : std_logic;
SIGNAL \u_sorting_control|cur_state.WAIT_CLEAR~0_combout\ : std_logic;
SIGNAL \u_sorting_control|cur_state.WAIT_CLEAR~q\ : std_logic;
SIGNAL \u_sorting_control|Selector0~0_combout\ : std_logic;
SIGNAL \u_sorting_control|cur_state.IDLE~q\ : std_logic;
SIGNAL \u_sorting_control|Selector1~0_combout\ : std_logic;
SIGNAL \u_sorting_control|Selector1~1_combout\ : std_logic;
SIGNAL \u_sorting_control|cur_state.CHECK~q\ : std_logic;
SIGNAL \u_sorting_control|Selector2~0_combout\ : std_logic;
SIGNAL \u_sorting_control|cur_state.SORT~q\ : std_logic;
SIGNAL \u_output_driver|Mux1~0_combout\ : std_logic;
SIGNAL \u_output_driver|Mux2~0_combout\ : std_logic;
SIGNAL \u_output_driver|Mux3~0_combout\ : std_logic;
SIGNAL \u_output_driver|Mux1~1_combout\ : std_logic;
SIGNAL \u_item_counter|cnt[1]~2_combout\ : std_logic;
SIGNAL \u_item_counter|cnt[2]~3_combout\ : std_logic;
SIGNAL \u_item_counter|cnt[0]~4_combout\ : std_logic;
SIGNAL \u_item_counter|cnt[3]~5_combout\ : std_logic;
SIGNAL \u_item_counter|cnt[0]~0_combout\ : std_logic;
SIGNAL \u_item_counter|cnt[0]~1_combout\ : std_logic;
SIGNAL \u_item_presence|ir_cnt\ : std_logic_vector(1 DOWNTO 0);
SIGNAL \u_item_counter|cnt\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \u_item_presence|weight_cnt\ : std_logic_vector(1 DOWNTO 0);
SIGNAL \u_item_counter|ALT_INV_cnt[0]~4_combout\ : std_logic;
SIGNAL \u_sorting_control|ALT_INV_cur_state.SORT~q\ : std_logic;
SIGNAL \u_item_counter|ALT_INV_cnt\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \u_item_presence|ALT_INV_ir_cnt\ : std_logic_vector(1 DOWNTO 0);
SIGNAL \u_item_presence|ALT_INV_ir_clean_tmp~q\ : std_logic;
SIGNAL \u_item_presence|ALT_INV_weight_cnt\ : std_logic_vector(1 DOWNTO 0);
SIGNAL \u_item_presence|ALT_INV_weight_clean_tmp~q\ : std_logic;
SIGNAL \u_item_presence|ALT_INV_item_present~q\ : std_logic;
SIGNAL \u_sorting_control|ALT_INV_cur_state.CHECK~q\ : std_logic;
SIGNAL \u_item_counter|ALT_INV_cnt[0]~0_combout\ : std_logic;
SIGNAL \u_output_driver|ALT_INV_Mux1~1_combout\ : std_logic;
SIGNAL \ALT_INV_left_free~input_o\ : std_logic;
SIGNAL \ALT_INV_right_free~input_o\ : std_logic;
SIGNAL \ALT_INV_weight_sensor~input_o\ : std_logic;
SIGNAL \ALT_INV_rst~input_o\ : std_logic;
SIGNAL \ALT_INV_ir_sensor~input_o\ : std_logic;
SIGNAL \ALT_INV_item_type[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_item_type[0]~input_o\ : std_logic;
SIGNAL \u_sorting_control|ALT_INV_Selector1~2_combout\ : std_logic;
SIGNAL \u_sorting_control|ALT_INV_cur_state.WAIT_CLEAR~q\ : std_logic;
SIGNAL \u_sorting_control|ALT_INV_Selector1~0_combout\ : std_logic;
SIGNAL \u_sorting_control|ALT_INV_cur_state.IDLE~q\ : std_logic;

BEGIN

ww_clk <= clk;
ww_rst <= rst;
ww_ir_sensor <= ir_sensor;
ww_weight_sensor <= weight_sensor;
ww_item_type <= item_type;
ww_left_free <= left_free;
ww_right_free <= right_free;
ir_clean <= ww_ir_clean;
weight_clean <= ww_weight_clean;
conveyor_on <= ww_conveyor_on;
divert_left <= ww_divert_left;
divert_right <= ww_divert_right;
reject_ack <= ww_reject_ack;
item_count <= ww_item_count;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\u_item_counter|ALT_INV_cnt[0]~4_combout\ <= NOT \u_item_counter|cnt[0]~4_combout\;
\u_sorting_control|ALT_INV_cur_state.SORT~q\ <= NOT \u_sorting_control|cur_state.SORT~q\;
\u_item_counter|ALT_INV_cnt\(0) <= NOT \u_item_counter|cnt\(0);
\u_item_counter|ALT_INV_cnt\(1) <= NOT \u_item_counter|cnt\(1);
\u_item_counter|ALT_INV_cnt\(2) <= NOT \u_item_counter|cnt\(2);
\u_item_counter|ALT_INV_cnt\(3) <= NOT \u_item_counter|cnt\(3);
\u_item_presence|ALT_INV_ir_cnt\(1) <= NOT \u_item_presence|ir_cnt\(1);
\u_item_presence|ALT_INV_ir_cnt\(0) <= NOT \u_item_presence|ir_cnt\(0);
\u_item_presence|ALT_INV_ir_clean_tmp~q\ <= NOT \u_item_presence|ir_clean_tmp~q\;
\u_item_presence|ALT_INV_weight_cnt\(1) <= NOT \u_item_presence|weight_cnt\(1);
\u_item_presence|ALT_INV_weight_clean_tmp~q\ <= NOT \u_item_presence|weight_clean_tmp~q\;
\u_item_presence|ALT_INV_item_present~q\ <= NOT \u_item_presence|item_present~q\;
\u_sorting_control|ALT_INV_cur_state.CHECK~q\ <= NOT \u_sorting_control|cur_state.CHECK~q\;
\u_item_counter|ALT_INV_cnt[0]~0_combout\ <= NOT \u_item_counter|cnt[0]~0_combout\;
\u_output_driver|ALT_INV_Mux1~1_combout\ <= NOT \u_output_driver|Mux1~1_combout\;
\u_item_presence|ALT_INV_weight_cnt\(0) <= NOT \u_item_presence|weight_cnt\(0);
\ALT_INV_left_free~input_o\ <= NOT \left_free~input_o\;
\ALT_INV_right_free~input_o\ <= NOT \right_free~input_o\;
\ALT_INV_weight_sensor~input_o\ <= NOT \weight_sensor~input_o\;
\ALT_INV_rst~input_o\ <= NOT \rst~input_o\;
\ALT_INV_ir_sensor~input_o\ <= NOT \ir_sensor~input_o\;
\ALT_INV_item_type[1]~input_o\ <= NOT \item_type[1]~input_o\;
\ALT_INV_item_type[0]~input_o\ <= NOT \item_type[0]~input_o\;
\u_sorting_control|ALT_INV_Selector1~2_combout\ <= NOT \u_sorting_control|Selector1~2_combout\;
\u_sorting_control|ALT_INV_cur_state.WAIT_CLEAR~q\ <= NOT \u_sorting_control|cur_state.WAIT_CLEAR~q\;
\u_sorting_control|ALT_INV_Selector1~0_combout\ <= NOT \u_sorting_control|Selector1~0_combout\;
\u_sorting_control|ALT_INV_cur_state.IDLE~q\ <= NOT \u_sorting_control|cur_state.IDLE~q\;

-- Location: IOOBUF_X89_Y36_N22
\ir_clean~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \u_item_presence|ir_clean~q\,
	devoe => ww_devoe,
	o => ww_ir_clean);

-- Location: IOOBUF_X89_Y38_N5
\weight_clean~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \u_item_presence|weight_clean~q\,
	devoe => ww_devoe,
	o => ww_weight_clean);

-- Location: IOOBUF_X89_Y9_N39
\conveyor_on~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \u_sorting_control|cur_state.SORT~q\,
	devoe => ww_devoe,
	o => ww_conveyor_on);

-- Location: IOOBUF_X89_Y38_N56
\divert_left~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \u_output_driver|Mux1~0_combout\,
	devoe => ww_devoe,
	o => ww_divert_left);

-- Location: IOOBUF_X89_Y36_N5
\divert_right~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \u_output_driver|Mux2~0_combout\,
	devoe => ww_devoe,
	o => ww_divert_right);

-- Location: IOOBUF_X89_Y9_N22
\reject_ack~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \u_output_driver|Mux3~0_combout\,
	devoe => ww_devoe,
	o => ww_reject_ack);

-- Location: IOOBUF_X89_Y36_N56
\item_count[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \u_item_counter|cnt\(0),
	devoe => ww_devoe,
	o => ww_item_count(0));

-- Location: IOOBUF_X89_Y9_N56
\item_count[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \u_item_counter|cnt\(1),
	devoe => ww_devoe,
	o => ww_item_count(1));

-- Location: IOOBUF_X89_Y36_N39
\item_count[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \u_item_counter|cnt\(2),
	devoe => ww_devoe,
	o => ww_item_count(2));

-- Location: IOOBUF_X89_Y38_N22
\item_count[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \u_item_counter|cnt\(3),
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

-- Location: IOIBUF_X89_Y35_N78
\ir_sensor~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_ir_sensor,
	o => \ir_sensor~input_o\);

-- Location: IOIBUF_X89_Y37_N55
\rst~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_rst,
	o => \rst~input_o\);

-- Location: FF_X88_Y26_N41
\u_item_presence|ir_clean_tmp\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \u_item_presence|ir_clean_tmp~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_item_presence|ir_clean_tmp~q\);

-- Location: MLABCELL_X87_Y26_N21
\u_item_presence|ir_cnt~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_item_presence|ir_cnt~1_combout\ = ( \u_item_presence|ir_cnt\(0) & ( (\ir_sensor~input_o\ & \u_item_presence|ir_cnt\(1)) ) ) # ( !\u_item_presence|ir_cnt\(0) & ( \ir_sensor~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000000000000111100001111000011110000000000001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_ir_sensor~input_o\,
	datad => \u_item_presence|ALT_INV_ir_cnt\(1),
	datae => \u_item_presence|ALT_INV_ir_cnt\(0),
	combout => \u_item_presence|ir_cnt~1_combout\);

-- Location: FF_X87_Y26_N22
\u_item_presence|ir_cnt[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_item_presence|ir_cnt~1_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_item_presence|ir_cnt\(0));

-- Location: MLABCELL_X87_Y26_N54
\u_item_presence|ir_cnt~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_item_presence|ir_cnt~0_combout\ = ( \u_item_presence|ir_cnt\(0) & ( \ir_sensor~input_o\ ) ) # ( !\u_item_presence|ir_cnt\(0) & ( (\ir_sensor~input_o\ & \u_item_presence|ir_cnt\(1)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000110011000000000011001100110011001100110011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_ir_sensor~input_o\,
	datad => \u_item_presence|ALT_INV_ir_cnt\(1),
	dataf => \u_item_presence|ALT_INV_ir_cnt\(0),
	combout => \u_item_presence|ir_cnt~0_combout\);

-- Location: FF_X87_Y26_N56
\u_item_presence|ir_cnt[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_item_presence|ir_cnt~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_item_presence|ir_cnt\(1));

-- Location: LABCELL_X88_Y26_N0
\u_item_presence|ir_clean_tmp~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_item_presence|ir_clean_tmp~0_combout\ = ( \u_item_presence|ir_cnt\(1) & ( \ir_sensor~input_o\ ) ) # ( !\u_item_presence|ir_cnt\(1) & ( (\ir_sensor~input_o\ & \u_item_presence|ir_clean_tmp~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000001111000000000000111100001111000011110000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_ir_sensor~input_o\,
	datad => \u_item_presence|ALT_INV_ir_clean_tmp~q\,
	dataf => \u_item_presence|ALT_INV_ir_cnt\(1),
	combout => \u_item_presence|ir_clean_tmp~0_combout\);

-- Location: FF_X88_Y26_N16
\u_item_presence|ir_clean\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \u_item_presence|ir_clean_tmp~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_item_presence|ir_clean~q\);

-- Location: IOIBUF_X89_Y38_N38
\weight_sensor~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_weight_sensor,
	o => \weight_sensor~input_o\);

-- Location: MLABCELL_X87_Y26_N24
\u_item_presence|weight_cnt~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_item_presence|weight_cnt~1_combout\ = ( \u_item_presence|weight_cnt\(1) & ( \weight_sensor~input_o\ ) ) # ( !\u_item_presence|weight_cnt\(1) & ( (\weight_sensor~input_o\ & !\u_item_presence|weight_cnt\(0)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011001100000000001100110000000000110011001100110011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_weight_sensor~input_o\,
	datad => \u_item_presence|ALT_INV_weight_cnt\(0),
	dataf => \u_item_presence|ALT_INV_weight_cnt\(1),
	combout => \u_item_presence|weight_cnt~1_combout\);

-- Location: FF_X87_Y26_N25
\u_item_presence|weight_cnt[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_item_presence|weight_cnt~1_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_item_presence|weight_cnt\(0));

-- Location: MLABCELL_X87_Y26_N27
\u_item_presence|weight_cnt~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_item_presence|weight_cnt~0_combout\ = ( \u_item_presence|weight_cnt\(0) & ( \weight_sensor~input_o\ ) ) # ( !\u_item_presence|weight_cnt\(0) & ( (\weight_sensor~input_o\ & \u_item_presence|weight_cnt\(1)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000110011000000000011001100110011001100110011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_weight_sensor~input_o\,
	datad => \u_item_presence|ALT_INV_weight_cnt\(1),
	dataf => \u_item_presence|ALT_INV_weight_cnt\(0),
	combout => \u_item_presence|weight_cnt~0_combout\);

-- Location: FF_X87_Y26_N29
\u_item_presence|weight_cnt[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_item_presence|weight_cnt~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_item_presence|weight_cnt\(1));

-- Location: FF_X87_Y26_N20
\u_item_presence|weight_clean_tmp\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	asdata => \u_item_presence|weight_clean_tmp~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_item_presence|weight_clean_tmp~q\);

-- Location: MLABCELL_X87_Y26_N45
\u_item_presence|weight_clean_tmp~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_item_presence|weight_clean_tmp~0_combout\ = ( \u_item_presence|weight_cnt\(1) & ( \u_item_presence|weight_clean_tmp~q\ & ( \weight_sensor~input_o\ ) ) ) # ( !\u_item_presence|weight_cnt\(1) & ( \u_item_presence|weight_clean_tmp~q\ & ( 
-- \weight_sensor~input_o\ ) ) ) # ( \u_item_presence|weight_cnt\(1) & ( !\u_item_presence|weight_clean_tmp~q\ & ( \weight_sensor~input_o\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000011110000111100001111000011110000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_weight_sensor~input_o\,
	datae => \u_item_presence|ALT_INV_weight_cnt\(1),
	dataf => \u_item_presence|ALT_INV_weight_clean_tmp~q\,
	combout => \u_item_presence|weight_clean_tmp~0_combout\);

-- Location: FF_X87_Y26_N46
\u_item_presence|weight_clean\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_item_presence|weight_clean_tmp~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_item_presence|weight_clean~q\);

-- Location: IOIBUF_X89_Y37_N21
\left_free~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_left_free,
	o => \left_free~input_o\);

-- Location: MLABCELL_X87_Y26_N36
\u_item_presence|item_present~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_item_presence|item_present~0_combout\ = ( \ir_sensor~input_o\ & ( \u_item_presence|ir_clean_tmp~q\ & ( (\weight_sensor~input_o\ & ((\u_item_presence|weight_clean_tmp~q\) # (\u_item_presence|weight_cnt\(1)))) ) ) ) # ( \ir_sensor~input_o\ & ( 
-- !\u_item_presence|ir_clean_tmp~q\ & ( (\weight_sensor~input_o\ & (\u_item_presence|ir_cnt\(1) & ((\u_item_presence|weight_clean_tmp~q\) # (\u_item_presence|weight_cnt\(1))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000010000001100000000000000000001000100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \u_item_presence|ALT_INV_weight_cnt\(1),
	datab => \ALT_INV_weight_sensor~input_o\,
	datac => \u_item_presence|ALT_INV_ir_cnt\(1),
	datad => \u_item_presence|ALT_INV_weight_clean_tmp~q\,
	datae => \ALT_INV_ir_sensor~input_o\,
	dataf => \u_item_presence|ALT_INV_ir_clean_tmp~q\,
	combout => \u_item_presence|item_present~0_combout\);

-- Location: FF_X87_Y26_N38
\u_item_presence|item_present\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_item_presence|item_present~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_item_presence|item_present~q\);

-- Location: IOIBUF_X89_Y35_N44
\item_type[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_item_type(0),
	o => \item_type[0]~input_o\);

-- Location: IOIBUF_X89_Y35_N95
\item_type[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_item_type(1),
	o => \item_type[1]~input_o\);

-- Location: IOIBUF_X89_Y37_N4
\right_free~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_right_free,
	o => \right_free~input_o\);

-- Location: LABCELL_X88_Y26_N36
\u_sorting_control|Selector1~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_sorting_control|Selector1~2_combout\ = ( \u_sorting_control|cur_state.CHECK~q\ & ( (!\item_type[0]~input_o\ & ((!\item_type[1]~input_o\ & (\left_free~input_o\)) # (\item_type[1]~input_o\ & ((\right_free~input_o\))))) # (\item_type[0]~input_o\ & 
-- (((\right_free~input_o\)) # (\item_type[1]~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000011001011111110001100101111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_item_type[0]~input_o\,
	datab => \ALT_INV_item_type[1]~input_o\,
	datac => \ALT_INV_left_free~input_o\,
	datad => \ALT_INV_right_free~input_o\,
	dataf => \u_sorting_control|ALT_INV_cur_state.CHECK~q\,
	combout => \u_sorting_control|Selector1~2_combout\);

-- Location: LABCELL_X88_Y26_N21
\u_sorting_control|cur_state.WAIT_CLEAR~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_sorting_control|cur_state.WAIT_CLEAR~0_combout\ = ( \u_sorting_control|cur_state.SORT~q\ ) # ( !\u_sorting_control|cur_state.SORT~q\ & ( (\u_sorting_control|cur_state.IDLE~q\ & (\u_item_presence|item_present~q\ & 
-- (!\u_sorting_control|Selector1~2_combout\ & \u_sorting_control|cur_state.WAIT_CLEAR~q\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000010000000000000001000011111111111111111111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \u_sorting_control|ALT_INV_cur_state.IDLE~q\,
	datab => \u_item_presence|ALT_INV_item_present~q\,
	datac => \u_sorting_control|ALT_INV_Selector1~2_combout\,
	datad => \u_sorting_control|ALT_INV_cur_state.WAIT_CLEAR~q\,
	dataf => \u_sorting_control|ALT_INV_cur_state.SORT~q\,
	combout => \u_sorting_control|cur_state.WAIT_CLEAR~0_combout\);

-- Location: FF_X88_Y26_N22
\u_sorting_control|cur_state.WAIT_CLEAR\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_sorting_control|cur_state.WAIT_CLEAR~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_sorting_control|cur_state.WAIT_CLEAR~q\);

-- Location: LABCELL_X88_Y26_N3
\u_sorting_control|Selector0~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_sorting_control|Selector0~0_combout\ = ( \u_sorting_control|cur_state.CHECK~q\ & ( ((!\u_sorting_control|cur_state.WAIT_CLEAR~q\ & \u_sorting_control|cur_state.SORT~q\)) # (\u_item_presence|item_present~q\) ) ) # ( 
-- !\u_sorting_control|cur_state.CHECK~q\ & ( ((!\u_sorting_control|cur_state.WAIT_CLEAR~q\ & ((\u_sorting_control|cur_state.IDLE~q\) # (\u_sorting_control|cur_state.SORT~q\)))) # (\u_item_presence|item_present~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101110111011101010111011101110101011101010111010101110101011101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \u_item_presence|ALT_INV_item_present~q\,
	datab => \u_sorting_control|ALT_INV_cur_state.WAIT_CLEAR~q\,
	datac => \u_sorting_control|ALT_INV_cur_state.SORT~q\,
	datad => \u_sorting_control|ALT_INV_cur_state.IDLE~q\,
	dataf => \u_sorting_control|ALT_INV_cur_state.CHECK~q\,
	combout => \u_sorting_control|Selector0~0_combout\);

-- Location: FF_X88_Y26_N5
\u_sorting_control|cur_state.IDLE\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_sorting_control|Selector0~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_sorting_control|cur_state.IDLE~q\);

-- Location: LABCELL_X88_Y26_N18
\u_sorting_control|Selector1~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_sorting_control|Selector1~0_combout\ = ( \u_item_presence|item_present~q\ & ( (!\u_sorting_control|cur_state.SORT~q\ & ((!\u_sorting_control|cur_state.IDLE~q\) # (\u_sorting_control|cur_state.CHECK~q\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000010101111000000001010111100000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \u_sorting_control|ALT_INV_cur_state.IDLE~q\,
	datac => \u_sorting_control|ALT_INV_cur_state.CHECK~q\,
	datad => \u_sorting_control|ALT_INV_cur_state.SORT~q\,
	dataf => \u_item_presence|ALT_INV_item_present~q\,
	combout => \u_sorting_control|Selector1~0_combout\);

-- Location: LABCELL_X88_Y26_N51
\u_sorting_control|Selector1~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_sorting_control|Selector1~1_combout\ = ( \u_sorting_control|cur_state.CHECK~q\ & ( \u_sorting_control|Selector1~0_combout\ & ( (!\item_type[1]~input_o\ & ((!\item_type[0]~input_o\ & (!\left_free~input_o\)) # (\item_type[0]~input_o\ & 
-- ((!\right_free~input_o\))))) # (\item_type[1]~input_o\ & (((!\right_free~input_o\ & !\item_type[0]~input_o\)))) ) ) ) # ( !\u_sorting_control|cur_state.CHECK~q\ & ( \u_sorting_control|Selector1~0_combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111111111011100011000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_left_free~input_o\,
	datab => \ALT_INV_item_type[1]~input_o\,
	datac => \ALT_INV_right_free~input_o\,
	datad => \ALT_INV_item_type[0]~input_o\,
	datae => \u_sorting_control|ALT_INV_cur_state.CHECK~q\,
	dataf => \u_sorting_control|ALT_INV_Selector1~0_combout\,
	combout => \u_sorting_control|Selector1~1_combout\);

-- Location: FF_X88_Y26_N53
\u_sorting_control|cur_state.CHECK\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_sorting_control|Selector1~1_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_sorting_control|cur_state.CHECK~q\);

-- Location: LABCELL_X88_Y26_N12
\u_sorting_control|Selector2~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_sorting_control|Selector2~0_combout\ = ( \right_free~input_o\ & ( \u_sorting_control|cur_state.CHECK~q\ & ( (\u_item_presence|item_present~q\ & (((\item_type[1]~input_o\) # (\item_type[0]~input_o\)) # (\left_free~input_o\))) ) ) ) # ( 
-- !\right_free~input_o\ & ( \u_sorting_control|cur_state.CHECK~q\ & ( (\u_item_presence|item_present~q\ & ((!\item_type[0]~input_o\ & (\left_free~input_o\ & !\item_type[1]~input_o\)) # (\item_type[0]~input_o\ & ((\item_type[1]~input_o\))))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000010000000000110001001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_left_free~input_o\,
	datab => \u_item_presence|ALT_INV_item_present~q\,
	datac => \ALT_INV_item_type[0]~input_o\,
	datad => \ALT_INV_item_type[1]~input_o\,
	datae => \ALT_INV_right_free~input_o\,
	dataf => \u_sorting_control|ALT_INV_cur_state.CHECK~q\,
	combout => \u_sorting_control|Selector2~0_combout\);

-- Location: FF_X88_Y26_N14
\u_sorting_control|cur_state.SORT\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_sorting_control|Selector2~0_combout\,
	clrn => \ALT_INV_rst~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_sorting_control|cur_state.SORT~q\);

-- Location: MLABCELL_X87_Y26_N57
\u_output_driver|Mux1~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_output_driver|Mux1~0_combout\ = ( !\item_type[1]~input_o\ & ( (!\item_type[0]~input_o\ & \u_sorting_control|cur_state.SORT~q\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000010101010000000001010101000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_item_type[0]~input_o\,
	datad => \u_sorting_control|ALT_INV_cur_state.SORT~q\,
	dataf => \ALT_INV_item_type[1]~input_o\,
	combout => \u_output_driver|Mux1~0_combout\);

-- Location: LABCELL_X88_Y26_N39
\u_output_driver|Mux2~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_output_driver|Mux2~0_combout\ = ( \u_sorting_control|cur_state.SORT~q\ & ( !\item_type[0]~input_o\ $ (!\item_type[1]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000001011010010110100101101001011010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_item_type[0]~input_o\,
	datac => \ALT_INV_item_type[1]~input_o\,
	dataf => \u_sorting_control|ALT_INV_cur_state.SORT~q\,
	combout => \u_output_driver|Mux2~0_combout\);

-- Location: MLABCELL_X87_Y26_N51
\u_output_driver|Mux3~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_output_driver|Mux3~0_combout\ = ( \u_sorting_control|cur_state.SORT~q\ & ( \item_type[1]~input_o\ & ( \item_type[0]~input_o\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000101010101010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_item_type[0]~input_o\,
	datae => \u_sorting_control|ALT_INV_cur_state.SORT~q\,
	dataf => \ALT_INV_item_type[1]~input_o\,
	combout => \u_output_driver|Mux3~0_combout\);

-- Location: LABCELL_X88_Y26_N30
\u_output_driver|Mux1~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_output_driver|Mux1~1_combout\ = ( \u_sorting_control|cur_state.SORT~q\ & ( (!\item_type[0]~input_o\) # (!\item_type[1]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011111111111100001111111111110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_item_type[0]~input_o\,
	datad => \ALT_INV_item_type[1]~input_o\,
	dataf => \u_sorting_control|ALT_INV_cur_state.SORT~q\,
	combout => \u_output_driver|Mux1~1_combout\);

-- Location: LABCELL_X88_Y26_N54
\u_item_counter|cnt[1]~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_item_counter|cnt[1]~2_combout\ = ( \u_output_driver|Mux1~1_combout\ & ( (!\rst~input_o\ & (!\u_item_counter|cnt\(1) $ (((!\u_item_counter|cnt\(0)) # (\u_item_counter|cnt[0]~0_combout\))))) ) ) # ( !\u_output_driver|Mux1~1_combout\ & ( (!\rst~input_o\ & 
-- \u_item_counter|cnt\(1)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011001100000000001100110001000000100011000100000010001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \u_item_counter|ALT_INV_cnt\(0),
	datab => \ALT_INV_rst~input_o\,
	datac => \u_item_counter|ALT_INV_cnt[0]~0_combout\,
	datad => \u_item_counter|ALT_INV_cnt\(1),
	dataf => \u_output_driver|ALT_INV_Mux1~1_combout\,
	combout => \u_item_counter|cnt[1]~2_combout\);

-- Location: FF_X88_Y26_N56
\u_item_counter|cnt[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_item_counter|cnt[1]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_item_counter|cnt\(1));

-- Location: LABCELL_X88_Y26_N42
\u_item_counter|cnt[2]~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_item_counter|cnt[2]~3_combout\ = ( \u_item_counter|cnt\(2) & ( \u_output_driver|Mux1~1_combout\ & ( (!\rst~input_o\ & ((!\u_item_counter|cnt\(1)) # ((!\u_item_counter|cnt\(0)) # (\u_item_counter|cnt\(3))))) ) ) ) # ( !\u_item_counter|cnt\(2) & ( 
-- \u_output_driver|Mux1~1_combout\ & ( (\u_item_counter|cnt\(1) & (!\rst~input_o\ & \u_item_counter|cnt\(0))) ) ) ) # ( \u_item_counter|cnt\(2) & ( !\u_output_driver|Mux1~1_combout\ & ( !\rst~input_o\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000110011001100110000000100000001001100100011001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \u_item_counter|ALT_INV_cnt\(1),
	datab => \ALT_INV_rst~input_o\,
	datac => \u_item_counter|ALT_INV_cnt\(0),
	datad => \u_item_counter|ALT_INV_cnt\(3),
	datae => \u_item_counter|ALT_INV_cnt\(2),
	dataf => \u_output_driver|ALT_INV_Mux1~1_combout\,
	combout => \u_item_counter|cnt[2]~3_combout\);

-- Location: FF_X88_Y26_N44
\u_item_counter|cnt[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_item_counter|cnt[2]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_item_counter|cnt\(2));

-- Location: LABCELL_X88_Y26_N57
\u_item_counter|cnt[0]~4\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_item_counter|cnt[0]~4_combout\ = ( \u_item_counter|cnt\(0) & ( (\u_item_counter|cnt\(2) & \u_item_counter|cnt\(1)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000011110000000000001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \u_item_counter|ALT_INV_cnt\(2),
	datad => \u_item_counter|ALT_INV_cnt\(1),
	dataf => \u_item_counter|ALT_INV_cnt\(0),
	combout => \u_item_counter|cnt[0]~4_combout\);

-- Location: LABCELL_X88_Y26_N6
\u_item_counter|cnt[3]~5\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_item_counter|cnt[3]~5_combout\ = ( \u_item_counter|cnt\(3) & ( \u_item_counter|cnt[0]~4_combout\ & ( !\rst~input_o\ ) ) ) # ( !\u_item_counter|cnt\(3) & ( \u_item_counter|cnt[0]~4_combout\ & ( (!\rst~input_o\ & (\u_sorting_control|cur_state.SORT~q\ & 
-- ((!\item_type[1]~input_o\) # (!\item_type[0]~input_o\)))) ) ) ) # ( \u_item_counter|cnt\(3) & ( !\u_item_counter|cnt[0]~4_combout\ & ( !\rst~input_o\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000101010101010101000000000101010001010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_rst~input_o\,
	datab => \ALT_INV_item_type[1]~input_o\,
	datac => \ALT_INV_item_type[0]~input_o\,
	datad => \u_sorting_control|ALT_INV_cur_state.SORT~q\,
	datae => \u_item_counter|ALT_INV_cnt\(3),
	dataf => \u_item_counter|ALT_INV_cnt[0]~4_combout\,
	combout => \u_item_counter|cnt[3]~5_combout\);

-- Location: FF_X88_Y26_N8
\u_item_counter|cnt[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_item_counter|cnt[3]~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_item_counter|cnt\(3));

-- Location: LABCELL_X88_Y26_N33
\u_item_counter|cnt[0]~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_item_counter|cnt[0]~0_combout\ = ( \u_item_counter|cnt\(0) & ( (\u_item_counter|cnt\(3) & (\u_item_counter|cnt\(2) & \u_item_counter|cnt\(1))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000110000000000000011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \u_item_counter|ALT_INV_cnt\(3),
	datac => \u_item_counter|ALT_INV_cnt\(2),
	datad => \u_item_counter|ALT_INV_cnt\(1),
	dataf => \u_item_counter|ALT_INV_cnt\(0),
	combout => \u_item_counter|cnt[0]~0_combout\);

-- Location: LABCELL_X88_Y26_N24
\u_item_counter|cnt[0]~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \u_item_counter|cnt[0]~1_combout\ = ( \u_item_counter|cnt\(0) & ( \u_sorting_control|cur_state.SORT~q\ & ( (!\rst~input_o\ & (((\item_type[0]~input_o\ & \item_type[1]~input_o\)) # (\u_item_counter|cnt[0]~0_combout\))) ) ) ) # ( !\u_item_counter|cnt\(0) & 
-- ( \u_sorting_control|cur_state.SORT~q\ & ( (!\rst~input_o\ & (!\u_item_counter|cnt[0]~0_combout\ & ((!\item_type[0]~input_o\) # (!\item_type[1]~input_o\)))) ) ) ) # ( \u_item_counter|cnt\(0) & ( !\u_sorting_control|cur_state.SORT~q\ & ( !\rst~input_o\ ) ) 
-- )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000110011001100110011000000100000000000110001001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_item_type[0]~input_o\,
	datab => \ALT_INV_rst~input_o\,
	datac => \u_item_counter|ALT_INV_cnt[0]~0_combout\,
	datad => \ALT_INV_item_type[1]~input_o\,
	datae => \u_item_counter|ALT_INV_cnt\(0),
	dataf => \u_sorting_control|ALT_INV_cur_state.SORT~q\,
	combout => \u_item_counter|cnt[0]~1_combout\);

-- Location: FF_X88_Y26_N26
\u_item_counter|cnt[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputCLKENA0_outclk\,
	d => \u_item_counter|cnt[0]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \u_item_counter|cnt\(0));

-- Location: LABCELL_X4_Y79_N0
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


