LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY bat_n_ball IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        
        bat_1_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat 1 x position
        bat_3_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat 3 x position        
        bat_2_y : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat 3 x position
        bat_4_y : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current bat 4 x position
        
        clear : IN STD_LOGIC; -- initiates serve
        serve : IN STD_LOGIC; -- initiates serve
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC;
        score: OUT STD_LOGIC_VECTOR (15 DOWNTO 0) -- count the number of successful hits
    );
END bat_n_ball;

ARCHITECTURE Behavioral OF bat_n_ball IS
    CONSTANT bsize : INTEGER := 8; -- ball size in pixels
    CONSTANT bat_tb_w : INTEGER := 20; -- bat width in pixels
    CONSTANT bat_tb_h : INTEGER := 3; -- bat height in pixels
    CONSTANT bat_lr_w : INTEGER := 3; -- bat width in pixels
    CONSTANT bat_lr_h : INTEGER := 20; -- bat height in pixels
    -- distance ball moves each frame
    CONSTANT ball_speed : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR (6, 11);
    SIGNAL ball_on : STD_LOGIC; -- indicates whether ball is at current pixel position
    SIGNAL bat_1_on : STD_LOGIC; -- indicates whether bat at over current pixel position
    SIGNAL bat_2_on : STD_LOGIC; -- indicates whether bat at over current pixel position
    SIGNAL bat_3_on : STD_LOGIC; -- indicates whether bat at over current pixel position
    SIGNAL bat_4_on : STD_LOGIC; -- indicates whether bat at over current pixel position
    SIGNAL game_on : STD_LOGIC := '0'; -- indicates whether ball is in play
    -- current ball position - intitialized to center of screen
    SIGNAL ball_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
    SIGNAL ball_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    -- bat vertical position
    CONSTANT bat_1_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(500, 11);
    CONSTANT bat_2_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(40, 11);
    CONSTANT bat_3_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(140, 11);
    CONSTANT bat_4_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(759, 11);
    -- current ball motion - initialized to (+ ball_speed) pixels/frame in both X and Y directions
    SIGNAL ball_x_motion, ball_y_motion : STD_LOGIC_VECTOR(10 DOWNTO 0) := ball_speed;
    SIGNAL scorecount : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL stop_dbl_hit : STD_LOGIC; -- stops the counter from registering 2 hits at once
BEGIN
    red <= NOT bat_1_on AND NOT bat_2_on; -- color setup for red ball and cyan bat on white background
    green <= NOT ball_on AND NOT bat_2_on AND NOT bat_4_on;
    blue <= NOT ball_on AND NOT bat_3_on;
    -- process to draw round ball
    -- set ball_on if current pixel address is covered by ball position
    balldraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF pixel_col <= ball_x THEN -- vx = |ball_x - pixel_col|
            vx := ball_x - pixel_col;
        ELSE
            vx := pixel_col - ball_x;
        END IF;
        IF pixel_row <= ball_y THEN -- vy = |ball_y - pixel_row|
            vy := ball_y - pixel_row;
        ELSE
            vy := pixel_row - ball_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (bsize * bsize) THEN -- test if radial distance < bsize
            ball_on <= game_on;
        ELSE
            ball_on <= '0';
        END IF;
    END PROCESS;
    -- process to draw bat
    -- set bat_on if current pixel address is covered by bat position
    batdraw : PROCESS (bat_1_x, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF ((pixel_col >= bat_1_x - bat_tb_w) OR (bat_1_x <= bat_tb_w)) AND
         pixel_col <= bat_1_x + bat_tb_w AND
             pixel_row >= bat_1_y - bat_tb_h AND
             pixel_row <= bat_1_y + bat_tb_h THEN
                bat_1_on <= '1';
        ELSE
            bat_1_on <= '0';
        END IF;
    END PROCESS;
    bat2draw : PROCESS (bat_2_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN    
        IF ((pixel_col >= bat_2_x - bat_lr_w) OR (bat_2_x <= bat_lr_w)) AND
         pixel_col <= bat_2_x + bat_lr_w AND
             pixel_row >= bat_2_y - bat_lr_h AND
             pixel_row <= bat_2_y + bat_lr_h THEN
                bat_2_on <= '1';
        ELSE
            bat_2_on <= '0';
        END IF;
    END PROCESS;
    bat3draw : PROCESS (bat_3_x, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF ((pixel_col >= bat_3_x - bat_tb_w) OR (bat_3_x <= bat_tb_w)) AND
         pixel_col <= bat_3_x + bat_tb_w AND
             pixel_row >= bat_3_y - bat_tb_h AND
             pixel_row <= bat_3_y + bat_tb_h THEN
                bat_3_on <= '1';
        ELSE
            bat_3_on <= '0';
        END IF;
    END PROCESS;
    bat4draw : PROCESS (bat_4_y, pixel_row, pixel_col) IS
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    BEGIN
        IF ((pixel_col >= bat_4_x - bat_lr_w) OR (bat_4_x <= bat_lr_w)) AND
         pixel_col <= bat_4_x + bat_lr_w AND
             pixel_row >= bat_4_y - bat_lr_h AND
             pixel_row <= bat_4_y + bat_lr_h THEN
                bat_4_on <= '1';
        ELSE
            bat_4_on <= '0';
        END IF;
    END PROCESS;
    -- process to move ball once every frame (i.e., once every vsync pulse)
    mball : PROCESS
        VARIABLE temp : STD_LOGIC_VECTOR (11 DOWNTO 0);
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        IF clear = '1' AND game_on = '0' THEN -- test for new serve
            scorecount <= CONV_STD_LOGIC_VECTOR(3, 16);
            score <= scorecount;
        END IF;
        IF serve = '1' AND game_on = '0' THEN -- test for new serve
            game_on <= '1';
            ball_y_motion <= (NOT ball_speed) + 1; -- set vspeed to (- ball_speed) pixels
            ball_x_motion <= ball_speed + 1;
        ELSIF ball_y <= bsize AND game_on <= '1' THEN -- bounce off top wall
            ball_y_motion <= (ball_speed) + 1; -- set vspeed to (- ball_speed) pixels
            game_on <= '0'; -- and make ball disappear
            scorecount <= scorecount + 1;
            score <= scorecount;
        ELSIF ball_y + bsize >= 600 AND game_on <= '1' THEN -- if ball meets bottom wall
            ball_y_motion <= (NOT ball_speed) + 1; -- set vspeed to (- ball_speed) pixels
            game_on <= '0'; -- and make ball disappear
            scorecount <= scorecount + 1;
            score <= scorecount;
        ELSIF ball_x + bsize >= 800 AND game_on <= '1' THEN -- if ball meets right wall
            ball_x_motion <= (NOT ball_speed) + 1; -- set vspeed to (- ball_speed) pixels
            game_on <= '0'; -- and make ball disappear
            scorecount <= scorecount - 1;
            score <= scorecount;
        ELSIF ball_x <= bsize AND game_on <= '1' THEN -- if ball meets left wall
            ball_x_motion <= (ball_speed) + 1; -- set vspeed to (- ball_speed) pixels
            game_on <= '0'; -- and make ball disappear
            scorecount <= scorecount - 1;
            score <= scorecount;
        END IF;
        -- allow for bounce off bat
        IF (ball_x + bsize/2) >= (bat_1_x - bat_tb_w) AND
         (ball_x - bsize/2) <= (bat_1_x + bat_tb_w) AND
             (ball_y + bsize/2) >= (bat_1_y - bat_tb_h) AND
             (ball_y - bsize/2) <= (bat_1_y + bat_tb_h) THEN
                ball_y_motion <= (NOT ball_speed) + 1; -- set vspeed to (- ball_speed) pixels
        END IF;
        IF (ball_x + bsize/2) >= (bat_2_x - bat_lr_w) AND
         (ball_x - bsize/2) <= (bat_2_x + bat_lr_w) AND
             (ball_y + bsize/2) >= (bat_2_y - bat_lr_h) AND
             (ball_y - bsize/2) <= (bat_2_y + bat_lr_h) THEN
                ball_x_motion <= (ball_speed) + 1; -- set vspeed to (+ ball_speed) pixels
        END IF;
        IF (ball_x + bsize/2) >= (bat_3_x - bat_tb_w) AND
         (ball_x - bsize/2) <= (bat_3_x + bat_tb_w) AND
             (ball_y + bsize/2) >= (bat_3_y - bat_tb_h) AND
             (ball_y - bsize/2) <= (bat_3_y + bat_tb_h) THEN
                ball_y_motion <= (ball_speed) + 1; -- set vspeed to (- ball_speed) pixels
        END IF;
        IF (ball_x + bsize/2) >= (bat_4_x - bat_lr_w) AND
         (ball_x - bsize/2) <= (bat_4_x + bat_lr_w) AND
             (ball_y + bsize/2) >= (bat_4_y - bat_lr_h) AND
             (ball_y - bsize/2) <= (bat_4_y + bat_lr_h) THEN
                ball_x_motion <= (NOT ball_speed) + 1; -- set vspeed to (+ ball_speed) pixels
        END IF;
        -- compute next ball vertical position
        -- variable temp adds one more bit to calculation to fix unsigned underflow problems
        -- when ball_y is close to zero and ball_y_motion is negative
        temp := ('0' & ball_y) + (ball_y_motion(10) & ball_y_motion);
        IF game_on = '0' THEN
            ball_y <= CONV_STD_LOGIC_VECTOR(440, 11);
            ball_x <= CONV_STD_LOGIC_VECTOR(400, 11);
        ELSIF temp(11) = '1' THEN
            ball_y <= (OTHERS => '0');
        ELSE ball_y <= temp(10 DOWNTO 0); -- 9 downto 0
        END IF;
        -- compute next ball horizontal position
        -- variable temp adds one more bit to calculation to fix unsigned underflow problems
        -- when ball_x is close to zero and ball_x_motion is negative
        temp := ('0' & ball_x) + (ball_x_motion(10) & ball_x_motion);
        IF temp(11) = '1' THEN
            ball_x <= (OTHERS => '0');
        ELSE ball_x <= temp(10 DOWNTO 0);
        END IF;
    END PROCESS;
END Behavioral;