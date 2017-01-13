# Unpacking the files
untar('data/Landsat8.gz', exdir='data/L8') # Landsat8 data, 2014-04-19
untar('data/Landsat5.gz', exdir='data/L5') # Landsat5 data, 1990-04-08

# Stacking the bands 
list_L8 <- list.files(path='data/L8', pattern = glob2rx('*.tif'), full.names = TRUE)
list_L5 <- list.files(path='data/L5', pattern = glob2rx('*.tif'), full.names = TRUE)

L8 <- stack(list_L8)
L5 <- stack(list_L5)

# Calculate the respective NDVI
calc_ndvi <- function(nir, red) {
  ndvi <- (nir - red) / (nir + red)
  return(ndvi)
}

ndvi_L8 <- overlay(x=L8[['LC81970242014109LGN00_sr_band5']], y=L8[['LC81970242014109LGN00_sr_band4']], fun=calc_ndvi) 
ndvi_L5 <- overlay(x=L5[['LT51980241990098KIS00_sr_band4']], y=L5[['LT51980241990098KIS00_sr_band3']], fun=calc_ndvi)

# Mask out the clouds
mask_clouds <- function(layer, mask) {
  layer[mask!=0] <- NA
  return(layer)
}

L8_ndvi_masked <- overlay(x=ndvi_L8, y=L8[['LC81970242014109LGN00_cfmask']], fun=mask_clouds)
L5_ndvi_masked <- overlay(x=ndvi_L5, y=L5[['LT51980241990098KIS00_cfmask']], fun=mask_clouds)

# Reduce data to the overlapping areas
l8_final <- intersect(L8_ndvi_masked, L5_ndvi_masked)
l5_final <- intersect(L5_ndvi_masked, L8_ndvi_masked)

# Create a multi-layer file for easy comparison
ndvi_wageningen <- stack(l8_final, l5_final)

# Subtract the earlier NDVI (April 1990) from the later NDVI (April 2014) for a comparison
difference <- l8_final - l5_final
writeRaster(difference, filename='output/NDVI_Change.tif', overwrite=TRUE, datatype='FLT4S')
