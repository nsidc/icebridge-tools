OVERVIEW

This readme accompanies the Operation IceBridge DMS L1B Geolocated and Orthorectified Images MATLAB data reader: readIODMS1B.m

The read-me describes how the function works, disclaimers, links to the software, the test data, and an example output in text format.  The readme includes instructions on downloading the software.

The function readIODMS1B.m reads time and position from data files from the Operation IceBridge DMS instrument, which are available as the IODMS1B product at the National Snow and Ice Data Center (NSIDC), at

http://nsidc.org/data/iodms1b.html

This software is available at

http://nsidc.org/data/icebridge/tools.html

DISCLAIMER

This software is provided as-is as a service to the user community in the
hope that it will be useful, but without any warranty of fitness for any
particular purpose or correctness.  Bug reports, comments, and suggestions for improvement are welcome; please send to nsidc@nsidc.org.


USING THE SOFTWARE

function [data] = readIODMS1B(filename)

  This function reads time and position from the IODMS1B embedded data.  
  Digital Mapping System, DMS geotiff IODMS1B.

  Please note that there are more embedded parameters than are 
  returned by this function.
 
  USAGE:
  filename = 'drag and drop a file';
  data = readIODMS1B(filename);
 
  RETURN VALUES:
  data - a numerical matrix of the embedded IODMSIB data with the columns:
   1) Date (YYYYMMDD)
   2) GPS Time (seconds)
   3) Altitude (meters)
   4) Upper Left corner Latitude (decimal degrees)
   5) Upper Left corner Longitude (decimal degrees)
   6) Lower Left corner Latitude (decimal degrees)
   7) Lower Left corner Longitude (decimal degrees)
   8) Lower Right corner Latitude (decimal degrees)
   9) Lower Right corner Longitude (decimal degrees)
  10) Upper Right corner Latitude (decimal degrees)
  11) Upper Right corner Longitude (decimal degrees)
  12) Center Latitude (decimal degrees)
  13) Center Longitude (decimal degrees)
 
  ARGUMENTS:
  filename - The IODMS1B path and file name.
 
  PATHS:
  code:
  http://nsidc.org/data/icebridge/tools.html

  code was tested on IceBridge FTP data:
  ftp://n4ftl01u.ecs.nasa.gov/SAN2/ICEBRIDGE_FTP/IODMS1B_DMSgeotiff_v01/
 
 --------------------------------------------------------------------------
  National Snow and Ice Data Center, Susan Rogers, March 16, 2011
  Copyright (c) 2011 Regents of the University of Colorado.


DOWNLOADING THE SOFTWARE

There are three files in the downloaded tar file:

example_output_readIODMS1B.txt
  An example input and output, copied to a text file.

readIODMS1B.m
  The executable m-file.

matlab-IODMS1B-reader-readme.txt
  The documentation.

To unpack the tar file on a Linux system:
(the "$" is the Linux command-line prompt):
  $ tar xvf matlab_IODMS1B_reader_0.1.tar
The result of these commands should be an executable m-file named readIODMS1B.m.

Add the reader path: either edit the Matlab start-up script, or use the function addpath at the Matlab command line.  Type help readIODMS1B at the matlab command prompt.
