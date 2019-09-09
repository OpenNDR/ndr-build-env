$(DPDKCOV) ?= $(NAME)

SUBCOMP += test
include $(NBE_DIR)/ndr.subcomp.mk

SRCDIR := $(NBE_ROOT)/$S
LDFLAGS += --as-needed -ldl
CFLAGS += -O0
CFLAGS += -g

.PHONY: build
build: $(DEPLIBS) $(SRCS) buildlist buildtest gcovlist gcovgen gcovcp

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	@[ -d $(NBE_COVPATH) ] || mkdir -p $(NBE_COVPATH)
	@[ -d $(NBE_COVPATH)/$(DPDKCOV) ] || mkdir -p $(NBE_COVPATH)/$(DPDKCOV)
	@[ -d $(NBE_MK_DPDKPATH) ] || mkdir -p $(NBE_MK_DPDKPATH)

$(HDRS)::
	@echo $@:$(SRCDIR):$(NBE_MK_INCPATH) >> $(NBE_LOG_PATHLOG)
	@cp -f $(SRCDIR)/$@ $(NBE_MK_INCPATH)

$(DEPLIBS)::
	$(eval LIBLIST += $(addprefix -l,$@))

$(SRCS)::
	$(eval BUILDLIST += $(SRCDIR)/$@)

buildlist::
	$(eval BUILDLIST += $(wildcard $(NBE_MK_COVPATH)/*.c))
	$(eval BUILDLIST += $(wildcard $(NBE_MK_COVPATH)/*.cc))
	$(eval BUILDLIST += $(wildcard $(NBE_MK_COVPATH)/*.s))
	$(eval BUILDLIST += $(wildcard $(NBE_MK_COVPATH)/*.S))
	$(eval BUILDLIST += $(wildcard $(NBE_MK_COVPATH)/*.asm))

buildtest::
	@[ -d $(NBE_DPDKPATH) ] && cp -Lr $(NBE_DPDKPATH)/include/* $(NBE_MK_DPDKPATH)/.
	@[ -d $(NBE_DPDKPATH) ] && cp -Lr $(NBE_DPDKPATH)/lib/* $(NBE_MK_DPDKPATH)/.
	@gcc -coverage -o $(DPDKCOV)_cov $(BUILDLIST) -I$(SRCDIR) -I$(NBE_INCPATH) -I$(NBE_MK_DPDKPATH) -I$(NBE_MK_INCPATH) -L$(NBE_LIBPATH) -L$(NBE_MK_DPDKPATH) $(NBE_LIBS) $(NBE_DPDKLIBS) $(LIBLIST) $(CFLAGS) $(EXTRA_CFLAGS) -DNTS_MAIN_$(DPDKCOV)
	@gcc -o $(DPDKCOV).app $(BUILDLIST) -I$(SRCDIR) -I$(NBE_INCPATH) -I$(NBE_MK_DPDKPATH) -I$(NBE_MK_INCPATH) -L$(NBE_LIBPATH) -L$(NBE_MK_DPDKPATH) $(NBE_LIBS) $(NBE_DPDKLIBS) $(LIBLIST) $(CFLAGS) $(EXTRA_CFLAGS) -DNTS_MAIN_$(DPDKCOV)

gcovlist::
	$(eval GCOVLIST += $(foreach COVFILE, $(COVLIST), $(shell ls $(NBE_MK_COVPATH)/$(COVFILE).c 2>/dev/null)))
	$(eval GCOVLIST += $(foreach COVFILE, $(COVLIST), $(shell ls $(NBE_MK_COVPATH)/$(COVFILE).cc 2>/dev/null)))

gcovgen::
	@cp -f $(DPDKCOV).app $(NBE_COVPATH)/$(DPDKCOV).app
	@./$(DPDKCOV)_cov $(TESTARGS) > $(DPDKCOV).result 2>&1
	@cp -f $(DPDKCOV).result $(NBE_COVPATH)/$(DPDKCOV).result
	@gcov $(GCOVLIST) -o .

gcovcp::
	@cp -f $(foreach GCOVFILE, $(GCOVLIST), ./$(notdir $(GCOVFILE)).gcov) $(NBE_COVPATH)/$(DPDKCOV)
	@$(NBE_SCRIPTS)/restore_source.sh $(NBE_LOG_PATHLOG) $(NBE_COVPATH)/$(DPDKCOV)
