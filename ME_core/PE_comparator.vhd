LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
LIBRARY work;
USE work.ME_package.all;

ENTITY PE_comparator IS
	PORT(clk, reset : IN STD_LOGIC;
		 enable		: IN STD_LOGIC;
		 in_SAD     : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 in_MV_ver  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 out_SAD    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 out_MV_ver : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END PE_comparator;

ARCHITECTURE behavorial OF PE_comparator IS

	SIGNAL reg_in_SAD, best_SAD, diff_SAD, reg_best_SAD : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL reg_in_MV, best_MV, reg_best_MV             : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN
	
	PROCESS(clk, reset)
	BEGIN
		IF reset = '1' THEN
			reg_best_SAD <= "0111111111111111";
			reg_best_MV <= (OTHERS => '0');
			reg_in_SAD <= "0111111111111111";
			reg_in_MV <= (OTHERS => '0');
		ELSIF clk'EVENT AND clk = '1' THEN
			IF enable = '0' THEN
				reg_in_SAD <= in_SAD;
				reg_in_MV <= in_MV_ver;				
				reg_best_SAD <= best_SAD;
				reg_best_MV <= best_MV;
			ELSE
				reg_in_SAD <= "0111111111111111";
				reg_in_MV <= (OTHERS => '0');
			END IF;
		END IF;
	END PROCESS;
	
	diff_SAD <=  reg_best_SAD - reg_in_SAD;
	
	WITH diff_SAD(15) SELECT
		best_SAD <= reg_in_SAD WHEN '0',
					reg_best_SAD WHEN OTHERS;
	WITH diff_SAD(15) SELECT
	   best_MV <= reg_in_MV WHEN '0',
	            reg_best_MV WHEN OTHERS;
				
	out_SAD <= reg_best_SAD;
	out_MV_ver <= reg_best_MV;
	
END behavorial;