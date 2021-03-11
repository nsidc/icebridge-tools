![NSIDC logo](/images/NSIDC_logo_2018_poster-1.png)


# NSIDC IceBridge Tools

NSIDC Tools for reading and viewing NASA IceBridge data.

## Level of Support

* This repository is not actively supported by NSIDC but we welcome issue submissions and pull requests in order to foster community contribution.

See the [LICENSE](LICENSE) for details on permissions and warranties. Please contact nsidc@nsidc.org for more information.

## Requirements

Various tools within this package may require:
* Python
* Matlab
* Fortran
* IDL

## Installation

See each subdirectory for installation and usage.

## Included Tools

### [CReSIS_L1Bv2](CReSIS_L1Bv2)
C, IDL, and MATLAB readers for Level-1B MATLAB data files from CReSIS [MCoRDS](https://nsidc.org/data/irmcr1b.html), [Ku-band Radar](https://nsidc.org/data/irkub1b.html), [Snow Radar](https://nsidc.org/data/irsno1b.html), and [Accumulation Radar](https://nsidc.org/data/iracc1b.html) instruments.

### [CReSISv1](CReSISv1)
MATLAB reader for MCoRDS Level-2 data. For more information see [IceBridge MCoRDS L2 Ice Thickness](https://nsidc.org/data/irmcr2.html). MATLAB reader `read_snow_radar.m` for CReSIS snow radar binary files. For more information see [IceBridge Snow Radar L1B Geolocated Radar Echo Strength Profiles](https://nsidc.org/data/irsno1b.html).

### [IAMET1B](IAMET1B)
MATLAB reader for NSERC L1B data files. For more information see [IceBridge NSERC L1B Geolocated Meteorologic and Surface Temperature Data](https://nsidc.org/data/iamet1b.html).

### [IDCSI2](IDCSI2)
MATLAB reader for IceBridge Sea Ice Freeboard, Snow Depth, and Thickness data. For more information see [IceBridge Sea Ice Freeboard, Snow Depth, and Thickness](https://nsidc.org/data/idcsi2.html).

### [IGGRV1B](IGGRV1B)
MATLAB readers for Sander AIRGrav gravity and aircraft attitude data files. For more information see [IceBridge Sander AIRGrav L1B Geolocated Free Air Gravity Anomalies](https://nsidc.org/data/iggrv1b.html).

### [ILATM1Bv1](ILATM1Bv1)
C, IDL, and MATLAB readers for IceBridge ATM L1B Version 1 qfit data. For more information see [IceBridge ATM L1B Qfit Elevation and Return Strength](https://nsidc.org/data/ilatm1b/versions/1).

### [ILATM2v1](ILATM2v1)
MATLAB reader for IceBridge ATM L2 Version 1 icessn data. For more information see [IceBridge ATM L2 Icessn Elevation, Slope, and Roughness](https://nsidc.org/data/ilatm2/versions/1).

### [ILNIRW1B](ILNIRW1B)
Python code for finding matching laser shots in both the [IceBridge Narrow Swath ATM L1B Elevation and Return Strength with Waveforms](https://nsidc.org/data/ilnsaw1b) and the [IceBridge ATM L1B Near-Infrared Waveforms](https://nsidc.org/data/ilnirw1b) data products.

### [IODMS1B](IODMS1B)
MATLAB reader for IceBridge DMS L1B data. For more information see [IceBridge DMS L1B Geolocated and Orthorectified Images](https://nsidc.org/data/iodms1b.html).

### [IPAPP1B](IPAPP1B)
C, MATLAB, and Perl readers for Applanix data files. For more information see [IceBridge POS/AV L1B Corrected Position and Attitude Data](https://nsidc.org/data/ipapp1b.html).

## Usage

See each subdirectory for installation and usage.

## License

See [LICENSE](LICENSE).

## Code of Conduct

See [Code of Conduct](CODE_OF_CONDUCT.md).

## Credit

This software was developed by the National Snow and Ice Data Center with funding from multiple sources.
