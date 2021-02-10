% 07/18/2013
% Author: Ben Panzer

% Function for reading in uploaded Snow Radar data in binary format.
 
% Input to the function is the full filename (directory included) of the
% binary data of interest and the region.  Region is specified as Greenland
% or Antarctica.

% Output of the function is the data and header information
% for each record.  The format of the header is as follows:
% header.time - GPS time for the record
% header.lat  - Latitude for the record
% header.long - Longitude for the record
% header.alt  - Altitude in meters for the record
% header.rbin_shift - Number of range bins record was shifted for altitude correction
% header.rbin_size - Vertical pixel size in seconds

% The number of data samples for each record is dependent upon the radar
% settings which can be viewed in the spreadsheet uploaded.

% Data for Greenland are stored as a complex voltage.  Data for Antarctica
% are stored as a linear magnitude.  Generating an image from the data will
% vary as such:
% Greenland - imagesc(20.*log10(abs(data)))
% Antarctica - imagesc(10.*log10(data))

% Example function call
% [data,header] = read_snow_radar('C:\Users\bpanzer\Desktop\data04.0025.bin','Antarctica');
% or
% [data,header] = read_snow_radar('C:\Users\bpanzer\Desktop\data00.0409.bin','Greenland');

function [data,header] = read_snow_radar(filename,region)

if ~exist('region','var')
    error('Region must be specified (Antarctica or Greenland)');
    return
elseif ~exist('filename','var')
    error('Filename must be specified');
    return
end

fid = fopen(filename,'r','ieee-le');
rec_len = fread(fid,1,'int32');
frewind(fid);
tmp_header = fread(fid,[6 inf],'6*int32',rec_len-6*4);
fseek(fid,6*4,'bof');
tmp_time = fread(fid,[1 inf],'float32',rec_len-4);
fseek(fid,7*4,'bof');
tmp_data = fread(fid,[(rec_len/4)-7 Inf],sprintf('%d*float32',(rec_len/4)-7),7*4);
fclose(fid);

if strcmp(region,'Greenland') || strcmp(region,'greenland');
    real_idx = 1:2:size(tmp_data,1);
    imag_idx = real_idx + 1;
    for rec_idx = 1:size(tmp_data,2);
        data(:,rec_idx) = tmp_data(real_idx,rec_idx)+1i*tmp_data(imag_idx,rec_idx);
    end
    clear tmp_data
elseif strcmp(region,'Antarctica') || strcmp(region,'antarctica')
    data = tmp_data;
    clear tmp_data
end

header.time         = tmp_header(2,:)/1e3; 
header.lat          = tmp_header(3,:)/1e6;
header.lon          = tmp_header(4,:)/1e6;
header.alt          = tmp_header(5,:)/1e3;
header.rbin_shift   = tmp_header(6,:);
header.rbin_size    = tmp_time/1e12;

return;

