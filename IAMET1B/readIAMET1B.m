function [data] = readIAMET1B(filename)
%
% Reads the NSERC L1B Geolocated Meteorologic and Surface Temperature Data.
% IAMET1B IR Surface Temperature Heitronics KT-19II IR Pyrometer
% National Suborbital Education and Research Center, Eric Buzay 
%--------------------------------------------------------------------------
% USAGE:
% filename = 'drag and drop a file';
% [data] = readIAMET1B(filename);
%
% RETURN VALUES: 
% data - a numerical matrix of the IPAPP1B data with the columns:
% 1UTC(sec), 2LAT(deg), 3LON(deg), 4GPS_ALT(m), 5PRESSURE_ALT(ft), 
% 6GROUND_SPD(m/s), 7TRUE_AIR_SPD(m/s), 8IND_AIR_SPD(kts), 9MACH(mach), 
% 10VERT_SPD(m/s), 11TRUE_HEADING(deg), 12TRACK_ANGLE(deg), 
% 13DRIFT_ANGLE(deg), 14PITCH_ANGLE(deg), 15ROLL_ANGLE(deg), 
% 16STATIC_AIR_TEMP(C), 17DEW_POINT(C), 18TOTAL_AIR_TEMP(C), 
% 19IR_SURF_TEMP(C), 20SAT_COMPUTED(C), 21STATIC_PRESSURE(mb), 
% 22CABIN_PRESSURE(mb), 23CABIN_ALT(ft), 24WIND_SPD(m/s), 25WIND_DIR(deg), 
% 26MIX_RATIO(g/kg), 27PART_PRES_H2O(mb), 28PART_PRES_ICE(mb), 
% 29REL_HUM_H2O(%), 30REL_HUM_ICE(mb), 31SAT_VP_H2O(mb), 32SAT_VP_ICE(mb), 
% 33SUN_ELEV_EARTH(deg), 34SUN_ELEV_PLANE(deg), 35SUN_AZM_EARTH(deg),
% 36SUN_AZM_PLANE(deg), 37SOLAR_ZEN_ANGLE(deg)        
%
% ARGUMENTS:
% filename - The IAMET1B path and file name.
%
% PATHS:
% code:
% http://nsidc.org/data/icebridge/tools.html
% code was tested on IceBridge FTP data:
%
% ftp://n4ftl01u.ecs.nasa.gov/SAN2/ICEBRIDGE_FTP/
% IAMET1B_NSERCmetXyMet_v01/
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
    disp('The filename is needed for read_IAMET1B.')
    return
end

%__________________________________________________________________________
% Read in the Meteorologic and Surface Temperature data --

tmpfilename = 'tmp.txt';

z = urlwrite(filename, tmpfilename);
s = csv2cell(tmpfilename,'fromfile');
loc = str2num(char(s(1,1)));
header = char(s(loc,:));
for k=1:size(s,2)
    data(:,k) = str2num(char(s(loc+1:end,k)));
end
        
%__________________________________________________________________________
end % readIAMET1B