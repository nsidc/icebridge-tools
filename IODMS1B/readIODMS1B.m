function [data] = readIODMS1B(filename)
%
% This function reads time and postion from the IODMS1B embedded data.  
% Digital Mapping System, DMS geotiff IODMS1B
% Airborne Sensor Facility, NASA Ames Research Center, RoseAnne Dominguez
% Please note that there are more embedded parameters than are 
% returned by this function.
%--------------------------------------------------------------------------
% USAGE:
% filename = 'drag and drop a file';
% [data] = readIODMS1B(filename);
%
% RETURN VALUES:
% data - a numerical matrix of the embedded IODMSIB data with the columns:
%  1) Date (YYYYMMDD)
%  2) GPS Time (seconds)
%  3) Altitude (meters)
%  4) Upper Left corner Latitude (decimal degrees)
%  5) Upper Left corner Longitude (decimal degrees)
%  6) Lower Left corner Latitude (decimal degrees)
%  7) Lower Left corner Longitude (decimal degrees)
%  8) Lower Right corner Latitude (decimal degrees)
%  9) Lower Right corner Longitude (decimal degrees)
% 10) Upper Right corner Latitude (decimal degrees)
% 11) Upper Right corner Longitude (decimal degrees)
% 12) Center Latitude (decimal degrees)
% 13) Center Longitude (decimal degrees)
%
% ARGUMENTS:
% filename - The IODMS1B path and file name.
%
% PATHS:
% code:
% http://nsidc.org/data/icebridge/tools.html
%
% code was tested on IceBridge FTP data:
% ftp://n4ftl01u.ecs.nasa.gov/SAN2/ICEBRIDGE_FTP/IODMS1B_DMSgeotiff_v01/
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
    disp('The IODMS1B filename is not defined.')
    return
end

%__________________________________________________________________________
% Read the IODMS1B embedded data --
tmpfilename = 'tmp.txt';
%__________________________________________________________________________
% ftp to OIB site in order to run gdalinfo.
% IODMS1B QA FTP login (spawning gdalinfo)
IODMS1B.ftp_login = ...
    'ftp(''n4ftl01u.ecs.nasa.gov'',''anonymous'',''name@nsidc.org'')';
OIBftp = eval(IODMS1B.ftp_login);
unix(['gdalinfo ', filename, ' > tmp.txt']);
fid = fopen('tmp.txt');

% get the first temporary line in file
tline = fgetl(fid);
      
while tline ~= -1
    %______________________________________________________________
    % CASE: get the string date and convert to numerical YYYYMMDD
    if strfind(tline, 'GPSDate')
        date_raw = tline;
        d = strfind(date_raw, '=') + 1;
        YYYYMMDD = date_raw([d:d+3,d+5:d+6,d+8:d+9]);
        data(1) = str2num(YYYYMMDD);
    %______________________________________________________________
    % CASE: get the string GPS TIME and convert to numerical UTC
    elseif strfind(tline, 'GPSTime')
        time_raw = tline;
        t = strfind(time_raw, '=') + 1;
        GPStime = [str2num(time_raw(t:t+1))*60 ...
            + str2num(time_raw(t+3:t+4))]*60 ...
            + str2num(time_raw(t+6:end));
        data(2) = GPStime;
                
    %______________________________________________________________
    % CASE: get the string Altitude (meters)
    elseif strfind(tline, 'Altitude')
        st = strfind(tline,'=')+1;
        ed = strfind(tline,'m')-1;
        data(3) = str2num(tline(st:ed));    
    %______________________________________________________________
    % CASE: get the string Center and convert to lat/lon in ddeg.
    elseif strfind(tline, 'Upper Left')
        [lat, lon] = convert_txt2LL(tline);       
        data(4) = lat; 
        data(5) = lon;
     
    %______________________________________________________________
    % CASE: get the string Center and convert to lat/lon in ddeg.
    elseif strfind(tline, 'Lower Left')
        [lat, lon] = convert_txt2LL(tline);       
        data(6) = lat; 
        data(7) = lon;             
            
    %______________________________________________________________
    % CASE: get the string Center and convert to lat/lon in ddeg.
    elseif strfind(tline, 'Lower Right')
        [lat, lon] = convert_txt2LL(tline);       
        data(8) = lat; 
        data(9) = lon; 
            
    %______________________________________________________________
    % CASE: get the string Center and convert to lat/lon in ddeg.
    elseif strfind(tline, 'Upper Right')
        [lat, lon] = convert_txt2LL(tline);       
        data(10) = lat; 
        data(11) = lon;            
            
    %______________________________________________________________
    % CASE: get the string Center and convert to lat/lon in ddeg.
    elseif strfind(tline, 'Center')
        [lat, lon] = convert_txt2LL(tline);       
        data(12) = lat; 
        data(13) = lon; 
        break % last parameter we want from the file.

    end
        
    tline = fgetl(fid);
        
end % while tline ~= -1
    
fclose(fid);
    
close(OIBftp)   
%__________________________________________________________________________
%end % readIODMS1B
       
%__________________________________________________________________________    
% Sub-Function Convert DMS embedded DegMinSec LAT LON text strings into 
% numerical decimal degrees.
function [lat, lon] = convert_txt2LL(DMStxt)
        
% convert the compass direction format to +/- format.
clear nLON pLON nLAT pLAT
nLON = strfind(DMStxt, 'W');
pLON = strfind(DMStxt, 'E');
nLAT = strfind(DMStxt, 'S');
pLAT = strfind(DMStxt, 'N');
if nLON
    signlon = -1;
elseif pLON
    signlon = 1;
end
if nLAT
    signlat = -1;
elseif pLAT
    signlat = 1;
end
loni = [nLON pLON];
lati = [nLAT pLAT];
if loni > lati
    disp(cat(2, ['Error in find_IODMS1B_ILATM2: '], ...
                ['lat/lon in reverse order.']))
    return
end
% parse the LAT and LON in a character string format and
% convert from degrees minutes seconds into decimal degrees 
cc = strfind(DMStxt, '(');
cm = strfind(DMStxt, ',');
lon_txt = DMStxt(cc(2)+1:loni);
lat_txt = DMStxt(cm(2):lati);
londd = strfind(lon_txt,'d');
lonsq = strfind(lon_txt,'''');
londq = strfind(lon_txt,'"');
londeg = str2num( lon_txt(1:londd-1) );
lonmin = str2num( lon_txt(londd+1:lonsq-1) );
lonsec = str2num( lon_txt(lonsq+1:londq-1) );      
     
latcc = strfind(lat_txt, ',');
latdd = strfind(lat_txt,'d');
latsq = strfind(lat_txt,'''');
latdq = strfind(lat_txt,'"');
latdeg = str2num( lat_txt(latcc+1:latdd-1) );
latmin = str2num( lat_txt(latdd+1:latsq-1) );
latsec = str2num( lat_txt(latsq+1:latdq-1) );    
      
lat = signlat*(latdeg + (latmin + latsec/60)/60);
lon = signlon*(londeg + (lonmin + lonsec/60)/60); 

%__________________________________________________________________________
% end %subfunction, convert_txt2LL