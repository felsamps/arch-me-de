LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
LIBRARY work;
USE work.ME_package.all;

ENTITY SAD_unit IS
	PORT(clk, reset   : IN STD_LOGIC;
		 curr_line_16,ref_line_16 : IN COLUMN_16;
		 out_SAD      : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
	 );
END SAD_unit;

ARCHITECTURE behavorial OF SAD_unit IS

	TYPE STAGE_0_TYPE IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(8  DOWNTO 0);
	TYPE STAGE_1_TYPE IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR(9  DOWNTO 0);
	TYPE STAGE_2_TYPE IS ARRAY (0 TO 1) OF STD_LOGIC_VECTOR(10 DOWNTO 0);	

	SIGNAL diff_line_16_A, diff_line_16_B, diff_line_16_ABS, diff_line_16_reg : COLUMN_16;
	SIGNAL stage_0, stage_0_reg                                               : STAGE_0_TYPE;
	SIGNAL stage_1, stage_1_reg                                               : STAGE_1_TYPE;
	SIGNAL stage_2, stage_2_reg                                               : STAGE_2_TYPE;
	SIGNAL stage_3                                                            : STD_LOGIC_VECTOR(11 DOWNTO 0);
	
BEGIN

	PROCESS(clk,reset)
	BEGIN
		IF reset = '1' THEN
			diff_line_16_reg <= (OTHERS => (OTHERS =>'0'));
			stage_0_reg      <= (OTHERS => (OTHERS =>'0'));
			stage_1_reg      <= (OTHERS => (OTHERS =>'0'));
			stage_2_reg      <= (OTHERS => (OTHERS =>'0'));
			out_SAD          <= (OTHERS =>'0');
		ELSIF clk'EVENT AND clk = '1' THEN
			diff_line_16_reg <= diff_line_16_ABS;
			stage_0_reg      <= stage_0;
			stage_1_reg      <= stage_1;
			stage_2_reg      <= stage_2;
			out_SAD          <= stage_3;
		END IF;
	END PROCESS;
	--SUBTRACTORS STAGE
	diff_line_16_A(0) <= curr_line_16(0)   - ref_line_16(0);
	diff_line_16_A(1) <= curr_line_16(1)   - ref_line_16(1);
	diff_line_16_A(2) <= curr_line_16(2)   - ref_line_16(2);
	diff_line_16_A(3) <= curr_line_16(3)   - ref_line_16(3);
	diff_line_16_A(4) <= curr_line_16(4)   - ref_line_16(4);
	diff_line_16_A(5) <= curr_line_16(5)   - ref_line_16(5);
	diff_line_16_A(6) <= curr_line_16(6)   - ref_line_16(6);
	diff_line_16_A(7) <= curr_line_16(7)   - ref_line_16(7);
	diff_line_16_A(8) <= curr_line_16(8)   - ref_line_16(8);
	diff_line_16_A(9) <= curr_line_16(9)   - ref_line_16(9);
	diff_line_16_A(10) <= curr_line_16(10) - ref_line_16(10);
	diff_line_16_A(11) <= curr_line_16(11) - ref_line_16(11);
	diff_line_16_A(12) <= curr_line_16(12) - ref_line_16(12);
	diff_line_16_A(13) <= curr_line_16(13) - ref_line_16(13);
	diff_line_16_A(14) <= curr_line_16(14) - ref_line_16(14);
	diff_line_16_A(15) <= curr_line_16(15) - ref_line_16(15);
	
	diff_line_16_B(0) <= ref_line_16(0)   - curr_line_16(0);
	diff_line_16_B(1) <= ref_line_16(1)   - curr_line_16(1);
	diff_line_16_B(2) <= ref_line_16(2)   - curr_line_16(2);
	diff_line_16_B(3) <= ref_line_16(3)   - curr_line_16(3);
	diff_line_16_B(4) <= ref_line_16(4)   - curr_line_16(4);
	diff_line_16_B(5) <= ref_line_16(5)   - curr_line_16(5);
	diff_line_16_B(6) <= ref_line_16(6)   - curr_line_16(6);
	diff_line_16_B(7) <= ref_line_16(7)   - curr_line_16(7);
	diff_line_16_B(8) <= ref_line_16(8)   - curr_line_16(8);
	diff_line_16_B(9) <= ref_line_16(9)   - curr_line_16(9);
	diff_line_16_B(10) <= ref_line_16(10) - curr_line_16(10);
	diff_line_16_B(11) <= ref_line_16(11) - curr_line_16(11);
	diff_line_16_B(12) <= ref_line_16(12) - curr_line_16(12);
	diff_line_16_B(13) <= ref_line_16(13) - curr_line_16(13);
	diff_line_16_B(14) <= ref_line_16(14) - curr_line_16(14);
	diff_line_16_B(15) <= ref_line_16(15) - curr_line_16(15);
	
	WITH diff_line_16_A(0)(7) SELECT
		diff_line_16_ABS(0) <= diff_line_16_A(0) WHEN '0',
						   diff_line_16_B(0) WHEN OTHERS;
	WITH diff_line_16_A(1)(7) SELECT
		diff_line_16_ABS(1) <= diff_line_16_A(1) WHEN '0',
						   diff_line_16_B(1) WHEN OTHERS;
	WITH diff_line_16_A(2)(7) SELECT
		diff_line_16_ABS(2) <= diff_line_16_A(2) WHEN '0',
						   diff_line_16_B(2) WHEN OTHERS;
	WITH diff_line_16_A(3)(7) SELECT
		diff_line_16_ABS(3) <= diff_line_16_A(3) WHEN '0',
						   diff_line_16_B(3) WHEN OTHERS;
	WITH diff_line_16_A(4)(7) SELECT
		diff_line_16_ABS(4) <= diff_line_16_A(4) WHEN '0',
						   diff_line_16_B(4) WHEN OTHERS;
	WITH diff_line_16_A(5)(7) SELECT
		diff_line_16_ABS(5) <= diff_line_16_A(5) WHEN '0',
						   diff_line_16_B(5) WHEN OTHERS;
	WITH diff_line_16_A(6)(7) SELECT
		diff_line_16_ABS(6) <= diff_line_16_A(6) WHEN '0',
						   diff_line_16_B(6) WHEN OTHERS;
	WITH diff_line_16_A(7)(7) SELECT
		diff_line_16_ABS(7) <= diff_line_16_A(7) WHEN '0',
						   diff_line_16_B(7) WHEN OTHERS;
	WITH diff_line_16_A(8)(7) SELECT
		diff_line_16_ABS(8) <= diff_line_16_A(8) WHEN '0',
						   diff_line_16_B(8) WHEN OTHERS;
	WITH diff_line_16_A(9)(7) SELECT
		diff_line_16_ABS(9) <= diff_line_16_A(9) WHEN '0',
						   diff_line_16_B(9) WHEN OTHERS;
	WITH diff_line_16_A(10)(7) SELECT
		diff_line_16_ABS(10) <= diff_line_16_A(10) WHEN '0',
							diff_line_16_B(10) WHEN OTHERS;
	WITH diff_line_16_A(11)(7) SELECT
		diff_line_16_ABS(11) <= diff_line_16_A(11) WHEN '0',
							diff_line_16_B(11) WHEN OTHERS;
	WITH diff_line_16_A(12)(7) SELECT
		diff_line_16_ABS(12) <= diff_line_16_A(12) WHEN '0',
							diff_line_16_B(12) WHEN OTHERS;
	WITH diff_line_16_A(13)(7) SELECT
		diff_line_16_ABS(13) <= diff_line_16_A(13) WHEN '0',
							diff_line_16_B(13) WHEN OTHERS;
	WITH diff_line_16_A(14)(7) SELECT
		diff_line_16_ABS(14) <= diff_line_16_A(14) WHEN '0',
							diff_line_16_B(14) WHEN OTHERS;
	WITH diff_line_16_A(15)(7) SELECT
		diff_line_16_ABS(15) <= diff_line_16_A(15) WHEN '0',
						    diff_line_16_B(15) WHEN OTHERS;
	
	stage_0(0) <= ('0'&diff_line_16_reg(0))  + ('0'&diff_line_16_reg(1));
	stage_0(1) <= ('0'&diff_line_16_reg(2))  + ('0'&diff_line_16_reg(3));
	stage_0(2) <= ('0'&diff_line_16_reg(4))  + ('0'&diff_line_16_reg(5));
	stage_0(3) <= ('0'&diff_line_16_reg(6))  + ('0'&diff_line_16_reg(7));
	stage_0(4) <= ('0'&diff_line_16_reg(8))  + ('0'&diff_line_16_reg(9));
	stage_0(5) <= ('0'&diff_line_16_reg(10)) + ('0'&diff_line_16_reg(11));
	stage_0(6) <= ('0'&diff_line_16_reg(12)) + ('0'&diff_line_16_reg(13));
	stage_0(7) <= ('0'&diff_line_16_reg(14)) + ('0'&diff_line_16_reg(15));
	
	stage_1(0) <= ('0'&stage_0_reg(0)) + ('0'&stage_0_reg(1));
	stage_1(1) <= ('0'&stage_0_reg(2)) + ('0'&stage_0_reg(3));
	stage_1(2) <= ('0'&stage_0_reg(4)) + ('0'&stage_0_reg(5));
	stage_1(3) <= ('0'&stage_0_reg(6)) + ('0'&stage_0_reg(7));
	
	stage_2(0) <= ('0'&stage_1_reg(0)) + ('0'&stage_1_reg(1));
	stage_2(1) <= ('0'&stage_1_reg(2)) + ('0'&stage_1_reg(3));
	
	stage_3    <= ('0'&stage_2_reg(0)) + ('0'&stage_2_reg(1));
	
END behavorial;