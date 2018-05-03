SUBCOMP += test
include $(NBE_DIR)/ndr.subcomp.mk
include $(NBE_DIR)/ndr.coverage.mk

SRCDIR := $(NBE_ROOT)/$S
LDFLAGS += --as-needed
CFLAGS += -O0
CFLAGS += -g

.PHONY: build
build: $(DEPLIBS) $(SRCS) buildlist buildtest gencov

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_APPPATH) ] || mkdir -p $(NBE_APPPATH)

$(HDRS):: ;

$(DEPLIBS):
	$(eval LIBLIST += $(addprefix -l,$@))

$(SRCS):: ;

buildlist:
	$(eval BUILDLIST += $(wildcard $(NBE_MK_COVPATH)/*.c))
	$(eval BUILDLIST += $(wildcard $(NBE_MK_COVPATH)/*.cc))

buildtest:
	@gcc -coverage -o $(COVAPP)_cov $(BUILDLIST) -I$(SRCDIR) -I$(NBE_MK_INCPATH) -L$(NBE_LIBPATH) $(LIBLIST) $(NBE_LIBS) $(CFLAGS) $(EXTRA_CFLAGS)
	@gcc -o $(COVAPP) $(BUILDLIST) -I$(SRCDIR) -I$(NBE_MK_INCPATH) -L$(NBE_LIBPATH) $(LIBLIST) $(NBE_LIBS) $(CFLAGS) $(EXTRA_CFLAGS)

gencov:
	@mv -f $(COVAPP) $(NBE_APPPATH)
	@./$(COVAPP)_cov $(TESTARGS)
	@gcov $(BUILDLIST) -o .
	@mv -f *.gcov $(NBE_COVPATH)