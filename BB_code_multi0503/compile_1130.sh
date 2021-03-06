#!/bin/csh

echo "Starting compiling..."

set CODE = 'main_bbtoolbox_0315_corr.f90 coda_lenupdate0421.f90 composition_lenupdate0421_corr_rupspeed.f90 convolution_lenupdate0421.f90 correlation_lenupdate_corr.f90 fourier.f90 error.f90 geometry.f90 io_verbose1121.f90 random.f90 scattering_0328_corr.f90 source_dreg1121.f90 integ_diff.f90 filtering.f90 ray3DJHfor.o interpolation_lenupdate0421.f90'
set MODULE = 'module_bbtoolbox_dreg1121.f90 module_interface_corr.f90'

gcc -w -c ray3DJHfor.c

gfortran -g $MODULE $CODE -o BBtoolbox-dreg1121.exe

rm -f *.mod *.o
