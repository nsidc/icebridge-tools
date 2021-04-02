This directory contains a basic Matlab .MAT -V6 reader. These are files saved with the '-v6' option from Matlab
which allow cell arrays, structures, objects, etc, but do not compress the data.

This reader only supports reading 2D numeric real arrays. Other datatypes,
complex arrays, and arrays with more than 2D are ignored by the reader.

The files included with this reader are:

matfile_format.pdf
  Mathworks document describing the full .MAT format

mat_reader_README.txt
  This readme

mat_reader_C/
  This directory contains the reader for the C language.

mat_reader_C/mat_reader.h
  Header file with information on how to use.

mat_reader_C/mat_reader.c
  Definitions of functions in mat_reader.h

mat_reader_C/mat_reader_main.c
  Example use of mat_reader.[ch]

mat_reader_C/mat_reader_test.mat
  Example file to use with mat_reader_main.c

mat_reader_IDL/
  This directory contains the reader for the IDL language.
  
mat_reader_IDL/mat_reader.pro
  Function mat_reader for reading in data
  
mat_reader_IDL/test_mat_reader.pro
  Batch script showing how to use mat_reader

