import xarray as xr
import numpy as np
import pandas as pd

import argparse

### You can pass the variable you want to extract as an argument
parser = argparse.ArgumentParser()
parser.add_argument('--var', type=str, required=True)
args = parser.parse_args()

### Define leap years, months with 31 and months with 30 days
leap_years = ['1940', '1944', '1948', '1952', '1956', '1960', 
              '1964', '1968', '1972', '1976', '1980', '1984', 
              '1988', '1992', '1996', '2000', '2004', '2008', 
              '2012','2016','2020']
months_31day = ['01','03','05','07','08','10','12']
months_30day = ['04','06','09','11']

### Location of files
pathwayIN='/g/data/rt52/era5/single-levels/reanalysis/'

def readin_file(var,year,month):
    ### Very clunky sorry
    if month in months_31day:
        suffix = '31.nc'
    elif month in months_30day:
        suffix = '30.nc'
    elif month == '02':
        if year in leap_years:
            suffix = '29.nc'
        else:
            suffix = '28.nc'

    ### Filename of raw data
    if var == 'wind':
        fileIN = pathwayIN+var+'/'+year+'/'+var+'_era5_wave_sfc_'+year+month+'01-'+year+month+suffix
    else:
        fileIN = pathwayIN+var+'/'+year+'/'+var+'_era5_oper_sfc_'+year+month+'01-'+year+month+suffix

    ### Define file name to write data to
    fileOUT = var+'/'+year+'/'+var+'_era5_oper_sfc_'+year+month+'01-'+year+month+suffix

    ### Open netCDF with xarray
    ds = xr.open_dataset(fileIN, mask_and_scale = True).sel(latitude=slice(-10,-44),
                                                            longitude=slice(110,155))
  
    ### Get land-sea mask - constant throughout each year
    first_timestamp = ds.time.min()
    ds_mask = xr.open_dataset(pathwayIN+'lsm/'+year+
                              '/lsm_era5_oper_sfc_'+year+month+'01-'+year+month+suffix).sel(latitude=slice(-10,-44),
                                                                                            longitude=slice(110,155),
                                                                                            time=first_timestamp)
    
    ### Mask ocean points
    ds_masked = xr.where(ds_mask.lsm !=0, ds,np.nan)

    ### Reorganise dimension to be CF-compliant
    ds_masked = ds_masked.transpose('time','latitude','longitude')

    ### Save as netCDF
    ds_masked.to_netcdf(fileOUT)

### Generate list of years
years = np.arange(1949,2024,1).astype(str)

### Generate list of months
months = np.arange(1,13,1).astype(str)

### Add leading zero
for i in range(0,10):
    months[i] = months[i].zfill(2)

'''
Variables of interest?
sp surface pressure
msl mean sea level pressure
10u 10m wind u component
10v 10m wind v component
mtpr mean total precip rate kg m-2 s-1
mx2t max temp
mn2t min temp
cape 
swvl1 upper layer soil moisture
'''

var = args.var

## Loop through years and months
for year in years:
    print(year)
    for month in months:
        print(month)
        readin_file(var,year,month)
