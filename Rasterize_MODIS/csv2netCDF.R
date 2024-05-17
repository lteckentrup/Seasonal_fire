library(raster)
library(data.table)

## Read in csv file
data_raw <- fread('fire_archive_M-C61_378340.csv')

## Define function to generate monthly sums of fire counts on 0.25 grid

get_monthly_sum <- function(data,date){
    ### Select timestep
    data_subset <- subset(data, format(as.Date(acq_date), "%Y-%m") == date)

    ### Select high confidence detections
    data_conf <- subset(data_subset, confidence >= 80)

    ### Set points where FRP greater than 0 to 1 (= fire hotspot)
    data_conf$frp[data_conf$frp > 0] <- 1

    ### Create SpatialPointsDataFrame
    coordinates(data_conf) <- c('longitude', 'latitude')
    proj4string(data_conf) <- CRS('+proj=longlat +datum=WGS84')

    ### Extent of your grid - match ERA5
    ext <- extent(109.875,155.125,-44.125,-9.875)

    ### Create raster grid
    resolution <- c(0.25, 0.25)  # Change resolution as needed
    raster_grid <- raster(ext, res = resolution)

    ### Grab FRP and rasterize
    frp_rasterized <- rasterize(data_conf,
                                raster_grid,
                                field = data_conf$frp,
                                fun = 'sum')

    ### Write to netCDF
    writeRaster(frp_rasterized,
                paste('MODIS','_count_',date,sep=''),
                format = 'CDF',
                varname = 'count',
                overwrite=TRUE)
    }

### Loop through all years and months
start_year <- 2001
end_year <- 2022

for (year in start_year:end_year) {
  for (month in 1:12) {
    current_date <- sprintf('%04d-%02d', year, month)
    get_monthly_sum(data_raw, current_date)
  }
}
