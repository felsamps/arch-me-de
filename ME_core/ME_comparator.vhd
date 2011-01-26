LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
LIBRARY work;
USE work.ME_package.all;


entity ME_comparator is
	PORT(
		clk, reset : IN STD_LOGIC;
		enable     : IN STD_LOGIC;
		in_SAD     : IN COLUMN_SAD_TYPE;
		in_MV      : IN COLUMN_MV_TYPE;
		out_SAD    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		out_MV     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
end ME_comparator;

ARCHITECTURE behavioral OF ME_comparator IS
	
	TYPE STAGE_0_SAD_TYPE IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	TYPE STAGE_1_SAD_TYPE IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	TYPE STAGE_2_SAD_TYPE IS ARRAY (0 TO 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	TYPE STAGE_0_MV_TYPE IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	TYPE STAGE_1_MV_TYPE IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	TYPE STAGE_2_MV_TYPE IS ARRAY (0 TO 1) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL stage_0_sad,reg_stage_0_sad : STAGE_0_SAD_TYPE;
	SIGNAL stage_1_sad,reg_stage_1_sad : STAGE_1_SAD_TYPE;
	SIGNAL stage_2_sad,reg_stage_2_sad : STAGE_2_SAD_TYPE;
	SIGNAL stage_3_sad,reg_stage_3_sad : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL stage_0_mv,reg_stage_0_mv : STAGE_0_MV_TYPE;
	SIGNAL stage_1_mv,reg_stage_1_mv : STAGE_1_MV_TYPE;
	SIGNAL stage_2_mv,reg_stage_2_mv : STAGE_2_MV_TYPE;
	SIGNAL stage_3_mv,reg_stage_3_mv : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL diff_in : STAGE_0_SAD_TYPE;
	SIGNAL diff_stage_0 : STAGE_1_SAD_TYPE;
	SIGNAL diff_stage_1 : STAGE_2_SAD_TYPE;
	SIGNAL diff_stage_2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

	PROCESS(clk, reset)
	BEGIN
		IF reset = '1' THEN
			reg_stage_0_sad <= (OTHERS=>(OTHERS=>'0'));
			reg_stage_1_sad <= (OTHERS=>(OTHERS=>'0'));
			reg_stage_2_sad <= (OTHERS=>(OTHERS=>'0'));
			reg_stage_3_sad <= (OTHERS=>'0');
			reg_stage_0_mv <= (OTHERS=>(OTHERS=>'0'));
			reg_stage_1_mv <= (OTHERS=>(OTHERS=>'0'));
			reg_stage_2_mv <= (OTHERS=>(OTHERS=>'0'));
			reg_stage_3_mv <= (OTHERS=>'0');
			out_SAD <= (OTHERS=>'0');
			out_MV  <= (OTHERS=>'0');
		ELSIF clk'EVENT AND clk = '1' THEN
			IF enable = '1' THEN 
				reg_stage_0_sad <= stage_0_sad;
				reg_stage_1_sad <= stage_1_sad;
				reg_stage_2_sad <= stage_2_sad;
				out_SAD <= stage_3_sad;
				reg_stage_0_mv <= stage_0_mv;
				reg_stage_1_mv <= stage_1_mv;
				reg_stage_2_mv <= stage_2_mv;
				out_MV  <= stage_3_mv;
			END IF;
		END IF;
	END PROCESS;

	-- DIFFERENCES TREE
	diff_in(0) <= in_SAD(0) - in_SAD(1);
	diff_in(1) <= in_SAD(2) - in_SAD(3);
	diff_in(2) <= in_SAD(4) - in_SAD(5);
	diff_in(3) <= in_SAD(6) - in_SAD(7);
	diff_in(4) <= in_SAD(8) - in_SAD(9);
	diff_in(5) <= in_SAD(10) - in_SAD(11);
	diff_in(6) <= in_SAD(12) - in_SAD(13);
	diff_in(7) <= in_SAD(14) - in_SAD(15);
	
	diff_stage_0(0) <= reg_stage_0_sad(0) - reg_stage_0_sad(1);
	diff_stage_0(1) <= reg_stage_0_sad(2) - reg_stage_0_sad(3);
	diff_stage_0(2) <= reg_stage_0_sad(4) - reg_stage_0_sad(5);
	diff_stage_0(3) <= reg_stage_0_sad(6) - reg_stage_0_sad(7);
	
	diff_stage_1(0) <= reg_stage_1_sad(0) - reg_stage_1_sad(1);
	diff_stage_1(1) <= reg_stage_1_sad(2) - reg_stage_1_sad(3);
	
	diff_stage_2 <= reg_stage_2_sad(0) - reg_stage_2_sad(1);
	
	-- SAD DECISION
	WITH diff_in(0)(15) SELECT
		stage_0_sad(0) <= in_SAD(0) WHEN '1',
								in_SAD(1) WHEN OTHERS;
	WITH diff_in(1)(15) SELECT
		stage_0_sad(1) <= in_SAD(2) WHEN '1',
								in_SAD(3) WHEN OTHERS;
	WITH diff_in(2)(15) SELECT
		stage_0_sad(2) <= in_SAD(4) WHEN '1',
								in_SAD(5) WHEN OTHERS;
	WITH diff_in(3)(15) SELECT
		stage_0_sad(3) <= in_SAD(6) WHEN '1',
								in_SAD(7) WHEN OTHERS;
	WITH diff_in(4)(15) SELECT
		stage_0_sad(4) <= in_SAD(8) WHEN '1',
								in_SAD(9) WHEN OTHERS;
	WITH diff_in(5)(15) SELECT
		stage_0_sad(5) <= in_SAD(10) WHEN '1',
								in_SAD(11) WHEN OTHERS;
	WITH diff_in(6)(15) SELECT
		stage_0_sad(6) <= in_SAD(12) WHEN '1',
								in_SAD(13) WHEN OTHERS;
	WITH diff_in(7)(15) SELECT
		stage_0_sad(7) <= in_SAD(14) WHEN '1',
								in_SAD(15) WHEN OTHERS;
	
	
	WITH diff_stage_0(0)(15) SELECT
		stage_1_sad(0) <= reg_stage_0_sad(0) WHEN '1',
								reg_stage_0_sad(1) WHEN OTHERS;
	WITH diff_stage_0(1)(15) SELECT
		stage_1_sad(1) <= reg_stage_0_sad(2) WHEN '1',
								reg_stage_0_sad(3) WHEN OTHERS;
	WITH diff_stage_0(2)(15) SELECT
		stage_1_sad(2) <= reg_stage_0_sad(4) WHEN '1',
								reg_stage_0_sad(5) WHEN OTHERS;
	WITH diff_stage_0(3)(15) SELECT
		stage_1_sad(3) <= reg_stage_0_sad(6) WHEN '1',
								reg_stage_0_sad(7) WHEN OTHERS;

	WITH diff_stage_1(0)(15) SELECT
		stage_2_sad(0) <= reg_stage_1_sad(0) WHEN '1',
								reg_stage_1_sad(1) WHEN OTHERS;
	WITH diff_stage_1(1)(15) SELECT
		stage_2_sad(1) <= reg_stage_1_sad(2) WHEN '1',
								reg_stage_1_sad(3) WHEN OTHERS;

	WITH diff_stage_2(15) SELECT
		stage_3_sad <= reg_stage_2_sad(0) WHEN '1',
								reg_stage_2_sad(1) WHEN OTHERS;
								
	-- MOTION VECTOR DECISON
	WITH diff_in(0)(15) SELECT
		stage_0_mv(0) <= in_MV(0) WHEN '1',
								in_MV(1) WHEN OTHERS;
	WITH diff_in(1)(15) SELECT
		stage_0_mv(1) <= in_MV(2) WHEN '1',
								in_MV(3) WHEN OTHERS;
	WITH diff_in(2)(15) SELECT
		stage_0_mv(2) <= in_MV(4) WHEN '1',
								in_MV(5) WHEN OTHERS;
	WITH diff_in(3)(15) SELECT
		stage_0_mv(3) <= in_MV(6) WHEN '1',
								in_MV(7) WHEN OTHERS;
	WITH diff_in(4)(15) SELECT
		stage_0_mv(4) <= in_MV(8) WHEN '1',
								in_MV(9) WHEN OTHERS;
	WITH diff_in(5)(15) SELECT
		stage_0_mv(5) <= in_MV(10) WHEN '1',
								in_MV(11) WHEN OTHERS;
	WITH diff_in(6)(15) SELECT
		stage_0_mv(6) <= in_MV(12) WHEN '1',
								in_MV(13) WHEN OTHERS;
	WITH diff_in(7)(15) SELECT
		stage_0_mv(7) <= in_MV(14) WHEN '1',
								in_MV(15) WHEN OTHERS;
								
	WITH diff_stage_0(0)(15) SELECT
		stage_1_mv(0) <= reg_stage_0_mv(0) WHEN '1',
								reg_stage_0_mv(1) WHEN OTHERS;
	WITH diff_stage_0(1)(15) SELECT
		stage_1_mv(1) <= reg_stage_0_mv(2) WHEN '1',
								reg_stage_0_mv(3) WHEN OTHERS;
	WITH diff_stage_0(2)(15) SELECT
		stage_1_mv(2) <= reg_stage_0_mv(4) WHEN '1',
								reg_stage_0_mv(5) WHEN OTHERS;
	WITH diff_stage_0(3)(15) SELECT
		stage_1_mv(3) <= reg_stage_0_mv(6) WHEN '1',
								reg_stage_0_mv(7) WHEN OTHERS;
								
	WITH diff_stage_1(0)(15) SELECT
		stage_2_mv(0) <= reg_stage_1_mv(0) WHEN '1',
								reg_stage_1_mv(1) WHEN OTHERS;
	WITH diff_stage_1(1)(15) SELECT
		stage_2_mv(1) <= reg_stage_1_mv(2) WHEN '1',
								reg_stage_1_mv(3) WHEN OTHERS;
								
	WITH diff_stage_2(15) SELECT
		stage_3_mv <= reg_stage_2_mv(0) WHEN '1',
								reg_stage_2_mv(1) WHEN OTHERS;

END behavioral;

