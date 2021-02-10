function [mdata,depth_good_idxs] = elevation_compensation(mdata,param)
% function [mdata,depth_good_idxs] = elevation_compensation(mdata,param)
%
% mdata = L1B data structure from load_L1B.m. Requires
%   .Data is Nt x Nx matrix
%   .Time is Nt x 1 vector
%   .Elevation is 1 x Nx vector
%   .Surface is 1 x Nx vector
% param = structure controlling compensation
%  .update_surf = logical, default false, if true the function uses
%    threshold and sidelobe fields to track the surface again
%    This will cause "mdata.Surface" to be updated.
%  .filter_surf = logical, default false, applies an along-track median
%    filter to the surface.
%    This will cause "mdata.Surface" to be updated.
%  .threshold = used with update_surf (specified in power magnitude
%    assuming mdata.Data is in power magnitude units), this threshold
%    will be used for tracking the surface.  Default is estimated from
%    the data.
%  .sidelobe = special case which helps the tracker avoid tracking side
%    lobes at the relative power specified or below. Actual threshold
%    used is:
%     max of param.threshold and max_value_of_current_rangeline*param.sidelobe
%    Default is "10^(-13/10)
%  .er_ice = default is 3.15, dielectric of ice
%  .depth = string to be evaluated in the calculation of depth_good_idxs
%     DEFAULT: '[-inf inf]';
%     EXAMPLE: '[min(Surface_Elev)-600 max(Surface_Elev)+20]';
%     EXAMPLE: '[1200 1800]';

% mdata = updated data structure
%  .Data = updated to be gridded on constant WGS-84 axes
%  .Elevation, .Surface_Elev = updated to account for compensation
%    of .Data on constant grid
% depth_good_idxs = indices specified by param.depth
%
% Examples: See plot_L1B.m
%
% Author: John Paden
%
% See also: load_L1B.m, plot_L1B.m

if ~exist('param','var')
  param = [];
end

if ~isfield(param,'update_surf')
  param.update_surf = false;
end

if ~isfield(param,'filter_surf')
  param.filter_surf = false;
end

if ~isfield(param,'threshold')
  param.threshold = median(max(mdata.Data)) / 10;
end

if ~isfield(param,'sidelobe')
  param.sidelobe = 10^(-13/10);
end

if ~isfield(param,'er_ice')
  param.er_ice = 3.15;
end

if ~isfield(param,'depth')
  param.depth = '[-inf inf]';
end

physical_constants;

if param.update_surf
  %% Update surface:
  for rline = 1:size(mdata.Data,2)
    new_surf = find(mdata.Data(:,rline) ...
      > max(param.threshold,max(mdata.Data(:,rline))*param.sidelobe),1);
    if isempty(new_surf)
      mdata.Surface_Bin(rline) = NaN;
    else
      mdata.Surface_Bin(rline) = new_surf;
    end
  end
  mdata.Surface = interp1(1:length(mdata.Time),mdata.Time,mdata.Surface_Bin);
  nan_mask = isnan(mdata.Surface);
  mdata.Surface = interp1(find(~nan_mask),mdata.Surface(~nan_mask),1:length(mdata.Surface));
end

if param.filter_surf
  %% Filter surface
  if length(mdata.Surface) >= 100
    [Bfilt,Afilt] = butter(2,0.02);
    surf_filt = filtfilt(Bfilt,Afilt,mdata.Surface);
    tmp = polyval(polyfit(1:51,reshape(mdata.Surface(1:51),[1 51]),2),1:51);
    surf_filt(1:50) = tmp(1:50) - tmp(51) + surf_filt(51);
    tmp = polyval(polyfit(1:51,reshape(mdata.Surface(end-50:end),[1 51]),2),1:51);
    surf_filt(end-49:end) = tmp(2:51) - tmp(1) + surf_filt(end-50);
    mdata.Surface = surf_filt;
  else
    surf_filt = medfilt1(mdata.Surface,round(length(mdata.Surface)/20)*2+1);
    mdata.Surface = surf_filt;
  end
else
  surf_filt = mdata.Surface;
end

%% Remove data before zero time
negative_bins = mdata.Time < 0;
mdata.Time = mdata.Time(~negative_bins);
mdata.Data = mdata.Data(~negative_bins,:);

%% Create elevation axis to interpolate to
max_elev = max(mdata.Elevation);
min_elev = min(mdata.Elevation - surf_filt*c/2 - (mdata.Time(end)-surf_filt)*c/2/sqrt(param.er_ice));
dt = mdata.Time(2)-mdata.Time(1);
dr = dt * c/2 / sqrt(param.er_ice);
elev_axis = max_elev:-dr:min_elev;
mdata.Elevation_Fasttime = elev_axis;

% Zero pad data to create space for interpolated data
zero_pad_len = length(elev_axis) - length(mdata.Time);
mdata.Data = cat(1,mdata.Data,zeros(zero_pad_len,size(mdata.Data,2)));

% Determine the corrections to apply to elevation and layers
dRange = max_elev - mdata.Elevation;
dBins = round(dRange / (c/2) / dt);
dtime = dRange/(c/2);

warning off
for rline = 1:size(mdata.Data,2)
  % Determine elevation bins before surface
  surf_elev = mdata.Elevation(rline) - surf_filt(rline) * c/2;
  dt_air = dr/(c/2);
  time0 = -(max_elev - mdata.Elevation(rline))/(c/2);
  last_air_idx = find(elev_axis > surf_elev,1,'last');
  new_time = (time0 + dt_air*(0:last_air_idx-1)).';
  if isempty(last_air_idx)
    % Radar is on the surface of the ice
    last_air_idx = 0;
  end
  if last_air_idx < length(elev_axis)
    % Determine elevation bins after surface
    dt_ice = dr/(c/2/sqrt(param.er_ice));
    first_ice_idx = last_air_idx + 1;
    time0 = surf_filt(rline) + (surf_elev - elev_axis(first_ice_idx))/(c/2/sqrt(param.er_ice));
    new_time = cat(1,new_time, (time0 + dt_ice*(0:length(elev_axis)-length(new_time)-1)).');
  end
  mdata.Data(:,rline) = interp1(mdata.Time, mdata.Data(1:length(mdata.Time),rline), new_time, 'linear',0);
  mdata.Elevation(rline) = mdata.Elevation(rline) + dRange(rline);
  mdata.Surface(rline) = mdata.Surface(rline) + dtime(rline);
  %mdata.Bottom(rline) = mdata.Bottom(rline) + dtime(rline);
end
warning on

%% Limit plotted depths according to input param.depth
DSurface = mdata.Elevation - mdata.Surface*c/2;
Surface_Elev = DSurface;
mdata.Surface_Elev = DSurface;
% Example: param.depth = '[min(Surface_Elev) - 15 max(Surface_Elev)+3]';
% Example: param.depth = '[100 120]';
depth_range = eval(param.depth);
depth_good_idxs = find(elev_axis >= depth_range(1) & elev_axis <= depth_range(end));

return;
