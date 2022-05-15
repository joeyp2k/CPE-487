#Lab 6: Pong
In lab 6 we created a vivado program that generates a game of pong outputted through the VGA out port on the FPGA.  Pressing BTNU shoots the ball and twisting the potentiometer connected to the JA port of the FPGA allows the user to move the platform left and right.
In the modified version of this program, we changed the color of the ball from blue to red.  Addidionally, the speed of the ball could be changed with the switches on the FPGA.  If the ball is launched while the switches are set to make the speed of the ball 0, the ball only move horizontally and will never make it back to the platform.  A system reset is needed in this situation.
##Pong

##Pong Modified