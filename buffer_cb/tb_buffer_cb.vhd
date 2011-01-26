LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use std.textio.all; 
USE work.ME_Package.all;

ENTITY tb_buffer_cb IS
END tb_buffer_cb;

architecture behavorial of tb_buffer_cb is
	COMPONENT buffer_cb IS
		PORT(clk, reset            : IN STD_LOGIC;
			 enable                : IN STD_LOGIC;
			 data_in               : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 data_out              : OUT BUFFER_CB_TYPE
		);
	END COMPONENT;
	   
   --funcao
   function str_to_stdvec(inp: string) return std_logic_vector is
		variable temp: std_logic_vector(inp'range);
	begin
		for i in inp'range loop
			if (inp(i) = '1') then
				temp(i) := '1';
			elsif (inp(i) = '0') then
				temp(i) := '0';
			end if;
		end loop; 
		return temp;
	end function str_to_stdvec;
   
   --funcao
	function stdvec_to_str(inp: std_logic_vector) return string is
		variable temp: string(inp'left+1 downto 1);
	begin
		for i in inp'reverse_range loop
			if (inp(i) = '1') then
				temp(i+1) := '1';
			elsif (inp(i) = '0') then
				temp(i+1) := '0';
			end if;
		end loop;
		return temp;
	end function stdvec_to_str;
   
   --entradas e saídas
	SIGNAL clk, reset, enable : std_logic;
	SIGNAL data_in           : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL data_out           : BUFFER_CB_TYPE;
	FILE infile               : TEXT;
   
begin
   clockgen :PROCESS 
	BEGIN
  		clk <= '1', '0' AFTER 20 ns;
  		WAIT FOR 40 ns;
	END PROCESS;
	
	reset <= '1', '0' AFTER 60 ns;
	
	estimulos_entrada: process
		variable i: integer;
		variable linha: line;
		variable linhaStr: string(8 downto 1);
	begin
		FILE_OPEN(infile, "D:\Arch_TCC\Input_Tests\inputs_buffer_cb.txt", READ_MODE);
		wait until (clk'event and clk='0' and reset='0');
		enable <= '1';
		while not endfile(infile) loop
			readline(infile, linha);
			read(linha, linhaStr);
			data_in <= str_to_stdvec (linhaStr);
			wait until (clk'event and clk='0');
		end loop;

		file_close(infile);
	end process;

	BUFFER_CB_0: buffer_cb PORT MAP(clk, reset, enable, data_in, data_out);
end behavorial;