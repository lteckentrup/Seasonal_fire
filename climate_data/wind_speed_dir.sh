### Parallelise computing wind speed and direction
N=6

for year in {1940..2023..1}; do
    echo ${year}
    for mon in {01..12..1}; do
        ((i=i%N)); ((i++==0)) && wait
        echo ${mon}
        echo 'Wind direction'
        cdo -L -b F64 -chname,u10,winddir -mulc,57.3 -atan2 10u/${year}/10u_era5_oper_sfc_${year}${mon}* \
                                                            10v/${year}/10v_era5_oper_sfc_${year}${mon}* \
                                                            winddir/${year}/winddir_era5_oper_sfc_${year}${mon}.nc &
    done
done


for year in {1940..2023..1}; do
    echo ${year}
    for mon in {01..12..1}; do
        ((i=i%N)); ((i++==0)) && wait
        echo ${mon}
        echo 'Wind speed'
        cdo -L -b F64 -chname,u10,windspeed -sqrt -add -sqrt -selname,u10 10u/${year}/10u_era5_oper_sfc_${year}${mon}* \
                                                       -sqrt -selname,v10 10v/${year}/10v_era5_oper_sfc_${year}${mon}* \
                                                                          windspeed/${year}/windspeed_era5_oper_sfc_${year}${mon}.nc &
    done
done
