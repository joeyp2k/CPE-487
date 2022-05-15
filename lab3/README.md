#Lab 3: Vgaball
In lab 3 we created a VHDL program to generate a cube that moves up and down, reversing direction when it reaches the top or bottom of the screen.
In the modified version of this program, the cube is changed to a ball and the color is changed from red to blue and the ball moves diagonally instead of only vertically.  The color change is achieved by modifying the red and blue signals used in drawing the ball.  The horizontal movement is possible after introducing a new signal ball_x_motion in ball.vhd that increments the ball's position when the rising edge of the clock is detected through the v_sync signal.

##Vgaball

##Vgaball Modified