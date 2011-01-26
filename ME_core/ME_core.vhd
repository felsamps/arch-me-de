LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
LIBRARY work;
USE work.ME_package.all;

ENTITY ME_core IS
	PORT(
	clk, reset          : IN STD_LOGIC;
	-- CONTROL SIGNALS
	en_col_0,en_col_1,en_col_2,en_col_3,
	en_col_4,en_col_5,en_col_6,en_col_7,
	en_col_8,en_col_9,en_col_10,en_col_11,
	en_col_12,en_col_13,en_col_14,en_col_15 : IN STD_LOGIC;
	enable_comp : IN STD_LOGIC;
	-- DATA
	sw_column  : IN COLUMN_16;
	cb_column_0,cb_column_1,cb_column_2,cb_column_3,
	cb_column_4,cb_column_5,cb_column_6,cb_column_7,
	cb_column_8,cb_column_9,cb_column_10,cb_column_11,
	cb_column_12,cb_column_13,cb_column_14,cb_column_15 : IN COLUMN_16;	--TODO  instanciar as demais PEs
	best_SAD             : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	best_MV              : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END ME_core;

ARCHITECTURE behavorial OF ME_core IS

	SIGNAL column_SAD : COLUMN_SAD_TYPE;
	SIGNAL column_MV_ver: COLUMN_MV_VER_TYPE;
	SIGNAL column_MV  : COLUMN_MV_TYPE;
	
BEGIN

	PE_COLUMN_0: PE_column PORT MAP(clk, reset, en_col_0, cb_column_0, sw_column,    column_SAD(0 ),column_MV_ver(0 ));
	PE_COLUMN_1: PE_column PORT MAP(clk, reset, en_col_1, cb_column_1, sw_column,    column_SAD(1 ),column_MV_ver(1 ));
	PE_COLUMN_2: PE_column PORT MAP(clk, reset, en_col_2, cb_column_2, sw_column,    column_SAD(2 ),column_MV_ver(2 ));
	PE_COLUMN_3: PE_column PORT MAP(clk, reset, en_col_3, cb_column_3, sw_column,    column_SAD(3 ),column_MV_ver(3 ));
	PE_COLUMN_4: PE_column PORT MAP(clk, reset, en_col_4, cb_column_4, sw_column,    column_SAD(4 ),column_MV_ver(4 ));
	PE_COLUMN_5: PE_column PORT MAP(clk, reset, en_col_5, cb_column_5, sw_column,    column_SAD(5 ),column_MV_ver(5 ));
	PE_COLUMN_6: PE_column PORT MAP(clk, reset, en_col_6, cb_column_6, sw_column,    column_SAD(6 ),column_MV_ver(6 ));
	PE_COLUMN_7: PE_column PORT MAP(clk, reset, en_col_7, cb_column_7, sw_column,    column_SAD(7 ),column_MV_ver(7 ));
	PE_COLUMN_8: PE_column PORT MAP(clk, reset, en_col_8, cb_column_8, sw_column,    column_SAD(8 ),column_MV_ver(8 ));
	PE_COLUMN_9: PE_column PORT MAP(clk, reset, en_col_9, cb_column_9, sw_column,    column_SAD(9 ),column_MV_ver(9 ));
	PE_COLUMN_10: PE_column PORT MAP(clk, reset, en_col_10, cb_column_10, sw_column, column_SAD(10),column_MV_ver(10));
	PE_COLUMN_11: PE_column PORT MAP(clk, reset, en_col_11, cb_column_11, sw_column, column_SAD(11),column_MV_ver(11));
	PE_COLUMN_12: PE_column PORT MAP(clk, reset, en_col_12, cb_column_12, sw_column, column_SAD(12),column_MV_ver(12));
	PE_COLUMN_13: PE_column PORT MAP(clk, reset, en_col_13, cb_column_13, sw_column, column_SAD(13),column_MV_ver(13));
	PE_COLUMN_14: PE_column PORT MAP(clk, reset, en_col_14, cb_column_14, sw_column, column_SAD(14),column_MV_ver(14));
	PE_COLUMN_15: PE_column PORT MAP(clk, reset, en_col_15, cb_column_15, sw_column, column_SAD(15),column_MV_ver(15));
	
	column_MV(0) <= ("1000"&column_MV_ver(0));
	column_MV(1) <= ("1001"&column_MV_ver(1));
	column_MV(2) <= ("1010"&column_MV_ver(2));
	column_MV(3) <= ("1011"&column_MV_ver(3));
	column_MV(4) <= ("1100"&column_MV_ver(4));
	column_MV(5) <= ("1101"&column_MV_ver(5));
	column_MV(6) <= ("1110"&column_MV_ver(6));
	column_MV(7) <= ("1111"&column_MV_ver(7));
	column_MV(8) <= ("0000"&column_MV_ver(8));
	column_MV(9) <= ("0001"&column_MV_ver(9));
	column_MV(10) <= ("0010"&column_MV_ver(10));
	column_MV(11) <= ("0011"&column_MV_ver(11));
	column_MV(12) <= ("0100"&column_MV_ver(12));
	column_MV(13) <= ("0101"&column_MV_ver(13));
	column_MV(14) <= ("0110"&column_MV_ver(14));
	column_MV(15) <= ("0111"&column_MV_ver(15));
	
	COMPARATOR: ME_comparator PORT MAP(clk, reset, enable_comp, column_SAD, column_MV, best_SAD, best_MV);
	
END behavorial;