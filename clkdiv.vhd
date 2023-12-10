LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY clkdiv IS
	PORT (
		clk : IN STD_LOGIC;
		clkms : OUT STD_LOGIC;
		clks : OUT STD_LOGIC
	);
END clkdiv;

ARCHITECTURE behav OF clkdiv IS

	SIGNAL divms : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL divs : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL clkms_s : STD_LOGIC;

BEGIN
	PROCESS (clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			--			IF divms = B"0000000000000011" THEN -- 1100001101001111
			IF divms = B"1100001101001111" THEN
				divms <= (OTHERS => '0');
			ELSE
				divms <= divms + 1;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			--			IF divms = B"0000000000000011" THEN -- 1100001101001111
			IF divms = B"1100001101001111" THEN
				clkms_s <= '1';
			ELSE
				clkms_s <= '0';
			END IF;
		END IF;
	END PROCESS;

	PROCESS (clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			clkms <= clkms_s;
		END IF;
	END PROCESS;

	PROCESS (clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF clkms_s = '1' THEN
				--				IF divs = B"0000000011" THEN -- 1111100111
				IF divs = B"1111100111" THEN
					divs <= (OTHERS => '0');
				ELSE
					divs <= divs + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (clk)
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF clkms_s = '1' THEN
				--				IF divs = B"0000000011" THEN -- 1111100111
				IF divs = B"1111100111" THEN
					clks <= '1';
				ELSE
					clks <= '0';
				END IF;
			END IF;
		END IF;
	END PROCESS;

END behav;