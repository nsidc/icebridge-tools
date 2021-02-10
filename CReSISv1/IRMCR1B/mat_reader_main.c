// mat_reader_main.c
// 
// Compile with:
//   g++ -Wall mat_reader_main.c mat_reader.c -o mat_reader_main
//
// Description:
//   Example of how to run mat_reader.c
//   Requires that you have a V6 Matlab .MAT file called "mat_reader_test.mat"
//   in the working directory when you execute the function and that the test
//   file have 2D matrix variables named "Data", "Latitude", "Longitude",
//   "Elevation", and "GPS_time".
//   To create such a file in Matlab:
//    >> Data = [1.1 1.2; 1.3 1.4; 1.5 1.6].';
//    >> Latitude = [1 2 3]; Longitude = Latitude; Elevation = Latitude; GPS_time = Latitude;
//    >> save('-v6','mat_reader_test.mat','Data','Latitude','Longitude','Elevation','GPS_time');
//   To run the function from the shell (no arguments required):
//    ./mat_reader_main
//
// Author: John Paden

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "mat_reader.h"

int main()
{
	// Test the parser.
	char test_file[] = "mat_reader_test.mat";
  int status;

	// Open a Matlab file and return an array of strings with variable names
  struct mat_matrix *vars;
  int num_vars;
  status = mat_reader_vars(test_file, &vars, &num_vars);
  if (status != 0)
  {
    printf("Error calling mat_reader_names\n");
    return 1;
  }
  // Print variable names
  for (int idx = 0; idx < num_vars; idx++)
  {
    // Make sure the variable was supported by checking the length of the name
    if (strlen(vars[idx].name) > 0)
    {
      printf("Name: %s\n", vars[idx].name);
    }
  }

  // Get a variable named "Data" from the file
	double* matrixData = NULL;
	int matrixDims[2];
  status = mat_reader_get(test_file, "Data", &matrixData, matrixDims);
  if (status != 0)
  {
    printf("Error calling mat_reader_get\n");
    return 1;
  }

  // Print out the contents of the data
  mat_reader_print(matrixData,matrixDims);

  // Free memory allocated by mat_reader_get
  free(matrixData);

  return 0;
}

