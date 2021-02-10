/*
* Initial version was received at NSIDC from Serdar Manizade.  Modified
* significantly by Bruce Raup (braup@nsidc.org).
* 
* qi2txt()  creates ascii output (to standard output) from qfit binary files
* (12-word input).  Output stream contains the laser lat/lon/elev/hhmmss
* (removed output of passive data and laser srt).  Originally written by Bob
* Swift/EG&G, Modified by Serdar Manizade 08-Feb-2010.  Output format includes
* title for each column, comma delimited.
*
* Input data are in big-endian format.  This reader automatically detects the
* endianness of the host machine and swaps if needed.
* 
* Fields:
* 
*  0    Relative Time (msec from start of data file) 
*  1    Laser Spot Latitude (degrees X 1,000,000)
*  2    Laser Spot Longitude (degrees X 1,000,000)
*  3    Elevation (meters)
*  4    Start Pulse Signal Strength (relative)
*  5    Reflected Laser Signal Strength (relative)
*  6    Scan Azimuth (degrees X 1,000)
*  7    Pitch (degrees X 1,000)
*  8    Roll (degrees X 1,000)
*  9    GPS PDOP (dilution of precision) (X 10)
* 10    Laser received pulse width (digitizer samples)
* 11    GPS Time packed (example: 153320100 = 15h 33m 20s 100ms)
* 
*/

#include <stdio.h>
#include <stdlib.h>
#include "define.h"

#define SEEK_SET        0
#define MAXARG          12
#define LAT_MIN         0
#define LAT_MAX         90

/* There are system endian.h definitions, but I'm not sure these are available
* on all potential platforms.  This source file includes a small routine to
* test the endianness of the machine it's running on.
*/

#define MY_BIG_ENDIAN      0
#define MY_LITTLE_ENDIAN   1
#define MAX_NAME_LENGTH    100
#define VERSION            0.3

int short_output = 0;
int host_endianness;
int data_endianness;
int4 get_record_length(int4 *, int4 *, FILE *);

int main(int argc, char *argv[]) {
    char infilename[MAX_NAME_LENGTH];
    FILE *infile;
    int4 value[MAXARG], svalue[MAXARG], gvalue[MAXARG];
    long unsigned int in_rec = 0L, out_rec = 0L;
    int4 neg_rec_count = 0;
    int4 j, nvar, ipart;
    double scale[MAXARG] = {
                              1.0e3,
                              1.0e6,
                              1.0e6,
                              1.0e3,
                              1.0,
                              1.0,
                              1.0e3,
                              1.0e3,
                              1.0e3,
                              1.0,
                              1.0,
                              1.0e3
                           };
    double bufout[MAXARG];
    char *endian[] = { "big", "little" };
    float version = VERSION;

    host_endianness = testendianness();

    if (argc == 2) {
      data_endianness = MY_BIG_ENDIAN;
      strncpy(infilename, argv[1], MAX_NAME_LENGTH);
    }
    else if (argc==3 && strcmp(argv[1], "-L")==0 ) {
      data_endianness = MY_LITTLE_ENDIAN;
      strncpy(infilename, argv[2], MAX_NAME_LENGTH);
    }
    else {
      fprintf(stderr, "%s version %g\n", argv[0], version );
      fprintf( stderr, "Usage:  %s [-L] inputfile\n", argv[0] );
      fprintf( stderr, "  Use -L to assume data is little-endian\n" );
      fprintf( stderr, "  By default the program assumes the data are big-endian\n" );
      fprintf( stderr, "  In either case, it tests the host architecture and will\n" );
      fprintf( stderr, "  try to match the data to that endianness.\n" );
      exit( 1 );
    }

    fprintf(stderr, "%s version %g\n", argv[0], version );
    fprintf(stderr, " Input file:  %s\n", infilename);
    fprintf(stderr, "This machine is %s endian.\n", endian[host_endianness]);
    fprintf(stderr, "Assuming data are %s endian.\n", endian[data_endianness]);
 
    infile=fopen(infilename,"rb");
    if (infile==NULL) {
        fprintf(stderr, "cannot open input file\n");
        exit(1);
    }

    /*  read first record and verify fixed record length */
    nvar = get_record_length(value, svalue, infile);
    fprintf(stderr, "Number of words/record = %d\n", nvar);
    fprintf(stderr, "Skipping records with negative time values.\n");
 
    /* write header line in output files */
    if (short_output)
        fprintf(stdout,"# LATITUDE,LONGITUDE,ELEVATION,TIME-HHMMSS\n"); 
    else
        fprintf(stdout,"# REL_TIME,LATITUDE,LONGITUDE,ELEVATION,strt_pulse_sigstr,ref_sigstr,azi,pitch,roll,GPS_dil_prec,pulse_width,TIME-HHMMSS\n"); 
 
    while (fread((char *)value,sizeof(*value),nvar,infile) != 0) {
        ++in_rec;
 
        /* swap bytes if host machine is little-endian (e.g. PC) */
        if (host_endianness != data_endianness) {
      	  ipart = myswap((char*)value,(char*)svalue,sizeof(*value),nvar);
        }
        else {
          /* host machine is big-endian (e.g. Sun Workstation) */
          for (j=0; j < nvar; j++) svalue[j] = value[j]; 
        }


        /*  skip header records which begin with negative integers */
        if (*(svalue) >= 0) {
            /*  convert scaled integers to double precision reals */
            for (j=0; j < nvar; j++)
                bufout[j] = svalue[j] / scale[j];

            /*  convert positive east longitude to negative when value exists */
            if (bufout[2] > 180) bufout[2] -= 360;

            /*  xyz limited output for laser spot */
            if (short_output) {
                if (bufout[1] != 0. && bufout[3] > -9999)
                    fprintf(stdout,"%10.7f  %11.7f  %8.3f  %10.6f\n",
                      bufout[1], bufout[2],bufout[3],bufout[11]);
            }
            else { /* full output */
                if (bufout[1] != 0.0 && bufout[3] > -9999)
                    fprintf(stdout,
                      "%10.6f %10.7f %11.7f %8.3f %7.0f %5.0f %5.0f %10.3f %11.3f %8.1f %10.1f %10.6f\n", 
                      bufout[0], bufout[1], bufout[2], bufout[3], bufout[4], bufout[5],
                      bufout[6], bufout[7], bufout[8], bufout[9], bufout[10], bufout[11]);
            }
            ++out_rec;
        }
        else {
          ++neg_rec_count;
        }
    }
 
    fprintf(stderr, "Number of records read = %ld\nNumber of records written = %ld\n", in_rec, out_rec);
    fprintf(stderr, "Number of negative time records skipped = %d\n", neg_rec_count);
    fclose(infile);
}

/*======================================================================*/
/* byte swap function myswap */
int4 myswap(char *in, char* out, int4 len, int4 cnt) {
    int4 i,  j,  k, sp, ep;

    for (i=0; i<cnt; ++i) {

        sp = i*len;
        ep = sp+len-1;     /* ((i+1) * len)-1; */

        for (j=sp, k=0; j<=ep; ++j, ++k) {
            out[j] = in[ep-k];
        }
    }
    return(i);
}

/*======================================================================*/
int testendianness(void) {

    typedef union
    {
        int i;
        char c[4];
    } u;

    u temp;
    temp.i = 0x12345678;

    if (temp.c[0] == 0x12) {
      return(MY_BIG_ENDIAN);
    }
    else {
      return(MY_LITTLE_ENDIAN);
    }
}


/*======================================================================*/
int4 get_record_length(int4 *value, int4 *svalue, FILE *infile) {

    int4 nvar, ipart;

    fread((char *)value,sizeof(*value),1,infile);
 
    /* swap bytes if host machine is little-endian (e.g. PC) */
    if (host_endianness != data_endianness) {
      ipart = myswap((char*)value,(char*)svalue,4,1);
      nvar = *(svalue) / 4;
    }
    else {
      /* Sun Workstations, etc. */
      nvar = *(value) / 4;
    }

    /*  rewind file */
    fseek (infile,0L,SEEK_SET);

    /*  read past first record */	 
    fread((char *)value,sizeof(*value),nvar,infile); 

    return( nvar );
}
