TESTAPP ?= $(NAME)

SUBCOMP += test
include $(NBE_DIR)/ndr.subcomp.mk

SRCDIR := $(NBE_ROOT)/$S
LDFLAGS += --as-needed -ldl

.PHONY: build
build: $(LIBLIST) $(OBJLIST) $(PICLIST) lkapp doapp

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	#Output directories pre-init
	@[ -d $(NBE_MK_OBJPATH) ] || mkdir -p $(NBE_MK_OBJPATH)
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)
	@[ -d $(NBE_LIBPATH) ] || mkdir -p $(NBE_LIBPATH)
	@[ -d $(NBE_COVPATH) ] || mkdir -p $(NBE_COVPATH)

$(LIBLIST)::
	$(eval LIBFLAG += $(addprefix -l,$@))

$(OBJLIST)::
	$(eval LNKLIST += $(wildcard $(NBE_MK_OBJPATH)/$@/*.o))

$(PICLIST)::
	$(eval LNKLIST += $(wildcard $(NBE_MK_PICPATH)/$@/*.o))

lkapp::
	@gcc -o $(TESTAPP).app $(LNKLIST) -L$(NBE_LIBPATH) $(NBE_LIBS) $(LIBFLAG)

doapp::
	@cp -f $(TESTAPP).app $(NBE_COVPATH)/$(TESTAPP).app
	@$(NBE_COVPATH)/$(TESTAPP).app $(TESTARGS) > $(NBE_COVPATH)/$(TESTAPP).result
