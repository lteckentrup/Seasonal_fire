import xarray as xr 
import numpy as np

### Saturation vapour pressure
def svp(var):
    svp = 6.112*(np.exp(17.67 * (var - 273.15) / (var - 29.65)))
    return(svp)

### Calculate VPD
def get_vpd(T,Td):
    e = svp(Td)
    e_s = svp(T)
    return (e_s-e)

def calc_vpd(year,mon):
    ### Get 2m dewpoint temperature
    ds_Td = xr.open_mfdataset('/g/data/rt52/era5/single-levels/reanalysis/2d/'+
                              year+'/2d_era5_oper_sfc_'+year+mon+'*.nc').sel(latitude=slice(-10,-44),
                                                                             longitude=slice(110,155))
    ### Get 2m temperature
    ds_T = xr.open_mfdataset('/g/data/rt52/era5/single-levels/reanalysis/2t/'+
                             year+'/2t_era5_oper_sfc_'+year+mon+'*.nc').sel(latitude=slice(-10,-44),
                                                                            longitude=slice(110,155))

    ### Dimensions
    time = ds_T.time
    lat = ds_T.latitude
    lon = ds_T.longitude

    ### Calculate VPD
    vpd = get_vpd(ds_T['t2m'].values,ds_Td['d2m'].values)

    ### Convert numpy matrix to xarray DataArray
    da_vpd = xr.DataArray(vpd, 
                          dims=('time','latitude','longitude'),
                          coords={'time': time,
                                  'latitude':lat,
                                  'longitude':lon},
                          attrs={'units': 'mb', 
                                 'long_name' : 'vapor pressure deficit'})

    ### Convert DataArray to DataSet
    ds_vpd = da_vpd.to_dataset(name='vpd')

    ### Sort attributes
    ds_vpd.time.encoding = {'units': 'hours since 1900-01-01', 
                            'calendar': 'gregorian',
                            'long_name' : 'time'}

    ### Sort latitude and longitude
    ds_vpd['latitude'].attrs={'units':'degrees_north', 
                              'long_name':'latitude'}
    ds_vpd['longitude'].attrs={'units':'degrees_east', 
                               'long_name':'longitude'}

    ### Save as netCDF
    ds_vpd.to_netcdf('vpd/'+year+'/vpd_era5_oper_sfc_'+year+mon+'.nc',
                    encoding={'time':{'dtype': 'double'},
                              'latitude':{'dtype': 'double'},
                              'longitude':{'dtype': 'double'},
                              'vpd':{'dtype': 'float32'}})

### Years
years = np.arange(1940,2024,1).astype(str)

### Months
months = np.arange(1,13,1).astype(str)
### Add leading zero
for i in range(0,10):
    months[i] = months[i].zfill(2)
    
for year in years:
    print(year)
    for month in months:
        print(month)
        calc_vpd(year,month)
