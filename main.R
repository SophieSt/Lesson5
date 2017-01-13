# Team: Kraftfahrzeug-Haftpflichtversicherung
# Authors: Felten, Bettina; Stuhler, Sophie C.
# Date: 13-01-2017

# Assignment on Lesson 5
# This file is meant to provide a pre-processing chain for Landsat 5 and 8 data in order to compare the NDVI of two images of the same area.


# Import packages
library(rgdal)
library(raster)

# Load datasets, might cause some troubles under Windows, if ever you encounter these, try manual download
download.file(url = 'https://www.dropbox.com/s/i1ylsft80ox6a32/LC81970242014109-SC20141230042441.tar.gz?dl=0', destfile = 'data/Landsat8', method = 'wget')
download.file(url = 'https://www.dropbox.com/s/akb9oyye3ee92h3/LT51980241990098-SC20150107121947.tar.gz?dl=0', destfile = 'data/Landsat5', method = 'wget')

# Source functions:
source('R/NDVI_preprocessing.R')

# Show some intermediate and final results
plot(L8_ndvi_masked) # The NDVI calculated from Landsat raw data, with cloud mask
plot(L5_ndvi_masked)


plot(ndvi_wageningen) # NDVI of the different years for the overlapping area in one stack object for direct comparison

plot(difference) # Difference between the two images. Positive values: Increase, negative values: Decrease

