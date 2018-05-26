#!/bin/sh
set -ex

export TOOLDIR=$(pwd)/tooldir

./build.sh -Uu -j8 -N0 -mamd64 -T ${TOOLDIR} makewrapper
_make=${TOOLDIR}/bin/nbmake-amd64

# blehh
${_make} do-top-obj do-tools-obj

# tools/Makefile says that you must build these programs in this order:
${_make} -C tools dependall-host-mkdep dependall-compat dependall-binstall
${_make} -C tools/host-mkdep install
${_make} -C tools/compat install
${_make} -C tools/binstall install

# OK now we can build whatever we want
${_make} -C tools/mtree install
${_make} -C tools/lex install
${_make} -C tools/yacc install
${_make} -C tools/awk install
${_make} -C tools/cat install
${_make} -C tools/sed install
${_make} -C tools/m4 install
${_make} -C tools/pax install
${_make} -C tools/join install
