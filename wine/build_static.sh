#!/usr/bin/env bash

# This script will download the libusb source code
# and compile the setupapi.dll linking against the static version of libusb.
# This is useful when libusb-1.0.so shipped with your Linux distro
# was compiled with SSE instruction set enabled.
# The SSE opcodes require the ram address to be aligned to 16 bytes boundary,
# while our library use a 4 bytes alignment compatible with windows software.
# This will prevent a segfault when any of libusb functions is invoked.


cd "$(dirname "$0")"
mkdir libusb && cd libusb
git clone https://github.com/libusb/libusb.git . && mkdir build && cd build
../bootstrap.sh  && ../configure CFLAGS="-m32 -mstackrealign -fPIC" --prefix="$(pwd)" --disable-shared && make install && cd ../../
make clean && make CFLAGS="-m32 -mstackrealign" LIBS="-Wl,--whole-archive libusb/build/lib/libusb-1.0.a -Wl,--no-whole-archive -ludev"
