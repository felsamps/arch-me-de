LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
LIBRARY work;
USE work.ME_package.all;

ENTITY top_level_arch IS
	PORT (
		-- CONTROL SIGNALS
		clk, reset : STD_LOGIC;
		en_col_0,en_col_1,en_col_2,en_col_3,
		en_col_4,en_col_5,en_col_6,en_col_7,
		en_col_8,en_col_9,en_col_10,en_col_11,
		en_col_12,en_col_13,en_col_14,en_col_15 : IN STD_LOGIC;
		enable_comp : IN STD_LOGIC;
		enable_sw_buffer : IN STD_LOGIC;
		enable_cb_buffer : IN STD_LOGIC;
		data_in_buffer_cb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		data_in_column_sw_0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		data_in_column_sw_1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		best_SAD : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		best_MV : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END top_level_arch;

ARCHITECTURE structure OF top_level_arch IS
	SIGNAL cb_column : BUFFER_CB_TYPE;
	SIGNAL sw_column : COLUMN_16;
	
BEGIN
	ME_CORE_0: ME_core
	PORT MAP (
		clk, reset,
		en_col_0,en_col_1,en_col_2,en_col_3,
		en_col_4,en_col_5,en_col_6,en_col_7,
		en_col_8,en_col_9,en_col_10,en_col_11,
		en_col_12,en_col_13,en_col_14,en_col_15,
		enable_comp,
		sw_column,
		cb_column(0), cb_column(1), cb_column(2), cb_column(3), 
		cb_column(4), cb_column(5), cb_column(6), cb_column(7), 
		cb_column(8), cb_column(9), cb_column(10), cb_column(11), 
		cb_column(12), cb_column(13), cb_column(14), cb_column(15),
		best_SAD,
		best_MV
	);
	
	BUFFER_SW_0: buffer_column
	PORT MAP (
		clk, reset,
		enable_sw_buffer,
		data_in_column_sw_0, data_in_column_sw_1,
		sw_column
	);
	
	BUFFER_CB_0: buffer_cb_column
	PORT MAP (
		clk, reset,
		enable_cb_buffer,
		data_in_buffer_cb,
		cb_column
	);

	
END structure;