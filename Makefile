TESTS = $(shell find tests -maxdepth 2 -name Makefile.in | cut -d\/ -f2 | sort -u)
TEST ?= tests/onenet

root_dir:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

SURELOG_BIN = ${root_dir}/image/bin/surelog
YOSYS_BIN = ${root_dir}/image/bin/yosys
VERILATOR_BIN = ${root_dir}/image/bin/verilator
VCDDIFF_BIN = ${root_dir}/image/bin/vcddiff
COVARAGE_REPORT = ${root_dir}/build/coverage

TEST_DIR := $(root_dir)/$(TEST)
MAIN_FILE := $(TEST_DIR)/main.cpp
YOSYS_SCRIPT := $(TEST_DIR)/yosys_script

# this include should set $(TOP_FILE) and $(TOP_MODULE) variables
include $(TEST)/Makefile.in

# this variables use $(TOP_MODULE) that is set in included Makefile.in
VERILATED_BIN := V$(TOP_MODULE)
TOP_UHDM = ${root_dir}/build/$(TOP_MODULE).uhdm
TOP_MAKEFILE := V$(TOP_MODULE).mk
# SURELOG_FLAGS are empty by default, unless set in Makefile.in

list:
	@echo "Available tests:"
	@for TEST in $(TESTS); do echo "- tests/$$TEST"; done
	@echo "Please specify the TEST variable."

# ------------ Binaries build targets ------------

image/bin/verilator: | image/bin/surelog
	(cd ${root_dir}/verilator && autoconf && ./configure --prefix=$(root_dir)/image && $(MAKE) install)

image/bin/yosys: | image/bin/surelog
	(cd ${root_dir}/yosys && $(MAKE) PREFIX=$(root_dir)/image install)

image/bin/surelog:
	(cd ${root_dir}/Surelog && $(MAKE) PREFIX=${root_dir}/image release install)

image/bin/vcddiff:
	$(MAKE) -C vcddiff PREFIX=$(root_dir)/image
	mkdir -p $(root_dir)/image/bin
	cp -p vcddiff/vcddiff $(VCDDIFF_BIN)

prep: | image/bin/verilator image/bin/yosys image/bin/surelog image/bin/vcddiff

# ------------ Test targets ------------

uhdm/vcddiff: clean-build image/bin/vcddiff
	# Make sure verilator/test-ast and yosys/verilate-ast are not runned in parallel
	# when executed with -j flag
	$(MAKE) uhdm/verilator/test-ast
	$(MAKE) uhdm/yosys/verilate-ast
	$(VCDDIFF_BIN) $(root_dir)/dumps/dump_yosys.vcd $(root_dir)/dumps/dump_verilator.vcd

uhdm/verilator/test-ast: uhdm/verilator/test-ast-generate
	mkdir -p $(root_dir)/dumps
	mv $(root_dir)/build/dump.vcd $(root_dir)/dumps/dump_verilator.vcd

uhdm/yosys/test-ast: surelog/parse | image/bin/yosys
	(cd $(root_dir)/build && ${YOSYS_BIN} -s $(YOSYS_SCRIPT))

surelog/regression:
	(cd Surelog && $(MAKE) regression)

# ------------ Test helper targets ------------

surelog/parse: clean-build | image/bin/surelog
	(cd ${root_dir}/build && \
		${SURELOG_BIN} -parse -sverilog -d coveruhdm ${SURELOG_FLAGS} $(INCLUDE) $(TOP_FILE))
	cp ${root_dir}/build/slpp_all/surelog.uhdm ${TOP_UHDM}

uhdm/verilator/test-ast-generate:surelog/parse | image/bin/verilator
	(cd $(root_dir)/build && \
		$(VERILATOR_BIN) --uhdm-ast --cc $(TOP_UHDM) \
			--dump-uhdm \
			--exe $(MAIN_FILE) --trace && \
		 make -j -C obj_dir -f $(TOP_MAKEFILE) $(VERILATED_BIN) && \
		 obj_dir/$(VERILATED_BIN))

uhdm/yosys/verilate-ast: uhdm/yosys/test-ast uhdm/verilator/test-ast-generate | image/bin/verilator
	(cd $(root_dir)/build && \
		$(VERILATOR_BIN) --cc ./yosys.sv \
			--top-module \$(TOP_MODULE) \
			--exe $(MAIN_FILE) --trace && \
		 make -j -C obj_dir -f $(TOP_MAKEFILE) $(VERILATED_BIN) && \
		 obj_dir/$(VERILATED_BIN))
	mv $(root_dir)/build/dump.vcd $(root_dir)/dumps/dump_yosys.vcd

# ------------ Coverage targets ------------

uhdm/verilator/coverage: surelog/parse | image/bin/verilator
	(cd $(root_dir)/build && \
		$(VERILATOR_BIN) --uhdm-ast --cc $(TOP_UHDM) \
			--uhdm-cov uhdm.cov \
			--xml-only)
	python3 gen_coverage_report.py --verilator-uhdm $(root_dir)/build/uhdm.cov \
		--output-file $(root_dir)/build/coverage.out

uhdm/yosys/coverage: surelog/parse | image/bin/yosys
	(cd ${root_dir}/build && ${YOSYS_BIN} -p "read_uhdm -report ${COVARAGE_REPORT} ${TOP_UHDM}")

# ------------ Clean targets ------------

clean-build:
	rm -rf $(root_dir)/build
	mkdir -p $(root_dir)/build

clean: clean-build
	rm -rf $(root_dir)/image

cleanall: clean
	$(MAKE) -C verilator clean
	$(MAKE) -C Surelog clean
	$(MAKE) -C yosys clean
	$(MAKE) -C vcddiff clean

# ------------ Other targets ------------

surelog/parse-earlgrey: clean-build | image/bin/surelog
	(cd ${root_dir}/Surelog/third_party/tests/Earlgrey_0_1/sim-icarus && \
		${SURELOG_BIN} -f Earlgrey_0_1.sl \
	)
	cp ${root_dir}/Surelog/third_party/tests/Earlgrey_0_1/sim-icarus/slpp_all/surelog.uhdm ${TOP_UHDM}

surelog/ibex-verilator: clean-build | image/bin/surelog
	(cd ${root_dir}/Surelog/third_party/tests/Earlgrey_Verilator_0_1/sim-verilator && \
		${SURELOG_BIN} -f Earlgrey_Verilator_0_1.sl)
	cp ${root_dir}/Surelog/third_party/tests/Earlgrey_Verilator_0_1/sim-verilator/slpp_all/surelog.uhdm ${TOP_UHDM}

surelog/ibex-simplesystem: clean-build | image/bin/surelog
	(cd ${root_dir}/tests/ibex/ibex/build/lowrisc_ibex_ibex_simple_system_0/sim-verilator \
		${SURELOG_BIN} +define+VERILATOR \
			-f lowrisc_ibex_ibex_simple_system_0.vc \
			-parse -d coveruhdm -verbose)
	cp ${root_dir}/tests/ibex/ibex/build/lowrisc_ibex_ibex_simple_system_0/sim-verilator/slpp_all/surelog.uhdm ${TOP_UHDM}

uhdm/verilator/get-ast: clean-build | image/bin/verilator
	(cd $(root_dir)/build && \
		$(VERILATOR_BIN) --cc $(TOP_FILE) \
			--exe $(MAIN_FILE) --debug --xml-only)

uhdm/verilator/ast-xml: surelog/parse | image/bin/verilator
	(cd $(root_dir)/build && \
		$(VERILATOR_BIN) --uhdm-ast --cc $(TOP_UHDM) \
			--dump-uhdm \
			--debugi 6 \
			--exe $(MAIN_FILE) --xml-only)

vcd:
	gtkwave $(root_dir)/build/dump.vcd &>/dev/null &

surelog-ibex:
	${SURELOG_BIN} -f ibex_uhdm.txt
	cp ${root_dir}/slpp_all/surelog.uhdm top.uhdm

ibex-ci:
	$(VERILATOR_BIN) -f ibex_sv.txt
#	$(VERILATOR_BIN) --cc -sv \
#-Itests/ibex/ibex/build/lowrisc_ibex_ibex_simple_system_0/src/lowrisc_prim_assert_0.1/rtl/ \
#tests/ibex/ibex/build/lowrisc_ibex_ibex_simple_system_0/src/lowrisc_ibex_ibex_pkg_0.1/rtl/ibex_pkg.sv \
#tests/ibex/ibex/build/lowrisc_ibex_ibex_simple_system_0/src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_cs_registers.sv \
#tests/ibex/ibex/build/lowrisc_ibex_ibex_simple_system_0/src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_core.sv \
#tests/ibex/ibex/build/lowrisc_ibex_ibex_simple_system_0/src/lowrisc_ibex_ibex_simple_system_0/rtl/ibex_simple_system.sv \
#			--top-module ibex_simple_system \
#                        --exe tests/ibex/ibex/build/lowrisc_ibex_ibex_simple_system_0/src/lowrisc_ibex_ibex_simple_system_0/ibex_simple_system.cc --trace
#

