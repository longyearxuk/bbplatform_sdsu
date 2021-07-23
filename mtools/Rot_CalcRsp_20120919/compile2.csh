#!/bin/csh

echo "Starting compiling..."
echo "with gfortran"

###compiles without linking the raytracer C-code
###icc -w -c ray3DJHfor.c

#compiles and links the whole Fortran95 codes

set CODE = 'calcrsp.f fftsub.f ft_th.f rotD50.f sort.f spline.f splint.f'
set TARGET = 'RotD50Fast'

gfortran $CODE -o $TARGET

echo "$TARGET is created"
#echo ''
#echo "$TARGET runs"
#./$TARGET
#echo "DONE"
