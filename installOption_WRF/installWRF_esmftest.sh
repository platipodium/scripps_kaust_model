echo "installing WRF"
WRF_PWD_DIR=${PWD}
cd WRFV3_esmf
echo "WRF_PWD_DIR is: ${WRF_PWD_DIR}"
WRF_OPTION_DIR=${WRF_PWD_DIR}/installOption_WRF/wrfESMFtestImplementations/

echo "Deleting old configure file..."
rm -rf configure.wrf

# WRF configure=50, then nesting=1
echo "choosing 50th option to compile WRF"
echo "nesting option is 1 (normal)"
printf '50\n1\n' | ./configure &> log.configure

echo "copying other files to compile ESMF--WRF"
ln -sf ${WRF_OPTION_DIR}/Makefile.main main/Makefile
ln -sf ${WRF_OPTION_DIR}/wrf_test_ESMF.F main/
ln -sf ${WRF_OPTION_DIR}/Makefile.wrf Makefile
ln -sf ${WRF_OPTION_DIR}/makefile.io_netcdf external/io_netcdf/makefile
ln -sf ${WRF_OPTION_DIR}/module_domain.F frame/
ln -sf ${WRF_OPTION_DIR}/ext_esmf_write_field.F90 external/io_esmf/
ln -sf ${WRF_OPTION_DIR}/configure.wrf configure.wrf

echo "compiling WRFv3.6"
./compile em_real &> log.em_real
cd ../
