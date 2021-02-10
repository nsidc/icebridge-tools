function [test_ok, cmp_result] = test_readILATM1B
%
% Calls readILATM1B for file
% ILATM1B_20100405_141754.atm4cT3.qi, and checks that the returned
% header and first 9 rows of data match expected values.
%--------------------------------------------------------------------------
% USAGE:
% [test_ok, cmp_result] = test_readILATM1B
%
% RETURN VALUES:
% test_ok - 1 if the data returned by readILATM1B match expected values,
%           0 otherwise.
% cmp_result - returned string from unix cmp command of expected and actual
%           text files.
%
% ARGUMENTS:
% None.
%
% PATHS:
% code:
% http://nsidc.org/data/icebridge/tools.html
%
% Program assumes that readILATM1B is in the current Matlab path.
% Program assumes that qi2txt is in the current directory.
% Program assumes that the unix cmp command is in the current path.
% Program assumes that expected_output.txt is in the current directory.
% Program assumes that the following URL is accessible:
% ftp://n5eil01u.ecs.nsidc.org/SAN2/ICEBRIDGE/ILATM1B.001/2010.04.05/ILATM1B_20100405_141754.atm4cT3.qi
%--------------------------------------------------------------------------
% National Snow and Ice Data Center, Terry Haran, May 7, 2013
% Copyright (c) 2011 Regents of the University of Colorado.
% This software was developed by the IceBridge Group under NASA-DAAC 
% Contract.
% This software is provided as-is as a service to the user community in the
% hope that it will be useful, but without any warranty of fitness for any
% particular purpose or correctness. Bug reports, comments, and suggestions
% for improvement are welcome; please send to nsidc@nsidc.org.

filename_url = 'ftp://n5eil01u.ecs.nsidc.org/SAN2/ICEBRIDGE/ILATM1B.001/2010.04.05/ILATM1B_20100405_141754.atm4cT3.qi';
qi2txt_dir = '.';
[data, header] = readILATM1B(filename_url, qi2txt_dir);
actual_output = tempname;
fid = fopen(actual_output, 'w');
fprintf(fid, '%s\n', header);
fprintf(fid, '%10.6f %10.7f %11.7f %8.3f %7.0f %5.0f %5.0f %10.3f %11.3f %8.1f %10.1f %11.6f\n', ...
  transpose(data(1:9,:)));
fclose(fid);

[status, cmp_result] = unix(['cmp expected_output.txt ', actual_output]);
if (status == 0)
    test_ok = 1;
    delete(actual_output);
else
    test_ok = 0;
end

%__________________________________________________________________________
end % test_readILATM1B
