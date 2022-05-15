LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY pong IS
    PORT (
        clk_in : IN STD_LOGIC; -- system clock
        VGA_red : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- VGA outputs
        VGA_green : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_blue : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_hsync : OUT STD_LOGIC;
        VGA_vsync : OUT STD_LOGIC;
        
        ADC_CS : OUT STD_LOGIC; -- ADC signals
        ADC_SCLK : OUT STD_LOGIC;
        ADC_SDATA1 : IN STD_LOGIC;
        ADC_SDATA2 : IN STD_LOGIC;
        
        ADC_CS_2 : OUT STD_LOGIC; -- ADC signals
        ADC_SCLK_2 : OUT STD_LOGIC;
        ADC_SDATA1_2 : IN STD_LOGIC;
        ADC_SDATA2_2 : IN STD_LOGIC;
        
        ADC_CS_3 : OUT STD_LOGIC; -- ADC signals
        ADC_SCLK_3 : OUT STD_LOGIC;
        ADC_SDATA1_3 : IN STD_LOGIC;
        ADC_SDATA2_3 : IN STD_LOGIC;
        
        ADC_CS_4 : OUT STD_LOGIC; -- ADC signals
        ADC_SCLK_4 : OUT STD_LOGIC;
        ADC_SDATA1_4 : IN STD_LOGIC;
        ADC_SDATA2_4 : IN STD_LOGIC;
        btn0 : IN STD_LOGIC;
        btnu : IN STD_LOGIC; -- button to initiate clear
        SEG7_anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- anodes of four 7-seg displays
        SEG7_seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
        ); -- button to initiate serve
END pong;

ARCHITECTURE Behavioral OF pong IS
    SIGNAL pxl_clk : STD_LOGIC := '0'; -- 25 MHz clock to VGA sync module
    -- internal signals to connect modules
    SIGNAL S_red, S_green, S_blue : STD_LOGIC; --_VECTOR (3 DOWNTO 0);
    SIGNAL S_vsync : STD_LOGIC;
    SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL bat_1_pos : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    SIGNAL bat_2_pos : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    SIGNAL bat_3_pos : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    SIGNAL bat_4_pos : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    SIGNAL serial_clk, sample_clk : STD_LOGIC;
    SIGNAL serial_clk_2, sample_clk_2 : STD_LOGIC;
    SIGNAL serial_clk_3, sample_clk_3 : STD_LOGIC;
    SIGNAL serial_clk_4, sample_clk_4 : STD_LOGIC;
    SIGNAL adout : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL adout2 : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL adout3 : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL adout4 : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL count : STD_LOGIC_VECTOR (9 DOWNTO 0); -- counter to generate ADC clocks
    SIGNAL display : std_logic_vector (15 DOWNTO 0); -- value to be displayed
    SIGNAL led_mpx : STD_LOGIC_VECTOR (2 DOWNTO 0); -- 7-seg multiplexing clock
    SIGNAL cnt : std_logic_vector(20 DOWNTO 0); -- counter to generate timing signals
    COMPONENT adc_if IS
        PORT (
            SCK : IN STD_LOGIC;
            SDATA1 : IN STD_LOGIC;
            SDATA2 : IN STD_LOGIC;
            CS : IN STD_LOGIC;
            
            SCK_2 : IN STD_LOGIC;
            SDATA1_2 : IN STD_LOGIC;
            SDATA2_2 : IN STD_LOGIC;
            CS_2 : IN STD_LOGIC;
            
            SCK_3 : IN STD_LOGIC;
            SDATA1_3 : IN STD_LOGIC;
            SDATA2_3 : IN STD_LOGIC;
            CS_3 : IN STD_LOGIC;
            
            SCK_4 : IN STD_LOGIC;
            SDATA1_4 : IN STD_LOGIC;
            SDATA2_4 : IN STD_LOGIC;
            CS_4 : IN STD_LOGIC;
            
            data_1 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            data_2 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            data_3 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            data_4 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            data_5 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            data_6 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            data_7 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            data_8 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)        
        );
    END COMPONENT;
    COMPONENT bat_n_ball IS
        PORT (
            v_sync : IN STD_LOGIC;
            pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            bat_1_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
--            bat_2_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
            bat_3_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
--            bat_4_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0);

            bat_2_y : IN STD_LOGIC_VECTOR (10 DOWNTO 0);

            bat_4_y : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
            
            score : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            clear : IN STD_LOGIC;
            serve : IN STD_LOGIC;
            red : OUT STD_LOGIC;
            green : OUT STD_LOGIC;
            blue : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT vga_sync IS
        PORT (
            pixel_clk : IN STD_LOGIC;
            red_in    : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_in  : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_in   : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            red_out   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_out  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            hsync : OUT STD_LOGIC;
            vsync : OUT STD_LOGIC;
            pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
            pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT clk_wiz_0 is
        PORT (
            clk_in1  : in std_logic;
            clk_out1 : out std_logic
        );
    END COMPONENT;
    COMPONENT leddec16 IS
    PORT (
        dig : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
    );
    END COMPONENT;
BEGIN
    -- Process to generate clock signals
    ckp : PROCESS
    BEGIN
        WAIT UNTIL rising_edge(clk_in);
        count <= count + 1; -- counter to generate ADC timing signals
    END PROCESS;
    led_mpx <= cnt(19 DOWNTO 17); -- 7-seg multiplexing clock
    serial_clk <= NOT count(4);
    serial_clk_2 <= NOT count(4);
    serial_clk_3 <= NOT count(4);
    serial_clk_4 <= NOT count(4); -- 1.5 MHz serial clock for ADC
    ADC_SCLK <= serial_clk;
    ADC_SCLK_2 <= serial_clk_2;
    ADC_SCLK_3 <= serial_clk_3;
    ADC_SCLK_4 <= serial_clk_4;
    sample_clk <= count(9); -- sampling clock is low for 16 SCLKs
    sample_clk_2 <= count(9);
    sample_clk_3 <= count(9);
    sample_clk_4 <= count(9);
    ADC_CS <= sample_clk;
    ADC_CS_2 <= sample_clk_2;
    ADC_CS_3 <= sample_clk_3;
    ADC_CS_4 <= sample_clk_4;
    -- Multiplies ADC output (0-4095) by 5/32 to give bat position (0-640)
    --batpos <= ('0' & adout(11 DOWNTO 3)) + adout(11 DOWNTO 5);
    bat_1_pos <= ("00" & adout(11 DOWNTO 3)) + adout(11 DOWNTO 4);
    bat_2_pos <= ("00" & adout2(11 DOWNTO 3)) + adout2(11 DOWNTO 4);
    bat_3_pos <= ("00" & adout3(11 DOWNTO 3)) + adout3(11 DOWNTO 4);
    bat_4_pos <= ("00" & adout4(11 DOWNTO 3)) + adout4(11 DOWNTO 4);
    -- 512 + 256 = 768
    adc : adc_if
    PORT MAP(-- instantiate ADC serial to parallel interface
        SCK => serial_clk, 
        CS => sample_clk, 
        SDATA1 => ADC_SDATA1, 
        SDATA2 => ADC_SDATA2, 
        data_1 => OPEN, 
        data_2 => adout,
        
        SCK_2 => serial_clk_2, 
        CS_2 => sample_clk_2, 
        SDATA1_2 => ADC_SDATA1_2, 
        SDATA2_2 => ADC_SDATA2_2, 
        data_3 => OPEN, 
        data_4 => adout2,
        
        SCK_3 => serial_clk_3, 
        CS_3 => sample_clk_3, 
        SDATA1_3 => ADC_SDATA1_3, 
        SDATA2_3 => ADC_SDATA2_3, 
        data_5 => OPEN, 
        data_6 => adout3,
        
        SCK_4 => serial_clk_4, 
        CS_4 => sample_clk_4, 
        SDATA1_4 => ADC_SDATA1_4, 
        SDATA2_4 => ADC_SDATA2_4, 
        data_7 => OPEN, 
        data_8 => adout4 
    );
    add_bb : bat_n_ball
    PORT MAP(--instantiate bat and ball component
        v_sync => S_vsync,
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col, 
        
        bat_1_x => bat_1_pos,
--        bat_2_x => bat_2_pos,
        bat_3_x => bat_3_pos,
--        bat_4_x => bat_4_pos, 
        
        bat_2_y => bat_2_pos,
        bat_4_y => bat_4_pos, 
        
        serve => btn0, 
        clear => btnu,
        red => S_red, 
        green => S_green, 
        blue => S_blue,
        score => display
    );
    vga_driver : vga_sync
    PORT MAP(--instantiate vga_sync component
        pixel_clk => pxl_clk,
        red_in => S_red & "000",
        green_in => S_green & "000",
        blue_in => S_blue & "000",
        red_out => VGA_red, 
        green_out => VGA_green, 
        blue_out => VGA_blue, 
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col, 
        hsync => VGA_hsync, 
        vsync => S_vsync
    );
    VGA_vsync <= S_vsync; --connect output vsync
        
    clk_wiz_0_inst : clk_wiz_0
    port map (
      clk_in1 => clk_in,
      clk_out1 => pxl_clk
    );
    led1 : leddec16
    PORT MAP(
      dig => led_mpx, data => display, 
      anode => SEG7_anode, seg => SEG7_seg
    );
END Behavioral;