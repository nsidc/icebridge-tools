// mat_reader.h
// 
// See mat_reader_main.c for an example of how to use.
// This is the header file for mat_header.c
//
// Description:
//   Search this file for "USER FUNCTION" to find the functions
//   for users.
//   These files are setup to be descriptive and have many
//   printf statements that you can turn off by setting
//   DEBUG_LEVEL to 0.
//
// Author: John Paden

#ifndef __MAT_READER_H__
#define __MAT_READER_H__

struct mat_header
{
  char text[117];
  char subsys_data_offset[9];
  unsigned short version;
  char endian_indicator[3];
};

struct mat_data_type
{
  unsigned int data_type;
  unsigned int num_bytes;
};

struct mat_matrix
{
  struct mat_data_type data_type;
  unsigned int array_flags[2];
  int dims[2];
  char name[129];
  int file_offset;
};

#define MAT_READER_miINT8 1
#define MAT_READER_miUINT8 2
#define MAT_READER_miINT16 3
#define MAT_READER_miUINT16 4
#define MAT_READER_miINT32 5
#define MAT_READER_miUINT32 6
#define MAT_READER_miSINGLE 7
#define MAT_READER_miDOUBLE 9
#define MAT_READER_miINT64 12
#define MAT_READER_miUINT64 13
#define MAT_READER_miMATRIX 14

#define MAT_READER_mxCHAR_CLASS 4
#define MAT_READER_mxDOUBLE_CLASS 6
#define MAT_READER_mxSINGLE_CLASS 7
#define MAT_READER_mxINT8_CLASS 8
#define MAT_READER_mxUINT8_CLASS 9
#define MAT_READER_mxINT16_CLASS 10
#define MAT_READER_mxUINT16_CLASS 11
#define MAT_READER_mxINT32_CLASS 12
#define MAT_READER_mxUINT32_CLASS 13
#define MAT_READER_mxINT64_CLASS 14
#define MAT_READER_mxUINT64_CLASS 15

#define DEBUG_LEVEL 0 // 0: none, 1: some, 2: all
#define dprintf !DEBUG_LEVEL ? : printf

// mat_reader_vars (USER FUNCTION)
// This function returns a list of the variables in the
// file that this file reader can read. Basic attributes
// about the variables are also returned.  Variables which
// are not supported have a zero length name.
int mat_reader_vars(const char *fn, struct mat_matrix **vars, int *num_vars);

// mat_reader_data
// Support function that reads the data from the "data" subelement
int mat_reader_data(FILE *fid, int data_type, int num_bytes, int numel, double *data, int data_packed_flag);

// mat_reader_tag
// Support function that reads the tag for variables and subelements
int mat_reader_tag(FILE *fid, unsigned int *num_bytes, unsigned int *data_type, int *data_packed);

// mat_reader_get (USER FUNCTION)
// Function for getting data.
int mat_reader_get(const char *fn, const char *var_name, double **data, int *dims);

// mat_reader_print (USER FUNCTION)
// Function for printing data.
void mat_reader_print(const double *data, const int dims[2]);
  
#endif
