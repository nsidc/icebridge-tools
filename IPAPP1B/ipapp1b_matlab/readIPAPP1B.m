function [data] = readIPAPP1B(filename, UTCtime_range)
%
% Reads the IPAPP1B Applanix aircraft data.
% IPAPP1B is a data collection derived mostly from the DMS data 
% streams; all of the parameters are "at the aircraft".
% University of Colorado, NSIDC 
%--------------------------------------------------------------------------
% USAGE:
% filename = 'drag and drop a file';
% [data] = read_IPAPP1B(filename, UTCtime_range);
%
% RETURN VALUES: 
% data -a numerical matrix of the IPAPP1B data with the columns:
%  1) time (UTC seconds)
%  2) latitude (radians)
%  3) longitude (radians)
%  4) Altitude (meters)
%  5) x w.a. velocity (meters/second)
%  6) y w.a. velocity (meters/second)
%  7) z w.a. velocity (meters/second)
%  8) roll (radians)
%  9) pitch (radians)
% 10) platform heading (radians)
% 11) wander angle (radians)
% 12) x body specific force (meters/second)
% 13) y body specific force (meters/second)
% 14) z body specific force (meters/second)
% 15) x body angular rate (radians/second)
% 16) y body angular rate (radians/second)
% 17) z body angular rate (radians/second)       
%
% ARGUMENTS:
% filename - The IPAPP1B path and filename, in single quotes.
% UTCtime_range - [time1 time2] in brackets, or a single time.
%
% PATHS:
% code:
% http://nsidc.org/data/icebridge/tools.html
%
% code was tested on IceBridge FTP data:
% ftp://n4ftl01u.ecs.nasa.gov/SAN2/ICEBRIDGE_FTP/...
% IPAPP1B_GPSInsCorrected_v01/
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
    disp('The filename is needed for readIPAPP1B.')
    return
end

if isempty(who('UTCtime_range'))
    disp('The UTCtime_range is needed for readIPAPP1B.')
    return
end

%__________________________________________________________________________
% Read the IPAPP1B Applanix data --

time1 = min(UTCtime_range);
time2 = max(UTCtime_range);

tmpfilename = 'tmp.bin';
% Matlab's urlread will not read the file; urlwrite is a work-around.
s = urlwrite(filename,tmpfilename);


fid = fopen(tmpfilename,'r');
tmp = fread(fid,17,'double');

while tmp ~= -1 & [time1 > tmp(1)]
    tmp = fread(fid,17,'double');
end

while tmp ~= -1 & [time2 > tmp(1)]
    data = [data; tmp'];
    tmp = fread(fid,17,'double');
end

fclose(fid);

%__________________________________________________________________________
end % readIPAPP1B