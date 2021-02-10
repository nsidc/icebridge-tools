OVERVIEW

This readme accompanies the IceBridge MCoRDS L2 Ice Thickness MATLAB data reader: readIRMCR2.m

The read-me describes how the function works, disclaimers, links to the software, the test data, and an example output in text format.  The readme includes instructions on downloading the software.

The function readIRMCR2.m reads MCoRDS text data files from the Operation IceBridge MCoRDS instrument, which are available as the IRMCR2 product at the National Snow and Ice Data Center (NSIDC), at

http://nsidc.org/data/irmcr2.html

This software is available at

http://nsidc.org/data/icebridge/tools.html

DISCLAIMER

This software is provided as-is as a service to the user community in the
hope that it will be useful, but without any warranty of fitness for any
particular purpose or correctness.  Bug reports, comments, and suggestions for improvement are welcome; please send to nsidc@nsidc.org.


USING THE SOFTWARE

function [data] = readIRMCR2(filename)

 Reads the MCoRDS TXT file.
  Multi-Channel Coherent Radar Depth Sounder, MCoRDS IRMCR2
  IceBridge MCoRDS L2 Ice Thickness
 --------------------------------------------------------------------------
  USAGE:
  filename = 'drag and drop a file';
  [data] = readIRMCR2(filename);
 
  RETURN VALUES:
  data - a numerical matrix of raw MCoRDS data with the columns: 
  1) LAT (decimal degrees)
  2) LON (decimal degrees) 
  3) UTC Time (seconds) 
  4) Ice Thickness (meters)
 
  ARGUMENTS:
  IRMCR2 - The IRMCR2 path and file name.
 
  PATHS:
  code:
  http://nsidc.org/data/icebridge/tools.html
 
  code was tested on IceBridge FTP data:
  ftp://n4ftl01u.ecs.nasa.gov/SAN2/ICEBRIDGE_FTP/...
  IRMCR2_MCORDSlayerPicks_v01/
 
 --------------------------------------------------------------------------
  National Snow and Ice Data Center, Susan Rogers, March 16, 2011
  Copyright (c) 2011 Regents of the University of Colorado.


DOWNLOADING THE SOFTWARE

There are three files in the downloaded tar file:

example_output_readIRMCR2.txt
  An example input and output, copied to a text file.

readIRMCR2.m
  The executable m-file.

matlab-IRMCR2-reader-readme.txt
  The documentation.


To make the reader executable on a Linux system:

Unpack the tar file (the "$" is the Linux command-line prompt):
  $ tar xvf matlab_IRMCR2_reader_0.1.tar


The result of these commands should be an executable m-file named readIRMCR2.m.

Add the reader path: either edit the Matlab start-up script, or use the function addpath at the Matlab command line.  Type help readIRMCR2 at the matlab command prompt.
