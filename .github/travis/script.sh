#!/bin/bash

set -x
set -e

# Default is to run tests.
MODE=${MODE:-test}

case $MODE in
    surelog-uhdm)
	make -j $(nproc) surelog/regression
	;;

    cache-verilator)
	make -j $(nproc) ENABLE_READLINE=0 PRETTY=0 surelog uhdm/verilator/build
	;;

    cache-yosys)
	make -j $(nproc) ENABLE_READLINE=0 PRETTY=0 surelog yosys/yosys
	;;

    test)
	make -j $(nproc) ENABLE_READLINE=0 PRETTY=0 TEST=$TEST_CASE $TARGET
	;;

    *)
	echo "script.sh: Unknown mode $MODE"
	exit 1
	;;
esac
