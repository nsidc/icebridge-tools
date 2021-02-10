OVERVIEW

This readme accompanies the IceBridge Sander Air GRAV L1B Geolocated Free Air Gravity Anomalies MATLAB data reader: readIGGRV1B.m

The read-me describes how the function works, disclaimers, links to the software, the test data, and an example output in text format.  The readme includes instructions on downloading the software.

The function readIGGRV1B.m reads location <Location>.xyz data files from the Operation IceBridge Snow Radar instrument, which are available as the IGGRV1B product at the National Snow and Ice Data Center (NSIDC), at

http://nsidc.org/data/iggrv1b.html

This software is available at

http://nsidc.org/data/icebridge/tools.html

DISCLAIMER

This software is provided as-is as a service to the user community in the
hope that it will be useful, but without any warranty of fitness for any
particular purpose or correctness.  Bug reports, comments, and suggestions for improvement are welcome; please send to nsidc@nsidc.org.

USING THE SOFTWARE

function [data] = readIGGRV1B(filename, YYYYMMDD)

Read the IGGRV1B Gravity data file, <Location>.xyz.
IceBridge Sander Air GRAV L1B Geolocated Free Air Gravity Anomalies
 --------------------------------------------------------------------------
  USAGE:
  filename = 'drag and drop a file';
  [data] = readIGGRV1B(filename, YYYYMMDD);
 
  RETURN VALUES:
  data - a numerical matrix of raw IGGRV1B data with the columns:
   1) Latitude (decimal degrees)
   2) Longitude (decimal degrees) 
   3) Date (YYYYMMDD)
   4) Day (day of year)
   5) Line (flight line id)
   6) UTC Time (seconds) 
   7) Fiducial Time (seconds)
   8) PSx (meters)
   9) PSy (meters)
  10) UPSx Universal Polar Stereographic X WGS-84 (meters)
  11) UPSy Universal Polar Stereographic Y WGS-84 (meters)
  12) WGS Height above the ellipsoid (meters)
  13) Fx Gravimeter x acceleration (mGal)
  14) Fy Gravimeter y acceleration (mGal)
  15) Fz Gravimeter z acceleration (mGal)
  16) EOT Grav (mGal)
  17) Free Air Correction (mGal)
  18) Intersection leveling Correction (mGal)
  19) 70s FA Grav (mGal)
  20) 100s FA Grav (mGal) 
  21) 140s FA Grav (mGal)
  22) 6000m FA Grav (mGal) 
 
  ARGUMENTS:
  filename - The IGGRV1B path and data file name, in single quotes.
  YYYYMMDD - the year month day, in single quotes.
 
  PATHS:
  code:
  http://nsidc.org/data/icebridge/tools.html
 
  code was tested on IceBridge FTP data:
  ftp://n4ftl01u.ecs.nasa.gov/SAN2/ICEBRIDGE_FTP/ ...
  IGGRV1B_AirGRAVxyAnom_v01/
 
 --------------------------------------------------------------------------
  National Snow and Ice Data Center, Susan Rogers, March 16, 2011
  Copyright (c) 2011 Regents of the University of Colorado.


DOWNLOADING THE SOFTWARE

There are three files in the downloaded tar file:

example_output_readIGGRV1B.txt
  An example input and the first few values of the output, in a text file.

readIGGRV1B.m
  The executable m-file.

matlab-IGGRV1B-readme.txt
  The documentation.

To unpack the tar file on a Linux system:
(the "$" is the Linux command-line prompt):
  $ tar xvf matlab_IGGRV1B_reader_0.1.tar
The result of these commands should be an executable m-file named readIGGRV1B.m.

Add the reader path: either edit the Matlab start-up script, or use the function addpath at the Matlab command line.  Type help readIGGRV1B at the matlab command prompt.
