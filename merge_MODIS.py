import xarray as xr
import glob

def merge_var(var):
  ### Find all files and sort
  file_paths = glob.glob('MODIS*'+var+'*.nc')
  file_paths.sort()
  
  ### Grab time info from file name
  timestamps = [file_path[6:-3] for file_path in file_paths]
  
  ### Add additional month
  timestamps.append('2023-01')
  
  ### Create xarray dataset with all ind. datasets
  datasets = [xr.open_dataset(file_path) for file_path in file_paths]
  
  ### Assign time dimension to each dataset
  for i, ds in enumerate(datasets):
      time = xr.cftime_range(timestamps[i],timestamps[i+1],
                             freq='M')
      ds['time'] = time
  
  ### Concatenate datasets along time dimension
  combined_dataset = xr.concat(datasets, dim='time')
  
  ### Save to netCDF
  combined_dataset.to_netcdf('MODIS_'+var+'_2001-2022.nc',
                             encoding={'time':{'dtype': 'double'},
                                       'latitude':{'dtype': 'double'},
                                       'longitude':{'dtype': 'double'},
                                       var:{'dtype': 'float32'}})

merge_var('count')
merge_var('FRP')
