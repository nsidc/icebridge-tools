
This readme accompanies the IceBridge Applanix SBET file C reader: extract_cols_from_sbet.c

The extract_cols_from_sbet.c program extracts longitude, latitude, and
altitude from binary data files from the Operation IceBridge Applanix
instrument, which are available as the IPAPP1B product at the National Snow
and Ice Data Center (NSIDC), at

http://nsidc.org/data/ipapp1b.html

This software is available at

http://nsidc.org/data/icebridge/tools.html


The output from this program is another binary file containing only
longitude, latitude, and altitude.  This may be of limited utility for many
users, but the software is provided as a starting point for creating your
own reader in C.  The source could be easily modified to output ASCII
formatted data, for example.  See also the Perl reader for this data set,
also available from NSIDC.

DISCLAIMER

This software is provided as-is as a service to the user community in the
hope that it will be useful, but without any warranty of fitness for any
particular purpose or correctness.  Bug reports, comments, and suggestions
for improvement are welcome; please send to nsidc@nsidc.org.

There are 2 files in the downloaded tar file:

extract_cols_from_sbet.c
  The C language source for the reader

extract_cols_from_sbet_c_readme.txt
  This readme file


To compile the reader on a Linux system:

Unpack the tar file (the "$" is the Linux command-line prompt):
  $ tar xvf c_sbet_reader.0.1.tar

Use "gcc" to compile:
  $ gcc -o extract_cols_from_sbet extract_cols_from_sbet.c


The result of these commands should be an executable program named
extract_cols_from_sbet.

The program does not use any graphics systems, and so should be easy to
compile on other systems besides Linux.


Examples of using the reader:

Print a usage summary:
  $ ./extract_cols_from_sbet

Convert an entire binary input file to a file:
  $ ./extract_cols_from_sbet sbet_20100517.out  lonlatalt.bin


(SBET file Perl reader by B. Raup, NSIDC)
