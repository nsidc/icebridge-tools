OVERVIEW

This readme accompanies the IceBridge QFIT data reader: qi2txt

The qi2txt program reads binary data files from the Operation IceBridge ATM
instrument, which are available as the ILATM1B and BLATM1B product at the
National Snow and Ice Data Center (NSIDC), at

http://nsidc.org/data/ilatm1b.html

This software is available at

http://nsidc.org/data/icebridge/tools.html

CHANGELOG

v0.4 >> 7-8-16 Modified to accommodate 10 and 14-word data outputs
       plus more output modes:
	- Short output  -Coordinates only -First and Last -Print all
v0.5 >> Modified to switch between data of different endianness
        automatically

DISCLAIMER

This software is provided as-is as a service to the user community in the
hope that it will be useful, but without any warranty of fitness for any
particular purpose or correctness.  Bug reports, comments, and suggestions
for improvement are welcome; please send to nsidc@nsidc.org.


USING THE SOFTWARE

There are five files in the downloaded tar file:

example_output.txt
  Example ASCII output from qi2txt

define.h
  A header file needed to build the reader

makefile.Linux
  The makefile used to build the reader on Linux operating systems

qi2txt.c
  The  C language source for the reader

qi2txt-readme.txt
  This file


To compile the reader on a Linux system:

Unpack the tar file (the "$" is the Linux command-line prompt):
  $ tar xvf qi2txt.tar

Use "make" to compile:
  $ make -f makefile.Linux


The result of these commands should be an executable program named qi2txt.

The program does not use any graphics systems, and so should be easy to
compile on other systems besides Linux.

The program will take the original qfit file and match the output to 
the correct endianness.  It tests the endianness of the host machine 
and swaps the data to match that of the host machine.


Examples of using the reader:

Convert an entire binary input file to a (possibly huge) text file:
  $ ./qi2txt inputfile.qi > outfile_ascii.txt

Extract lat, lon, elevation only, skipping over the header line:
  $ ./qi2txt inputfile.qi | grep -v '^#' | awk '{print $2,$3,$4}' > xyz.txt

Print the first few lines:
  $ ./qi2txt inputfile.qi | head
