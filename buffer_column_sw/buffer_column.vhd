LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
LIBRARY work;
USE work.ME_package.all;

ENTITY buffer_column IS
	PORT(clk, reset             : IN STD_LOGIC;
		  enable				: IN STD_LOGIC;
		  data_in0, data_in1    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		  data_out              : OUT COLUMN_16
	);
END buffer_column;

ARCHITECTURE behavorial OF buffer_column IS
	TYPE BUFFER_COLUMN IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL state   : BUFFER_STATE;
	SIGNAL column0 : BUFFER_COLUMN;
	SIGNAL column1 : BUFFER_COLUMN;
	SIGNAL counter : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	PROCESS(clk, reset)
	BEGIN
		IF reset = '1' THEN
			column0 <= (OTHERS=>(OTHERS=>'0'));
			column1 <= (OTHERS=>(OTHERS=>'0'));
		ELSIF clk'EVENT AND clk = '1' THEN
			IF enable = '1' THEN
				column0(31) <= data_in1;
				column0(30) <= data_in0;
				column0(29) <= column0(31);
				column0(28) <= column0(30);
				column0(27) <= column0(29);
				column0(26) <= column0(28);
				column0(25) <= column0(27);
				column0(24) <= column0(26);
				column0(23) <= column0(25);
				column0(22) <= column0(24);
				column0(21) <= column0(23);
				column0(20) <= column0(22);
				column0(19) <= column0(21);
				column0(18) <= column0(20);
				column0(17) <= column0(19);
				column0(16) <= column0(18);
				column0(15) <= column0(17);
				column0(14) <= column0(16);
				column0(13) <= column0(15);
				column0(12) <= column0(14);
				column0(11) <= column0(13);
				column0(10) <= column0(12);
				column0(9) <= column0(11);
				column0(8) <= column0(10);
				column0(7) <= column0(9);
				column0(6) <= column0(8);
				column0(5) <= column0(7);
				column0(4) <= column0(6);
				column0(3) <= column0(5);
				column0(2) <= column0(4);
				column0(1) <= column0(3);
				column0(0) <= column0(2);
				IF state = ROLLING THEN
					column1(30) <= column1(31);
					column1(29) <= column1(30);
					column1(28) <= column1(29);
					column1(27) <= column1(28);
					column1(26) <= column1(27);
					column1(25) <= column1(26);
					column1(24) <= column1(25);
					column1(23) <= column1(24);
					column1(22) <= column1(23);
					column1(21) <= column1(22);
					column1(20) <= column1(21);
					column1(19) <= column1(20);
					column1(18) <= column1(19);
					column1(17) <= column1(18);
					column1(16) <= column1(17);
					column1(15) <= column1(16);
					column1(14) <= column1(15);
					column1(13) <= column1(14);
					column1(12) <= column1(13);
					column1(11) <= column1(12);
					column1(10) <= column1(11);
					column1(9) <= column1(10);
					column1(8) <= column1(9);
					column1(7) <= column1(8);
					column1(6) <= column1(7);
					column1(5) <= column1(6);
					column1(4) <= column1(5);
					column1(3) <= column1(4);
					column1(2) <= column1(3);
					column1(1) <= column1(2);
					column1(0) <= column1(1);
				ELSIF state = NEW_COLUMN THEN
					column1 <= column0;
				END IF;
			END IF;
		END IF;				
	END PROCESS;
	
	PROCESS(clk, reset)
	BEGIN
		IF reset = '1' THEN
			counter <= "0000";
		ELSIF clk'EVENT AND clk = '1' THEN
			IF enable = '1' THEN
				counter <= counter + "0001";
				IF counter = "0000" THEN
					state <= ROLLING;
				ELSIF counter = "1111" THEN
					state <= NEW_COLUMN;
					counter <= "0000";
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	data_out(0) <= column1(0);
	data_out(1) <= column1(1);
	data_out(2) <= column1(2);
	data_out(3) <= column1(3);
	data_out(4) <= column1(4);
	data_out(5) <= column1(5);
	data_out(6) <= column1(6);
	data_out(7) <= column1(7);
	data_out(8) <= column1(8);
	data_out(9) <= column1(9);
	data_out(10) <= column1(10);
	data_out(11) <= column1(11);
	data_out(12) <= column1(12);
	data_out(13) <= column1(13);
	data_out(14) <= column1(14);
	data_out(15) <= column1(15);
	
END behavorial;