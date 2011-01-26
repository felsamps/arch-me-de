LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
LIBRARY work;
USE work.ME_package.all;

ENTITY buffer_cb_column IS
	PORT(clk, reset            : IN STD_LOGIC;
		 enable                : IN STD_LOGIC;
		 data_in               : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data_out              : OUT BUFFER_CB_TYPE
	);
END buffer_cb_column;

ARCHITECTURE behavorial OF buffer_cb_column IS
	SIGNAL buffer_cb     : BUFFER_CB_TYPE;
	SIGNAL column_ping   : COLUMN_16;
	SIGNAL counter       : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL state         : BUFFER_CB_STATE;
	
BEGIN

	PROCESS(clk,reset)
	BEGIN
		IF reset = '1' THEN
			buffer_cb <= (OTHERS=>(OTHERS=>(OTHERS=>'0')));
		ELSIF clk'EVENT AND clk = '1' THEN
			IF enable = '1' THEN
				column_ping(15) <= data_in;
				column_ping(14) <= column_ping(15);
				column_ping(13) <= column_ping(14);
				column_ping(12) <= column_ping(13);
				column_ping(11) <= column_ping(12);
				column_ping(10) <= column_ping(11);
				column_ping(9) <= column_ping(10);
				column_ping(8) <= column_ping(9);
				column_ping(7) <= column_ping(8);
				column_ping(6) <= column_ping(7);
				column_ping(5) <= column_ping(6);
				column_ping(4) <= column_ping(5);
				column_ping(3) <= column_ping(4);
				column_ping(2) <= column_ping(3);
				column_ping(1) <= column_ping(2);
				column_ping(0) <= column_ping(1);
				IF state = NEW_COLUMN THEN
					buffer_cb(0) <= column_ping;
					buffer_cb(1) <= buffer_cb(0);
					buffer_cb(2) <= buffer_cb(1);
					buffer_cb(3) <= buffer_cb(2);
					buffer_cb(4) <= buffer_cb(3);
					buffer_cb(5) <= buffer_cb(4);
					buffer_cb(6) <= buffer_cb(5);
					buffer_cb(7) <= buffer_cb(6);
					buffer_cb(8) <= buffer_cb(7);
					buffer_cb(9) <= buffer_cb(8);
					buffer_cb(10) <= buffer_cb(9);
					buffer_cb(11) <= buffer_cb(10);
					buffer_cb(12) <= buffer_cb(11);
					buffer_cb(13) <= buffer_cb(12);
					buffer_cb(14) <= buffer_cb(13);
					buffer_cb(15) <= buffer_cb(14);
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
	
	data_out <= buffer_cb;
	
END behavorial;