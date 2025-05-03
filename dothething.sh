git clean -xdf
autoreconf -fvi

# Force the times‐header off + override GS_LIB_DEFAULT in one go:
# export CFLAGS="-DHAVE_SYS_TIMES_H=0 -DHAVE_FUNC_TIMES=0"
# export CPPFLAGS='-DGS_LIB_DEFAULT="\"/mingw64/share/ghostpdl\""' 


#  -O2 -Wall
export CFLAGS="-DHAVE_SYS_TIMES_H=0 -DHAVE_FUNC_TIMES=0 -DGS_LIB_DEFAULT=\"/mingw64/share/ghostpdl\""

./configure --prefix=/mingw64
make -j"$(nproc)"
make install
