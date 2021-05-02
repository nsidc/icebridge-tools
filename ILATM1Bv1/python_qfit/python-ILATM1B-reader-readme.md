#### Reads Level-1b Airborne Topographic Mapper (ATM) QFIT binary data products

- [IceBridge ATM L1B Qfit Elevation and Return Strength](https://nsidc.org/data/ilatm1b/1)
- [IceBridge Narrow Swath ATM L1B Qfit Elevation and Return Strength](https://nsidc.org/data/ilnsa1b/1)
- [NSIDC IceBridge Software Tools](https://nsidc.org/data/icebridge/tools.html)
- [Python program for retrieving Operation IceBridge data](https://github.com/tsutterley/nsidc-earthdata)

#### Calling Sequence
```
from read_ATM1b_QFIT_binary import read_ATM1b_QFIT_binary
ATM1b_data, ATM1b_header = read_ATM1b_QFIT_binary('example_filename.qi')
```

#### Returns

- 10-word format (used prior to 2006):
    * `time`: Relative Time (seconds from start of data file)
    * `latitude`: Laser Spot Latitude (degrees)
    * `longitude`: Laser Spot Longitude (degrees)
    * `elevation`: Elevation above WGS84 ellipsoid (meters)
    * `xmt_sigstr`: Start Pulse Signal Strength (relative)
    * `rcv_sigstr`: Reflected Laser Signal Strength (relative)
    * `azimuth`: Scan Azimuth (degrees)
    * `pitch`: Pitch (degrees)
    * `roll`: Roll (degrees)
    * `time_hhmmss`: GPS Time packed (example: 153320.1000 = 15h 33m 20.1s)
    * `time_J2000`: Time converted to seconds since 2000-01-01 12:00:00 UTC

- 12-word format (in use since 2006):
    * `time`: Relative Time (seconds from start of data file)
    * `latitude`: Laser Spot Latitude (degrees)
    * `longitude`: Laser Spot Longitude (degrees)
    * `elevation`: Elevation above WGS84 ellipsoid (meters)
    * `xmt_sigstr`: Start Pulse Signal Strength (relative)
    * `rcv_sigstr`: Reflected Laser Signal Strength (relative)
    * `azimuth`: Scan Azimuth (degrees)
    * `pitch`: Pitch (degrees)
    * `roll`: Roll (degrees)
    * `gps_pdop`: GPS PDOP (dilution of precision)
    * `pulse_width`: Laser received pulse width (digitizer samples)
    * `time_hhmmss`: GPS Time packed (example: 153320.1000 = 15h 33m 20.1s)
    * `time_J2000`: Time converted to seconds since 2000-01-01 12:00:00 UTC

- 14-word format (used in some surveys between 1997 and 2004):
    * `time`: Relative Time (seconds from start of data file)
    * `latitude`: Laser Spot Latitude (degrees)
    * `longitude`: Laser Spot Longitude (degrees)
    * `elevation`: Elevation above WGS84 ellipsoid (meters)
    * `xmt_sigstr`: Start Pulse Signal Strength (relative)
    * `rcv_sigstr`: Reflected Laser Signal Strength (relative)
    * `azimuth`: Scan Azimuth (degrees)
    * `pitch`: Pitch (degrees)
    * `roll`: Roll (degrees)
    * `passive_sig`: Passive Signal (relative)
    * `pass_foot_lat`: Passive Footprint Latitude (degrees)
    * `pass_foot_long`: Passive Footprint Longitude (degrees)
    * `pass_foot_synth_elev`: Passive Footprint Synthesized Elevation (meters)
    * `time_hhmmss`: GPS Time packed (example: 153320.1000 = 15h 33m 20.1s)
    * `time_J2000`: Time converted to seconds since 2000-01-01 12:00:00 UTC

#### Dependencies
- [numpy: Scientific Computing Tools For Python](https://numpy.org)
