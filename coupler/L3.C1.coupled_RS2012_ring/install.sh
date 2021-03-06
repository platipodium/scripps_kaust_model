#!/bin/sh
export MITGCM_DIR=${SKRIPS_DIR}/MITgcm_c67m

read -e -p "WRF413 (with OA coupling) location? :" -i "${SKRIPS_DIR}/WRFV413_AO/" wrfLocation
read -e -p "ESMF location? :" -i "${SKRIPS_DIR}/esmf/" esmfLocation

read -e -p "Using intel compiler? (Y/N) :" -i "N" intelFlag
if [ $intelFlag == 'Y' ]; then
  echo "Using intel compiler"
  export MITGCM_OPT=mitgcm_optfile.ifort
else 
  echo "Using default PGI compiler"
  export MITGCM_OPT=mitgcm_optfile.pgi
fi
echo "The option file is: $MITGCM_OPT"

# build the MITGCM as an executable
mkdir build_mit code_mit
cp utils/* build_mit/ # copy the scripts to install MITGCM
cp mitCode/* code_mit/ # copy the scripts to install MITGCM
cp mitSettingRS/* code_mit/ # copy the scripts to install MITGCM
rm code_mit/exf_get* # remove the exf_get file so that MITGCM read the file input
rm code_mit/main.F # remove the main file
cd build_mit
sed -i s/code/code_mit/g makescript_fwd.sio.ring
./makescript_fwd.sio.ring ${MITGCM_DIR} # install MITGCM, generate *.f files
cd ..

# build the MITGCM as a library
mkdir build code
cp utils/* build/ # copy the scripts to install MITGCM
cp mitCode/* code/ # copy the scripts to install MITGCM
cp mitSettingRS/* code/ # copy the scripts to install MITGCM
cd build
./makescript_fwd.sio.ring ${MITGCM_DIR} # install MITGCM, generate *.f files

cp ${SKRIPS_MPI_DIR}/include/mpif* . 
./mkmod.sh ocn # install MITGCM as a library, generate *.mod files
cd ..

# build the test coupler
cd coupledCode
./Allmake.sh
cd ..

if [ -f ./coupledCode/esmf_application ]; then
  echo "Installation is successful!"
  echo The coupled model is installed as ./coupledCode/esmf_application
else 
  echo ERROR! Installation is NOT successful!
fi
