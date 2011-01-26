LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

PACKAGE ME_Package IS
	TYPE COLUMN_16 IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	TYPE BUFFER_CB_TYPE IS ARRAY (0 TO 15) OF COLUMN_16;
	
	TYPE BUFFER_STATE IS (ROLLING, NEW_COLUMN);
	TYPE BUFFER_CB_STATE IS (ROLLING, NEW_COLUMN);
	
	TYPE COLUMN_SAD_TYPE IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	TYPE COLUMN_MV_TYPE IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	TYPE COLUMN_MV_VER_TYPE IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	COMPONENT SAD_unit IS
		PORT(clk, reset   : IN STD_LOGIC;
			 curr_line_16,ref_line_16 : IN COLUMN_16;
			 out_SAD      : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
		 );
	END COMPONENT;	
	
	COMPONENT PE_comparator IS
		PORT(clk, reset : IN STD_LOGIC;
			 enable     : IN STD_LOGIC;
			 in_SAD     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			 in_MV_ver  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			 out_SAD    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 out_MV_ver : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT PE_column IS
		PORT( 
		clk,reset                 : IN STD_LOGIC;
		--CONTROL INPUTS
		enable                    : IN STD_LOGIC;
		--DATA INPUTS
		curr_line_16, ref_line_16 : IN COLUMN_16;
		best_SAD                  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		best_MV                   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT ME_comparator is
		PORT(
			clk, reset : IN STD_LOGIC;
			enable     : IN STD_LOGIC;
			in_SAD     : IN COLUMN_SAD_TYPE;
			in_MV      : IN COLUMN_MV_TYPE;
			out_SAD    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			out_MV     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT buffer_cb_column IS
		PORT(clk, reset            : IN STD_LOGIC;
			 enable                : IN STD_LOGIC;
			 data_in               : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 data_out              : OUT BUFFER_CB_TYPE
		);
	END COMPONENT;

	COMPONENT buffer_column IS
		PORT(clk, reset             : IN STD_LOGIC;
			  enable				: IN STD_LOGIC;
			  data_in0, data_in1    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			  data_out              : OUT COLUMN_16
		);
	END COMPONENT;
	
	COMPONENT ME_core IS
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
		cb_column_12,cb_column_13,cb_column_14,cb_column_15 : IN COLUMN_16;
		best_SAD             : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		best_MV              : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT local_memory IS
		PORT(
			clk : IN STD_LOGIC;
			read_write : IN STD_LOGIC;
			address : IN STD_LOGIC_VECTOR (14 DOWNTO 0);
			data_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			data_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END COMPONENT;
	
END PACKAGE;
