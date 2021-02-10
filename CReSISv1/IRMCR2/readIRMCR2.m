function [data] = readIRMCR2(filename)
%
% Reads the MCoRDS TXT file.
% Multi-Channel Coherent Radar Depth Sounder, MCoRDS IRMCR2
% OIB MCoRDS L2 Picked Ice and Bed Surfaces and RELATIVE Ice Thickness
% CReSIS Center Remote Sensing of Ice Sheets, Univ Kansas, John Paden
%--------------------------------------------------------------------------
% USAGE:
% filename = 'drag and drop a file';
% [data] = readIRMCR2(filename);
%
% RETURN VALUES:
% data - a numerical matrix of raw MCoRDS data with the columns: 
% 1) LAT (decimal degrees)
% 2) LON (decimal degrees) 
% 3) UTC Time (seconds) 
% 4) Ice Thickness (meters)
%
% ARGUMENTS:
% IRMCR2 - The IRMCR2 path and file name.
%
% PATHS:
% code:
% http://nsidc.org/data/icebridge/tools.html
%
% code was tested on IceBridge FTP data:
% ftp://n4ftl01u.ecs.nasa.gov/SAN2/ICEBRIDGE_FTP/...
% IRMCR2_MCORDSlayerPicks_v01/
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
    disp('The IRMCR2 structure is needed for read_IRMCR2.')
    return
end

%__________________________________________________________________________
% Read in the MCoRDS data --

% Matlab's urlread will not read the file; urlwrite is a work-around.
tmpfilename = 'tmp.txt';
M_urlwrite = urlwrite(filename, tmpfilename);

mfid = fopen(tmpfilename);
junk_header = fgetl(mfid);
data_tmp = [fscanf(mfid, '%f', [4,inf])]';
data = [data; data_tmp];

fclose(mfid);

%__________________________________________________________________________
end % readIRMCR2