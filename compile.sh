#!/bin/sh

export deepmd_root=/deepmd_root
export tensorflow_root=/tensorflow_root
export LD_LIBRARY_PATH=$deepmd_root/lib:$tensorflow_root/lib:$LD_LIBRARY_PATH

g++ -c c_wrapper.cpp -I$deepmd_root/include/deepmd -I$tensorflow_root/include -DHIGH_PREC
gfortran -c deepmd_wrapper.f90
gfortran -c fortran_call.f90
gfortran -o fortran_call c_wrapper.o deepmd_wrapper.o fortran_call.o -lstdc++ -L$deepmd_root/lib -L$tensorflow_root/lib -Wl,--no-as-needed -ldeepmd_op -ldeepmd -ltensorflow_cc -ltensorflow_framework -Wl,-rpath,$deepmd_root/lib -Wl,-rpath,$tensorflow_root/lib