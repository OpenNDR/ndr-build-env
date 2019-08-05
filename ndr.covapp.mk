SUBCOMP += test
include $(NBE_DIR)/ndr.subcomp.mk
include $(NBE_DIR)/ndr.coverage.mk

SRCDIR := $(NBE_ROOT)/$S
LDFLAGS += --as-needed -ldl
CFLAGS += -O0
CFLAGS += -g

.PHONY: build
build: $(DEPLIBS) $(SRCS) buildlist buildtest covlist gencov delcov mvcov

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	@[ -d $(NBE_APPPATH) ] || mkdir -p $(NBE_APPPATH)

$(HDRS)::
	@echo $@:$(SRCDIR):$(NBE_MK_INCPATH) >> $(NBE_LOG_PATHLOG)
	@cp -f $(SRCDIR)/$@ $(NBE_MK_INCPATH)

$(DEPLIBS):
	$(eval LIBLIST += $(addprefix -l,$@))

$(SRCS):: ;

buildlist:
	$(eval BUILDLIST += $(wildcard $(NBE_MK_COVPATH)/*.c))
	$(eval BUILDLIST += $(wildcard $(NBE_MK_COVPATH)/*.cc))
	$(eval BUILDLIST += $(wildcard $(NBE_MK_COVPATH)/*.s))
	$(eval BUILDLIST += $(wildcard $(NBE_MK_COVPATH)/*.S))
	$(eval BUILDLIST += $(wildcard $(NBE_MK_COVPATH)/*.asm))

buildtest:
	@gcc -coverage -o $(COVAPP)_cov $(BUILDLIST) -I$(SRCDIR) -I$(NBE_MK_INCPATH) -L$(NBE_LIBPATH) $(LIBLIST) $(NBE_LIBS) $(CFLAGS) $(EXTRA_CFLAGS)
	@gcc -o $(COVAPP) $(BUILDLIST) -I$(SRCDIR) -I$(NBE_MK_INCPATH) -L$(NBE_LIBPATH) $(NBE_LIBS) $(LIBLIST) $(CFLAGS) $(EXTRA_CFLAGS)

covlist:
	$(eval COVLIST += $(wildcard $(NBE_MK_COVPATH)/*.c))
	$(eval COVLIST += $(wildcard $(NBE_MK_COVPATH)/*.cc))

gencov:
	@mv -f $(COVAPP) $(NBE_APPPATH)
	@./$(COVAPP)_cov $(TESTARGS)
	@gcov $(COVLIST) -o .

delcov:
	$(eval EXCEPTLIST += $(basename $(SRCS)))
	$(eval EXCEPTLIST += nts)
	$(foreach EXCEPT_ITER, $(EXCEPTLIST), @rm -f $(EXCEPT_ITER).*)

mvcov:
	@mv -f *.gcov $(NBE_COVPATH)
	@$(NBE_SCRIPTS)/restore_source.sh $(NBE_LOG_PATHLOG) $(NBE_COVPATH)
