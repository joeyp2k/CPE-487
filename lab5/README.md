# Lab 5: Siren
In lab 5 we created a VHDL program that controlls a speaker to make a siren sound.  The speaker module must be connected to the JA port of the FPGA.  During this lab I decided to search online for a solution to the constant hanging I would experience whenever operating vivado.  I found a forum online that covered the exact problem I was having and provided the solution of changing the "syntax checking" option under text editor settings ("Tools->Settings->Text Editor->Syntax Checking") from sigasi to Vivado.  This increased loading times substantially and I have not experienced any crashing or constant hanging since.

In the modified version of this program, the switches on the FPGA are used to modify the frequency of the siren's oscillating sound.  The switches to the right of the board increment the frequency of the siren less than those to the left. 

Support forum for constant hanging: https://support.xilinx.com/s/question/0D52E00006tdCiISAU/vivado-hangs-a-lot-while-waiting-for-child-processes?language=en_US

## Siren
https://user-images.githubusercontent.com/65480784/168590036-2aa83d36-3962-4cad-9ec6-b48f96d54290.mp4

## Siren Modified
Uploading siren_1.mp4…

