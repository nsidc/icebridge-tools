function [data] = readILATM2(filename)
%
% Read the ATM file. 
% Airborne Topographic Mapper, the ATM icessn ILATM2
% Wallops Flight Facility, William Krabill
%--------------------------------------------------------------------------
% USAGE:
% filename = 'drag and drop a file';
% [data] = readILATM2(filename);
%
% RETURN VALUES:
% data - a numerical matrix of raw ATM data with the columns: 
%  1) GPS TIME (seconds)
%  2) LAT (decimal degrees) 
%  3) E.LON (decimal degrees)
%  4) WGS84 Surface Elevation (meters)
%  5) SN slope 
%  6) WE slope 
%  7) RMS surface roughness (centimeters) 
%  8) Number of points plane 
%  9) Number of points edited 
% 10) map view distance between aircraft and center plate (meters)
% 11) track identifier (1 ... n, starboard to port, 0 is nadir)
%
% ARGUMENTS:
% filename - The ILATM2 path and file name, in single quotes.
%
% PATHS:
% code:
% http://nsidc.org/data/icebridge/tools.html
%
% code was tested on IceBridge FTP data:
% ftp://n4ftl01u.ecs.nasa.gov/SAN2/ICEBRIDGE_FTP/...
% ILATM2_ATMicessn_v01/
%
%--------------------------------------------------------------------------
% National Snow and Ice Data Center, Susan Rogers, March 16, 2011
% Copyright (c) 2011 Regents of the University of Colorado.
% This software was developed by the IceBridge Group under NASA-DAAC 
% Contract.
% This software is provided as-is as a service to the user community in the
% hope that it will be useful, but without any warranty of fitness for any
% particular purpose or correctness. Bug reports, comments, and suggestions
% for improvement are welcome; please send to nsidc@nsidc.org.

data = [];

if isempty(who('filename'))
    disp('The ILATM2 filename is needed for readILATM2.')
    return
end

%__________________________________________________________________________
% Read in the ATM data --

% read data and convert format from string to numerical values.
[ATM_urlread, ATM_msg] = urlread(filename);

data = str2num(ATM_urlread);

%__________________________________________________________________________
end % readILATM2