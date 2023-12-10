LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY alarm IS
	PORT (
		clk : IN STD_LOGIC;
		alarmsignal : IN STD_LOGIC;
		alarmout : OUT STD_LOGIC_VECTOR (17 DOWNTO 0)
	);
END alarm;

ARCHITECTURE behav OF alarm IS

	SIGNAL count1 : STD_LOGIC_VECTOR (22 DOWNTO 0) := (OTHERS => '0');
	SIGNAL count2 : STD_LOGIC_VECTOR (17 DOWNTO 0) := B"000000000000000001";
	SIGNAL a_start : STD_LOGIC := '0';
BEGIN
	PROCESS (clk)--用于检测闹钟信号
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF alarmsignal = '1' THEN
				a_start <= '1';
			END IF;
			IF a_start = '1' THEN
				IF count2 > B"010000000000000000" THEN
					count2 <= B"000000000000000001";
					a_start <= '0';
				ELSE
					IF count1 > B"11111111100101101000000" THEN
						count1 <= (OTHERS => '0');
					ELSE
						count1 <= count1 + 1;
					END IF;
					count2 <= count2 + count2;
				END IF;
			END IF;
		END IF;
	END PROCESS;
alarmout <= count2;
END behav;