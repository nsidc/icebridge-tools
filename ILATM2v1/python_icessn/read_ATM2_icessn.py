#!/usr/bin/env python
u"""
read_ATM2_icessn.py
Written by Tyler Sutterley (University of Washington)

Reads Level-2 Airborne Topographic Mapper (ATM) Icessn Elevation, Slope, and
    Roughness data products provided by the National Snow and Ice Data Center
    http://nsidc.org/data/docs/daac/icebridge/ilatm2/index.html

Can be the following ATM icessn file types:
    BLATM2: Pre-Icebridge Airborne Topographic Mapper icessn product
    ILATM2: Airborne Topographic Mapper icessn product version 1
    ILATM2: Airborne Topographic Mapper icessn product version 2 (*.csv)

INPUTS:
    full_filename: full path to ATM icessn file (can have tilde-prefix)

OUTPUTS:
Data variables for the given input icessn file format listed below:
    time: Time at which the aircraft passed the mid-point of the platelet
        Seconds since 2000-01-01 12:00:00 UTC
    latitude: Latitude of the center of the platelet (degrees)
    longitude: Longitude of the center of the platelet (degrees)
    elevation: Height of center of the platelet above WGS84 ellipsoid (meters)
    SNslope: South to North slope of the platelet (dimensionless)
    WEslope: West to East slope of the platelet (dimensionless)
    RMS: RMS fit of the ATM data to the plane. (meters)
    npt_used: Number of points used in estimating the plane parameters
    npt_edit: Number of points removed in estimating the plane parameters
    distance: Distance of the center of the block from the centerline of the
        aircraft trajectory (starboard = positive, port = negative). (meters)
    track: Track identifier (numbered 1...n, starboard to port, and 0 = nadir)

NOTES:
    elevation(phi,lambda) = QFIT_elevation(phi0,lambda0)
        + SNslope * (phi - phi0) * 6378137 * pi/180
        + WEslope * (lambda - lambda0) * cos(phi0) * 6378137 * pi/180

PYTHON DEPENDENCIES:
    numpy: Scientific Computing Tools For Python
        https://numpy.org
        https://numpy.org/doc/stable/user/numpy-for-matlab-users.html

UPDATE HISTORY:
    Updated 04/2021: add function docstrings
    Updated 02/2020: changed import of count_leap_seconds function
    Updated 10/2017: include distance bad values in regular expression pattern
    Written 10/2017
"""
import os
import re
import numpy as np

# PURPOSE: read the ATM Level-2 icessn data file
def read_ATM2_icessn(full_filename):
    """
    Reads an ATM Level-2 icessn data file

    Arguments
    ---------
    full_filename: path to ATM icessn file
    """
    # regular expression pattern for extracting parameters
    rx=re.compile(r'(BLATM2|ILATM2)_(\d+)_(\d+)_smooth_nadir(.*?)(csv|seg|pt)$')
    # extract mission and other parameters from filename
    file_basename = os.path.basename(full_filename)
    MISSION,YYMMDD,HHMMSS,AUX,SFX = rx.findall(file_basename).pop()
    # early date strings omitted century and millenia (e.g. 93 for 1993)
    if (len(YYMMDD) == 6):
        ypre,month,day = np.array([YYMMDD[:2],YYMMDD[2:4],YYMMDD[4:]],dtype='f')
        year = (ypre + 1900.0) if (ypre >= 90) else (ypre + 2000.0)
    elif (len(YYMMDD) == 8):
        year,month,day = np.array([YYMMDD[:4],YYMMDD[4:6],YYMMDD[6:]],dtype='f')
    # input file column types for input variable
    dtype = {}
    dtype['names'] = ['seconds','latitude','longitude','elevation',
        'SNslope','WEslope','RMS','npt_used','npt_edit','distance','track']
    dtype['formats'] = ['f','f','f','f','f','f','f','u4','u4','f','u4']
    # convert RMS from centimeters to meters
    dtype['scale'] = [1.0,1.0,1.0,1.0,1.0,1.0,1.0/100.0,1,1,1.0,1]
    # compile regular expression operator for reading lines (extracts numbers)
    regex=re.compile(r'[-+]?(?:(?:\d*\.\d+)|(?:\d+\.?)|(?:\*+))(?:[Ee][+-]?\d+)?')
    # read the input file, split at lines and remove all commented lines
    with open(os.path.expanduser(full_filename),'r') as f:
        file_contents=[i for i in f.readlines() if re.match(r'^(?!\#|\n)',i)]
    ind = [i for i,v in enumerate(dtype['names'])]
    # output python dictionary with variables
    ATM_L2_input = {}
    # create output variables with length equal to the number of file lines
    for key,val in zip(dtype['names'],dtype['formats']):
        ATM_L2_input[key] = np.zeros_like(file_contents, dtype=val)
    # for each line within the file
    for i,line_entries in enumerate(file_contents):
        # find numerical instances within the line
        line_contents = regex.findall(line_entries)
        # for each variable: save to dinput as output variable type
        for j,n,f,s in zip(ind,dtype['names'],dtype['formats'],dtype['scale']):
            # convert masked variables to nan
            if re.match(r'\*+',line_contents[j]):
                ATM_L2_input[n][i] = np.nan
            else:
                ATM_L2_input[n][i] = s*np.array(line_contents[j],dtype=f)
    # convert shot time (seconds of day) to J2000
    hour = np.floor(ATM_L2_input['seconds']/3600.0)
    minute = np.floor((ATM_L2_input['seconds'] % 3600)/60.0)
    second = ATM_L2_input['seconds'] % 60.0
    # First column in Pre-IceBridge and ICESSN Version 1 files is GPS time
    if (MISSION == 'BLATM2') or (SFX != 'csv'):
        # leap seconds for converting from GPS time to UTC
        S = calc_GPS_to_UTC(year,month,day,hour,minute,second)
    else:
        S = 0.0
    # calculation of Julian day
    JD = calc_julian_day(year,month,day,HOUR=hour,MINUTE=minute,SECOND=second-S)
    # converting to J2000 seconds
    ATM_L2_input['time'] = (JD - 2451545.0)*86400.0
    # return the input data
    return ATM_L2_input

# PURPOSE: calculate the Julian day from calendar date
# http://scienceworld.wolfram.com/astronomy/JulianDate.html
def calc_julian_day(YEAR, MONTH, DAY, HOUR=0.0, MINUTE=0.0, SECOND=0.0):
    """
	Calculates the Julian day from calendar date

	Arguments
	---------
	YEAR: year
	MONTH: month of the year
	DAY: day of the month
	HOUR: hour of the day
	MINUTE: minute of the hour
	SECOND: second of the minute
	"""
    JD = np.zeros_like(SECOND,dtype=np.float)
    JD += 367.*YEAR - np.floor(7.*(YEAR + np.floor((MONTH+9.)/12.))/4.) - \
        np.floor(3.*(np.floor((YEAR + (MONTH - 9.)/7.)/100.) + 1.)/4.) + \
        np.floor(275.*MONTH/9.) + DAY + 1721028.5
    JD += HOUR/24. + MINUTE/1440. + SECOND/86400.
    return JD

# PURPOSE: calculate the number of leap seconds between GPS time (seconds
# since Jan 6, 1980 00:00:00) and UTC
def calc_GPS_to_UTC(YEAR, MONTH, DAY, HOUR, MINUTE, SECOND):
    """
	Gets the number of leaps seconds for a calendar date in GPS time

	Arguments
	---------
	YEAR: year (GPS)
	MONTH: month of the year (GPS)
	DAY: day of the month (GPS)
	HOUR: hour of the day (GPS)
	MINUTE: minute of the hour (GPS)
	SECOND: second of the minute (GPS)
	"""
    GPS = 367.*YEAR - np.floor(7.*(YEAR + np.floor((MONTH+9.)/12.))/4.) - \
        np.floor(3.*(np.floor((YEAR + (MONTH - 9.)/7.)/100.) + 1.)/4.) + \
        np.floor(275.*MONTH/9.) + DAY + 1721028.5 - 2444244.5
    GPS_Time = GPS*86400.0 + HOUR*3600.0 + MINUTE*60.0 + SECOND
    return count_leap_seconds(GPS_Time)

# PURPOSE: Count number of leap seconds that have passed for each GPS time
def count_leap_seconds(GPS_Time):
    """
    Count number of leap seconds that have passed for each GPS time

    Arguments
    ---------
    GPS_Time: time in seconds since 1980-01-06T00:00:00
    """
    leaps = [46828800, 78364801, 109900802, 173059203, 252028804, 315187205,
        346723206, 393984007, 425520008, 457056009, 504489610, 551750411,
        599184012, 820108813, 914803214, 1025136015, 1119744016, 1167264017]
    # number of leap seconds prior to GPS_Time
    n_leaps = np.zeros_like(GPS_Time)
    for i,leap in enumerate(leaps):
        count = np.count_nonzero(GPS_Time >= leap)
        if (count > 0):
            indices, = np.nonzero(GPS_Time >= leap)
            n_leaps[indices] += 1.0
    return n_leaps
