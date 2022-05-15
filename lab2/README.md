#Lab 2: Hex4Count
In Lab 2 we created a VHDL program called hex4count that utilizes four seven segment displays on the FPGA to count in hex.  We use a 39 bit binary counter in counter.vhd in order to slow down the frequency that the counter is changed to a speed the human eye can read.  The higher bits are changed at this slower speed which is why we use the 39th to 17th bit as outputs to the multiplexer.  The lower bits are changed at a faster rate thanks to the constant clock speed.  Each incrementation occurs at a frequency of 12Hz.  We also set up the program to boot from memory when the FPGA is powered on and off.  This was achieved by moving the MODE jumper from JTAG to QSPI, generating the memory configuration file in the tools tab of Vivado, and finally adding and programming the configuration memory device.
In a modified version of the program, the counter operates with eight digits instead of four.

##Hex4Count

##Hex4Count Modified