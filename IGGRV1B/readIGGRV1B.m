function [data] = readIGGRV1B(filename, YYYYMMDD)
%
% Read the IGGRV1B Gravity data file, <Location>.xyz.
% IceBridge Sander Air GRAV L1B Geolocated Free Air Gravity Anomalies
% Lamont-Doherty Earth Observatory, Stefan Elieff
%--------------------------------------------------------------------------
% USAGE:
% filename = 'drag and drop a file';
% [data] = readIGGRV1B(filename, YYYYMMDD);
%
% RETURN VALUES:
% data - a numerical matrix of raw IGGRV1B data with the columns:
%  1) Latitude (decimal degrees)
%  2) Longitude (decimal degrees) 
%  3) Date (YYYYMMDD)
%  4) Day (day of year)
%  5) Line (flight line id)
%  6) UTC Time (seconds) 
%  7) Fiducial Time (seconds)
%  8) PSx (meters)
%  9) PSy (meters)
% 10) UPSx Universal Polar Stereographic X WGS-84 (meters)
% 11) UPSy Universal Polar Stereographic Y WGS-84 (meters)
% 12) WGS Height above the ellipsoid (meters)
% 13) Fx Gravimeter x acceleration (mGal)
% 14) Fy Gravimeter y acceleration (mGal)
% 15) Fz Gravimeter z acceleration (mGal)
% 16) EOT Grav (mGal)
% 17) Free Air Correction (mGal)
% 18) Intersection leveling Correction (mGal)
% 19) 70s FA Grav (mGal)
% 20) 100s FA Grav (mGal) 
% 21) 140s FA Grav (mGal)
% 22) 6000m FA Grav (mGal) 
%
% ARGUMENTS:
% filename - The IGGRV1B path and data file name, in single quotes.
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
% contract.
% This software is provided as-is as a service to the user community in the
% hope that it will be useful, but without any warranty of fitness for any
% particular purpose or correctness. Bug reports, comments, and suggestions
% for improvement are welcome; please send to nsidc@nsidc.org.

data = [];

if isempty(who('filename'))
    disp('The filename is needed for readIGGRV1B.')
    return
end

%__________________________________________________________________________
% Read the Gravity data file --

% Concatentating the flights for YYYYMMDD within this gravity file.

% Matlab's urlread will not read the file; urlwrite is a work-around.
tmpfilename = 'tmp.txt';
G1_urlwrite = urlwrite(filename, tmpfilename);
g1fid = fopen(tmpfilename,'r');

junk = fgetl(g1fid);
junk = fgetl(g1fid);
tline = fgetl(g1fid);
while tline ~= -1
    tline = fgetl(g1fid);
    junk = fgetl(g1fid);
    junk = fgetl(g1fid);

    G1 = fscanf(g1fid, '%f', [22,inf]);

    G1_found = strfind(tline,...
           [YYYYMMDD(1:4), '/', YYYYMMDD(5:6), '/',...
            YYYYMMDD(7:8)]);
    if G1_found
        data = [data G1]; 
    end
end
% Transpose the data to have N rows by 22 columns.
data = data';

fclose(g1fid);

%__________________________________________________________________________
end % readIGGRV1B