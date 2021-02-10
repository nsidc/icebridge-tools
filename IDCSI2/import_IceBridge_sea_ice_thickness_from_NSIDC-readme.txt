OVERVIEW

This readme accompanies the Operation IceBridge IDSCI2 matlab data reader
called import_IceBridge_sea_ice_thickness_from_NSIDC.m.

The matlab program reads ASCII data files and displays graphical
representations of the data in the IceBridge Sea Ice Freeboard, Snow
Depth, and Thickness data files, which are available as the IDCSI2 product
at the National Snow and Ice Data Center (NSIDC):

http://nsidc.org/data/idcsi2.html

This software is available at

http://nsidc.org/data/icebridge/tools.html

DISCLAIMER

This software is provided as-is as a service to the user community in the
hope that it will be useful, but without any warranty of fitness for any
particular purpose or correctness.  Bug reports, comments, and suggestions
for improvement are welcome; please send to nsidc@nsidc.org.


USING THE SOFTWARE

There are two files in the downloaded tar file:

import_IceBridge_sea_ice_thickness_from_NSIDC.m
  the matlab program with the reader and display commands

import_IceBridge_sea_ice_thickness_from_NSIDC-readme.txt
  This file

Assuming that you have a working matlab license and you have downloaded
the IDCSI2 data file 'OIB_20090331_IDCSI2.txt' to the same directory as
the matlab .m file, in matlab do:

>> cd('/path/to/reader/and/data/file/')
>> import_IceBridge_sea_ice_thickness_from_NSIDC

You will be presented with a prompt to choose the data file to open.
Choose OIB_20090331_IDCSI2.txt and click "Open".  There will be a short
delay while the file is opened.  Four (4) windows will be opened, with the
following figures describing the contents of the file:

Figure 1: plots of snow depth, ATM freeboard and sea ice thickness, along
       	  the flight profile
Figure 2: the flight path, in an Easting-Northing coordinate system
Figure 3: plot of distance to closest sea surface height tie-point, along
          the flight profile
Figure 4: plot of the flight path, on a Blue Marble background, projected
          to the standard IceBridge polar stereographic projection.

The first time you call the reader, you may see the following warning about
obsolete layers from a map server:

"Warning: While attempting to update layers from the server, 'http://svs.gsfc.nasa.gov/cgi-bin/wms?',
some layers are no longer available on the server and are being removed from the layer array. The
number of layers no longer available on this server is 3. 
> In wmsupdate>synchronizeLayerArray at 145
  In wmsupdate at 91
  In import_IceBridge_sea_ice_thickness_from_NSIDC at 221"

and the file "blue_marble.mat" will be created in the current directory.

The reader will also create an array variable in your matlab workspace for
each column in the input data set.  Variable names are derived from the
column header strings in the data file.  For example, columns 1, 2 and 6
in the file represent latitude, longitude and ATM_fb.  The matlab
workspace will contain variables lat, lon and ATM_fb, as <78844x1 double>
arrays, and the last 4 values of these records in this file are:

>> lat(78841:78844), lon(78841:78844), ATM_fb(78841:78844)

ans =

                 83.907455
                  83.90744
                 83.907425
                 83.907417


ans =

                333.172363
                333.169037
                333.165588
                333.162598


ans =

                    0.7155
                    0.7472
                    0.6578
                    0.4981

>> 






