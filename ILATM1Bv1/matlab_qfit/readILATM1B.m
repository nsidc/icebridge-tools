function [data, header] = readILATM1B(filename_url, qi2txt_dir)
%
% Reads the Qfit ILATM1B data into matlab; wrapper on the C version.
% ILATM1B Airborne Topographic Mapper (ATM) Project
% NASA, Goddard Space Flight Center, Wallops Flight Facility
% Principal Investigator: Bill Krabill (William.B.Krabill@nasa.gov)
%--------------------------------------------------------------------------
% The readILATM1B.m Matlab function calls C program qi2txt which reads
% binary data files from the Operation IceBridge ATM
% instrument. readILATM1B.m returns a data array containing the
% floating-point ATM data as well as an ASCII header line identifying
% each of the 12 fields comprising each ATM data record. Operation
% IceBridge ATM data are available as the ILATM1B product at the
% National Snow and Ice Data Center (NSIDC), at
% 
% http://nsidc.org/data/ilatm1b.html
%
% USAGE:
% [data, header] = readILATM1B(filename_url, qi2txt_dir);
%
% RETURN VALUES: 
% data - ILATM1B data.
% NOTE: the C version qfit reader qi2txt called by this function returns data: 
%  1    Relative Time (seconds from start of the file)
%  2    Laser Spot Latitude (decimal degrees)
%  3    Laser Spot Longitude (decimal degrees)
%  4    Elevation (meters)
%  5    Start Pulse signal Strength (relative integer) 
%  6    Reflected Laser Signal Strength (relative integer)
%  7    Scan Azimuth (degrees)
%  8    Pitch (degrees)
%  9    Roll (degrees)
% 10    GPS PDOP (dilution of precision) 
% 11    Laser received pulse width (digitizer samples)
% 12    GPS Time (seconds)
%
% header - ILATM1B ASCII header line produced by qi2txt.
%
% ARGUMENTS:
% filename_url - ILATM1B Qfit input data file URL.
% qi2txt_dir - directory containing qi2txt C program executable.
%
% PATHS:
% code:
% http://nsidc.org/data/icebridge/tools.html
%
% code was tested on IceBridge FTP data file:
% ftp://n5eil01u.ecs.nsidc.org/SAN2/ICEBRIDGE/ILATM1B.001/2010.04.05/ILATM1B_20100405_141754.atm4cT3.qi
%--------------------------------------------------------------------------
% National Snow and Ice Data Center, Susan Rogers, March 16, 2011
% Copyright (c) 2011 Regents of the University of Colorado.
% This software was developed by the IceBridge Group under NASA-DAAC 
% Contract.
% This software is provided as-is as a service to the user community in the
% hope that it will be useful, but without any warranty of fitness for any
% particular purpose or correctness. Bug reports, comments, and suggestions
% for improvement are welcome; please send to nsidc@nsidc.org.

%__________________________________________________________________________
% Check input parameters

if isempty(who('filename_url'))
    disp('The filename_url parameter is needed for readILATM1B.')
    return
end

if isempty(who('qi2txt_dir'))
    disp('The qi2txt_dir parameter is needed for readILATM1B.')
    return
end

%__________________________________________________________________________
% Define variable values

ILATM1B.version = '0.3';
ILATM1B.read = [qi2txt_dir, '/qi2txt']; 
ILATM1B.tmpqi = tempname;
ILATM1B.tmptxt = ILATM1B.tmpqi;
while (ILATM1B.tmptxt == ILATM1B.tmpqi)
  ILATM1B.tmptxt = tempname;
end

%__________________________________________________________________________
% Display the current version

disp(['readILATM1B.m version ', ILATM1B.version]);

%__________________________________________________________________________
% Read in the ATM data --

L_pth = urlwrite(filename_url, ILATM1B.tmpqi);
pause(.1); % pause empties out the buffer queue
unix([ILATM1B.read ' ' L_pth ' > ' ILATM1B.tmptxt]);
pause(.1);
fid = fopen(ILATM1B.tmptxt, 'r');
header = [fgetl(fid)];
data = [fscanf(fid, '%f', [12,inf])]';
fclose(fid);

delete(ILATM1B.tmpqi, ILATM1B.tmptxt);

%__________________________________________________________________________
end % readILATM1B
