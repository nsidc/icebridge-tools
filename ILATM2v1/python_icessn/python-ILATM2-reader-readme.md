#### Reads Level-2 Airborne Topographic Mapper (ATM) Icessn data products

- [IceBridge ATM L2 Icessn Elevation, Slope, and Roughness](https://nsidc.org/data/ilatm2/)
- [Pre-IceBridge ATM L2 Icessn Elevation, Slope, and Roughness](https://nsidc.org/data/blatm2/)
- [NSIDC IceBridge Software Tools](https://nsidc.org/data/icebridge/tools.html)

#### Calling Sequence
```
from read_ATM2_icessn import read_ATM2_icessn
ATM_L2_input = read_ATM2_icessn('example_filename.csv')
```

#### Returns

- `time`: Time at which the aircraft passed the mid-point of the platelet (seconds since 2000-01-01 12:00:00 UTC)
- `latitude`: Latitude of the center of the platelet (degrees)
- `longitude`: Longitude of the center of the platelet (degrees)
- `elevation`: Height of center of the platelet above WGS84 ellipsoid (meters)
- `SNslope`: South to North slope of the platelet (dimensionless)
- `WEslope`: West to East slope of the platelet (dimensionless)
- `RMS`: RMS fit of the ATM data to the plane. (meters)
- `npt_used`: Number of points used in estimating the plane parameters
- `npt_edit`: Number of points removed in estimating the plane parameters
- `distance`: Distance of the center of the block from the centerline of the aircraft trajectory (meters)
    * starboard: positive values
    * port: negative values
- `track`: Track identifier (numbered 1...n, starboard to port, and 0 = nadir)

#### Dependencies
- [numpy: Scientific Computing Tools For Python](https://numpy.org)
