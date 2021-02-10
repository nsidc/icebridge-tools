% script plot_L1B
%
% Example of loading data with load_L1B.m and using elevation_compensation.m
%
% Plots data in three different ways:
%   Figure 1: time-delay on y-axis
%   Figure 2: range on y-axis
%   Figure 3: time-delay on y-axis
%
% Author: John Paden
%
% See also: load_L1B.m, elevation_compensation.m

%  fn = 'IRMCR1B_V01_20130408_01_020.nc';
%  mdata = load_L1B(fn);

fn = 'Data_20111107_02_191.mat';
mdata = load_L1B(fn);

%% Set which bins to plot
param.ylims_bins = [-inf inf];
good_bins = round(max(1,min(mdata.Surface)+param.ylims_bins(1)) : min(max(mdata.Surface)+param.ylims_bins(2),size(mdata.Data,1)));

figure(1); clf;
imagesc([],mdata.Time(good_bins)*1e6,10*log10(mdata.Data(good_bins,:)))
xlabel('Range line');
ylabel('Two way travel time (us)')
colormap(1-gray(256))
hold on
plot(mdata.Surface*1e6);
hold off;

%% Elevation Correction Example
param = [];
param.update_surf = true;
param.filter_surf = false;
param.er_ice = 3.15;
param.depth = '[min(Surface_Elev)-20 max(Surface_Elev)+2]';
[mdata_WGS84,depth_good_idxs] = elevation_compensation(mdata,param);

%% Plot versus range
figure(2); clf;
imagesc([],mdata_WGS84.Elevation(1) - mdata_WGS84.Elevation_Fasttime(depth_good_idxs),10*log10(mdata_WGS84.Data(depth_good_idxs,:)));
xlabel('Range line');
ylabel('Range (m)')
colormap(1-gray(256))
hold on
plot(mdata_WGS84.Elevation(1) - mdata_WGS84.Surface_Elev);
hold off;

%% Plot versus WGS-84 elevation
figure(3); clf;
imagesc([],mdata_WGS84.Elevation_Fasttime(depth_good_idxs),10*log10(mdata_WGS84.Data(depth_good_idxs,:)));
xlabel('Range line');
ylabel('WGS-84 (m)')
set(gca,'YDir','normal')
colormap(1-gray(256))
hold on
plot(mdata_WGS84.Surface_Elev);
hold off;

return;
