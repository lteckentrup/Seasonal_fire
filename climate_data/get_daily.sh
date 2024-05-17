### In ERA5, you need to include the last timestep of the previous day for your daily aggregates: 
### -shifttime,-1sec

echo mn2t
cdo -L -b F64 -setunit,C -selyear,1950/2023 -daymin -shifttime,-1sec -subc,273.15 -mergetime mn2t/*/*nc \
                                                                                             mn2t/mn2t_era5_oper_sfc_1950-2023.nc
echo mx2t
cdo -L -b F64 -setunit,C -selyear,1950/2023 -daymax -shifttime,-1sec -subc,273.15 -mergetime mx2t/*/*nc \
                                                                                             mx2t/mx2t_era5_oper_sfc_1950-2023.nc
echo msl
cdo -L -b F64 -setunit,Pa -selyear,1950/2023 -daymean -shifttime,-1sec -mergetime msl/*/*nc \
                                                                                  msl/msl_era5_oper_sfc_1950-2023.nc
echo sp
cdo -L -b F64 -setunit,Pa -selyear,1950/2023 -daymean -shifttime,-1sec -mergetime sp/*/*nc \
                                                                                  sp/sp_era5_oper_sfc_1950-2023.nc
echo mtpr
cdo -L -b F64 -setunit,mm -selyear,1950/2023 -daysum -shifttime,-1sec -mulc,3600 -mergetime mtpr/*/*nc \
                                                                                            mtpr/mtpr_era5_oper_sfc_1950-2023.nc
echo swvl1
cdo -L -b F64 -setunit,'m**3 m**-3' -selyear,1950/2023 -daymean -shifttime,-1sec -mergetime swvl1/*/*nc \
                                                                                            swvl1/swvl1_era5_oper_sfc_1950-2023.nc
echo winddir
cdo -L -b F64 -setunit,degree -selyear,1950/2023 -daymin -shifttime,-1sec -mergetime winddir/*/*nc \
                                                                                     winddir/winddir_era5_oper_sfc_1950-2023.nc
echo windspeed
cdo -L -b F64 -setunit,'m s**-1' -selyear,1950/2023 -daymean -shifttime,-1sec -mergetime windspeed/*/*nc \
                                                                                         windspeed/windspeed_era5_oper_sfc_1950-2023.nc
echo vpd
cdo -L -b F64 -setunit,hPa -selyear,1950/2023 -daymean -shifttime,-1sec -mergetime vpd/*/*nc \
                                                                                   vpd/vpd_era5_oper_sfc_1950-2023.nc
echo cape
cdo -L -b F64 -setunit,'J kg**-1' -selyear,1950/2023 -daymean -shifttime,-1sec -mergetime cape/*/*nc \
                                                                                          cape/cape_era5_oper_sfc_1950-2023.nc

cdo -L -b F64 -monmean mn2t/mn2t_era5_oper_sfc_1950-2023.nc mn2t/mn2t_era5_oper_sfc_1950-2023_mon.nc
cdo -L -b F64 -monmean mx2t/mx2t_era5_oper_sfc_1950-2023.nc mx2t/mx2t_era5_oper_sfc_1950-2023_mon.nc
cdo -L -b F64 -monmean msl/msl_era5_oper_sfc_1950-2023.nc msl/msl_era5_oper_sfc_1950-2023_mon.nc
cdo -L -b F64 -monmean sp/sp_era5_oper_sfc_1950-2023.nc sp/sp_era5_oper_sfc_1950-2023_mon.nc
cdo -L -b F64 -monsum mtpr/mtpr_era5_oper_sfc_1950-2023.nc mtpr/mtpr_era5_oper_sfc_1950-2023_mon.nc
cdo -L -b F64 -monmean swvl1/swvl1_era5_oper_sfc_1950-2023.nc swvl1/swvl1_era5_oper_sfc_1950-2023_mon.nc
cdo -L -b F64 -monmean winddir/winddir_era5_oper_sfc_1950-2023.nc winddir/windir_era5_oper_sfc_1950-2023_mon.nc
cdo -L -b F64 -monmean windspeed/windspeed_era5_oper_sfc_1950-2023.nc windspeed/windspeed_era5_oper_sfc_1950-2023_mon.nc
cdo -L -b F64 -monmean vpd/vpd_era5_oper_sfc_1950-2023.nc vpd/vpd_era5_oper_sfc_1950-2023_mon.nc
cdo -L -b F64 -monmean cape/cape_era5_oper_sfc_1950-2023.nc cape/cape_era5_oper_sfc_1950-2023_mon.nc
