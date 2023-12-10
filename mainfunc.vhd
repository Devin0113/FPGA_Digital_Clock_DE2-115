LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY mainfunc IS
	PORT (
		clk : IN STD_LOGIC;
		clkms : IN STD_LOGIC;
		clks : IN STD_LOGIC;

		key : IN STD_LOGIC_VECTOR (3 DOWNTO 0);-- 3210，3切换功能，2选位，1正向调时，0负向调时

		data1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);--时间和闹铃数据输出，秒分时，低位到高位
		data2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		data3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		data4 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		data5 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		data6 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);

		alarm_signal : OUT STD_LOGIC
	);
END mainfunc;

ARCHITECTURE behav OF mainfunc IS

	SIGNAL func_type : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');--00时钟，01调时，10闹钟，11转00
	SIGNAL keycount : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');--按键防抖计数
	SIGNAL key_s : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');--按键防抖传递

	SIGNAL times : STD_LOGIC_VECTOR(17 DOWNTO 0) := B"010101000101111100";--初始标准时间
	SIGNAL timep : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');--修正时间量
	SIGNAL timesp : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');--修正时间
	SIGNAL alarms : STD_LOGIC_VECTOR(17 DOWNTO 0) := (OTHERS => '0');--闹铃时间

	SIGNAL seconds : INTEGER := 0;--时间数据存储
	SIGNAL minutes : INTEGER := 0;
	SIGNAL hours : INTEGER := 0;

	SIGNAL timedata_s : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');--时间数据存储，秒分时，低位到高位

	SIGNAL digit : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');--存储位数
	SIGNAL digitcount : STD_LOGIC := '0';--用于修改位的亮度降低显示

	SIGNAL alarmseconds : INTEGER := 0;--闹铃时间数据存储
	SIGNAL alarmminutes : INTEGER := 0;
	SIGNAL alarmhours : INTEGER := 0;
	SIGNAL alarmdata_s : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');--闹铃数据存储，秒分时，低位到高位

--   signal A_un : INTEGER:=0;
	signal counter:integer:=0;
BEGIN
	PROCESS (clks)--时钟自走，每秒触发一次
	BEGIN
		IF clks'event AND clks = '1' THEN
			IF times = B"010101000101111111" THEN
				times <= (OTHERS => '0');
			ELSE
				times <= times + 1;
			END IF;
		END IF;
	END PROCESS;

	
	PROCESS (clkms)--换算时分秒并存储，每一个时钟信号触发一次
	BEGIN
		IF clkms'event AND clkms = '1' THEN
			
			--换算此时时间
			timesp <= times + timep;
			IF timesp > B"010101000101111111" THEN--防溢出
				timesp <= timesp - B"010101000110000000";
			END IF;
--			IF timesp_a >= B"010101000110000000" THEN--防溢出
--				timesp <= timesp_a - B"010101000110000000";
--			END IF;
			
			seconds <= CONV_INTEGER(timesp);
			minutes <= seconds / 60;
			hours <= minutes / 60;
			timedata_s(3 DOWNTO 0) <= CONV_STD_LOGIC_VECTOR(seconds MOD 10, 4);
			timedata_s(7 DOWNTO 4) <= CONV_STD_LOGIC_VECTOR((seconds / 10) MOD 6, 4);
			timedata_s(11 DOWNTO 8) <= CONV_STD_LOGIC_VECTOR(minutes MOD 10, 4);
			timedata_s(15 DOWNTO 12) <= CONV_STD_LOGIC_VECTOR((minutes / 10) MOD 6, 4);
			timedata_s(19 DOWNTO 16) <= CONV_STD_LOGIC_VECTOR(hours MOD 10, 4);
			timedata_s(23 DOWNTO 20) <= CONV_STD_LOGIC_VECTOR((hours / 10) MOD 10, 4);

			--换算闹铃时间
			alarmseconds <= CONV_INTEGER(alarms);
			alarmminutes <= alarmseconds / 60;
			alarmhours <= alarmminutes / 60;
			alarmdata_s(3 DOWNTO 0) <= CONV_STD_LOGIC_VECTOR(alarmseconds MOD 10, 4);
			alarmdata_s(7 DOWNTO 4) <= CONV_STD_LOGIC_VECTOR((alarmseconds / 10) MOD 6, 4);
			alarmdata_s(11 DOWNTO 8) <= CONV_STD_LOGIC_VECTOR(alarmminutes MOD 10, 4);
			alarmdata_s(15 DOWNTO 12) <= CONV_STD_LOGIC_VECTOR((alarmminutes / 10) MOD 6, 4);
			alarmdata_s(19 DOWNTO 16) <= CONV_STD_LOGIC_VECTOR(alarmhours MOD 10, 4);
			alarmdata_s(23 DOWNTO 20) <= CONV_STD_LOGIC_VECTOR((alarmhours / 10) MOD 10, 4);
		END IF;
	END PROCESS;

	--	PROCESS (clkms)--按键防抖
	--	BEGIN
	--		IF clkms'event AND clkms = '1' THEN
	--			IF key = B"0000" THEN
	--				key_s <= (OTHERS => '0');
	--				keycount <= (OTHERS => '0');
	--			ELSE
	--				IF keycount = B"1100100" THEN--按键防抖，时长为100ms
	--					key_s <= key;
	--					keycount <= (OTHERS => '0');
	--				ELSE
	--					IF key_s = key THEN--防止持续输出
	--						keycount <= (OTHERS => '0');
	--					ELSE
	--						keycount <= keycount + 1;
	--					END IF;
	--				END IF;
	--			END IF;
	--		END IF;
	--	END PROCESS;

	PROCESS (clkms)--按键防抖
	BEGIN
		IF clkms'event AND clkms = '1' THEN
			
			IF timep >= B"010101000110000000" THEN--防溢出
				timep <= timep - B"010101000110000000";
			END IF;
			IF alarms >= B"010101000110000000" THEN--防溢出
				alarms <= alarms - B"010101000110000000";
			END IF;
			
			IF key = B"1111" THEN
				key_s <= (OTHERS => '0');
				keycount <= (OTHERS => '0');
			ELSIF key = B"0111" THEN--按键3选择功能
				IF keycount = B"1100100" THEN--按键防抖，时长为100ms
					key_s <= key;
					keycount <= (OTHERS => '0');
					------按键3主要功能处------
					IF func_type = B"10" THEN
						func_type <= (OTHERS => '0');
					ELSE
						func_type <= func_type + 1;
					END IF;
					------按键3主要功能处------
				ELSE
					IF key_s = key THEN--防止持续输出
						keycount <= (OTHERS => '0');
					ELSE
						keycount <= keycount + 1;
					END IF;
				END IF;

			ELSIF key = B"1011" THEN--按键2选择位
				IF keycount = B"1100100" THEN--按键防抖，时长为100ms
					key_s <= key;
					keycount <= (OTHERS => '0');
					------按键2主要功能处------
					IF func_type = B"10" OR func_type = B"01" THEN
						IF digit = B"101" THEN
							digit <= (OTHERS => '0');
						ELSE
							digit <= digit + 1;
						END IF;
					END IF;
					------按键2主要功能处------
				ELSE
					IF key_s = key THEN--防止持续输出
						keycount <= (OTHERS => '0');
					ELSE
						keycount <= keycount + 1;
					END IF;
				END IF;

			ELSIF key = B"1101" THEN--按键1正向调时
				IF keycount = B"1100100" THEN--按键防抖，时长为100ms
					key_s <= key;
					keycount <= (OTHERS => '0');
					------按键1主要功能处------
					IF func_type = B"01" THEN
						IF digit = B"000" THEN--加一秒
							timep <= timep + 1;
						ELSIF digit = B"001" THEN--加10秒
							timep <= timep + B"1010";
						ELSIF digit = B"010" THEN--加1分（60秒）
							timep <= timep + B"111100";
						ELSIF digit = B"011" THEN--加10分（600秒）
							timep <= timep + B"1001011000";
						ELSIF digit = B"100" THEN--加1时（60*60秒）
							timep <= timep + B"111000010000";
						ELSIF digit = B"101" THEN--加10时（600*60秒）
							timep <= timep + B"1000110010100000";
						END IF;
--						IF timep >= B"010101000110000000" THEN--防溢出
--							timep <= timep - B"010101000110000000";
--						END IF;
					ELSIF func_type = B"10" THEN
						IF digit = B"000" THEN--加一秒
							alarms <= alarms + 1;
						ELSIF digit = B"001" THEN--加10秒
							alarms <= alarms + B"1010";
						ELSIF digit = B"010" THEN--加1分（60秒）
							alarms <= alarms + B"111100";
						ELSIF digit = B"011" THEN--加10分（600秒）
							alarms <= alarms + B"1001011000";
						ELSIF digit = B"100" THEN--加1时（60*60秒）
							alarms <= alarms + B"111000010000";
						ELSIF digit = B"101" THEN--加10时（600*60秒）
							alarms <= alarms + B"1000110010100000";
						END IF;
--						IF alarms >= B"010101000110000000" THEN--防溢出
--							alarms <= alarms - B"010101000110000000";
--						END IF;
					END IF;
					------按键1主要功能处------
				ELSE
					IF key_s = key THEN--防止持续输出
						keycount <= (OTHERS => '0');
					ELSE
						keycount <= keycount + 1;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (clk)--数码管显示数据的输出
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF func_type = B"00" THEN--显示时间
				data1 <= timedata_s(3 DOWNTO 0);
				data2 <= timedata_s(7 DOWNTO 4);
				data3 <= timedata_s(11 DOWNTO 8);
				data4 <= timedata_s(15 DOWNTO 12);
				data5 <= timedata_s(19 DOWNTO 16);
				data6 <= timedata_s(23 DOWNTO 20);
			ELSIF func_type = B"10" THEN--显示闹钟时间
				data1 <= alarmdata_s(3 DOWNTO 0);
				data2 <= alarmdata_s(7 DOWNTO 4);
				data3 <= alarmdata_s(11 DOWNTO 8);
				data4 <= alarmdata_s(15 DOWNTO 12);
				data5 <= alarmdata_s(19 DOWNTO 16);
				data6 <= alarmdata_s(23 DOWNTO 20);
				IF digitcount = '1' THEN--高亮选中位
					IF digit = B"000" THEN
						data1 <= B"1111";
					ELSIF digit = B"001" THEN
						data2 <= B"1111";
					ELSIF digit = B"010" THEN
						data3 <= B"1111";
					ELSIF digit = B"011" THEN
						data4 <= B"1111";
					ELSIF digit = B"100" THEN
						data5 <= B"1111";
					ELSIF digit = B"101" THEN
						data6 <= B"1111";
					END IF;
					digitcount <= '0';
				ELSE
					digitcount <= '1';
				END IF;
			ELSIF func_type = B"01" THEN--显示调时
				data1 <= timedata_s(3 DOWNTO 0);
				data2 <= timedata_s(7 DOWNTO 4);
				data3 <= timedata_s(11 DOWNTO 8);
				data4 <= timedata_s(15 DOWNTO 12);
				data5 <= timedata_s(19 DOWNTO 16);
				data6 <= timedata_s(23 DOWNTO 20);
				IF digitcount = '1' THEN--高亮选中位
					IF digit = B"000" THEN
						data1 <= B"1111";
					ELSIF digit = B"001" THEN
						data2 <= B"1111";
					ELSIF digit = B"010" THEN
						data3 <= B"1111";
					ELSIF digit = B"011" THEN
						data4 <= B"1111";
					ELSIF digit = B"100" THEN
						data5 <= B"1111";
					ELSIF digit = B"101" THEN
						data6 <= B"1111";
					END IF;
					digitcount <= '0';
				ELSE
					digitcount <= '1';
				END IF;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (clk)--判断是否达到设定闹钟时间
	BEGIN
		IF clk'event AND clk = '1' THEN
			IF alarms = timesp THEN
				alarm_signal <= '1';
			ELSE
				alarm_signal <= '0';
			END IF;
		END IF;
	END PROCESS;
END behav;