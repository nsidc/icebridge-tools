% import_sea_ice_thickness_vers04.m
%
%       Version 1.0: February 2012
%
%       written by Michael Studinger
%       NASA Goddard Space Flight Center and UMBC/JCET
%       with code snippets from Nathan Kurtz
%
%       Requirements: mapping toolbox 
%                     optional: internet connection to get blue marble file (only once)
%

clear all;

format long g;

%% read sea ice thickness file

[FileName,PathName] = uigetfile('*.txt','Select IceBridge sea ice thickness file',...
    'Z:\for_NSIDC\2009_Sea_Ice_Thickness_Product');

if isequal(FileName,0)
   disp('User selected: Cancel'); return;
else
   fname = fullfile(PathName, FileName);
end


%% import data

% define format parameters
% example data set:
%     lat,         lon,         thickness,thickness_unc,mean_fb,ATM_fb,fb_unc,snow_depth,snow_depth_unc,n_atm,pcnt_ow,pcnt_thin_ice,pcnt_grey_ice,corr_elev,elev,date,elapsed,atmos_corr,geoid_corr,ellip_corr,tidal_corr,ocean_tide_corr_part,load_tide_corr_part,earth_tide_corr_part,ssh,n_ssh,ssh_sd,ssh_diff,ssh_elapsed,ssh_tp_dist,surface_roughness,ATM_file_name,Tx,Rx,KT19_surf,KT19_int,low_en_corr,sa_int_elev,si_int_elev,my_ice_flag,empty1,empty2,empty3,empty4,empty5,empty6,empty7,empty8,empty9,empty10
%     81.138336,   266.008241,-99999.0000,-99999.0000,-99999.0000,-99999.0000,-99999.0000,     0.2250,     0.0570,    0,-99999.000000,-99999.000000,-99999.000000,-99999.0000,-99999.0000,20090421,-99999.000000000,-99999.0000,-99999.0000,-99999.0000,-99999.0000,-99999.0000,-99999.0000,-99999.0000,-99999.0000, -99999,-99999.0000,-99999.0000,-99999.000000000, -99999.0000,-99999.000000, 20090421_151742.ATM4BT2.qi,-99999.0,-99999.0,-99999.00,-99999.00,-99999.0000,-99999.0000,-99999.0000, 1,-99999.00000,-99999.00000,-99999.00000,-99999.00000,-99999.00000,-99999.00000,-99999.00000,-99999.00000,-99999.00000,-99999.00000
%     81.138534,   266.006348,-99999.0000,-99999.0000,-99999.0000,-99999.0000,-99999.0000,     0.1540,     0.0570,    0,-99999.000000,-99999.000000,-99999.000000,-99999.0000,-99999.0000,20090421,-99999.000000000,-99999.0000,-99999.0000,-99999.0000,-99999.0000,-99999.0000,-99999.0000,-99999.0000,-99999.0000, -99999,-99999.0000,-99999.0000,-99999.000000000, -99999.0000,-99999.000000, 20090421_151742.ATM4BT2.qi,-99999.0,-99999.0,-99999.00,-99999.00,-99999.0000,-99999.0000,-99999.0000, 1,-99999.00000,-99999.00000,-99999.00000,-99999.00000,-99999.00000,-99999.00000,-99999.00000,-99999.00000,-99999.00000,-99999.00000

FormatString='%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%f%f%f%f%f%f%f%f%q%q%q%q%q%q%q%q%q%q';

% read data from file

fid = fopen(fname,'r');
    data = textscan(fid,FormatString,'headerlines',1,'delimiter',',');
status = fclose(fid);

% read 50 column headers

[column_headers] = textread(fname,'%s',50,'delimiter',',','headerlines',0);

%% locate -99999 and replace with NaNs  

for i = 1:length(column_headers) 
    if (i ~= 32 && i < 41)% need to avoid coloumn 32, which are file names
        indx = find(data{i} == -99999);
        data{i}(indx) = NaN;
    end
end

%% create new variables in the base workspace from column headers

% check if column headers are valid variable names

for i = 1:length(column_headers)
    var_check(i) = isvarname(column_headers(i));
end

if any(var_check > 0) 
    disp('Column headers are not valid MATLAB variable names.'); return;
else % file contains valid variable names
    for i = 1:length(column_headers) % assign new variables to MATLAB workspace 
        assignin('base', char(column_headers(i)),data{i});
    end
end

latitude  = data{1}; % need to change varibale name because 
longitude = data{2}; % lat and lon are variables names used when reading file landareas.shp


%% set up map projection depending if data is in the northern or southern hemisphere

% -------------------------------------------------------------------------
% Arctic
% 
% The standard projection parameters for Northern hemisphere Operation IceBridge data are:
% 
% Polar Stereographic
% Standard Parallel 70°N
% Longitude of the origin (central meridian): 45°W
% WGS 84 ellipsoid
% 
% This projection is defined as EPSG:3413.
%
% Antarctic
% 
% The standard projection parameters for Southern hemisphere Operation IceBridge data are:
% 
% Polar Stereographic
% Standard Parallel 71° S
% Longitude of the origin (central meridian): 0°
% WGS 84 ellipsoid
% 
% This projection is defined as EPSG:3031. 
% -------------------------------------------------------------------------

if mean(latitude(1:100:end)) > 0 % northern hemisphere
    
    mstruct_pole = defaultm('stereo');
    mstruct_pole.origin = [90 -45 0];
    mstruct_pole.geoid = almanac('earth','wgs84','kilometers');
    mstruct_pole.falsenorthing = 0;
    mstruct_pole.falseeasting = 0;
    mstruct_pole.scalefactor = 0.969858730377;
    mstruct_pole = defaultm(stereo(mstruct_pole)); % fix errors if any
    
elseif mean(latitude(1:100:end)) < 0 % southern hemisphere
    
    mstruct_pole = defaultm('stereo');
    mstruct_pole.origin = [-90 0 0];
    mstruct_pole.geoid = almanac('earth','wgs84','kilometers');
    mstruct_pole.falsenorthing = 0;
    mstruct_pole.falseeasting = 0;
    mstruct_pole.scalefactor = 0.9727715381; 
    mstruct_pole = defaultm(stereo(mstruct_pole)); % fix errors if any

end


%% calculate projected coordinates

[x y] = projfwd(mstruct_pole,latitude,longitude);

%% calculate distance along profile

% use this since it avoids wrong distances from distortions in map projections

[course,dist] = legs(latitude,longitude);

dist_along(1) = 0;

for i = 2:size(longitude,1)
    dist_along(i) = dist_along(i-1) + nm2km(dist(i-1));
end

%% calculate snow thicknes from snow climatology by Warren et al. (1999) for quality control
% using modified IDL code from Nathan Kurtz

% polynomial fit of data using Table 1 coeffs (page 1821), starting with January

H_0 = [28.01, 30.28, 33.89, 36.8, 36.93, 36.59, 11.02, 4.64, 15.81, 22.66, 25.57, 26.67];
a = [.127, .1056, .5486, .4046, .0214, .7021, .3008, .31, .2119, .3594, .1496, -0.1876];
b = [-1.1833, -0.5908, -0.1996, -0.4005, -1.1795, -1.4819, -1.2591, -0.635, -1.0292, -1.3483, -1.4643, -1.4229];
c = [-0.1164, -0.0263, 0.0280, 0.0256, -0.1076, -0.1195, -0.0811, -0.0655, -0.0868, -0.1063, -0.1409, -0.1413];
d = [-0.0051, -0.0049, 0.0216, 0.0024, -0.0244, -0.0009, -0.0043, 0.0059, -0.0177, 0.0051, -0.0079, -0.0316];
e = [0.0243, 0.0044, -0.0176, -0.0641, -0.0142, -0.0603, -0.0959, -0.0005, -0.0723, -0.0577, -0.0258, -0.0029];

% convert latitude and longitude into degrees of arc: 
% x axis is positive along 0° longitude 
% y axis is positive along 90°E longitude

x_snow = (90.0 - latitude).* cos(longitude*pi/180); % to convert lat lon values into x and y coordinates
y_snow = (90.0 - latitude).* sin(longitude*pi/180); % used in the quadratic fit

N = datenum(num2str(date(1)),'yyyymmdd');
month = str2num(datestr(N,'mm'));

for (i = 1:size(x_snow,1)) 
    hs(i) = H_0(month) + a(month)*x_snow(i) + b(month)*y_snow(i) + c(month)*x_snow(i)*y_snow(i) + d(month)*x_snow(i)^2 + e(month)*y_snow(i)^2;
end


%% plot data for qc

edge = 50; scrsz = get(0,'ScreenSize');

fig1 = figure('Position',[edge edge (scrsz(3)-2*edge) (scrsz(4)-3*edge)]);

subplot(3,1,1);
    plot(dist_along,thickness,'+'); grid on; hold on;
    if (exist('thickness_ICESat') == 1) % plot only if data exist
        plot(dist_along,thickness_ICESat/100,'r-','Linewidth',2);
    end
    ylabel('Sea Ice Thickness [m]');
    N = datenum(num2str(date(1)),'yyyymmdd');
    title(datestr(N,'mmmm dd, yyyy'),'FontSize',14);

subplot(3,1,2);
    plot(dist_along,ATM_fb,'+'); grid on; hold on;
    ylabel('ATM Freeboard [m]');

subplot(3,1,3);
    plot(dist_along,snow_depth,'+'); grid on; hold on;
    plot(dist_along,hs/100,'r-','Linewidth',2);
    ylabel('Snow Depth [m]');
    xlabel('Distance along Profile [km]');
    legend('IceBridge','Warren et al. (1999)');

%% projected map view

fig2 = figure('Position',[edge edge (scrsz(3)-2*edge) (scrsz(4)-3*edge)]);
    plot(x,y,'o'); hold on; axis equal; grid on;
    xlabel('Easting [km]');
    ylabel('Northing [km]');
    title(datestr(N,'mmmm dd, yyyy'),'FontSize',14);

%% individual panel for tie points

fig4 = figure('Position',[edge edge (scrsz(3)-2*edge) (scrsz(4)-3*edge)]);
    plot(dist_along,ssh_tp_dist/1000,'+'); grid on; hold on;
    ylabel('Distance to closest sea surface height tie-point [km]');
    xlabel('Distance along Profile [km]');
    title(datestr(N,'mmmm dd, yyyy'),'FontSize',14);    
    
%% get blue marble background image

if (exist('blue_marble.mat') == 2) % load blue marble image from previously saved MATLAB file 

    load('blue_marble.mat');

else % get blue marble image from SVS WMS server at Goddard
    
    gsfc = wmsfind('svs.gsfc.nasa.gov', 'SearchField', 'serverurl');
    gsfc = wmsupdate(gsfc);
    blue_marble = gsfc.refine('blue marble', 'SearchField','abstract');
    blueMarbleQuery = '2048x1024';
    layer = blue_marble.refine(blueMarbleQuery); 
    [blue_marble_image, blue_marble_bbox] = wmsread(layer);
    
    save('blue_marble.mat','blue_marble_image', 'blue_marble_bbox');
    
end


%% make map plot for orientation - distinguish between northern and southern hemisphere data

fig3 = figure('Position',[edge edge (scrsz(3)-2*edge) (scrsz(4)-3*edge)]);

if mean(latitude(1:100:end)) > 0 % northern hemisphere
    
    h = worldmap('North Pole'); hold on;
    setm(h,'MapLatlimit',[65 90]); % use test = getm(h); for info
    setm(h,'Origin', [90 -45 0]);
    setm(h,'PLabelLocation',[70 75 80]);
    setm(h,'MLabelLocation',30); % spacing between longitude labels
    setm(h,'MLabelParallel',67); % latitude for longitude labels
    setm(h,'PLabelMeridian',-45); % longitude location for latitude labels
    setm(h,'PLineLocation',5); % spacing between latitude grid lines
    setm(h,'MLabelRound',0); % number of digits for labels
    setm(h,'PLabelRound',0);
    setm(h,'FontWeight','bold');
    
elseif mean(latitude(1:100:end)) < 0 % southern hemisphere - not yet fully implemented
    
    h = worldmap('Antarctica'); hold on;
    setm(h,'MapLatlimit',[-90 -65]);
    setm(h,'Origin', [-90 0 0]);
    
end

% continue plotting

setm(h,'gcolor', [0.1 0.1 0.2],'ffacecolor','blue');

if (exist('blue_marble_image') == 1) % check if blue marble exists 
    geoshow(blue_marble_image, blue_marble_bbox);
else
    geoshow('landareas.shp', 'FaceColor',[0.75 0.75 0.75]);
end

plotm(latitude,longitude,'.y');
scatterm(latitude(1:100:end),longitude(1:100:end),12,thickness(1:100:end),'filled');
colorbar;

title(datestr(N,'mmmm dd, yyyy'),'FontSize',14);


