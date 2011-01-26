LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
LIBRARY work;
USE work.ME_package.all;

ENTITY PE_column IS
	PORT( 
	clk,reset                 : IN STD_LOGIC;
	--CONTROL INPUTS
	enable                    : IN STD_LOGIC;
	--DATA INPUTS
	curr_line_16, ref_line_16 : IN COLUMN_16;
	best_SAD                  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	best_MV                   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END PE_column;

ARCHITECTURE behavorial OF PE_column IS

	TYPE SAD_COLUMN_TYPE IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(11 DOWNTO 0);
	TYPE ACC_COLUMN_TYPE IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	TYPE MV_VERTICAL_ARRAY IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	SIGNAL cand_sel_in, cand_sel_comp : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL enable_comp, flag_SAD_out, reset_reg_column_flag : STD_LOGIC;
	SIGNAL counter : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL counter_pipe_fill : STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	SIGNAL out_SAD        : STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL reg_column     : ACC_COLUMN_TYPE;
	SIGNAL sad_column     : SAD_COLUMN_TYPE;
	SIGNAL acc_column     : ACC_COLUMN_TYPE;
	SIGNAL mv_vertical    : MV_VERTICAL_ARRAY := ("1000","1001","1010","1011","1100","1101","1110","1111",
												  "0000","0001","0010","0011","0100","0101","0110","0111");
	SIGNAL in_comp_SAD    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL in_comp_MV_ver : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN

--CONTROL UNIT PE_COLUMN
	PROCESS(clk, reset)
	BEGIN
		IF reset='1' THEN
			counter <= (OTHERS=>'0');
			counter_pipe_fill <= (OTHERS=>'0');
			flag_SAD_out <= '1';
			enable_comp <= '1';
		ELSIF clk'EVENT AND clk = '1' THEN
			IF enable = '0' THEN -- ENABLED!
				IF counter_pipe_fill = "100" THEN -- COUNT THE INITIAL PIPELINE FILLED OVERHEAD
					flag_SAD_out <= '0';
				ELSE
					counter_pipe_fill <= counter_pipe_fill + 1;
				END IF;
				IF flag_SAD_out = '0' THEN -- VALID SADs ARE IN THE PE_UNIT OUTPUT!
					counter <= counter + "00000001";
					IF counter = "00000001" THEN
						enable_comp <= '1';
					ELSIF counter = "00000010" THEN
						cand_sel_comp <= (OTHERS=>'0');
					ELSIF counter = "11110000" THEN
						enable_comp <= '0';
					ELSIF counter = "11111111" THEN -- ACC MUST BE RESETED TO ACCUMULATE THE NEW SAD VALUES
						reset_reg_column_flag <= '1';
					ELSIF counter = "00000000" THEN
						reset_reg_column_flag <= '0';
					END IF;
				END IF;
				IF enable_comp = '0' THEN -- SADs ARE COMPLETED TO BE COMPARED!
					cand_sel_comp <= cand_sel_comp + "0001";
				END IF;
			END IF;
		END IF;
	END PROCESS;

	--REGISTERS
	PROCESS(clk, reset)
	BEGIN
		IF reset = '1' THEN
			reg_column <= (OTHERS=>(OTHERS=>'0'));
		ELSIF clk'EVENT AND clk = '1' THEN
			reg_column <= acc_column;
			IF reset_reg_column_flag = '1' THEN
				reg_column(0) <= ("0000"&sad_column(0));
				reg_column(1) <= (OTHERS=>'0');
				reg_column(2) <= (OTHERS=>'0');
				reg_column(3) <= (OTHERS=>'0');
				reg_column(4) <= (OTHERS=>'0');
				reg_column(5) <= (OTHERS=>'0');
				reg_column(6) <= (OTHERS=>'0');
				reg_column(7) <= (OTHERS=>'0');
				reg_column(8) <= (OTHERS=>'0');
				reg_column(9) <= (OTHERS=>'0');
				reg_column(10) <= (OTHERS=>'0');
				reg_column(11) <= (OTHERS=>'0');
				reg_column(12) <= (OTHERS=>'0');
				reg_column(13) <= (OTHERS=>'0');
				reg_column(14) <= (OTHERS=>'0');
				reg_column(15) <= (OTHERS=>'0');
			END IF;			
		END IF;
	END PROCESS;

	SAD_PE: SAD_unit PORT MAP (clk, reset, curr_line_16, ref_line_16, out_SAD);
	
	--DEMULTIPLEXERS 1x16
	WITH cand_sel_in SELECT
		sad_column(0) <= out_SAD WHEN "0000",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(1) <= out_SAD WHEN "0001",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(2) <= out_SAD WHEN "0010",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(3) <= out_SAD WHEN "0011",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(4) <= out_SAD WHEN "0100",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(5) <= out_SAD WHEN "0101",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(6) <= out_SAD WHEN "0110",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(7) <= out_SAD WHEN "0111",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(8) <= out_SAD WHEN "1000",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(9) <= out_SAD WHEN "1001",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(10) <= out_SAD WHEN "1010",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(11) <= out_SAD WHEN "1011",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(12) <= out_SAD WHEN "1100",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(13) <= out_SAD WHEN "1101",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(14) <= out_SAD WHEN "1110",
					  (OTHERS=>'0') WHEN OTHERS;
	WITH cand_sel_in SELECT
		sad_column(15) <= out_SAD WHEN "1111",
					  (OTHERS=>'0') WHEN OTHERS;
	
	cand_sel_in <= counter(3 DOWNTO 0);
	
	acc_column(0) <= ("0000"&sad_column(0)) + reg_column(0);
	acc_column(1) <= ("0000"&sad_column(1)) + reg_column(1);
	acc_column(2) <= ("0000"&sad_column(2)) + reg_column(2);
	acc_column(3) <= ("0000"&sad_column(3)) + reg_column(3);
	acc_column(4) <= ("0000"&sad_column(4)) + reg_column(4);
	acc_column(5) <= ("0000"&sad_column(5)) + reg_column(5);
	acc_column(6) <= ("0000"&sad_column(6)) + reg_column(6);
	acc_column(7) <= ("0000"&sad_column(7)) + reg_column(7);
	acc_column(8) <= ("0000"&sad_column(8)) + reg_column(8);
	acc_column(9) <= ("0000"&sad_column(9)) + reg_column(9);
	acc_column(10) <= ("0000"&sad_column(10)) + reg_column(10);
	acc_column(11) <= ("0000"&sad_column(11)) + reg_column(11);
	acc_column(12) <= ("0000"&sad_column(12)) + reg_column(12);
	acc_column(13) <= ("0000"&sad_column(13)) + reg_column(13);
	acc_column(14) <= ("0000"&sad_column(14)) + reg_column(14);
	acc_column(15) <= ("0000"&sad_column(15)) + reg_column(15);
	
	WITH cand_sel_comp SELECT
		in_comp_SAD <=  reg_column(0)  WHEN "0000",
						reg_column(1)  WHEN "0001",
						reg_column(2)  WHEN "0010",
						reg_column(3)  WHEN "0011",
						reg_column(4)  WHEN "0100",
						reg_column(5)  WHEN "0101",
						reg_column(6)  WHEN "0110",
						reg_column(7)  WHEN "0111",
						reg_column(8)  WHEN "1000",
						reg_column(9)  WHEN "1001",
						reg_column(10) WHEN "1010",
						reg_column(11) WHEN "1011",
						reg_column(12) WHEN "1100",
						reg_column(13) WHEN "1101",
						reg_column(14) WHEN "1110",
						reg_column(15) WHEN OTHERS;
						
	WITH cand_sel_comp SELECT
		in_comp_MV_ver <=   mv_vertical(0) WHEN "0000",
							mv_vertical(1) WHEN "0001",
							mv_vertical(2) WHEN "0010",
							mv_vertical(3) WHEN "0011",
							mv_vertical(4) WHEN "0100",
							mv_vertical(5) WHEN "0101",
							mv_vertical(6) WHEN "0110",
							mv_vertical(7) WHEN "0111",
							mv_vertical(8) WHEN "1000",
							mv_vertical(9) WHEN "1001",
							mv_vertical(10) WHEN "1010",
							mv_vertical(11) WHEN "1011",
							mv_vertical(12) WHEN "1100",
							mv_vertical(13) WHEN "1101",
							mv_vertical(14) WHEN "1110",
							mv_vertical(15) WHEN OTHERS;
	
	PE_COMP: PE_comparator PORT MAP(clk, reset, enable_comp, in_comp_SAD, in_comp_MV_ver, best_SAD, best_MV);
	
END behavorial;