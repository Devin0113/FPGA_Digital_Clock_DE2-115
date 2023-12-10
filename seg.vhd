LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY seg IS
	PORT (
		data : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		hex : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END seg;

ARCHITECTURE behav OF seg IS

	SIGNAL nhex : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL a, b, c, d, e, f, g : STD_LOGIC;

BEGIN
	PROCESS (data)
	BEGIN
		CASE data IS
			WHEN B"0000" => nhex <= B"1111110";
			WHEN B"0001" => nhex <= B"0110000";
			WHEN B"0010" => nhex <= B"1101101";
			WHEN B"0011" => nhex <= B"1111001";
			WHEN B"0100" => nhex <= B"0110011";
			WHEN B"0101" => nhex <= B"1011011";
			WHEN B"0110" => nhex <= B"1011111";
			WHEN B"0111" => nhex <= B"1110000";
			WHEN B"1000" => nhex <= B"1111111";
			WHEN B"1001" => nhex <= B"1111011";
			WHEN B"1010" => nhex <= B"0001101";
			WHEN B"1011" => nhex <= B"0011001";
			WHEN B"1100" => nhex <= B"0100011";
			WHEN B"1101" => nhex <= B"1001011";
			WHEN B"1110" => nhex <= B"0001111";
			WHEN B"1111" => nhex <= B"0000000";
			WHEN OTHERS =>
		END CASE;
	END PROCESS;

	hex(0) <= NOT nhex(6);
	hex(1) <= NOT nhex(5);
	hex(2) <= NOT nhex(4);
	hex(3) <= NOT nhex(3);
	hex(4) <= NOT nhex(2);
	hex(5) <= NOT nhex(1);
	hex(6) <= NOT nhex(0);
END behav;