LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY adc_if IS
	PORT (
		SCK : IN STD_LOGIC; -- serial clock that goes to ADC
		SDATA1 : IN STD_LOGIC; -- serial data channel 1
		SDATA2 : IN STD_LOGIC; -- serial data channel 2
		CS : IN STD_LOGIC; -- chip select that initiates A/D conversion
		
		SCK_2 : IN STD_LOGIC; -- serial clock that goes to ADC
		SDATA1_2 : IN STD_LOGIC; -- serial data channel 1
		SDATA2_2 : IN STD_LOGIC; -- serial data channel 2
		CS_2 : IN STD_LOGIC; -- chip select that initiates A/D conversion
		
		SCK_3 : IN STD_LOGIC; -- serial clock that goes to ADC
		SDATA1_3 : IN STD_LOGIC; -- serial data channel 1
		SDATA2_3 : IN STD_LOGIC; -- serial data channel 2
		CS_3 : IN STD_LOGIC; -- chip select that initiates A/D conversion
		
		SCK_4 : IN STD_LOGIC; -- serial clock that goes to ADC
		SDATA1_4 : IN STD_LOGIC; -- serial data channel 1
		SDATA2_4 : IN STD_LOGIC; -- serial data channel 2
		CS_4 : IN STD_LOGIC; -- chip select that initiates A/D conversion
		
		data_1 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- parallel 12-bit data ch1
		data_2 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- parallel 12-bit data ch2
		data_3 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- parallel 12-bit data ch1
		data_4 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- parallel 12-bit data ch2
		data_5 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- parallel 12-bit data ch1
		data_6 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- parallel 12-bit data ch2
		data_7 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- parallel 12-bit data ch1
		data_8 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)); -- parallel 12-bit data ch2
END adc_if;

ARCHITECTURE Behavioral OF adc_if IS
	SIGNAL pdata1, pdata2, pdata3, pdata4, pdata5, pdata6, pdata7, pdata8 : std_logic_vector (11 DOWNTO 0); -- 12-bit shift registers
BEGIN
	-- this process waits for CS=0 and then clocks serial data from ADC into shift register
	-- MSBit first. After 16 SCK's, four leading zeros will have fallen out of the most significant
	-- end of the shift register and the register will contain the parallel 12-bit data
	adpr : PROCESS
	BEGIN
		WAIT UNTIL falling_edge (SCK);
		IF CS = '0' THEN
			pdata1 <= pdata1 (10 DOWNTO 0) & SDATA1;
			pdata2 <= pdata2 (10 DOWNTO 0) & SDATA2;
		END IF;
	END PROCESS;
	adpr2 : PROCESS
	BEGIN
		WAIT UNTIL falling_edge (SCK_2);
		IF CS_2 = '0' THEN
			pdata3 <= pdata3 (10 DOWNTO 0) & SDATA1_2;
			pdata4 <= pdata4 (10 DOWNTO 0) & SDATA2_2;
		END IF;
	END PROCESS;
	adpr3 : PROCESS
	BEGIN
		WAIT UNTIL falling_edge (SCK_3);
		IF CS_3 = '0' THEN
			pdata5 <= pdata5 (10 DOWNTO 0) & SDATA1_3;
			pdata6 <= pdata6 (10 DOWNTO 0) & SDATA2_3;
		END IF;
	END PROCESS;
	adpr4 : PROCESS
	BEGIN
		WAIT UNTIL falling_edge (SCK_4);
		IF CS_4 = '0' THEN
			pdata7 <= pdata7 (10 DOWNTO 0) & SDATA1_4;
			pdata8 <= pdata8 (10 DOWNTO 0) & SDATA2_4;
		END IF;
	END PROCESS;
	-- this process waits for rising edge of CS and then loads parallel data
	-- from shift register into appropriate output port
	sync : PROCESS
	BEGIN
		WAIT UNTIL rising_edge (CS);
		data_1 <= pdata1;
		data_2 <= pdata2;
	END PROCESS;
    sync2 : PROCESS
	BEGIN
		WAIT UNTIL rising_edge (CS_2);
		data_3 <= pdata3;
		data_4 <= pdata4;
	END PROCESS;
	sync3 : PROCESS
	BEGIN
		WAIT UNTIL rising_edge (CS_3);
		data_5 <= pdata5;
		data_6 <= pdata6;
	END PROCESS;
	sync4 : PROCESS
	BEGIN
		WAIT UNTIL rising_edge (CS_4);
		data_7 <= pdata7;
		data_8 <= pdata8;
	END PROCESS;
END Behavioral;