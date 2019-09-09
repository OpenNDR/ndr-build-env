SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: lcovgen lcovhtml

.PHONY: depset
depset: mkdir

mkdir::
	@[ -d $(NBE_COVPATH) ] || mkdir -p $(NBE_COVPATH)
	@[ -d $(NBE_COVPATH)/$(COVERAGE) ] || mkdir -p $(NBE_COVPATH)/$(COVERAGE)

lcovgen::
	@lcov -c -d . -o $(COVERAGE)_raw.lcov
	@sed -i 's/-\([0-9]\+\)/\1/g' $(COVERAGE)_raw.lcov
	@lcov -e $(COVERAGE)_raw.lcov $(COVFILES) -o $(COVERAGE).lcov

lcovhtml::
	@genhtml -branch-coverage -o $(NBE_COVPATH)/$(COVERAGE) $(COVERAGE).lcov
