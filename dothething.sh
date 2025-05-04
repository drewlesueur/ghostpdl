#!/usr/bin/env bash

# git clean -xdf
# autoreconf -fvi
# 
# # Force the times‐header off + override GS_LIB_DEFAULT in one go:
# # export CFLAGS="-DHAVE_SYS_TIMES_H=0 -DHAVE_FUNC_TIMES=0"
# # export CPPFLAGS='-DGS_LIB_DEFAULT="\"/mingw64/share/ghostpdl\""' 
# 
# 
# #  -O2 -Wall
# export CFLAGS="-DHAVE_SYS_TIMES_H=0 -DHAVE_FUNC_TIMES=0 -DGS_LIB_DEFAULT=\"/mingw64/share/ghostpdl\""
# 
# ./configure --prefix=/mingw64
# make -j"$(nproc)"
# make install

set -euo pipefail

# don't convert /mingw64/whatever to C:\mingw64\whatever
export MSYS2_ARG_CONV_EXCL="*"
export MSYS2_ENV_CONV_EXCL='*'
# this does both
export MSYS2_NO_PATHCONV=1


# 1) Clean out any old build artifacts
git clean -xdf

# 2) Re-gen the autotools scripts
autoreconf -fvi


export MSYS2_ARG_CONV_EXCL="*"
export MSYS2_ENV_CONV_EXCL='*'
# this does both
export MSYS2_NO_PATHCONV=1


# 3) Disable <sys/times.h> and times() tests
export CFLAGS="-DHAVE_SYS_TIMES_H=0 -DHAVE_FUNC_TIMES=0"

# 4) Configure for a /mingw64 install
./configure \
  --prefix=/mingw64 \
  --cache-file=/dev/null

# 5) Build everything
make -j"$(nproc)"

# 6) Patch gconfigd.h: 
#    - Replace the Windows‐style prefix (C:\msys64\mingw64) with /mingw64
#    - Then turn all remaining backslashes into forward‐slashes
# sed -i \
#   -e 's#C:\\msys64\\mingw64#/mingw64#g' \
#   -e 's#\\#/#g' \
#   obj/gconfigd.h

# 7) Recompile the two objects that pull in gconfigd.h
# make -j"$(nproc)" obj/gconfig.o obj/gscdefs.o

# 8) Install into /mingw64
make install

echo "GhostPDL built & installed under /mingw64 with clean POSIX paths"

