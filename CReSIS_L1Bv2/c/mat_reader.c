// mat_reader.c
// 
// Provides basic support for reading Matlab -V6 .MAT files.
// Supports: 2-D real matrices
// See mat_reader.h for details on how to use.
//
// Author: John Paden

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "mat_reader.h"

int mat_reader_vars(const char *fn, struct mat_matrix **vars, int *num_vars)
{
  dprintf("Opening file %s\n", fn);
  FILE *fid;
  fid = fopen(fn, "r");
  if (fid == NULL)
  {
    dprintf("  Error opening file %s\n", fn);
    return 1;
  }

  // ======================================================
  // Read in Matlab File Header
  //   128 bytes:
  //   116 byte text description
  //   8 byte subsystem data offset
  //   2 byte short version (0x100)
  //   2 byte little-endian/big-endian indicator
  // ======================================================
  
  // Declare and initialize Matlab file header
  struct mat_header header;
  header.text[116] = 0;
  header.subsys_data_offset[8] = 0;
  header.endian_indicator[2] = 0;

  // char text[117];
  // char subsys_data_offset[9];
  // unsigned short version;
  // char endian_indicator[3];

  fread(header.text, sizeof(char), 116, fid);
  dprintf("  Header: %s\n", header.text);

  fread(header.subsys_data_offset, sizeof(char), 8, fid);
  dprintf("  Subsystem Data Offset: %s\n", header.subsys_data_offset);

  fread(&header.version, sizeof(short), 1, fid);
  dprintf("  Version: 0x%hx\n", header.version);

  fread(header.endian_indicator, sizeof(short), 1, fid);
  dprintf("  Endian Indicator: %s\n", header.endian_indicator);

  // ======================================================
  // Read in data blocks until end of file reached
  //   Each data block is 8 byte tag + variable size data
  //   8 byte tag:
  //     4 byte integer data type
  //     4 byte integer number of bytes
  //   Variable length miMATRIX data block
  // ======================================================

  int cur_pos = ftell(fid);
  fseek(fid, 0, SEEK_END);
  int file_length = ftell(fid);
  fseek(fid, cur_pos, SEEK_SET);

  *vars = NULL;
  *num_vars = 0;
  while (ftell(fid) < file_length)
  {
    // Not at end of file so read in data block
    
    // 1. allocate memory for the new data variable header
    if (*vars == NULL)
    {
      (*num_vars)++;
      *vars = (struct mat_matrix *)malloc(sizeof(struct mat_matrix) * (*num_vars));
    }
    else
    {
      (*num_vars)++;
      *vars = (struct mat_matrix *)realloc(*vars, sizeof(struct mat_matrix) * (*num_vars));
    }
    if (*vars == NULL)
    {
      dprintf("malloc or realloc failed\n");
      return 1;
    }

    // 2. read in new header
    dprintf("Variable %d\n", (*num_vars));
    int data_packed_flag;
    mat_reader_tag(fid, &(*vars)[(*num_vars)-1].data_type.num_bytes, \
      &(*vars)[(*num_vars)-1].data_type.data_type, &data_packed_flag);
    int next_field = ftell(fid) + (*vars)[(*num_vars)-1].data_type.num_bytes;

    if ((*vars)[(*num_vars)-1].data_type.data_type != MAT_READER_miMATRIX)
    {
      dprintf("  Variable must be miMATRIX type\n");
      fseek(fid,next_field,SEEK_SET);
      continue;
    }
    else
    {
      // 3. read in array flags
      dprintf(" Array flags\n");
      unsigned int num_bytes;
      unsigned int data_type;
      mat_reader_tag(fid, &num_bytes, &data_type, &data_packed_flag);
      fread(&(*vars)[(*num_vars)-1].array_flags, sizeof(int), 2, fid);
      dprintf("  %d/0x%x  %d/0x%x\n", (*vars)[(*num_vars)-1].array_flags[0],
        (*vars)[(*num_vars)-1].array_flags[0],
        (*vars)[(*num_vars)-1].array_flags[1],
        (*vars)[(*num_vars)-1].array_flags[1]);

      int data_class = (*vars)[(*num_vars)-1].array_flags[0] & 0xFF;
      dprintf("  Matlab array type class %d\n", data_class);

      if (data_class == 4 || data_class >= 6 && data_class <= 15)
      {
        dprintf("  Supported class\n");
      }
      else
      {
        dprintf("  Unsupported class, skipping\n");
        fseek(fid,next_field,SEEK_SET);
        continue;
      }

      // 4. read in dimensions
      dprintf(" Dimensions\n");
      mat_reader_tag(fid, &num_bytes, &data_type, &data_packed_flag);
      if (num_bytes > 8)
      {
        dprintf("  Unsupported number of dimensions, skipping\n");
        fseek(fid,next_field,SEEK_SET);
        continue;
      }
      fread(&(*vars)[(*num_vars)-1].dims, sizeof(int), 2, fid);
      dprintf("  %d %d\n", (*vars)[(*num_vars)-1].dims[0],
        (*vars)[(*num_vars)-1].dims[1]);

      // 5. read in variable name
      dprintf(" Variable name\n");
      mat_reader_tag(fid, &num_bytes, &data_type, &data_packed_flag);
      if (data_packed_flag)
      {
        char packed_data[4];
        fread(packed_data, sizeof(*packed_data), 4, fid);
        memcpy((*vars)[(*num_vars)-1].name,packed_data,num_bytes);
      }
      else
      {
        fread((*vars)[(*num_vars)-1].name, sizeof(char), num_bytes, fid);
        // Seek to next 8 byte boundary
        int field_size = (int)ceil((double)num_bytes/8) * 8;
        fseek(fid, field_size - num_bytes, SEEK_CUR);
      }
      dprintf("  %s\n", (*vars)[(*num_vars)-1].name);

      (*vars)[(*num_vars)-1].file_offset = ftell(fid);
      if (DEBUG_LEVEL >= 2)
      {
        // 6. read in real data
        dprintf(" Data\n");
        mat_reader_tag(fid, &num_bytes, &data_type, &data_packed_flag);
        
        double *data;
        int numel = (*vars)[(*num_vars)-1].dims[0] * (*vars)[(*num_vars)-1].dims[1];
        data = (double *)malloc( numel * sizeof(double) );
        mat_reader_data(fid,data_type,num_bytes,numel,data,data_packed_flag);
        for (int idx = 0; idx < numel; idx++)
        {
          int dim1 = 1 + idx % (*vars)[(*num_vars)-1].dims[0];
          int dim2 = (idx - dim1 + 1) / (*vars)[(*num_vars)-1].dims[0] + 1;
          dprintf("  %d (%d,%d): %f\n", idx, dim1, dim2, data[idx]);
        }
        free(data);
      }

      fseek(fid,next_field,SEEK_SET);
    }

  }

  fclose(fid);
  return 0;
}

int mat_reader_data(FILE *fid, int data_type, int num_bytes, int numel, double *data, int data_packed_flag)
{
  if (data_type == MAT_READER_miINT8)
  {
    char *tmp_data;
    tmp_data = (char *)malloc(numel * sizeof(*tmp_data));
    fread(tmp_data, sizeof(*tmp_data), numel, fid);
    for (int idx = 0; idx < numel; idx++)
    {
      data[idx] = (double)tmp_data[idx];
    }
    free(tmp_data);
  }
  else if (data_type == MAT_READER_miUINT8)
  {
    unsigned char *tmp_data;
    tmp_data = (unsigned char *)malloc(numel * sizeof(*tmp_data));
    fread(tmp_data, sizeof(*tmp_data), numel, fid);
    for (int idx = 0; idx < numel; idx++)
    {
      data[idx] = (double)tmp_data[idx];
    }
    free(tmp_data);
  }
  else if (data_type == MAT_READER_miINT16)
  {
    short *tmp_data;
    tmp_data = (short *)malloc(numel * sizeof(*tmp_data));
    fread(tmp_data, sizeof(*tmp_data), numel, fid);
    for (int idx = 0; idx < numel; idx++)
    {
      data[idx] = (double)tmp_data[idx];
    }
    free(tmp_data);
  }
  else if (data_type == MAT_READER_miUINT16)
  {
    unsigned short *tmp_data;
    tmp_data = (unsigned short *)malloc(numel * sizeof(*tmp_data));
    fread(tmp_data, sizeof(*tmp_data), numel, fid);
    for (int idx = 0; idx < numel; idx++)
    {
      data[idx] = (double)tmp_data[idx];
    }
    free(tmp_data);
  }
  else if (data_type == MAT_READER_miINT32)
  {
    int *tmp_data;
    tmp_data = (int *)malloc(numel * sizeof(*tmp_data));
    fread(tmp_data, sizeof(*tmp_data), numel, fid);
    for (int idx = 0; idx < numel; idx++)
    {
      data[idx] = (double)tmp_data[idx];
    }
    free(tmp_data);
  }
  else if (data_type == MAT_READER_miUINT32)
  {
    unsigned int *tmp_data;
    tmp_data = (unsigned int *)malloc(numel * sizeof(*tmp_data));
    fread(tmp_data, sizeof(*tmp_data), numel, fid);
    for (int idx = 0; idx < numel; idx++)
    {
      data[idx] = (double)tmp_data[idx];
    }
    free(tmp_data);
  }
  else if (data_type == MAT_READER_miSINGLE)
  {
    float *tmp_data;
    tmp_data = (float *)malloc(numel * sizeof(*tmp_data));
    fread(tmp_data, sizeof(*tmp_data), numel, fid);
    for (int idx = 0; idx < numel; idx++)
    {
      data[idx] = (double)tmp_data[idx];
    }
    free(tmp_data);
  }
  else if (data_type == MAT_READER_miDOUBLE)
  {
    fread(data, sizeof(double), numel, fid);
  }
  else if (data_type == MAT_READER_miINT64)
  {
    long long *tmp_data;
    tmp_data = (long long *)malloc(numel * sizeof(*tmp_data));
    fread(tmp_data, sizeof(*tmp_data), numel, fid);
    for (int idx = 0; idx < numel; idx++)
    {
      data[idx] = (double)tmp_data[idx];
    }
    free(tmp_data);
  }
  else if (data_type == MAT_READER_miUINT64)
  {
    unsigned long long *tmp_data;
    tmp_data = (unsigned long long *)malloc(numel * sizeof(*tmp_data));
    fread(tmp_data, sizeof(*tmp_data), numel, fid);
    for (int idx = 0; idx < numel; idx++)
    {
      data[idx] = (double)tmp_data[idx];
    }
    free(tmp_data);
  }
  else
  {
    dprintf("Unsupported type\n");
    exit(1);
  }

  // Make sure we have proper byte alignment
  double byte_align;
  if (data_packed_flag)
  {
    byte_align = 4;
  }
  else
  {
    byte_align = 8;
  }
  int offset = (int)((int)ceil(double(num_bytes)/byte_align)*byte_align) - num_bytes;
  dprintf("  Moving forward %d bytes\n", offset);
  fseek(fid,offset,SEEK_CUR);

  return 0;
}

int mat_reader_tag(FILE *fid, unsigned int *num_bytes, unsigned int *data_type, int *data_packed)
{
  // ======================================================
  // Read in tag
  //   Each tag is 8 bytes long.  A tag may have data
  //   embedded in it (up to 4 bytes).
  //   8 byte tag w/o data embedded
  //     4 byte integer data type (only bottom 2 bytes used)
  //     4 byte integer number of bytes
  //   8 byte tag w/o data embedded
  //     2 byte integer number of bytes
  //     2 byte integer data type
  //     4 byte data
  // ======================================================
  unsigned int tmp;
  fread(&tmp, sizeof(tmp), 1, fid);
  if (tmp >> 16 == 0)
  {
    dprintf("  Regular data block\n");
    *data_packed = 0;
    *data_type = tmp;
    fread(num_bytes, sizeof(int), 1, fid);
  }
  else
  {
    dprintf("  Data block with data in tag\n");
    *data_packed = 1;
    *num_bytes = tmp >> 16;
    *data_type = tmp & 0xFFFF;
  }
  dprintf("  Datatype: %d\n", *data_type);
  dprintf("  Num bytes: %d\n", *num_bytes);
  return 0;
}

int mat_reader_get(const char *fn, const char *var_name, double **data, int *dims)
{
	// Open a Matlab file and return an array of strings with variable names
  struct mat_matrix *vars;
  int num_vars;
  int status = mat_reader_vars(fn, &vars, &num_vars);
  if (status != 0)
  {
    dprintf("Error calling mat_reader_names\n");
    return 1;
  }
  // Find the variable of interest
  int var_idx;
  for (var_idx = 0; var_idx < num_vars; var_idx++)
  {
    if (strcmp(vars[var_idx].name, var_name) == 0)
    {
      dprintf("Found variable %s\n", var_name);
      break;
    }
  }

  if (var_idx >= num_vars)
  {
    dprintf("Variable %s not found\n", var_name);
    return 1;
  }

  // Copy the dimensions
  dims[0] = vars[var_idx].dims[0];
  dims[1] = vars[var_idx].dims[1];

  // Read in the data
  dprintf("Opening file %s\n", fn);
  FILE *fid;
  fid = fopen(fn, "r");
  if (fid == NULL)
  {
    dprintf("  Error opening file %s\n", fn);
    return 1;
  }

  // Seek to where the data subelement starts
  fseek(fid,vars[var_idx].file_offset,SEEK_SET);

  // 6. read in real data
  dprintf(" Data\n");
  unsigned int num_bytes;
  unsigned int data_type;
  int data_packed_flag;
  mat_reader_tag(fid, &num_bytes, &data_type, &data_packed_flag);
  
  int numel = vars[var_idx].dims[0] * vars[var_idx].dims[1];
  *data = (double *)malloc( numel * sizeof(double) );
  mat_reader_data(fid,data_type,num_bytes,numel,*data,data_packed_flag);
  fclose(fid);

  if (DEBUG_LEVEL == 1)
  {
    mat_reader_print(*data,dims);
  }
  //dprintf("%s:%d: \n", __FILE__, __LINE__);

  return 0;
}

void mat_reader_print(const double *data, const int dims[2])
{
  int numel = dims[0] * dims[1];
  for (int idx = 0; idx < numel; idx++)
  {
    int dim1 = 1 + idx % dims[0];
    int dim2 = (idx - dim1 + 1) / dims[0] + 1;
    printf("  %d (%d,%d): %f\n", idx, dim1, dim2, data[idx]);
  }
  return;
}

