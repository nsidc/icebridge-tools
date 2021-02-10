OVERVIEW

This readme accompanies the IceBridge ATM L1B Qfit Elevation and
Return Strength MATLAB data reader: readILATM1B.m

The read-me describes how the function works, disclaimers, links to
the software, the test data, and an example output in text format.
The readme includes instructions on downloading the software.

The readILATM1B.m Matlab function calls C program qi2txt which reads
binary data files from the Operation IceBridge ATM
instrument. readILATM1B.m returns a data array containing the
floating-point ATM data as well as an ASCII header line identifying
each of the 12 fields comprising each ATM data record. Operation
IceBridge ATM data are available as the ILATM1B product at the
National Snow and Ice Data Center (NSIDC), at

http://nsidc.org/data/ilatm1b.html

Both the readILATM1B.m software and its required qi2txt software are
available at

http://nsidc.org/data/icebridge/tools.html

DISCLAIMER

This software is provided as-is as a service to the user community in
the hope that it will be useful, but without any warranty of fitness
for any particular purpose or correctness.  Bug reports, comments, and
suggestions for improvement are welcome; please send to
nsidc@nsidc.org.

USING THE SOFTWARE
 
function [data, header] = readILATM1B(filename_url, qi2txt_dir)
 
  Reads the Qfit ILATM1B data into matlab; wrapper on the C version.
  ILATM1B Airborne Topographic Mapper (ATM) Project
  NASA, Goddard Space Flight Center, Wallops Flight Facility
  Principal Investigator: Bill Krabill (William.B.Krabill@nasa.gov)
 --------------------------------------------------------------------------
  USAGE:
  [data, header] = readILATM1B(filename_url, qi2txt_dir);
 
  RETURN VALUES: 
  data - ILATM1B data.
  NOTE: the C version qfit reader qi2txt called by this function returns data: 
   1    Relative Time (seconds from start of the file)
   2    Laser Spot Latitude (decimal degrees)
   3    Laser Spot Longitude (decimal degrees)
   4    Elevation (meters)
   5    Start Pulse signal Strength (relative integer) 
   6    Reflected Laser Signal Strength (relative integer)
   7    Scan Azimuth (degrees)
   8    Pitch (degrees)
   9    Roll (degrees)
  10    GPS PDOP (dilution of precision) 
  11    Laser received pulse width (digitizer samples)
  12    GPS Time (seconds)
 
  header - ILATM1B ASCII header line produced by qi2txt.
 
  ARGUMENTS:
  filename_url - ILATM1B Qfit input data file URL.
  qi2txt_dir - directory containing qi2txt C program executable.
 
  PATHS:
  code:
  http://nsidc.org/data/icebridge/tools.html
 
  code was tested on IceBridge FTP data file:
  ftp://n5eil01u.ecs.nsidc.org/SAN2/ICEBRIDGE/ILATM1B.001/2010.04.05/ILATM1B_20100405_141754.atm4cT3.qi
 --------------------------------------------------------------------------
  National Snow and Ice Data Center, Susan Rogers, March 16, 2011
  Copyright (c) 2011 Regents of the University of Colorado.


DOWNLOADING THE SOFTWARE

There are five files in the downloaded tar file:

RELEASE_NOTES.txt
  Contains a running list of changes incorporated into each release of the ILATM1B matlab reader.

matlab-ILATM1B-reader-readme.txt
  This file.

readILATM1B.m
  The Matlab program for the reader.

test_readILATM1B.m
  Matlab test program that serves as an example of how to call
  readILATM1B.m.

expected_output.txt
  ASCII text file used by test_readLATM1B.m.

To unpack the tar file on a Linux system:
(the "$" is the Linux command-line prompt):

  $ tar xvf matlab_ILATM1B_reader_VERSION.tar

Where VERSION is the version of the tar file, e.g. 0.3.
The result of this command should be the five files listed above
written to the current directory.

Add the reader path: either edit the Matlab start-up script, or use
the function addpath at the Matlab command line.

Type help readILATM1B at the matlab command prompt.

Type help test_readILATM1B at the matlab command prompt.
