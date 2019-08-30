SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: lcovlist lcovgen lcovhtml

.PHONY: depset
depset: mkdir

mkdir::
	@[ -d $(NBE_COVPATH) ] || mkdir -p $(NBE_COVPATH)
	@[ -d $(NBE_COVPATH)/$(COVAPP) ] || mkdir -p $(NBE_COVPATH)/$(COVAPP)

lcovlist::
	$(eval LCOVLIST += $(foreach COVFILE, $(COVLIST), $(shell ls $(NBE_MK_COVPATH)/$(COVFILE).c 2>/dev/null)))
	$(eval LCOVLIST += $(foreach COVFILE, $(COVLIST), $(shell ls $(NBE_MK_COVPATH)/$(COVFILE).cc 2>/dev/null)))

lcovgen::
	@echo $(LCOVLIST)
	@lcov -c -d . -o $(COVAPP)_raw.lcov
	@sed -i 's/-\([0-9]\+\)/\1/g' $(COVAPP)_raw.lcov
	@lcov -e $(COVAPP)_raw.lcov $(LCOVLIST) -o $(COVAPP).lcov

lcovhtml::
	@genhtml -branch-coverage -o $(NBE_COVPATH)/$(COVAPP) $(COVAPP).lcov
