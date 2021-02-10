OVERVIEW

This readme accompanies the IceBridge Snow Radar MATLAB data reader: readIGGRV1Battitude.m

The read-me describes how the function works, disclaimers, links to the software, the test data, and an example output in text format.  The readme includes instructions on downloading the software.

The function readIGGRV1Battitude.m reads "Attitude".xyz data files from the Operation IceBridge AIRGrav instrument, which are available as the IGGRV1B product at the National Snow and Ice Data Center (NSIDC), at

http://nsidc.org/data/iggrv1b.html

This software is available at

http://nsidc.org/data/icebridge/tools.html

DISCLAIMER

This software is provided as-is as a service to the user community in the
hope that it will be useful, but without any warranty of fitness for any
particular purpose or correctness.  Bug reports, comments, and suggestions for improvement are welcome; please send to nsidc@nsidc.org.

USING THE SOFTWARE
 
function [data] = readIGGRV1Battitude(filename, YYYYMMDD)

Read the IGGRV1B Gravity aircraft attitude file, "Attitude".xyz.
IceBridge Sander Air GRAV L1B Geolocated Free Air Gravity Anomalies
 --------------------------------------------------------------------------
  USAGE:
  filename = 'drag and drop a file';
  [data] = readIGGRV1Battitude(filename, YYYYMMDD);
 
  RETURN VALUES:
  data - a numerical matrix of the IGGRV1B attitude data with the columns:
   1) Date (YYYYMMDD)
   2) Day (day of year)
   3) UTC Time (seconds)
   4) Fiducial Time (seconds)
   5) Pitch (degrees)
   6) Roll (degrees)
   7) Heading (degrees)
   8) Latitude (decimal degrees)
   9) Longitude (decimal degrees)
  10) PSx (meters)
  11) PSy (meters)
  12) WGS-84 Height above the ellipsoid (meters)
  13) UPSx (meters)
  14) UPSy (meters)
 
  ARGUMENTS:
  filename - The IGGRV1B path and attitude file name, in single quotes.
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

example_output_readIGGRV1Battitude.txt
  An example input and the first few values of the output, in a text file.

readIGGRV1Battitude.m
  The executable m-file.

matlab-IGGRV1Battitude-readme.txt
  The documentation.

To unpack the tar file on a Linux system:
(the "$" is the Linux command-line prompt):
  $ tar xvf matlab_IGGRV1Battitude_reader_0.1.tar
The result of these commands should be an executable m-file named readIGGRV1Battitude.m.

Add the reader path: either edit the Matlab start-up script, or use the function addpath at the Matlab command line.  Type help readIGGRV1Battitude at the matlab command prompt.
