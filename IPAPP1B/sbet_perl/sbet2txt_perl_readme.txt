
This readme accompanies the IceBridge Applanix SBET file Perl reader: sbet2txt.pl

The sbet2txt.pl program reads binary data files from the Operation IceBridge Applanix
instrument, which are available as the IPAPP1B product at the National Snow
and Ice Data Center (NSIDC), at

http://nsidc.org/data/ipapp1b.html

This software is available at

http://nsidc.org/data/icebridge/tools.html

DISCLAIMER

This software is provided as-is as a service to the user community in the
hope that it will be useful, but without any warranty of fitness for any
particular purpose or correctness.  Bug reports, comments, and suggestions
for improvement are welcome; please send to nsidc@nsidc.org.


There are 3 files in the downloaded tar file:

sbet2txt_perl_readme.txt
  This readme file

example_output.txt
  Example ASCII output from sbet2txt.pl (first 10 lines)

sbet2txt.pl
  The Perl source for the reader


Examples of using the reader:

Print a usage summary:
  $ ./sbet2txt.pl -h

Convert an entire binary input file to a (possibly huge) text file:
  $ ./sbet2txt.pl inputfile.out > outfile_ascii.txt

Extract lat, lon, elevation only, skipping over the header line:
  $ ./sbet2txt.pl inputfile.out | grep -v '^#' | awk '{print $2,$3,$4}' > xyz.txt

Print the first few lines:
  $ ./sbet2txt.pl inputfile.out | head

Print every 500th point and save in a file:
  $ ./sbet2txt.pl -n 500 inputfile.out > outfile_ascii.txt

Print angles (lon,lat...) in radians as they're stored in the file:
  $ ./sbet2txt.pl -r inputfile.out > outfile_ascii_rawmode.txt



(SBET file Perl reader by B. Raup, NSIDC)
