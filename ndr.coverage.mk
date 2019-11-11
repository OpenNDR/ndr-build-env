COVERAGE ?= $(NAME)

SRCDIR := $(NBE_ROOT)/$S
LDFLAGS += --as-needed -ldl
CFLAGS += -O0
CFLAGS += -g

.PHONY: build
build: $(LIBLIST) $(OBJLIST) $(COVLIST) linktest gcovgen gcovcp

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	@[ -d $(NBE_MK_COVPATH) ] || mkdir -p $(NBE_MK_COVPATH)
	@[ -d $(NBE_MK_COVPATH)/$(COVERAGE) ] || mkdir -p $(NBE_MK_COVPATH)/$(COVERAGE)
	@[ -d $(NBE_COVPATH) ] || mkdir -p $(NBE_COVPATH)

$(LIBLIST)::
	$(eval LIBLIST += $(addprefix -l,$@))

$(OBJLIST)::
	$(eval LNKLIST += $(wildcard $(NBE_MK_COVPATH)/$@/*.raw.o))
	$(eval COVLNKS += $(wildcard $(NBE_MK_COVPATH)/$@/*.cov.o))

$(COVLIST)::
	$(eval LNKLIST += $(wildcard $(NBE_MK_COVPATH)/$@/*.raw.o))
	$(eval COVLNKS += $(wildcard $(NBE_MK_COVPATH)/$@/*.cov.o))
	$(eval COVDIRS += $(shell cat $(NBE_MK_COVPATH)/$@/build.path))
	$(eval COVFILES += $(wildcard $(shell cat $(NBE_MK_COVPATH)/$@/source.path)/*.c))
	$(eval COVFILES += $(wildcard $(shell cat $(NBE_MK_COVPATH)/$@/source.path)/*.cc))
	@cp -f $(NBE_MK_COVPATH)/$@/*.gcno .

linktest::
	@gcc -o $(COVERAGE).app $(LNKLIST) -L$(NBE_LIBPATH) $(NBE_LIBS) $(LIBLIST) $(CFLAGS) $(EXTRA_CFLAGS)
	@gcc -o $(COVERAGE)_cov $(COVLNKS) -L$(NBE_LIBPATH) $(LIBLIST) $(NBE_LIBS) $(CFLAGS) $(EXTRA_CFLAGS) -lgcov

gcovgen::
	@cp -f $(COVERAGE).app $(NBE_COVPATH)/$(COVERAGE).app
	@./$(COVERAGE)_cov $(TESTARGS) > $(COVERAGE).result 2>&1
	@cp -f $(COVERAGE).result $(NBE_COVPATH)/$(COVERAGE).result
	@rename 's/\.cov\.gcno/\.gcno/' *
	@cp -f $(foreach COVDIR, $(COVDIRS), $(COVDIR)/*.gcda) .
	@rename 's/\.cov\.gcda/\.gcda/' *
	@gcov $(COVFILES) -o .

gcovcp::
	@cp -f $(foreach COVFILE, $(COVFILES), ./$(notdir $(COVFILE)).gcov) $(NBE_COVPATH)/$(COVERAGE)
	@$(NBE_SCRIPTS)/nbs.restore.path $(NBE_PATHLOG_RESTORE) $(NBE_COVPATH)/$(COVERAGE)
