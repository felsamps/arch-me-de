LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
LIBRARY work;
USE work.ME_package.all;

ENTITY local_memory IS
	PORT(
		clk : IN STD_LOGIC;
		read_write : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR (14 DOWNTO 0);
		data_in : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END local_memory;

ARCHITECTURE structure OF local_memory IS
	
	TYPE LOCAL_MEMORY_TYPE IS ARRAY (0 TO 32768) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL memory : LOCAL_MEMORY_TYPE;

BEGIN

	PROCESS(clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF read_write = '0' THEN
				data_out <= memory(conv_integer(address));
			ELSE
				memory(conv_integer(address)) <= data_in;
			END IF;				
		END IF;
	END PROCESS;

END structure;