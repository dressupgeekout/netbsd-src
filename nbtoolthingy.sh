#!/bin/sh
set -ex

./build.sh -Uu -j8 -N0 -mamd64 makewrapper
_make=./obj/tooldir.Darwin-17.4.0-x86_64/bin/nbmake-amd64

# blehh
${_make} do-top-obj do-tools-obj

# tools/Makefile says that you must build these programs in this order:
${_make} -C tools dependall-host-mkdep dependall-compat dependall-binstall
${_make} -C tools/host-mkdep install
${_make} -C tools/compat install
${_make} -C tools/binstall install

${_make} -C tools/mtree install
