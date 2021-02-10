OVERVIEW

This readme accompanies the IceBridge POS/AV L1B Corrected Position and Attitude Data MATLAB data reader: readIPAPP1B.m

The read-me describes how the function works, disclaimers, links to the software, the test data, and an example output in text format.  The readme includes instructions on downloading the software.

The function readIPAPP1B.m reads Applanix aircraft data files from the Operation IceBridge Applanix instrument, which are available as the IPAPP1B product at the National Snow and Ice Data Center (NSIDC), at

http://nsidc.org/data/ipapp1b.html

This software is available at

http://nsidc.org/data/icebridge/tools.html

DISCLAIMER

This software is provided as-is as a service to the user community in the
hope that it will be useful, but without any warranty of fitness for any
particular purpose or correctness.  Bug reports, comments, and suggestions for improvement are welcome; please send to nsidc@nsidc.org.


USING THE SOFTWARE
 
function [data] = readIPAPP1B(filename, UTCtime_range)

Reads the IPAPP1B Applanix aircraft data.
IPAPP1B is a data collection derived mostly from the DMS data streams; all of the parameters are "at the aircraft".
 --------------------------------------------------------------------------
  USAGE:
  filename = 'drag and drop a file';
  [data] = read_IPAPP1B(filename, UTCtime_range);
 
  RETURN VALUES: 
  data -a numerical matrix of the IPAPP1B data with the columns:
   1) time (UTC seconds)
   2) latitude (radians)
   3) longitude (radians)
   4) Altitude (meters)
   5) x w.a. velocity (meters/second)
   6) y w.a. velocity (meters/second)
   7) z w.a. velocity (meters/second)
   8) roll (radians)
   9) pitch (radians)
  10) platform heading (radians)
  11) wander angle (radians)
  12) x body specific force (meters/second)
  13) y body specific force (meters/second)
  14) z body specific force (meters/second)
  15) x body angular rate (radians/second)
  16) y body angular rate (radians/second)
  17) z body angular rate (radians/second)       
 
  ARGUMENTS:
  filename - The IPAPP1B path and filename, in single quotes.
  UTCtime_range - [time1 time2] in brackets, or a single time.
 
  PATHS:
  code:
  http://nsidc.org/data/icebridge/tools.html
 
  code was tested on IceBridge FTP data:
  ftp://n4ftl01u.ecs.nasa.gov/SAN2/ICEBRIDGE_FTP/...
  IPAPP1B_GPSInsCorrected_v01/

 --------------------------------------------------------------------------
  National Snow and Ice Data Center, Susan Rogers, March 16, 2011
  Copyright (c) 2011 Regents of the University of Colorado.


DOWNLOADING THE SOFTWARE

There are three files in the downloaded tar file:

example_output_readIPAPP1B.txt
  An example input and the first few values of the output, in a text file.

readIPAPP1B.m
  The executable m-file.

matlab-IPAPP1B-readme.txt
  The documentation.

To unpack the tar file on a Linux system:
(the "$" is the Linux command-line prompt):
  $ tar xvf matlab_IPAPP1B_reader_0.1.tar
The result of these commands should be an executable m-file named readIPAPP1B.m.

Add the reader path: either edit the Matlab start-up script, or use the function addpath at the Matlab command line.  Type help readIPAPP1B at the matlab command prompt.
