function [data] = readIGGRV1Battitude(filename, YYYYMMDD)
%
% Read the IGGRV1B Gravity aircraft attitude file, "Attitude".xyz.
% IceBridge Sander Air GRAV L1B Geolocated Free Air Gravity Anomalies
% Lamont-Doherty Earth Observatory, Stefan Elieff
%--------------------------------------------------------------------------
% USAGE:
% filename = 'drag and drop a file';
% [data] = readIGGRV1Battitude(filename, YYYYMMDD);
%
% RETURN VALUES:
% data - a numerical matrix of the IGGRV1B attitude data with the columns:
%  1) Date (YYYYMMDD)
%  2) Day (day of year)
%  3) UTC Time (seconds)
%  4) Fiducial Time (seconds)
%  5) Pitch (degrees)
%  6) Roll (degrees)
%  7) Heading (degrees)
%  8) Latitude (decimal degrees)
%  9) Longitude (decimal degrees)
% 10) PSx (meters)
% 11) PSy (meters)
% 12) WGS-84 Height above the ellipsoid (meters)
% 13) UPSx (meters)
% 14) UPSy (meters)
%
% ARGUMENTS:
% filename - The IGGRV1B path and attitude file name, in single quotes.
% YYYYMMDD - the year month day, in single quotes.
%
% PATHS:
% code:
% http://nsidc.org/data/icebridge/tools.html
%
% code was tested on IceBridge FTP data:
% ftp://n4ftl01u.ecs.nasa.gov/SAN2/ICEBRIDGE_FTP/ ...
% IGGRV1B_AirGRAVxyAnom_v01/
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
    disp('The filename structure is needed for read_IGGRV1B.')
    return
end

%__________________________________________________________________________
% Read the Gravity aircraft attitude file --

% Matlab's urlread will not read the file; urlwrite is a work-around.
tmpfilename = 'tmp.txt';
G2_urlwrite = urlwrite(filename, tmpfilename);
g2fid = fopen(tmpfilename,'r');

junk = fgetl(g2fid);
junk = fgetl(g2fid);
junk = fgetl(g2fid);
junk = fgetl(g2fid);
junk = fgetl(g2fid);
junk = fgetl(g2fid);
data = fscanf(g2fid, '%f', [14,inf]);

idx = find( data(1,:) == str2num(YYYYMMDD) );
data = data(:,idx);

data = data';

fclose(g2fid);

%__________________________________________________________________________
end % readIGGRV1Battitude