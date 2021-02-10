OVERVIEW

This readme accompanies the IceBridge QFIT data reader: qi2txt

The qi2txt program reads binary data files from the Operation IceBridge ATM
instrument, which are available as the ILATM1B and BLATM1B product at the
National Snow and Ice Data Center (NSIDC), at

http://nsidc.org/data/ilatm1b.html

This software is available at

http://nsidc.org/data/icebridge/tools.html

DISCLAIMER

This software is provided as-is as a service to the user community in the
hope that it will be useful, but without any warranty of fitness for any
particular purpose or correctness.  Bug reports, comments, and suggestions
for improvement are welcome; please send to nsidc@nsidc.org.

CHANGELOG

v0.4 >> 7-8-16 Modified to accommodate 10 and 14-word data outputs
       plus more output modes:
        - Short output  -Coordinates only -First and Last -Print all


USING THE SOFTWARE

There are eight files in the downloaded tar file:

define.h
  A header file needed to build the reader

example_output.txt
  Example ASCII output from qi2txt

makefile
  The makefile used to build the reader on Mac, Win, Linux operating systems

qi2txt.c
  The  C language source for the reader

qi2txt_linux
qi2txt_mac
qi2txt_win.exe
  Executables compiled for each platform, all 32-bit

qi2txt-readme.txt
  This file

-----

To recompile the reader on a Linux system:

Unpack the tar file (the "$" is the Linux command-line prompt):
  $ tar xvf qi2txt.tar

Use "make" to compile:
  $ make -f makefile.Linux

On Mac you must have gcc installed. On Windows, MinGW or a compiler with an executable similar to mingw32-make.exe must be present.

The result of these commands should be an executable program named qi2txt.

The program does not use any graphics systems, and so should be easy to
compile on other systems besides Linux.

The program assumes by default that the input binary QFIT file is in big
endian format.  It tests the endianness of the host machine and swaps the
data to match that of the host machine.  To have the program assume the
data format is little endian, use the -L option.


Examples of using the reader:

Convert an entire binary input file to a (possibly huge) text file:
  $ ./qi2txt inputfile.qi > outfile_ascii.txt

Extract lat, lon, elevation only, skipping over the header line:
  $ ./qi2txt -S inputfile.qi > xyz.txt

Print the first few lines, and tell the program that the input file is in
little endian format:
  $ ./qi2txt -L inputfile.qi | head -n10
