OVERVIEW

This readme accompanies the IceBridge QFIT IDL data reader: get_file.pro.

The IDL get_file.pro program reads binary data files from the Operation
IceBridge ATM instrument, which are available as the ILATM1B product at
the National Snow and Ice Data Center (NSIDC), at

http://nsidc.org/data/ilatm1b.html

This software is available at

http://nsidc.org/data/icebridge/tools.html

DISCLAIMER

This software is provided as-is as a service to the user community in the
hope that it will be useful, but without any warranty of fitness for any
particular purpose or correctness.  Bug reports, comments, and suggestions
for improvement are welcome; please send to nsidc@nsidc.org.


USING THE SOFTWARE

There are two files in the downloaded tar file:

qfit_get_file.pro
  The IDL program with the reader

qfit_get_file-readme.txt
  This file


To run the program in IDL on the data file 'ILATM1B/20100421_160657.atm4cT3.qi':

IDL> .run "./qfit_get_file.pro"
% Compiled module: GET_FILE.
IDL> file='ILATM1B/20100421_160657.atm4cT3.qi'
IDL> a = qfit_get_file( idata, 'integer', file=file, /SWAP )

The program displays the header information from the file, and returns
idata array with a 12-column by N-record lonarr with the data records.

NOTE: For little endian files (2011 and 2012), remove the /SWAP option
to ensure that 2011 and 2012 files will process and will display the header.

The first 10 records are:

IDL> print,idata[*,0:9],format='(12I12)'
           0    69290408   224339265       -3635        1477         937       62814         906        -515          37           7   160713000
           0    69290408   224339155       -3712        2107         888       64197         905        -515          37           7   160713000
           0    69290409   224339045       -3662        1352         776       65581         905        -515          37           7   160713000
           0    69290411   224338935       -3607        2001         881       66965         905        -515          37           7   160713000
           1    69290413   224338825       -3553        1701         799       68349         904        -515          37           8   160713001
           1    69290416   224338715       -3707        1864         745       69735         904        -515          37           7   160713001
           1    69290420   224338605       -3706        1991         883       71119         904        -515          37           9   160713001
           1    69290424   224338496       -3909        1720         850       72503         904        -515          37           7   160713001
           1    69290430   224338386       -3783        1848         790       73886         903        -515          37           7   160713001
           2    69290436   224338277       -3928        1501         829       75270         903        -515          37           7   160713002




