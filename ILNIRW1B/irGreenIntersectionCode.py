#!/usr/bin/env python
'''
Python code for finding matching shots in both the ILNSAW1B and ILNIRW1B data products

Run with the command:
python irGreenIntersectionCode.py ILNSAW1B_filename.h5
'''

import sys, os, h5py, bisect, glob
import numpy as np
import matplotlib.pyplot as plt

# Search tolerance for finding matching shots (should be less than 50usec, ie, half the laser interval)
tolerance = 40e-6 # 40 us (most matches are within 10usec)

# Get ILNSAW1B filename from command line argument and look for corresponding ILNIRW1B file
green_filename = sys.argv[1]
print green_filename
ir_filename = green_filename.replace('ILNSAW1B', 'ILNIRW1B').replace('atm6DT7', 'atm6CT7')
if not os.path.exists(ir_filename):
	print('Matching ILNIRW1B file could not be found')
	exit()

# Load seconds of day from green filename
with h5py.File(green_filename, 'r') as f:
	green_utc = f['time/seconds_of_day'][:]

# Load seconds of day from IR filename
with h5py.File(ir_filename, 'r') as f:
	ir_utc = f['time/seconds_of_day'][:]

# Create empty lists to hold matching indices
ir_match, green_match = [], []
nomatch = 0

# Loop through the IR UTC timestamps and find the corresponding green timestamp for each
for i,irt in enumerate(ir_utc):
	# Find sorted location for ir timestamp in green timestamp list (sorted position doesn't guarantee closest timestamp)
	j = bisect.bisect(green_utc, irt)
	
	# Check that the index found isn't the last element of the green timestamps
	if j >= len(green_utc):
		break
	
	# Check if ir timestamp is closer to the green timestamp to the left
	if j > 0:
		if abs(green_utc[j-1] - irt) < abs(green_utc[j] - irt):
			j -= 1
	
	# Check if ir timestamp is closer to the green timestamp to the right
	if j < len(green_utc)-1:
		if abs(green_utc[j+1] - irt) < abs(green_utc[j] - irt):
			j += 1
	
	# Make sure the timestamp difference is less than the tolerance before adding the matching indices to each list
	if abs(ir_utc[i] - green_utc[j]) < tolerance:
		ir_match.append(i)
		green_match.append(j)
	else:
		nomatch+=1

# Convert lists to numpy arrays
ir_match, green_match = map(np.array, [ir_match, green_match])

# Create plot to visualize matches
plt.plot(green_utc, 2*np.ones_like(green_utc), 'og', ms=15, label='Green returns') # plot green returns
plt.plot(ir_utc, 1*np.ones_like(ir_utc), 'or', ms=15, label='IR returns') # plot ir returns
plt.plot(green_utc[green_match], 0*np.ones_like(green_utc[green_match]), 'ob', ms=15, label='Matching returns') # plot matches
plt.gca().get_xaxis().get_major_formatter().set_useOffset(False) # remove offset from xaxis
plt.ylim([-0.2, 3]) # set y-axis limits manually
plt.yticks([]) # remove y-axis values
plt.title(ir_filename) # add filename to plot title
plt.xlabel('time/seconds_of_day (s)') # add x-axis label
plt.legend(numpoints=1) # add legend
plt.grid(True) # add gridlines
plt.show()
