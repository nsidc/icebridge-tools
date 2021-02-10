/*========================================================================
 * extract_cols_from_sbet.c
 *
 * This program reads the binary SBET format for Applanix data and writes the
 * lon, lat, altitude columns to the binary outfile.  This will allow me to use
 * the gmtdp program efficiently.
 *
 * 2011-02-15  Bruce Raup  braup@nsidc.org
 * National Snow & Ice Data Center, University of Colorado, Boulder
 * Copyright 2011 Regents of the University of Colorado
 *========================================================================*/

#include <stdio.h>
#include <stdlib.h>

typedef struct {
  double time;
  double lat;
  double lon;
  double alt;
  double x_vel;
  double y_vel;
  double z_vel;
  double roll;
  double pitch;
  double heading;
  double wander;
  double x_force;
  double y_force;
  double z_force;
  double x_ang_rate;
  double y_ang_rate;
  double z_ang_rate;
} record_type;

int main(int argc, char **argv) {
  FILE *infile, *outfile;
  record_type rec;

  size_t sz;
  int num_items;

  double r2d = 180/3.141592654;

  double londeg, latdeg; /* lon and lat in degrees */

  sz = sizeof(record_type);

  if (argc != 3) {
    printf( "Usage:  %s input_sbet_file  output_lonlatalt_file\n", argv[0] );
    exit(0);
  }

  fprintf( stderr, "sz = %d\n", sz );

  infile = fopen(argv[1], "rb");
  if (! infile) {
    fprintf(stderr, "Can't open %s for reading\n", argv[1]);
    exit(1);
  }

  outfile = fopen(argv[2], "wb");
  if (! outfile) {
    fprintf(stderr, "Can't open %s for reading\n", argv[2]);
    exit(1);
  }

  while (1) {
    num_items = fread(&rec, sz, 1, infile);
    //fprintf(stderr, "num_items = %d\n", num_items);
    if (num_items != 1) {
      break;
    }
    //printf("%lf %lf %lf\n", rec.lon*r2d, rec.lat*r2d, rec.alt);

    londeg = rec.lon * r2d;
    latdeg = rec.lat * r2d;
    num_items = fwrite(&londeg, sizeof(londeg), 1, outfile);
    num_items += fwrite(&latdeg, sizeof(latdeg), 1, outfile);
    num_items += fwrite(&rec.alt, sizeof(rec.alt), 1, outfile);
    if (num_items != 3) {
      break;
    }
  }
}

