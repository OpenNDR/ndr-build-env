COV ?= $(NAME)

SUBCOMP += test
include $(NBE_DIR)/ndr.subcomp.mk

SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: $(ASMS) $(SRCS) savepath

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	#Output directories pre-init
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_COVPATH) ] || mkdir -p $(NBE_MK_COVPATH)
	@[ -d $(NBE_MK_COVPATH)/$(COV) ] || mkdir -p $(NBE_MK_COVPATH)/$(COV)
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)
	@[ -d $(NBE_COVPATH) ] || mkdir -p $(NBE_COVPATH)

$(HDRS)::
	@echo $@:$(SRCDIR):$(NBE_MK_INCPATH) >> $(NBE_PATHLOG_RESTORE)
	@cp -f $(SRCDIR)/$@ $(NBE_MK_INCPATH)

$(ASMS)::
	@gcc -c -o $(basename $@).raw.o $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS)
	@cp -f $(basename $@).raw.o $(NBE_MK_COVPATH)/$(COV)
	@cp -f $(basename $@).raw.o $(NBE_MK_COVPATH)/$(COV)/$(basename $@).cov.o

$(SRCS)::
	@gcc -c -o $(basename $@).raw.o $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS)
	@cp -f $(basename $@).raw.o $(NBE_MK_COVPATH)/$(COV)
	@echo $@:$(SRCDIR):$(NBE_MK_COVPATH)/$(COV) >> $(NBE_PATHLOG_RESTORE)
	@gcc -c -o $(basename $@).cov.o $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS) -fprofile-arcs -ftest-coverage
	@cp -f $(basename $@).cov.o $(NBE_MK_COVPATH)/$(COV)
	@cp -f $(basename $@).cov.gcno $(NBE_MK_COVPATH)/$(COV)
	@cp -f $(SRCDIR)/$@ $(NBE_MK_COVPATH)/$(COV)

savepath::
	@echo -n $(SRCDIR) >> $(NBE_MK_COVPATH)/$(COV)/source.path
	@echo -n $(shell pwd) >> $(NBE_MK_COVPATH)/$(COV)/build.path
