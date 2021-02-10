OVERVIEW

This readme accompanies the IceBridge ATM L2 Icessn Elevation, Slope, and Roughness MATLAB data reader: readILATM2.m

The read-me describes how the function works, disclaimers, links to the software, the test data, and an example output in text format.  The readme includes instructions on downloading the software.

The function readILATM2.m reads ATM icessn data files from the Operation IceBridge Airborne Topographic Mapper instrument, which are available as the ILATM2 product at the National Snow and Ice Data Center (NSIDC), at

http://nsidc.org/data/ilatm2.html

This software is available at

http://nsidc.org/data/icebridge/tools.html

DISCLAIMER

This software is provided as-is as a service to the user community in the
hope that it will be useful, but without any warranty of fitness for any
particular purpose or correctness.  Bug reports, comments, and suggestions for improvement are welcome; please send to nsidc@nsidc.org.


USING THE SOFTWARE

function [data] = readILATM2(filename)

Read the ATM file. 
Airborne Topographic Mapper, the ATM icessn ILATM2
 --------------------------------------------------------------------------
  USAGE:
  filename = 'drag and drop a file';
  [data] = readILATM2(filename);
 
  RETURN VALUES:
  data - a numerical matrix of raw ATM data with the columns: 
   1) GPS TIME (seconds)
   2) LAT (decimal degrees) 
   3) E.LON (decimal degrees)
   4) WGS84 Surface Elevation (meters)
   5) SN slope 
   6) WE slope 
   7) RMS surface roughness (centimeters) 
   8) Number of points plane 
   9) Number of points edited 
  10) map view distance between aircraft and center plate (meters)
  11) track identifier (1 ... n, starboard to port, 0 is nadir)
 
  ARGUMENTS:
  filename - The ILATM2 path and file name, in single quotes.
 
  PATHS:
  code:
  http://nsidc.org/data/icebridge/tools.html
 
  code was tested on IceBridge FTP data:
  ftp://n4ftl01u.ecs.nasa.gov/SAN2/ICEBRIDGE_FTP/...
  ILATM2_ATMicessn_v01/

 --------------------------------------------------------------------------
  National Snow and Ice Data Center, Susan Rogers, March 16, 2011
  Copyright (c) 2011 Regents of the University of Colorado.


DOWNLOADING THE SOFTWARE

There are three files in the downloaded tar file:

example_output_readILATM2.txt
  An example input and the first few values of the output, in a text file.

readILATM2.m
  The executable m-file.

matlab-ILATM2-readme.txt
  The documentation.

To unpack the tar file on a Linux system:
(the "$" is the Linux command-line prompt):
  $ tar xvf matlab_ILATM2_reader_0.1.tar
The result of these commands should be an executable m-file named readILATM2.m.

Add the reader path: either edit the Matlab start-up script, or use the function addpath at the Matlab command line.  Type help readILATM2 at the matlab command prompt.
